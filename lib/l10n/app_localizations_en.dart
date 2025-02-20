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
  String get homePatchAvailable => 'Installing new patch...';

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
  String get loginCustomEndpointCheckbox => 'Use custom endpoint';

  @override
  String get loginCustomEndpoint => 'Enter custom endpoint URL';

  @override
  String get loginDemoButton => 'Or try the demo';

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
  String get loadCredentials => 'Loading credentials...';

  @override
  String get loadLoggingIn => 'Logging in...';

  @override
  String get loadLoggedIn => 'Logged in';

  @override
  String get loadAccessToken => 'Getting access token...';

  @override
  String get loadVerify => 'Verifying';

  @override
  String get loadDownloadTimetable => 'Downloading time table...';

  @override
  String get loadDownloadGrades => 'Downloading grades...';

  @override
  String get loadDownloadMessages => 'Downloading messages...';

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
  String get messagesLoadingAttachment => 'Loading pdf...';

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
  String get createMessageNotifSendingBody => 'Your message is being sent...';

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
}
