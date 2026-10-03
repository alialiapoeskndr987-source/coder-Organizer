import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:coder_organizer/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/enums.dart';
import '../../data/db/app_database.dart';
import '../../providers/tree_providers.dart';
import '../../shared/widgets/common.dart';

// ── helpers ───────────────────────────────────────────────────────────
Future<DateTime?> pickDateTime(BuildContext context, DateTime initial) async {
  final date = await showDatePicker(
    context: context,
    initialDate: initial,
    firstDate: DateTime(2000),
    lastDate: DateTime(2100),
  );
  if (date == null) return null;
  final time = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.fromDateTime(initial),
  );
  if (time == null) return null;
  return DateTime(date.year, date.month, date.day, time.hour, time.minute);
}

Future<DateTime?> pickDate(BuildContext context, DateTime initial) async {
  return showDatePicker(
    context: context,
    initialDate: initial,
    firstDate: DateTime(2000),
    lastDate: DateTime(2100),
  );
}

const _reminderOptions = [0, 5, 15, 30, 60];

String reminderLabel(AppLocalizations l10n, int minutes) =>
    minutes == 0 ? l10n.reminderNone : l10n.reminderBefore(minutes);

Future<bool?> _saveDialog(
  BuildContext context, {
  required String title,
  required GlobalKey<FormState> formKey,
  required WidgetBuilder contentBuilder,
}) {
  return showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: Form(
        key: formKey,
        child: SingleChildScrollView(child: Builder(builder: contentBuilder)),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(AppLocalizations.of(ctx)!.cancel)),
        FilledButton(
            onPressed: () {
              if (formKey.currentState?.validate() ?? false) {
                Navigator.pop(ctx, true);
              }
            },
            child: Text(AppLocalizations.of(ctx)!.save)),
      ],
    ),
  );
}

// ── Link (title + URL + category, FR-06) ─────────────────────────────
Future<void> showLinkDialog(
  BuildContext context,
  WidgetRef ref, {
  required int nodeId,
  Link? existing,
}) async {
  final l10n = AppLocalizations.of(context)!;
  final title = TextEditingController(text: existing?.title);
  final url = TextEditingController(text: existing?.url);
  var category = existing?.category ?? LinkCategory.website;
  final formKey = GlobalKey<FormState>();

  final ok = await _saveDialog(
    context,
    title: existing == null ? l10n.addLink : l10n.edit,
    formKey: formKey,
    contentBuilder: (ctx) => Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextFormField(
          controller: title,
          decoration: InputDecoration(labelText: l10n.linkTitle),
          validator: (v) =>
              v == null || v.trim().isEmpty ? l10n.fieldRequired : null,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: url,
          keyboardType: TextInputType.url,
          decoration: InputDecoration(labelText: l10n.url),
          validator: (v) =>
              v == null || !(v.startsWith('http') || v.startsWith('www'))
                  ? l10n.urlInvalid
                  : null,
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<LinkCategory>(
          initialValue: category,
          decoration: InputDecoration(labelText: l10n.nodeType),
          items: [
            for (final c in LinkCategory.values)
              DropdownMenuItem(value: c, child: Text(linkCategoryLabel(l10n, c))),
          ],
          onChanged: (v) => category = v ?? LinkCategory.other,
        ),
      ],
    ),
  );
  if (ok != true) return;
  final actions = ref.read(elementActionsProvider);
  final companion = LinksCompanion.insert(
    nodeId: nodeId,
    title: title.text.trim(),
    url: url.text.trim(),
    category: category,
  );
  if (existing == null) {
    await actions.addLink(companion);
  } else {
    await actions.updateLink(existing.id, companion);
  }
}

