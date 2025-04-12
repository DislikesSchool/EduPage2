import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get loading => 'Loading';

  @override
  String get mainHome => 'Home';

  @override
  String get mainTimetable => 'Time table';

  @override
  String get mainICanteen => 'iCanteen';

  @override
  String get mainMessages => 'Messages';

  @override
  String get mainHomework => 'Homework';

  @override
  String get mainGrades => 'Grades';

  @override
  String get homeLunchesNotLoaded => 'Could not load lunches';

  @override
  String get homeNoLunchToday => 'You don\'t have any lunch for today';

  @override
  String homeLunchToday(int lunch) {
    return 'You have lunch option number $lunch';
  }

  @override
  String homeLunchDontForget(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return 'Don\'t forget to order lunch for $dateString';
  }

  @override
  String get homeLogout => 'Logout';

  @override
  String get homeOnboarding => 'Onboarding';

  @override
  String get homeSetupICanteen => 'Setup iCanteen';

  @override
  String get homeNoClasses => 'No school today :D';

  @override
  String get homeUpdateTitle => 'New version available';

  @override
  String get homeUpdateDescription => 'Please visit https://github.com/DislikesSchool/EduPage2/releases to download the latest version';

  @override
  String get homeQuickstart => 'QuickStart';

  @override
  String get homePreview => 'Preview';

  @override
  String get homePatchAvailable => 'Installing new patch…';

  @override
  String get homePatchDownloaded => 'Patch downloaded, please restart EduPage2';

  @override
  String get homeGrades => 'Grades';

  @override
  String get homeHomework => 'Homework';

  @override
  String get homeworkTitle => 'Homework';

  @override
  String get messagesTitle => 'Messages';

  @override
  String get loginPleaseLogin => 'Please login to EduPage2';

  @override
  String get loginUseExistingCredentials => 'Use your existing EduPage credentials';

  @override
  String get loginUsername => 'Username';

  @override
  String get loginPassword => 'Password';

  @override
  String get loginServer => 'Server (e.g., school.edupage.org)';

  @override
  String get loginLogin => 'Login';

  @override
  String get loggingIn => 'Logging in...';

  @override
  String get loginCustomEndpointCheckbox => 'Use custom endpoint';

  @override
  String get loginCustomEndpoint => 'Enter custom endpoint URL';

  @override
  String get loginDemoButton => 'Or try the demo';

  @override
  String get loginCredentialsRequired => 'Username and password are required';

  @override
  String get loginInvalidCredentials => 'Invalid username or password';

  @override
  String get loginServerOptional => 'Server is optional, but might help if you are unable to login and are sure you have the correct credentials';

  @override
  String get setupWelcomeTitle => 'Welcome to EduPage2';

  @override
  String get setupWelcomeBody => 'EduPage2 is a modern client for Edupage focusing on speed, efficiency and user experience. EduPage2 is fully open-source and free to use. Make sure to join our Discord server for news and updates.';

  @override
  String get setupQuickStartTitle => 'Quick Start';

  @override
  String get setupQuickStartExplanation => 'Experimental feature to greatly speed up app loading times.';

  @override
  String get setupQuickStartEnable => 'Enable Quick Start';

  @override
  String get setupQuickStartDetails => 'Enabling Quick Start will make the app prefer cached data over fetching data from the server. This can be disabled later.';

  @override
  String get setupQuickStartInfo => 'Quick Start is still experimental';

  @override
  String get setupQuickStartBenefits => 'Quick Start will make the app start nearly instant, and fetch data from the server in the background, as opposed to waiting for the server to respond.';

  @override
  String get setupQuickStartDrawbacks => 'While this speeds up the initial loading time, it may lead to outdated data being displayed briefly.';

  @override
  String get setupDataStorageTitle => 'Data Storage';

  @override
  String get setupDataStorageExplanation => 'EduPage2 has can optionally store some user data on the EduPage2 server to provide advanced functionality. The app will work fine without it, but some features may be limited.';

  @override
  String get setupDataStorageDisabled => 'Server storage is disabled';

  @override
  String get setupDataStorageDisabledExplanation => 'Server storage is disabled on the EduPage2 server instance that you are connecting to.';

  @override
  String get setupDataStoragePrivacyEncrypted => 'Your data is encrypted';

  @override
  String get setupDataStoragePrivacyUnencrypted => 'Your data is not encrypted';

  @override
  String get setupDataStoragePrivacyDetailsEncrypted => 'The server that you are connecting to stores your credentials in a secure and encrypted manner.';

  @override
  String get setupDataStoragePrivacyDetailsUnencrypted => 'The server that you are connecting to does not encrypt your data. We would recommend either enabling encryption on the server, or using the official EduPage2 server to store your data securely.';

  @override
  String get setupDataStorageEnable => 'Enable Data Storage';

  @override
  String get setupDataStorageChoose => 'Choose what data to store';

  @override
  String get setupDataStorageAttendance => 'User login credentials';

  @override
  String get setupDataStorageGrades => 'Text message storage';

  @override
  String get setupDataStorageMessages => 'Timeline storage';

  @override
  String get setupDataStoragePrivacy => 'EduPage2 Data Storage Security';

  @override
  String get setupDataStoragePrivacyDetails => 'The EduPage2 server stores data securely and in an encrypted manner on a private dedicated server. No data is shared with any external parties.';

  @override
  String get setupFeaturesAvailable => 'Working features';

  @override
  String get setupFeatureBasic => 'Basic app functionality (messages, timetables, grades, ...)';

  @override
  String get setupFeatureNotifications => 'Push notificatons';

  @override
  String get setupFeatureSearch => 'Full-text search';

  @override
  String get setupCompleteTitle => 'Setup Complete';

  @override
  String get setupCompleteBody => 'Your setup is complete. You can now start using EduPage2.';

  @override
  String get setupDone => 'Setup Done';

  @override
  String get today => 'Today';

  @override
  String get tomorrow => 'Tomorrow';

  @override
  String timetableTeacher(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
      
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString Teachers',
      one: 'Teacher',
    );
    return '$_temp0';
  }

  @override
  String get loadCredentials => 'Loading credentials…';

  @override
  String get loadLoggingIn => 'Logging in…';

  @override
  String get loadLoggedIn => 'Logged in';

  @override
  String get loadAccessToken => 'Getting access token…';

  @override
  String get loadVerify => 'Verifying';

  @override
  String get loadDownloadTimetable => 'Downloading time table…';

  @override
  String get loadDownloadGrades => 'Downloading grades…';

  @override
  String get loadDownloadMessages => 'Downloading messages…';

  @override
  String get loadDone => 'Done!';

  @override
  String get loadError => 'Error';

  @override
  String get loadErrorDescription => 'There was an error loading data. This error has been reported.';

  @override
  String get iCanteenLoading => 'Loading lunches (this could take a while)';

  @override
  String get iCanteenCantLoad => 'Unable to load lunches';

  @override
  String get iCanteenSetupPleaseLogin => 'Login to iCanteen';

  @override
  String get iCanteenSetupDetails => 'URL address in this format: https://lunches.yourschool.com/login';

  @override
  String get iCanteenSetupServer => 'Server address';

  @override
  String get iCanteenSetupEmail => 'Username';

  @override
  String get iCanteenSetupPassword => 'Password';

  @override
  String get iCanteenSetupError => 'There was an error logging in';

  @override
  String get messagesLoadingAttachment => 'Loading pdf…';

  @override
  String messagesAttachments(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
      
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString Attachments',
      one: '1 Attachment',
    );
    return '$_temp0';
  }

  @override
  String get messagesPoll => 'Poll';

  @override
  String get createMessageDiscard => 'Discard message?';

  @override
  String get createMessageDiscardDescription => 'The message has not been sent yet. Are you sure you want to discard it?';

  @override
  String get createMessageDiscardCancel => 'Cancel';

  @override
  String get createMessageDiscardDiscard => 'Discard';

  @override
  String get createMessageTitle => 'New message';

  @override
  String get createMessageSelectRecipient => 'Select recipient';

  @override
  String get createMessageMessageHere => 'Your message here';

  @override
  String get createMessageImportant => 'Important';

  @override
  String get createMessageIncludePoll => 'Include poll';

  @override
  String get createMessagePollEnableMultiple => 'Allow multiple answers';

  @override
  String get createMessageNewPollOptionPlaceholder => 'New option';

  @override
  String get createMessageErrorSelectRecipient => 'Please select a recipient';

  @override
  String get createMessageErrorNoMessage => 'Please write a message';

  @override
  String get createMessageSend => 'Send';

  @override
  String get createMessageNotifSending => 'Sending message';

  @override
  String get createMessageNotifSendingBody => 'Your message is being sent…';

  @override
  String get createMessageNotifSent => 'Sent message';

  @override
  String get createMessageNotifSentBody => 'Your message was sent successfully';

  @override
  String get createMessageNotifError => 'Error';

  @override
  String get createMessageNotifErrorBody => 'There was an issue sending your message, it has been reported!';

  @override
  String get qrLoginPleaseLogin => 'EduPage2 QR Login';

  @override
  String get qrLoginUseExistingCredentials => 'You are about to login to EduPage2 using a QR code';

  @override
  String get gradesTitle => 'Grades';

  @override
  String get messagesSearchTitle => 'Search messages';

  @override
  String get messagesSearchHint => 'Enter search term…';

  @override
  String get messagesSearchInstructions => 'Enter a search term above';

  @override
  String get messagesNoResults => 'No results found';
}
