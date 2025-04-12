import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_cs.dart';
import 'app_localizations_en.dart';
import 'app_localizations_sk.dart';

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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('cs'),
    Locale('en'),
    Locale('sk')
  ];

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading'**
  String get loading;

  /// No description provided for @mainHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get mainHome;

  /// No description provided for @mainTimetable.
  ///
  /// In en, this message translates to:
  /// **'Time table'**
  String get mainTimetable;

  /// No description provided for @mainICanteen.
  ///
  /// In en, this message translates to:
  /// **'iCanteen'**
  String get mainICanteen;

  /// No description provided for @mainMessages.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get mainMessages;

  /// No description provided for @mainHomework.
  ///
  /// In en, this message translates to:
  /// **'Homework'**
  String get mainHomework;

  /// No description provided for @mainGrades.
  ///
  /// In en, this message translates to:
  /// **'Grades'**
  String get mainGrades;

  /// No description provided for @homeLunchesNotLoaded.
  ///
  /// In en, this message translates to:
  /// **'Could not load lunches'**
  String get homeLunchesNotLoaded;

  /// No description provided for @homeNoLunchToday.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have any lunch for today'**
  String get homeNoLunchToday;

  /// Shows the user the lunch that is ordered
  ///
  /// In en, this message translates to:
  /// **'You have lunch option number {lunch}'**
  String homeLunchToday(int lunch);

  /// Displayed to remind user to order lunch
  ///
  /// In en, this message translates to:
  /// **'Don\'t forget to order lunch for {date}'**
  String homeLunchDontForget(DateTime date);

  /// No description provided for @homeLogout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get homeLogout;

  /// No description provided for @homeOnboarding.
  ///
  /// In en, this message translates to:
  /// **'Onboarding'**
  String get homeOnboarding;

  /// No description provided for @homeSetupICanteen.
  ///
  /// In en, this message translates to:
  /// **'Setup iCanteen'**
  String get homeSetupICanteen;

  /// No description provided for @homeNoClasses.
  ///
  /// In en, this message translates to:
  /// **'No school today :D'**
  String get homeNoClasses;

  /// No description provided for @homeUpdateTitle.
  ///
  /// In en, this message translates to:
  /// **'New version available'**
  String get homeUpdateTitle;

  /// No description provided for @homeUpdateDescription.
  ///
  /// In en, this message translates to:
  /// **'Please visit https://github.com/DislikesSchool/EduPage2/releases to download the latest version'**
  String get homeUpdateDescription;

  /// No description provided for @homeQuickstart.
  ///
  /// In en, this message translates to:
  /// **'QuickStart'**
  String get homeQuickstart;

  /// No description provided for @homePreview.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get homePreview;

  /// No description provided for @homePatchAvailable.
  ///
  /// In en, this message translates to:
  /// **'Installing new patch…'**
  String get homePatchAvailable;

  /// No description provided for @homePatchDownloaded.
  ///
  /// In en, this message translates to:
  /// **'Patch downloaded, please restart EduPage2'**
  String get homePatchDownloaded;

  /// No description provided for @homeGrades.
  ///
  /// In en, this message translates to:
  /// **'Grades'**
  String get homeGrades;

  /// No description provided for @homeHomework.
  ///
  /// In en, this message translates to:
  /// **'Homework'**
  String get homeHomework;

  /// No description provided for @homeworkTitle.
  ///
  /// In en, this message translates to:
  /// **'Homework'**
  String get homeworkTitle;

  /// No description provided for @messagesTitle.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get messagesTitle;

  /// No description provided for @loginPleaseLogin.
  ///
  /// In en, this message translates to:
  /// **'Please login to EduPage2'**
  String get loginPleaseLogin;

  /// No description provided for @loginUseExistingCredentials.
  ///
  /// In en, this message translates to:
  /// **'Use your existing EduPage credentials'**
  String get loginUseExistingCredentials;

  /// No description provided for @loginUsername.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get loginUsername;

  /// No description provided for @loginPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get loginPassword;

  /// No description provided for @loginServer.
  ///
  /// In en, this message translates to:
  /// **'Server (e.g., school.edupage.org)'**
  String get loginServer;

  /// No description provided for @loginLogin.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginLogin;

  /// No description provided for @loggingIn.
  ///
  /// In en, this message translates to:
  /// **'Logging in...'**
  String get loggingIn;

  /// No description provided for @loginCustomEndpointCheckbox.
  ///
  /// In en, this message translates to:
  /// **'Use custom endpoint'**
  String get loginCustomEndpointCheckbox;

  /// No description provided for @loginCustomEndpoint.
  ///
  /// In en, this message translates to:
  /// **'Enter custom endpoint URL'**
  String get loginCustomEndpoint;

  /// No description provided for @loginDemoButton.
  ///
  /// In en, this message translates to:
  /// **'Or try the demo'**
  String get loginDemoButton;

  /// No description provided for @loginCredentialsRequired.
  ///
  /// In en, this message translates to:
  /// **'Username and password are required'**
  String get loginCredentialsRequired;

  /// No description provided for @loginInvalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Invalid username or password'**
  String get loginInvalidCredentials;

  /// No description provided for @loginServerOptional.
  ///
  /// In en, this message translates to:
  /// **'Server is optional, but might help if you are unable to login and are sure you have the correct credentials'**
  String get loginServerOptional;

  /// No description provided for @setupWelcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to EduPage2'**
  String get setupWelcomeTitle;

  /// No description provided for @setupWelcomeBody.
  ///
  /// In en, this message translates to:
  /// **'EduPage2 is a modern client for Edupage focusing on speed, efficiency and user experience. EduPage2 is fully open-source and free to use. Make sure to join our Discord server for news and updates.'**
  String get setupWelcomeBody;

  /// No description provided for @setupQuickStartTitle.
  ///
  /// In en, this message translates to:
  /// **'Quick Start'**
  String get setupQuickStartTitle;

  /// No description provided for @setupQuickStartExplanation.
  ///
  /// In en, this message translates to:
  /// **'Experimental feature to greatly speed up app loading times.'**
  String get setupQuickStartExplanation;

  /// No description provided for @setupQuickStartEnable.
  ///
  /// In en, this message translates to:
  /// **'Enable Quick Start'**
  String get setupQuickStartEnable;

  /// No description provided for @setupQuickStartDetails.
  ///
  /// In en, this message translates to:
  /// **'Enabling Quick Start will make the app prefer cached data over fetching data from the server. This can be disabled later.'**
  String get setupQuickStartDetails;

  /// No description provided for @setupQuickStartInfo.
  ///
  /// In en, this message translates to:
  /// **'Quick Start is still experimental'**
  String get setupQuickStartInfo;

  /// No description provided for @setupQuickStartBenefits.
  ///
  /// In en, this message translates to:
  /// **'Quick Start will make the app start nearly instant, and fetch data from the server in the background, as opposed to waiting for the server to respond.'**
  String get setupQuickStartBenefits;

  /// No description provided for @setupQuickStartDrawbacks.
  ///
  /// In en, this message translates to:
  /// **'While this speeds up the initial loading time, it may lead to outdated data being displayed briefly.'**
  String get setupQuickStartDrawbacks;

  /// No description provided for @setupDataStorageTitle.
  ///
  /// In en, this message translates to:
  /// **'Data Storage'**
  String get setupDataStorageTitle;

  /// No description provided for @setupDataStorageExplanation.
  ///
  /// In en, this message translates to:
  /// **'EduPage2 has can optionally store some user data on the EduPage2 server to provide advanced functionality. The app will work fine without it, but some features may be limited.'**
  String get setupDataStorageExplanation;

  /// No description provided for @setupDataStorageEnable.
  ///
  /// In en, this message translates to:
  /// **'Enable Data Storage'**
  String get setupDataStorageEnable;

  /// No description provided for @setupDataStorageChoose.
  ///
  /// In en, this message translates to:
  /// **'Choose what data to store'**
  String get setupDataStorageChoose;

  /// No description provided for @setupDataStorageAttendance.
  ///
  /// In en, this message translates to:
  /// **'User login credentials'**
  String get setupDataStorageAttendance;

  /// No description provided for @setupDataStorageGrades.
  ///
  /// In en, this message translates to:
  /// **'Text message storage'**
  String get setupDataStorageGrades;

  /// No description provided for @setupDataStorageMessages.
  ///
  /// In en, this message translates to:
  /// **'Timeline storage'**
  String get setupDataStorageMessages;

  /// No description provided for @setupDataStoragePrivacy.
  ///
  /// In en, this message translates to:
  /// **'EduPage2 Data Storage Security'**
  String get setupDataStoragePrivacy;

  /// No description provided for @setupDataStoragePrivacyDetails.
  ///
  /// In en, this message translates to:
  /// **'The EduPage2 server stores data securely and in an encrypted manner on a private dedicated server. No data is shared with any external parties.'**
  String get setupDataStoragePrivacyDetails;

  /// No description provided for @setupFeaturesAvailable.
  ///
  /// In en, this message translates to:
  /// **'Working features'**
  String get setupFeaturesAvailable;

  /// No description provided for @setupFeatureBasic.
  ///
  /// In en, this message translates to:
  /// **'Basic app functionality (messages, timetables, grades, ...)'**
  String get setupFeatureBasic;

  /// No description provided for @setupFeatureNotifications.
  ///
  /// In en, this message translates to:
  /// **'Push notificatons'**
  String get setupFeatureNotifications;

  /// No description provided for @setupFeatureSearch.
  ///
  /// In en, this message translates to:
  /// **'Full-text search'**
  String get setupFeatureSearch;

  /// No description provided for @setupCompleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Setup Complete'**
  String get setupCompleteTitle;

  /// No description provided for @setupCompleteBody.
  ///
  /// In en, this message translates to:
  /// **'Your setup is complete. You can now start using EduPage2.'**
  String get setupCompleteBody;

  /// No description provided for @setupDone.
  ///
  /// In en, this message translates to:
  /// **'Setup Done'**
  String get setupDone;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @tomorrow.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get tomorrow;

  /// No description provided for @timetableTeacher.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Teacher} other{{count} Teachers}}'**
  String timetableTeacher(num count);

  /// No description provided for @loadCredentials.
  ///
  /// In en, this message translates to:
  /// **'Loading credentials…'**
  String get loadCredentials;

  /// No description provided for @loadLoggingIn.
  ///
  /// In en, this message translates to:
  /// **'Logging in…'**
  String get loadLoggingIn;

  /// No description provided for @loadLoggedIn.
  ///
  /// In en, this message translates to:
  /// **'Logged in'**
  String get loadLoggedIn;

  /// No description provided for @loadAccessToken.
  ///
  /// In en, this message translates to:
  /// **'Getting access token…'**
  String get loadAccessToken;

  /// No description provided for @loadVerify.
  ///
  /// In en, this message translates to:
  /// **'Verifying'**
  String get loadVerify;

  /// No description provided for @loadDownloadTimetable.
  ///
  /// In en, this message translates to:
  /// **'Downloading time table…'**
  String get loadDownloadTimetable;

  /// No description provided for @loadDownloadGrades.
  ///
  /// In en, this message translates to:
  /// **'Downloading grades…'**
  String get loadDownloadGrades;

  /// No description provided for @loadDownloadMessages.
  ///
  /// In en, this message translates to:
  /// **'Downloading messages…'**
  String get loadDownloadMessages;

  /// No description provided for @loadDone.
  ///
  /// In en, this message translates to:
  /// **'Done!'**
  String get loadDone;

  /// No description provided for @loadError.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get loadError;

  /// No description provided for @loadErrorDescription.
  ///
  /// In en, this message translates to:
  /// **'There was an error loading data. This error has been reported.'**
  String get loadErrorDescription;

  /// No description provided for @iCanteenLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading lunches (this could take a while)'**
  String get iCanteenLoading;

  /// No description provided for @iCanteenCantLoad.
  ///
  /// In en, this message translates to:
  /// **'Unable to load lunches'**
  String get iCanteenCantLoad;

  /// No description provided for @iCanteenSetupPleaseLogin.
  ///
  /// In en, this message translates to:
  /// **'Login to iCanteen'**
  String get iCanteenSetupPleaseLogin;

  /// No description provided for @iCanteenSetupDetails.
  ///
  /// In en, this message translates to:
  /// **'URL address in this format: https://lunches.yourschool.com/login'**
  String get iCanteenSetupDetails;

  /// No description provided for @iCanteenSetupServer.
  ///
  /// In en, this message translates to:
  /// **'Server address'**
  String get iCanteenSetupServer;

  /// No description provided for @iCanteenSetupEmail.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get iCanteenSetupEmail;

  /// No description provided for @iCanteenSetupPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get iCanteenSetupPassword;

  /// No description provided for @iCanteenSetupError.
  ///
  /// In en, this message translates to:
  /// **'There was an error logging in'**
  String get iCanteenSetupError;

  /// No description provided for @messagesLoadingAttachment.
  ///
  /// In en, this message translates to:
  /// **'Loading pdf…'**
  String get messagesLoadingAttachment;

  /// No description provided for @messagesAttachments.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 Attachment} other{{count} Attachments}}'**
  String messagesAttachments(num count);

  /// No description provided for @messagesPoll.
  ///
  /// In en, this message translates to:
  /// **'Poll'**
  String get messagesPoll;

  /// No description provided for @createMessageDiscard.
  ///
  /// In en, this message translates to:
  /// **'Discard message?'**
  String get createMessageDiscard;

  /// No description provided for @createMessageDiscardDescription.
  ///
  /// In en, this message translates to:
  /// **'The message has not been sent yet. Are you sure you want to discard it?'**
  String get createMessageDiscardDescription;

  /// No description provided for @createMessageDiscardCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get createMessageDiscardCancel;

  /// No description provided for @createMessageDiscardDiscard.
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get createMessageDiscardDiscard;

  /// No description provided for @createMessageTitle.
  ///
  /// In en, this message translates to:
  /// **'New message'**
  String get createMessageTitle;

  /// No description provided for @createMessageSelectRecipient.
  ///
  /// In en, this message translates to:
  /// **'Select recipient'**
  String get createMessageSelectRecipient;

  /// No description provided for @createMessageMessageHere.
  ///
  /// In en, this message translates to:
  /// **'Your message here'**
  String get createMessageMessageHere;

  /// No description provided for @createMessageImportant.
  ///
  /// In en, this message translates to:
  /// **'Important'**
  String get createMessageImportant;

  /// No description provided for @createMessageIncludePoll.
  ///
  /// In en, this message translates to:
  /// **'Include poll'**
  String get createMessageIncludePoll;

  /// No description provided for @createMessagePollEnableMultiple.
  ///
  /// In en, this message translates to:
  /// **'Allow multiple answers'**
  String get createMessagePollEnableMultiple;

  /// No description provided for @createMessageNewPollOptionPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'New option'**
  String get createMessageNewPollOptionPlaceholder;

  /// No description provided for @createMessageErrorSelectRecipient.
  ///
  /// In en, this message translates to:
  /// **'Please select a recipient'**
  String get createMessageErrorSelectRecipient;

  /// No description provided for @createMessageErrorNoMessage.
  ///
  /// In en, this message translates to:
  /// **'Please write a message'**
  String get createMessageErrorNoMessage;

  /// No description provided for @createMessageSend.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get createMessageSend;

  /// No description provided for @createMessageNotifSending.
  ///
  /// In en, this message translates to:
  /// **'Sending message'**
  String get createMessageNotifSending;

  /// No description provided for @createMessageNotifSendingBody.
  ///
  /// In en, this message translates to:
  /// **'Your message is being sent…'**
  String get createMessageNotifSendingBody;

  /// No description provided for @createMessageNotifSent.
  ///
  /// In en, this message translates to:
  /// **'Sent message'**
  String get createMessageNotifSent;

  /// No description provided for @createMessageNotifSentBody.
  ///
  /// In en, this message translates to:
  /// **'Your message was sent successfully'**
  String get createMessageNotifSentBody;

  /// No description provided for @createMessageNotifError.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get createMessageNotifError;

  /// No description provided for @createMessageNotifErrorBody.
  ///
  /// In en, this message translates to:
  /// **'There was an issue sending your message, it has been reported!'**
  String get createMessageNotifErrorBody;

  /// No description provided for @qrLoginPleaseLogin.
  ///
  /// In en, this message translates to:
  /// **'EduPage2 QR Login'**
  String get qrLoginPleaseLogin;

  /// No description provided for @qrLoginUseExistingCredentials.
  ///
  /// In en, this message translates to:
  /// **'You are about to login to EduPage2 using a QR code'**
  String get qrLoginUseExistingCredentials;

  /// No description provided for @gradesTitle.
  ///
  /// In en, this message translates to:
  /// **'Grades'**
  String get gradesTitle;

  /// No description provided for @messagesSearchTitle.
  ///
  /// In en, this message translates to:
  /// **'Search messages'**
  String get messagesSearchTitle;

  /// No description provided for @messagesSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Enter search term…'**
  String get messagesSearchHint;

  /// No description provided for @messagesSearchInstructions.
  ///
  /// In en, this message translates to:
  /// **'Enter a search term above'**
  String get messagesSearchInstructions;

  /// No description provided for @messagesNoResults.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get messagesNoResults;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['cs', 'en', 'sk'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'cs': return AppLocalizationsCs();
    case 'en': return AppLocalizationsEn();
    case 'sk': return AppLocalizationsSk();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
