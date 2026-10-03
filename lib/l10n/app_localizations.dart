import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Coder Organizer'**
  String get appName;

  /// No description provided for @tagline.
  ///
  /// In en, this message translates to:
  /// **'Your projects, fully organized'**
  String get tagline;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @undo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo;

  /// No description provided for @restore.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get restore;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @optional.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get optional;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @alerts.
  ///
  /// In en, this message translates to:
  /// **'Alerts'**
  String get alerts;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @trash.
  ///
  /// In en, this message translates to:
  /// **'Trash'**
  String get trash;

  /// No description provided for @trialBanner.
  ///
  /// In en, this message translates to:
  /// **'Free trial — {days} days left'**
  String trialBanner(int days);

  /// No description provided for @trialLastDay.
  ///
  /// In en, this message translates to:
  /// **'Free trial — last day!'**
  String get trialLastDay;

  /// No description provided for @trialExpiredTitle.
  ///
  /// In en, this message translates to:
  /// **'Your free trial has ended'**
  String get trialExpiredTitle;

  /// No description provided for @trialExpiredBody.
  ///
  /// In en, this message translates to:
  /// **'Your data is safe and you can still browse everything. Upgrade once for lifetime access to keep creating and editing.'**
  String get trialExpiredBody;

  /// No description provided for @upgrade.
  ///
  /// In en, this message translates to:
  /// **'Upgrade'**
  String get upgrade;

  /// No description provided for @upgradeNow.
  ///
  /// In en, this message translates to:
  /// **'Upgrade now'**
  String get upgradeNow;

  /// No description provided for @priceLifetime.
  ///
  /// In en, this message translates to:
  /// **'Lifetime access — {price}'**
  String priceLifetime(String price);

  /// No description provided for @purchaseSuccess.
  ///
  /// In en, this message translates to:
  /// **'Purchase complete. Thank you for supporting Coder Organizer!'**
  String get purchaseSuccess;

  /// No description provided for @purchaseError.
  ///
  /// In en, this message translates to:
  /// **'Purchase could not be completed. Please try again.'**
  String get purchaseError;

  /// No description provided for @purchasePending.
  ///
  /// In en, this message translates to:
  /// **'Purchase is pending. It will unlock automatically once confirmed.'**
  String get purchasePending;

  /// No description provided for @restorePurchases.
  ///
  /// In en, this message translates to:
  /// **'Restore purchases'**
  String get restorePurchases;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading…'**
  String get loading;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get login;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get register;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get logout;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmPassword;

  /// No description provided for @passwordWeak.
  ///
  /// In en, this message translates to:
  /// **'Weak'**
  String get passwordWeak;

  /// No description provided for @passwordFair.
  ///
  /// In en, this message translates to:
  /// **'Fair'**
  String get passwordFair;

  /// No description provided for @passwordStrong.
  ///
  /// In en, this message translates to:
  /// **'Strong'**
  String get passwordStrong;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

  /// No description provided for @resetLinkSent.
  ///
  /// In en, this message translates to:
  /// **'If the email exists, a secure reset link valid for 60 minutes has been sent.'**
  String get resetLinkSent;

  /// No description provided for @continueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get continueWithGoogle;

  /// No description provided for @authError.
  ///
  /// In en, this message translates to:
  /// **'Authentication failed. Please check your details and try again.'**
  String get authError;

  /// No description provided for @deleteMyAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete my account'**
  String get deleteMyAccount;

  /// No description provided for @deleteAccountConfirm.
  ///
  /// In en, this message translates to:
  /// **'This permanently deletes your account and its cloud data. Local data on this device stays until you uninstall. Continue?'**
  String get deleteAccountConfirm;

  /// No description provided for @defaultWorkspaceTitle.
  ///
  /// In en, this message translates to:
  /// **'My Workspace'**
  String get defaultWorkspaceTitle;

  /// No description provided for @mostVisited.
  ///
  /// In en, this message translates to:
  /// **'Most visited (7 days)'**
  String get mostVisited;

  /// No description provided for @lastOpened.
  ///
  /// In en, this message translates to:
  /// **'Recently opened'**
  String get lastOpened;

  /// No description provided for @projectsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} projects'**
  String projectsCount(int count);

  /// No description provided for @createNew.
  ///
  /// In en, this message translates to:
  /// **'Create new'**
  String get createNew;

  /// No description provided for @mainTab.
  ///
  /// In en, this message translates to:
  /// **'Main tab'**
  String get mainTab;

  /// No description provided for @subTab.
  ///
  /// In en, this message translates to:
  /// **'Sub tab'**
  String get subTab;

  /// No description provided for @section.
  ///
  /// In en, this message translates to:
  /// **'Section'**
  String get section;

  /// No description provided for @project.
  ///
  /// In en, this message translates to:
  /// **'Project'**
  String get project;

  /// No description provided for @nodeType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get nodeType;

  /// No description provided for @tplClient.
  ///
  /// In en, this message translates to:
  /// **'Client project'**
  String get tplClient;

  /// No description provided for @tplPersonal.
  ///
  /// In en, this message translates to:
  /// **'Personal project'**
  String get tplPersonal;

  /// No description provided for @tplSubscription.
  ///
  /// In en, this message translates to:
  /// **'Subscription / service'**
  String get tplSubscription;

  /// No description provided for @tplQuickNote.
  ///
  /// In en, this message translates to:
  /// **'Quick note'**
  String get tplQuickNote;

  /// No description provided for @tplCustom.
  ///
  /// In en, this message translates to:
  /// **'Custom (no template)'**
  String get tplCustom;

  /// No description provided for @template.
  ///
  /// In en, this message translates to:
  /// **'Template'**
  String get template;

  /// No description provided for @createNodeTitle.
  ///
  /// In en, this message translates to:
  /// **'Create {type}'**
  String createNodeTitle(String type);

  /// No description provided for @parentTab.
  ///
  /// In en, this message translates to:
  /// **'Main tab'**
  String get parentTab;

  /// No description provided for @parentSub.
  ///
  /// In en, this message translates to:
  /// **'Sub tab'**
  String get parentSub;

  /// No description provided for @parentSection.
  ///
  /// In en, this message translates to:
  /// **'Section'**
  String get parentSection;

  /// No description provided for @optionNew.
  ///
  /// In en, this message translates to:
  /// **'➕ New…'**
  String get optionNew;

  /// No description provided for @noParentYet.
  ///
  /// In en, this message translates to:
  /// **'None yet — create one above'**
  String get noParentYet;

  /// No description provided for @deleteNodeTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete \"{name}\"?'**
  String deleteNodeTitle(String name);

  /// No description provided for @deleteCascadeWarn.
  ///
  /// In en, this message translates to:
  /// **'This also deletes {count} nested items and all their elements to trash.'**
  String deleteCascadeWarn(int count);

  /// No description provided for @movedToTrash.
  ///
  /// In en, this message translates to:
  /// **'Moved to trash'**
  String get movedToTrash;

  /// No description provided for @restored.
  ///
  /// In en, this message translates to:
  /// **'Restored'**
  String get restored;

  /// No description provided for @breadcrumbRoot.
  ///
  /// In en, this message translates to:
  /// **'Workspace'**
  String get breadcrumbRoot;

  /// No description provided for @childrenCount.
  ///
  /// In en, this message translates to:
  /// **'{count} items'**
  String childrenCount(int count);

  /// No description provided for @nodeDetails.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get nodeDetails;

  /// No description provided for @renameNode.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get renameNode;

  /// No description provided for @changeIcon.
  ///
  /// In en, this message translates to:
  /// **'Change icon'**
  String get changeIcon;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @statusActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get statusActive;

  /// No description provided for @statusArchived.
  ///
  /// In en, this message translates to:
  /// **'Archived'**
  String get statusArchived;

  /// No description provided for @links.
  ///
  /// In en, this message translates to:
  /// **'Links'**
  String get links;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @alertsWithCount.
  ///
  /// In en, this message translates to:
  /// **'Alerts'**
  String get alertsWithCount;

  /// No description provided for @registeredEmails.
  ///
  /// In en, this message translates to:
  /// **'Registered emails'**
  String get registeredEmails;

  /// No description provided for @subscriptions.
  ///
  /// In en, this message translates to:
  /// **'Subscriptions'**
  String get subscriptions;

  /// No description provided for @platforms.
  ///
  /// In en, this message translates to:
  /// **'Publishing platforms'**
  String get platforms;

  /// No description provided for @variables.
  ///
  /// In en, this message translates to:
  /// **'Variables'**
  String get variables;

  /// No description provided for @addLink.
  ///
  /// In en, this message translates to:
  /// **'Add link'**
  String get addLink;

  /// No description provided for @addNote.
  ///
  /// In en, this message translates to:
  /// **'Add note'**
  String get addNote;

  /// No description provided for @addAlert.
  ///
  /// In en, this message translates to:
  /// **'Add alert'**
  String get addAlert;

  /// No description provided for @addEmail.
  ///
  /// In en, this message translates to:
  /// **'Add email'**
  String get addEmail;

  /// No description provided for @addSubscription.
  ///
  /// In en, this message translates to:
  /// **'Add subscription'**
  String get addSubscription;

  /// No description provided for @addPlatform.
  ///
  /// In en, this message translates to:
  /// **'Add platform'**
  String get addPlatform;

  /// No description provided for @addVariable.
  ///
  /// In en, this message translates to:
  /// **'Add variable'**
  String get addVariable;

  /// No description provided for @linkTitle.
  ///
  /// In en, this message translates to:
  /// **'Link title'**
  String get linkTitle;

  /// No description provided for @url.
  ///
  /// In en, this message translates to:
  /// **'URL'**
  String get url;

  /// No description provided for @linkRepository.
  ///
  /// In en, this message translates to:
  /// **'Repository'**
  String get linkRepository;

  /// No description provided for @linkDashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get linkDashboard;

  /// No description provided for @linkWebsite.
  ///
  /// In en, this message translates to:
  /// **'Website'**
  String get linkWebsite;

  /// No description provided for @linkStore.
  ///
  /// In en, this message translates to:
  /// **'Store listing'**
  String get linkStore;

  /// No description provided for @linkOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get linkOther;

  /// No description provided for @noteTitle.
  ///
  /// In en, this message translates to:
  /// **'Title (optional)'**
  String get noteTitle;

  /// No description provided for @noteContent.
  ///
  /// In en, this message translates to:
  /// **'Content'**
  String get noteContent;

  /// No description provided for @notesLimit.
  ///
  /// In en, this message translates to:
  /// **'Up to 50 notes per node'**
  String get notesLimit;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Label'**
  String get emailLabel;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email address'**
  String get emailAddress;

  /// No description provided for @emailPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get emailPassword;

  /// No description provided for @showSecret.
  ///
  /// In en, this message translates to:
  /// **'Show'**
  String get showSecret;

  /// No description provided for @hideSecret.
  ///
  /// In en, this message translates to:
  /// **'Hide'**
  String get hideSecret;

  /// No description provided for @subService.
  ///
  /// In en, this message translates to:
  /// **'Service name'**
  String get subService;

  /// No description provided for @subPlan.
  ///
  /// In en, this message translates to:
  /// **'Plan'**
  String get subPlan;

  /// No description provided for @subPrice.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get subPrice;

  /// No description provided for @subCycle.
  ///
  /// In en, this message translates to:
  /// **'Billing cycle'**
  String get subCycle;

  /// No description provided for @cycleMonthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get cycleMonthly;

  /// No description provided for @cycleYearly.
  ///
  /// In en, this message translates to:
  /// **'Yearly'**
  String get cycleYearly;

  /// No description provided for @cycleLifetime.
  ///
  /// In en, this message translates to:
  /// **'Lifetime'**
  String get cycleLifetime;

  /// No description provided for @cycleCustom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get cycleCustom;

  /// No description provided for @subRenewsAt.
  ///
  /// In en, this message translates to:
  /// **'Renews on'**
  String get subRenewsAt;

  /// No description provided for @subStatus.
  ///
  /// In en, this message translates to:
  /// **'Subscription status'**
  String get subStatus;

  /// No description provided for @subActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get subActive;

  /// No description provided for @subCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get subCancelled;

  /// No description provided for @subExpired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get subExpired;

  /// No description provided for @platformName.
  ///
  /// In en, this message translates to:
  /// **'Platform'**
  String get platformName;

  /// No description provided for @platformAccount.
  ///
  /// In en, this message translates to:
  /// **'Account / handle'**
  String get platformAccount;

  /// No description provided for @varKey.
  ///
  /// In en, this message translates to:
  /// **'Key'**
  String get varKey;

  /// No description provided for @varValue.
  ///
  /// In en, this message translates to:
  /// **'Value'**
  String get varValue;

  /// No description provided for @isSecret.
  ///
  /// In en, this message translates to:
  /// **'Secret (never exported)'**
  String get isSecret;

  /// No description provided for @secretExportNote.
  ///
  /// In en, this message translates to:
  /// **'Secret values are excluded from exports.'**
  String get secretExportNote;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search by name…'**
  String get searchHint;

  /// No description provided for @filterTab.
  ///
  /// In en, this message translates to:
  /// **'Main tab'**
  String get filterTab;

  /// No description provided for @filterSub.
  ///
  /// In en, this message translates to:
  /// **'Sub tab'**
  String get filterSub;

  /// No description provided for @filterSection.
  ///
  /// In en, this message translates to:
  /// **'Section'**
  String get filterSection;

  /// No description provided for @filterStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get filterStatus;

  /// No description provided for @allOption.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get allOption;

  /// No description provided for @noResults.
  ///
  /// In en, this message translates to:
  /// **'No matching results'**
  String get noResults;

  /// No description provided for @resultsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} results'**
  String resultsCount(int count);

  /// No description provided for @mainTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Main title (home header)'**
  String get mainTitleLabel;

  /// No description provided for @mainTitleHint.
  ///
  /// In en, this message translates to:
  /// **'Up to 60 characters'**
  String get mainTitleHint;

  /// No description provided for @themes.
  ///
  /// In en, this message translates to:
  /// **'Themes'**
  String get themes;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @dataSection.
  ///
  /// In en, this message translates to:
  /// **'Data'**
  String get dataSection;

  /// No description provided for @exportData.
  ///
  /// In en, this message translates to:
  /// **'Export data (JSON)'**
  String get exportData;

  /// No description provided for @importData.
  ///
  /// In en, this message translates to:
  /// **'Import data (JSON)'**
  String get importData;

  /// No description provided for @importStrategy.
  ///
  /// In en, this message translates to:
  /// **'Import strategy'**
  String get importStrategy;

  /// No description provided for @strategyReplace.
  ///
  /// In en, this message translates to:
  /// **'Replace everything'**
  String get strategyReplace;

  /// No description provided for @strategyMerge.
  ///
  /// In en, this message translates to:
  /// **'Merge with current data'**
  String get strategyMerge;

  /// No description provided for @importPreview.
  ///
  /// In en, this message translates to:
  /// **'{nodes} nodes, {links} links, {notes} notes, {emails} emails, {subs} subscriptions, {platforms} platforms, {variables} variables, {alerts} alerts'**
  String importPreview(
    int nodes,
    int links,
    int notes,
    int emails,
    int subs,
    int platforms,
    int variables,
    int alerts,
  );

  /// No description provided for @exportDone.
  ///
  /// In en, this message translates to:
  /// **'Export completed successfully'**
  String get exportDone;

  /// No description provided for @importDone.
  ///
  /// In en, this message translates to:
  /// **'Import completed successfully'**
  String get importDone;

  /// No description provided for @dataError.
  ///
  /// In en, this message translates to:
  /// **'Operation failed. Please try again.'**
  String get dataError;

  /// No description provided for @trashEmpty.
  ///
  /// In en, this message translates to:
  /// **'Trash is empty'**
  String get trashEmpty;

  /// No description provided for @trashAutoPurge.
  ///
  /// In en, this message translates to:
  /// **'Items are kept for 30 days, then permanently removed.'**
  String get trashAutoPurge;

  /// No description provided for @purgeNow.
  ///
  /// In en, this message translates to:
  /// **'Empty trash now'**
  String get purgeNow;

  /// No description provided for @purgeConfirm.
  ///
  /// In en, this message translates to:
  /// **'Permanently delete everything in trash? This cannot be undone.'**
  String get purgeConfirm;

  /// No description provided for @restoreNode.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get restoreNode;

  /// No description provided for @deleteForever.
  ///
  /// In en, this message translates to:
  /// **'Delete forever'**
  String get deleteForever;

  /// No description provided for @accountSection.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get accountSection;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get changePassword;

  /// No description provided for @currentPassword.
  ///
  /// In en, this message translates to:
  /// **'Current password'**
  String get currentPassword;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get newPassword;

  /// No description provided for @analyticsSection.
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get analyticsSection;

  /// No description provided for @analyticsDesc.
  ///
  /// In en, this message translates to:
  /// **'Share minimal anonymous usage events (install, first project, trial start, purchase, active projects count). No content ever leaves your device.'**
  String get analyticsDesc;

  /// No description provided for @analyticsOn.
  ///
  /// In en, this message translates to:
  /// **'On'**
  String get analyticsOn;

  /// No description provided for @analyticsOff.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get analyticsOff;

  /// No description provided for @aboutSection.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get aboutSection;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @alertsCenter.
  ///
  /// In en, this message translates to:
  /// **'Alerts center'**
  String get alertsCenter;

  /// No description provided for @upcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get upcoming;

  /// No description provided for @fired.
  ///
  /// In en, this message translates to:
  /// **'Fired'**
  String get fired;

  /// No description provided for @alertDisabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get alertDisabled;

  /// No description provided for @noAlerts.
  ///
  /// In en, this message translates to:
  /// **'No alerts yet'**
  String get noAlerts;

  /// No description provided for @alertTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Alert title'**
  String get alertTitleLabel;

  /// No description provided for @alertDateTime.
  ///
  /// In en, this message translates to:
  /// **'Date & time'**
  String get alertDateTime;

  /// No description provided for @reminderBefore.
  ///
  /// In en, this message translates to:
  /// **'Remind {min} min before'**
  String reminderBefore(int min);

  /// No description provided for @reminderNone.
  ///
  /// In en, this message translates to:
  /// **'No early reminder'**
  String get reminderNone;

  /// No description provided for @notifPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Notifications permission was denied. Alerts will not appear — enable it in system settings.'**
  String get notifPermissionDenied;

  /// No description provided for @featureLocked.
  ///
  /// In en, this message translates to:
  /// **'Trial ended — upgrade to continue.'**
  String get featureLocked;

  /// No description provided for @fieldRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get fieldRequired;

  /// No description provided for @nameTooLong.
  ///
  /// In en, this message translates to:
  /// **'Name is too long'**
  String get nameTooLong;

  /// No description provided for @urlInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid URL'**
  String get urlInvalid;

  /// No description provided for @emailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email'**
  String get emailInvalid;

  /// No description provided for @passwordShort.
  ///
  /// In en, this message translates to:
  /// **'At least 8 characters'**
  String get passwordShort;

  /// No description provided for @passwordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordMismatch;

  /// No description provided for @unexpectedError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get unexpectedError;

  /// No description provided for @openNode.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get openNode;

  /// No description provided for @items.
  ///
  /// In en, this message translates to:
  /// **'Items'**
  String get items;

  /// No description provided for @emptyState.
  ///
  /// In en, this message translates to:
  /// **'Nothing here yet — use the + button to create'**
  String get emptyState;

  /// No description provided for @noteOf.
  ///
  /// In en, this message translates to:
  /// **'Note {index} of {total}'**
  String noteOf(int index, int total);

  /// No description provided for @theme1.
  ///
  /// In en, this message translates to:
  /// **'Programmer Blue'**
  String get theme1;

  /// No description provided for @theme2.
  ///
  /// In en, this message translates to:
  /// **'Terminal Green'**
  String get theme2;

  /// No description provided for @theme3.
  ///
  /// In en, this message translates to:
  /// **'Neon Purple'**
  String get theme3;

  /// No description provided for @theme4.
  ///
  /// In en, this message translates to:
  /// **'Sunset Orange'**
  String get theme4;

  /// No description provided for @theme5.
  ///
  /// In en, this message translates to:
  /// **'Night Crimson'**
  String get theme5;

  /// No description provided for @theme6.
  ///
  /// In en, this message translates to:
  /// **'Ocean Teal'**
  String get theme6;

  /// No description provided for @theme7.
  ///
  /// In en, this message translates to:
  /// **'Metal Silver'**
  String get theme7;

  /// No description provided for @theme8.
  ///
  /// In en, this message translates to:
  /// **'Midnight Gold'**
  String get theme8;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
