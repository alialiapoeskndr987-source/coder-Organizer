import 'package:drift/drift.dart';
import '../../core/models/enums.dart';

/// Hierarchy node (FR-03): mainTab → subTab → section → project (4 levels).
class Nodes extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get parentId => integer().nullable().references(Nodes, #id)();
  TextColumn get name => text().withLength(min: 1, max: 120)();
  TextColumn get type => textEnum<NodeType>()();
  TextColumn get template => textEnum<NodeTemplate>().nullable()();
  TextColumn get icon => text().withDefault(const Constant('folder'))();
  TextColumn get status => textEnum<NodeStatus>().withDefault(const Constant('active'))();
  IntColumn get sortIndex => integer().withDefault(const Constant(0))();
  DateTimeColumn get lastOpenedAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get deletedAt => dateTime().nullable()(); // trash (D-010)
}

class Links extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get nodeId => integer().references(Nodes, #id)();
  TextColumn get title => text().withLength(min: 1, max: 120)();
  TextColumn get url => text()();
  TextColumn get category => textEnum<LinkCategory>()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get deletedAt => dateTime().nullable()();
}

class Notes extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get nodeId => integer().references(Nodes, #id)();
  TextColumn get title => text().nullable()();
  TextColumn get content => text().withDefault(const Constant(''))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get deletedAt => dateTime().nullable()();
}

/// Registered emails — the project's signature differentiator (SRS 2.1).
class Emails extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get nodeId => integer().references(Nodes, #id)();
  TextColumn get label => text().withLength(min: 1, max: 120)();
  TextColumn get address => text()();
  TextColumn get password => text().nullable()(); // never exported (NFR-02)
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get deletedAt => dateTime().nullable()();
}

class Subscriptions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get nodeId => integer().references(Nodes, #id)();
  TextColumn get serviceName => text().withLength(min: 1, max: 120)();
  TextColumn get plan => text().nullable()();
  TextColumn get price => text().nullable()();
  TextColumn get cycle => textEnum<BillingCycle>().withDefault(const Constant('monthly'))();
  DateTimeColumn get renewsAt => dateTime().nullable()();
  TextColumn get status => textEnum<SubStatus>().withDefault(const Constant('active'))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get deletedAt => dateTime().nullable()();
}

@DataClassName('PlatformRow')
class Platforms extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get nodeId => integer().references(Nodes, #id)();
  TextColumn get platformName => text().withLength(min: 1, max: 80)();
  TextColumn get account => text().nullable()();
  TextColumn get url => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get deletedAt => dateTime().nullable()();
}

/// Key/value variables; `isSecret` values are excluded from export (NFR-02).
@DataClassName('VariableRow')
class Variables extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get nodeId => integer().references(Nodes, #id)();
  TextColumn get varKey => text().withLength(min: 1, max: 80)();
  TextColumn get varValue => text().withDefault(const Constant(''))();
  BoolColumn get isSecret => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get deletedAt => dateTime().nullable()();
}

class Alerts extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get nodeId => integer().references(Nodes, #id)();
  TextColumn get title => text().withLength(min: 1, max: 120)();
  DateTimeColumn get fireAt => dateTime()();
  IntColumn get reminderMinutesBefore => integer().withDefault(const Constant(15))();
  BoolColumn get enabled => boolean().withDefault(const Constant(true))();
  BoolColumn get notified => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get deletedAt => dateTime().nullable()();
}

/// Open events for "most visited (last 7 days)" (FR-05).
class OpenLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get nodeId => integer().references(Nodes, #id)();
  DateTimeColumn get openedAt => dateTime().withDefault(currentDateAndTime)();
}

/// Simple key/value app settings (theme, locale, main title, trial, consent…).
class AppSettings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();
  @override
  Set<Column> get primaryKey => {key};
}