// ── Note (optional title + content, ≤50/node, D-007) ─────────────────
Future<void> showNoteDialog(
  BuildContext context,
  WidgetRef ref, {
  required int nodeId,
  Note? existing,
}) async {
  final l10n = AppLocalizations.of(context)!;
  final title = TextEditingController(text: existing?.title);
  final content = TextEditingController(text: existing?.content);
  final formKey = GlobalKey<FormState>();

  final ok = await _saveDialog(
    context,
    title: existing == null ? l10n.addNote : l10n.edit,
    formKey: formKey,
    contentBuilder: (ctx) => Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextFormField(
          controller: title,
          decoration:
              InputDecoration(labelText: l10n.noteTitle, counterText: ''),
          maxLength: 120,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: content,
          maxLines: 6,
          decoration: InputDecoration(labelText: l10n.noteContent),
        ),
      ],
    ),
  );
  if (ok != true) return;
  final actions = ref.read(elementActionsProvider);
  final companion = NotesCompanion.insert(
    nodeId: nodeId,
    title: Value(title.text.trim().isEmpty ? null : title.text.trim()),
    content: Value(content.text),
  );
  try {
    if (existing == null) {
      await actions.addNote(companion);
    } else {
      await actions.updateNote(existing.id, companion);
    }
  } on NotesLimitReached {
    if (context.mounted) showError(context, l10n.notesLimit);
  }
}

// ── Alert (date/time + early reminder, FR-06) ────────────────────────
Future<void> showAlertDialog(
  BuildContext context,
  WidgetRef ref, {
  required int nodeId,
  Alert? existing,
}) async {
  final l10n = AppLocalizations.of(context)!;
  final title = TextEditingController(text: existing?.title);
  DateTime fireAt = existing?.fireAt ??
      DateTime.now().add(const Duration(days: 1, hours: 1));
  var reminder = existing?.reminderMinutesBefore ?? 15;
  final formKey = GlobalKey<FormState>();

  final ok = await _saveDialog(
    context,
    title: existing == null ? l10n.addAlert : l10n.edit,
    formKey: formKey,
    contentBuilder: (ctx) => StatefulBuilder(
      builder: (ctx, setState) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: title,
            decoration: InputDecoration(labelText: l10n.alertTitleLabel),
            validator: (v) =>
                v == null || v.trim().isEmpty ? l10n.fieldRequired : null,
          ),
          const SizedBox(height: 12),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.event_outlined),
            title: Text(l10n.alertDateTime),
            subtitle: Text(fireAt.toString().substring(0, 16)),
            onTap: () async {
              final picked = await pickDateTime(ctx, fireAt);
              if (picked != null) setState(() => fireAt = picked);
            },
          ),
          DropdownButtonFormField<int>(
            initialValue: reminder,
            decoration: InputDecoration(labelText: l10n.alertDateTime),
            items: [
              for (final m in _reminderOptions)
                DropdownMenuItem(value: m, child: Text(reminderLabel(l10n, m))),
            ],
            onChanged: (v) => setState(() => reminder = v ?? 15),
          ),
        ],
      ),
    ),
  );
  if (ok != true) return;
  final actions = ref.read(elementActionsProvider);
  final companion = AlertsCompanion.insert(
    nodeId: nodeId,
    title: title.text.trim(),
    fireAt: fireAt,
    reminderMinutesBefore: Value(reminder),
  );
  if (existing == null) {
    await actions.addAlert(companion);
  } else {
    await actions.updateAlert(existing.id, companion);
  }
}

// ── Registered email (differentiator element) ────────────────────────
Future<void> showEmailDialog(
  BuildContext context,
  WidgetRef ref, {
  required int nodeId,
  Email? existing,
}) async {
  final l10n = AppLocalizations.of(context)!;
  final label = TextEditingController(text: existing?.label);
  final address = TextEditingController(text: existing?.address);
  final password = TextEditingController(text: existing?.password);
  var obscure = true;
  final formKey = GlobalKey<FormState>();

  final ok = await _saveDialog(
    context,
    title: existing == null ? l10n.addEmail : l10n.edit,
    formKey: formKey,
    contentBuilder: (ctx) => StatefulBuilder(
      builder: (ctx, setState) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: label,
            decoration: InputDecoration(labelText: l10n.emailLabel),
            validator: (v) =>
                v == null || v.trim().isEmpty ? l10n.fieldRequired : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: address,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(labelText: l10n.emailAddress),
            validator: (v) =>
                v == null || !v.contains('@') ? l10n.emailInvalid : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: password,
            obscureText: obscure,
            decoration: InputDecoration(
              labelText: l10n.emailPassword,
              suffixIcon: IconButton(
                icon: Icon(obscure
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined),
                onPressed: () => setState(() => obscure = !obscure),
              ),
            ),
          ),
        ],
      ),
    ),
  );
  if (ok != true) return;
  final actions = ref.read(elementActionsProvider);
  final companion = EmailsCompanion.insert(
    nodeId: nodeId,
    label: label.text.trim(),
    address: address.text.trim(),
    password: Value(password.text.isEmpty ? null : password.text),
  );
  if (existing == null) {
    await actions.addEmail(companion);
  } else {
    await actions.updateEmail(existing.id, companion);
  }
}

