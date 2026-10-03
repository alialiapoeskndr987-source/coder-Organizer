// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Coder Organizer';

  @override
  String get tagline => 'Your projects, fully organized';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get add => 'Add';

  @override
  String get done => 'Done';

  @override
  String get undo => 'Undo';

  @override
  String get restore => 'Restore';

  @override
  String get search => 'Search';

  @override
  String get close => 'Close';

  @override
  String get confirm => 'Confirm';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get ok => 'OK';

  @override
  String get create => 'Create';

  @override
  String get name => 'Name';

  @override
  String get optional => 'Optional';

  @override
  String get home => 'Home';

  @override
  String get alerts => 'Alerts';

  @override
  String get settings => 'Settings';

  @override
  String get trash => 'Trash';

  @override
  String trialBanner(int days) {
    return 'Free trial — $days days left';
  }

  @override
  String get trialLastDay => 'Free trial — last day!';

  @override
  String get trialExpiredTitle => 'Your free trial has ended';

  @override
  String get trialExpiredBody =>
      'Your data is safe and you can still browse everything. Upgrade once for lifetime access to keep creating and editing.';

  @override
  String get upgrade => 'Upgrade';

  @override
  String get upgradeNow => 'Upgrade now';

  @override
  String priceLifetime(String price) {
    return 'Lifetime access — $price';
  }

  @override
  String get purchaseSuccess =>
      'Purchase complete. Thank you for supporting Coder Organizer!';

  @override
  String get purchaseError =>
      'Purchase could not be completed. Please try again.';

  @override
  String get purchasePending =>
      'Purchase is pending. It will unlock automatically once confirmed.';

  @override
  String get restorePurchases => 'Restore purchases';

  @override
  String get loading => 'Loading…';

  @override
  String get login => 'Sign in';

  @override
  String get register => 'Create account';

  @override
  String get logout => 'Sign out';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get confirmPassword => 'Confirm password';

  @override
  String get passwordWeak => 'Weak';

  @override
  String get passwordFair => 'Fair';

  @override
  String get passwordStrong => 'Strong';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get resetLinkSent =>
      'If the email exists, a secure reset link valid for 60 minutes has been sent.';

  @override
  String get continueWithGoogle => 'Continue with Google';

  @override
  String get authError =>
      'Authentication failed. Please check your details and try again.';

  @override
  String get deleteMyAccount => 'Delete my account';

  @override
  String get deleteAccountConfirm =>
      'This permanently deletes your account and its cloud data. Local data on this device stays until you uninstall. Continue?';

  @override
  String get defaultWorkspaceTitle => 'My Workspace';

  @override
  String get mostVisited => 'Most visited (7 days)';

  @override
  String get lastOpened => 'Recently opened';

  @override
  String projectsCount(int count) {
    return '$count projects';
  }

  @override
  String get createNew => 'Create new';

  @override
  String get mainTab => 'Main tab';

  @override
  String get subTab => 'Sub tab';

  @override
  String get section => 'Section';

  @override
  String get project => 'Project';

  @override
  String get nodeType => 'Type';

  @override
  String get tplClient => 'Client project';

  @override
  String get tplPersonal => 'Personal project';

  @override
  String get tplSubscription => 'Subscription / service';

  @override
  String get tplQuickNote => 'Quick note';

  @override
  String get tplCustom => 'Custom (no template)';

  @override
  String get template => 'Template';

  @override
  String createNodeTitle(String type) {
    return 'Create $type';
  }

  @override
  String get parentTab => 'Main tab';

  @override
  String get parentSub => 'Sub tab';

  @override
  String get parentSection => 'Section';

  @override
  String get optionNew => '➕ New…';

  @override
  String get noParentYet => 'None yet — create one above';

  @override
  String deleteNodeTitle(String name) {
    return 'Delete \"$name\"?';
  }

  @override
  String deleteCascadeWarn(int count) {
    return 'This also deletes $count nested items and all their elements to trash.';
  }

  @override
  String get movedToTrash => 'Moved to trash';

  @override
  String get restored => 'Restored';

  @override
  String get breadcrumbRoot => 'Workspace';

  @override
  String childrenCount(int count) {
    return '$count items';
  }

  @override
  String get nodeDetails => 'Details';

  @override
  String get renameNode => 'Rename';

  @override
  String get changeIcon => 'Change icon';

  @override
  String get status => 'Status';

  @override
  String get statusActive => 'Active';

  @override
  String get statusArchived => 'Archived';

  @override
  String get links => 'Links';

  @override
  String get notes => 'Notes';

  @override
  String get alertsWithCount => 'Alerts';

  @override
  String get registeredEmails => 'Registered emails';

  @override
  String get subscriptions => 'Subscriptions';

  @override
  String get platforms => 'Publishing platforms';

  @override
  String get variables => 'Variables';

  @override
  String get addLink => 'Add link';

  @override
  String get addNote => 'Add note';

  @override
  String get addAlert => 'Add alert';

  @override
  String get addEmail => 'Add email';

  @override
  String get addSubscription => 'Add subscription';

  @override
  String get addPlatform => 'Add platform';

  @override
  String get addVariable => 'Add variable';

  @override
  String get linkTitle => 'Link title';

  @override
  String get url => 'URL';

  @override
  String get linkRepository => 'Repository';

  @override
  String get linkDashboard => 'Dashboard';

  @override
  String get linkWebsite => 'Website';

  @override
  String get linkStore => 'Store listing';

  @override
  String get linkOther => 'Other';

  @override
  String get noteTitle => 'Title (optional)';

  @override
  String get noteContent => 'Content';

  @override
  String get notesLimit => 'Up to 50 notes per node';

  @override
  String get emailLabel => 'Label';

  @override
  String get emailAddress => 'Email address';

  @override
  String get emailPassword => 'Password';

  @override
  String get showSecret => 'Show';

  @override
  String get hideSecret => 'Hide';

  @override
  String get subService => 'Service name';

  @override
  String get subPlan => 'Plan';

  @override
  String get subPrice => 'Price';

  @override
  String get subCycle => 'Billing cycle';

  @override
  String get cycleMonthly => 'Monthly';

  @override
  String get cycleYearly => 'Yearly';

  @override
  String get cycleLifetime => 'Lifetime';

  @override
  String get cycleCustom => 'Custom';

  @override
  String get subRenewsAt => 'Renews on';

  @override
  String get subStatus => 'Subscription status';

  @override
  String get subActive => 'Active';

  @override
  String get subCancelled => 'Cancelled';

  @override
  String get subExpired => 'Expired';

  @override
  String get platformName => 'Platform';

  @override
  String get platformAccount => 'Account / handle';

  @override
  String get varKey => 'Key';

  @override
  String get varValue => 'Value';

  @override
  String get isSecret => 'Secret (never exported)';

  @override
  String get secretExportNote => 'Secret values are excluded from exports.';

  @override
  String get searchHint => 'Search by name…';

  @override
  String get filterTab => 'Main tab';

  @override
  String get filterSub => 'Sub tab';

  @override
  String get filterSection => 'Section';

  @override
  String get filterStatus => 'Status';

  @override
  String get allOption => 'All';

  @override
  String get noResults => 'No matching results';

  @override
  String resultsCount(int count) {
    return '$count results';
  }

  @override
  String get mainTitleLabel => 'Main title (home header)';

  @override
  String get mainTitleHint => 'Up to 60 characters';

  @override
  String get themes => 'Themes';

  @override
  String get language => 'Language';

  @override
  String get dataSection => 'Data';

  @override
  String get exportData => 'Export data (JSON)';

  @override
  String get importData => 'Import data (JSON)';

  @override
  String get importStrategy => 'Import strategy';

  @override
  String get strategyReplace => 'Replace everything';

  @override
  String get strategyMerge => 'Merge with current data';

  @override
  String importPreview(
    int nodes,
    int links,
    int notes,
    int emails,
    int subs,
    int platforms,
    int variables,
    int alerts,
  ) {
    return '$nodes nodes, $links links, $notes notes, $emails emails, $subs subscriptions, $platforms platforms, $variables variables, $alerts alerts';
  }

  @override
  String get exportDone => 'Export completed successfully';

  @override
  String get importDone => 'Import completed successfully';

  @override
  String get dataError => 'Operation failed. Please try again.';

  @override
  String get trashEmpty => 'Trash is empty';

  @override
  String get trashAutoPurge =>
      'Items are kept for 30 days, then permanently removed.';

  @override
  String get purgeNow => 'Empty trash now';

  @override
  String get purgeConfirm =>
      'Permanently delete everything in trash? This cannot be undone.';

  @override
  String get restoreNode => 'Restore';

  @override
  String get deleteForever => 'Delete forever';

  @override
  String get accountSection => 'Account';

  @override
  String get changePassword => 'Change password';

  @override
  String get currentPassword => 'Current password';

  @override
  String get newPassword => 'New password';

  @override
  String get analyticsSection => 'Analytics';

  @override
  String get analyticsDesc =>
      'Share minimal anonymous usage events (install, first project, trial start, purchase, active projects count). No content ever leaves your device.';

  @override
  String get analyticsOn => 'On';

  @override
  String get analyticsOff => 'Off';

  @override
  String get aboutSection => 'About';

  @override
  String get version => 'Version';

  @override
  String get alertsCenter => 'Alerts center';

  @override
  String get upcoming => 'Upcoming';

  @override
  String get fired => 'Fired';

  @override
  String get alertDisabled => 'Disabled';

  @override
  String get noAlerts => 'No alerts yet';

  @override
  String get alertTitleLabel => 'Alert title';

  @override
  String get alertDateTime => 'Date & time';

  @override
  String reminderBefore(int min) {
    return 'Remind $min min before';
  }

  @override
  String get reminderNone => 'No early reminder';

  @override
  String get notifPermissionDenied =>
      'Notifications permission was denied. Alerts will not appear — enable it in system settings.';

  @override
  String get featureLocked => 'Trial ended — upgrade to continue.';

  @override
  String get fieldRequired => 'This field is required';

  @override
  String get nameTooLong => 'Name is too long';

  @override
  String get urlInvalid => 'Enter a valid URL';

  @override
  String get emailInvalid => 'Enter a valid email';

  @override
  String get passwordShort => 'At least 8 characters';

  @override
  String get passwordMismatch => 'Passwords do not match';

  @override
  String get unexpectedError => 'Something went wrong. Please try again.';

  @override
  String get openNode => 'Open';

  @override
  String get items => 'Items';

  @override
  String get emptyState => 'Nothing here yet — use the + button to create';

  @override
  String noteOf(int index, int total) {
    return 'Note $index of $total';
  }

  @override
  String get theme1 => 'Programmer Blue';

  @override
  String get theme2 => 'Terminal Green';

  @override
  String get theme3 => 'Neon Purple';

  @override
  String get theme4 => 'Sunset Orange';

  @override
  String get theme5 => 'Night Crimson';

  @override
  String get theme6 => 'Ocean Teal';

  @override
  String get theme7 => 'Metal Silver';

  @override
  String get theme8 => 'Midnight Gold';
}
