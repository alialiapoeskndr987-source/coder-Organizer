import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/constants/app_constants.dart';
import '../data/db/app_database.dart';
import 'core_providers.dart';

// ── v2.0 structural undo (D-025): last ~10 operations, in-memory ────────

/// One reversible structural operation. Undo implementations are
/// deliberately conservative: they either soft-delete to trash or restore
/// previous column values — nothing is destroyed.
sealed class UndoOp {
  const UndoOp();
  Future<void> undo(AppDatabase db);
}

/// Undo of a create = move the created subtree to the trash (safe even if
/// children were added afterwards).
class CreateNodeOp extends UndoOp {
  final int nodeId;
  const CreateNodeOp(this.nodeId);
  @override
  Future<void> undo(AppDatabase db) => db.nodesDao.softDeleteSubtree(nodeId);
}

/// Undo of a delete = restore the captured subtree snapshot.
class DeleteNodeOp extends UndoOp {
  final DeleteSnapshot snapshot;
  const DeleteNodeOp(this.snapshot);
  @override
  Future<void> undo(AppDatabase db) => db.nodesDao.restoreSubtree(snapshot.nodeIds);
}

class RenameNodeOp extends UndoOp {
  final int nodeId;
  final String oldName;
  const RenameNodeOp(this.nodeId, this.oldName);
  @override
  Future<void> undo(AppDatabase db) =>
      db.nodesDao.updateNode(nodeId, NodesCompanion(name: Value(oldName)));
}

/// Undo of a move (parent change).
class MoveNodeOp extends UndoOp {
  final int nodeId;
  final int? oldParentId;
  const MoveNodeOp(this.nodeId, this.oldParentId);
  @override
  Future<void> undo(AppDatabase db) => db.nodesDao.updateNode(
      nodeId, NodesCompanion(parentId: Value(oldParentId)));
}

/// Undo of a category assignment.
class SetCategoryOp extends UndoOp {
  final int nodeId;
  final int? oldCategoryId;
  const SetCategoryOp(this.nodeId, this.oldCategoryId);
  @override
  Future<void> undo(AppDatabase db) => db.nodesDao.updateNode(
      nodeId, NodesCompanion(categoryId: Value(oldCategoryId)));
}

/// Ring buffer of the last [AppConstants.undoDepth] operations.
/// State = number of undoable operations (drives UI enablement).
class UndoManager extends StateNotifier<int> {
  final AppDatabase _db;
  final List<UndoOp> _ops = [];

  UndoManager(this._db) : super(0);

  bool get canUndo => _ops.isNotEmpty;

  void push(UndoOp op) {
    _ops.add(op);
    while (_ops.length > AppConstants.undoDepth) {
      _ops.removeAt(0);
    }
    state = _ops.length;
  }

  /// Undoes the most recent operation. Returns false when nothing to undo.
  Future<bool> undo() async {
    if (_ops.isEmpty) return false;
    final op = _ops.removeLast();
    await op.undo(_db);
    state = _ops.length;
    return true;
  }

  void clear() {
    _ops.clear();
    state = 0;
  }
}

final undoProvider = StateNotifierProvider<UndoManager, int>((ref) {
  return UndoManager(ref.watch(appDatabaseProvider));
});