// ── Subscription (cycle + renewal, differentiator element) ───────────
Future<void> showSubscriptionDialog(
  BuildContext context,
  WidgetRef ref, {
  required int nodeId,
  Subscription? existing,
}) async {
  final l10n = AppLocalizations.of(context)!;
  final service = TextEditingController(text: existing?.serviceName);
  final plan = TextEditingController(text: existing?.plan);
  final price = TextEditingController(text: existing?.price);
  var cycle = existing?.cycle ?? BillingCycle.monthly;
  var renewsAt = existing?.renewsAt;
  var status = existing?.status ?? SubStatus.active;
  final formKey = GlobalKey<FormState>();

  final ok = await _saveDialog(
    context,
    title: existing == null ? l10n.addSubscription : l10n.edit,
    formKey: formKey,
    contentBuilder: (ctx) => StatefulBuilder(
      builder: (ctx, setState) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: service,
            decoration: InputDecoration(labelText: l10n.subService),
            validator: (v) =>
                v == null || v.trim().isEmpty ? l10n.fieldRequired : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: plan,
            decoration: InputDecoration(labelText: l10n.subPlan),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: price,
            decoration: InputDecoration(labelText: l10n.subPrice),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<BillingCycle>(
            initialValue: cycle,
            decoration: InputDecoration(labelText: l10n.subCycle),
            items: [
              for (final c in BillingCycle.values)
                DropdownMenuItem(value: c, child: Text(cycleLabel(l10n, c))),
            ],
            onChanged: (v) => setState(() => cycle = v ?? BillingCycle.monthly),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<SubStatus>(
            initialValue: status,
            decoration: InputDecoration(labelText: l10n.subStatus),
            items: [
              for (final s in SubStatus.values)
                DropdownMenuItem(value: s, child: Text(subStatusLabel(l10n, s))),
            ],
            onChanged: (v) => setState(() => status = v ?? SubStatus.active),
          ),
          const SizedBox(height: 8),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.event_repeat_outlined),
            title: Text(l10n.subRenewsAt),
            subtitle: Text(renewsAt?.toString().substring(0, 10) ?? '—'),
            onTap: () async {
              final picked =
                  await pickDate(ctx, renewsAt ?? DateTime.now());
              setState(() => renewsAt = picked);
            },
          ),
        ],
      ),
    ),
  );
  if (ok != true) return;
  final actions = ref.read(elementActionsProvider);
  final companion = SubscriptionsCompanion.insert(
    nodeId: nodeId,
    serviceName: service.text.trim(),
    plan: Value(plan.text.trim().isEmpty ? null : plan.text.trim()),
    price: Value(price.text.trim().isEmpty ? null : price.text.trim()),
    cycle: Value(cycle),
    renewsAt: Value(renewsAt),
    status: Value(status),
  );
  if (existing == null) {
    await actions.addSubscription(companion);
  } else {
    await actions.updateSubscription(existing.id, companion);
  }
}

// ── Publishing platform ──────────────────────────────────────────────
const _quickPlatforms = ['Google Play', 'App Store', 'GitHub', 'GitLab', 'Fiverr', 'Upwork'];

Future<void> showPlatformDialog(
  BuildContext context,
  WidgetRef ref, {
  required int nodeId,
  PlatformRow? existing,
}) async {
  final l10n = AppLocalizations.of(context)!;
  final name = TextEditingController(text: existing?.platformName);
  final account = TextEditingController(text: existing?.account);
  final url = TextEditingController(text: existing?.url);
  final formKey = GlobalKey<FormState>();

  final ok = await _saveDialog(
    context,
    title: existing == null ? l10n.addPlatform : l10n.edit,
    formKey: formKey,
    contentBuilder: (ctx) => Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextFormField(
          controller: name,
          decoration: InputDecoration(labelText: l10n.platformName),
          validator: (v) =>
              v == null || v.trim().isEmpty ? l10n.fieldRequired : null,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 6,
          children: [
            for (final p in _quickPlatforms)
              ActionChip(
                label: Text(p, style: const TextStyle(fontSize: 12)),
                onPressed: () => name.text = p,
              ),
          ],
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: account,
          decoration: InputDecoration(labelText: l10n.platformAccount),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: url,
          keyboardType: TextInputType.url,
          decoration: InputDecoration(labelText: l10n.url),
        ),
      ],
    ),
  );
  if (ok != true) return;
  final actions = ref.read(elementActionsProvider);
  final companion = PlatformsCompanion.insert(
    nodeId: nodeId,
    platformName: name.text.trim(),
    account: Value(account.text.trim().isEmpty ? null : account.text.trim()),
    url: Value(url.text.trim().isEmpty ? null : url.text.trim()),
  );
  if (existing == null) {
    await actions.addPlatform(companion);
  } else {
    await actions.updatePlatform(existing.id, companion);
  }
}

// ── Variable (key/value, secrets never exported — NFR-02) ────────────
Future<void> showVariableDialog(
  BuildContext context,
  WidgetRef ref, {
  required int nodeId,
  VariableRow? existing,
}) async {
  final l10n = AppLocalizations.of(context)!;
  final key = TextEditingController(text: existing?.varKey);
  final value = TextEditingController(text: existing?.varValue);
  var isSecret = existing?.isSecret ?? false;
  var obscure = existing?.isSecret ?? false;
  final formKey = GlobalKey<FormState>();

  final ok = await _saveDialog(
    context,
    title: existing == null ? l10n.addVariable : l10n.edit,
    formKey: formKey,
    contentBuilder: (ctx) => StatefulBuilder(
      builder: (ctx, setState) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: key,
            decoration: InputDecoration(labelText: l10n.varKey),
            validator: (v) =>
                v == null || v.trim().isEmpty ? l10n.fieldRequired : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: value,
            obscureText: obscure,
            maxLines: obscure ? 1 : 3,
            decoration: InputDecoration(labelText: l10n.varValue),
          ),
          const SizedBox(height: 8),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.isSecret),
            subtitle: Text(l10n.secretExportNote),
            value: isSecret,
            onChanged: (v) => setState(() {
              isSecret = v;
              if (v) obscure = true;
            }),
          ),
          if (isSecret)
            IconButton(
              onPressed: () => setState(() => obscure = !obscure),
              icon: Icon(obscure
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined),
            ),
        ],
      ),
    ),
  );
  if (ok != true) return;
  final actions = ref.read(elementActionsProvider);
  final companion = VariablesCompanion.insert(
    nodeId: nodeId,
    varKey: key.text.trim(),
    varValue: Value(value.text),
    isSecret: Value(isSecret),
  );
  if (existing == null) {
    await actions.addVariable(companion);
  } else {
    await actions.updateVariable(existing.id, companion);
  }
}

/// Generic element delete with instant-undo snackbar (D-010).
Future<void> deleteElementWithUndo(
  BuildContext context,
  WidgetRef ref, {
  required ElementType type,
  required int id,
}) async {
  final l10n = AppLocalizations.of(context)!;
  final actions = ref.read(elementActionsProvider);
  switch (type) {
    case ElementType.link:
      await actions.deleteLink(id);
    case ElementType.note:
      await actions.deleteNote(id);
    case ElementType.email:
      await actions.deleteEmail(id);
    case ElementType.subscription:
      await actions.deleteSubscription(id);
    case ElementType.platform:
      await actions.deletePlatform(id);
    case ElementType.variable:
      await actions.deleteVariable(id);
    case ElementType.alert:
      await actions.deleteAlert(id);
  }
  if (!context.mounted) return;
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(
      content: Text(l10n.movedToTrash),
      action: SnackBarAction(
        label: l10n.undo,
        onPressed: () => switch (type) {
          ElementType.link => actions.restoreLink(id),
          ElementType.note => actions.restoreNote(id),
          ElementType.email => actions.restoreEmail(id),
          ElementType.subscription => actions.restoreSubscription(id),
          ElementType.platform => actions.restorePlatform(id),
          ElementType.variable => actions.restoreVariable(id),
          ElementType.alert => actions.restoreAlert(id),
        },
      ),
    ));
}

enum ElementType { link, note, email, subscription, platform, variable, alert }
