// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get loading => 'Loading';

  @override
  String get mainHome => 'Home';

  @override
  String get mainTimetable => 'Zeitplan';

  @override
  String get mainICanteen => 'iCanteen';

  @override
  String get mainMessages => 'Nachrichten';

  @override
  String get mainHomework => 'Hausaufgaben';

  @override
  String get mainGrades => 'Noten';

  @override
  String get homeLunchesNotLoaded => 'Konnte das Essen nicht Laden';

  @override
  String get homeNoLunchToday => 'Du hast für Heute kein Essen geplant';

  @override
  String homeLunchToday(int lunch) {
    return 'Sie haben die Möglichkeit, zu Mittag zu essen $lunch';
  }

  @override
  String homeLunchDontForget(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return 'Vergiss nicht dein essen zu Bestellen für den $dateString';
  }

  @override
  String get homeLogout => 'Abmelden';

  @override
  String get homeOnboarding => 'Einführung';

  @override
  String get homeSetupICanteen => 'iCanteen einrichten';

  @override
  String get homeNoClasses => 'Heute ist keine Schule :D';

  @override
  String get homeUpdateTitle => 'Neue Version Verfügbar';

  @override
  String get homeUpdateDescription =>
      'Bitte besuchen Sie https://github.com/DislikesSchool/EduPage2/releases, um die neueste Version herunterzuladen';

  @override
  String get homeQuickstart => 'Schnell Stark';

  @override
  String get homePreview => 'Vorschau';

  @override
  String get homePatchAvailable => 'Installiere Neuen Patch…';

  @override
  String get homePatchDownloaded =>
      'Patch heruntergeladen, Bitte starte die App neu um ihn zu Installieren';

  @override
  String get homeDeleteData => 'Daten Löschen';

  @override
  String get homeDeleteDataTitle => 'Daten Löschen';

  @override
  String get homeDeleteDataConfirmation =>
      'Sind Sie sicher, dass Sie die Löschung der Daten vom Server beantragen möchten?';

  @override
  String get homeDeleteDataProcessing => 'Lösche daten.…';

  @override
  String get homeDeleteDataSuccess => 'Daten Erfolgreich Gelöscht';

  @override
  String get homeDeleteDataError => 'Daten konnten nicht gelöscht werden';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get confirm => 'Bestätigen';

  @override
  String get homeGrades => 'Noten';

  @override
  String get homeHomework => 'Hausaufgaben';

  @override
  String get homeworkTitle => 'Hausaufgaben';

  @override
  String get messagesTitle => 'Nachrichten';

  @override
  String get loginPleaseLogin => 'Bitte melde dich bei Edupage2 an';

  @override
  String get loginUseExistingCredentials =>
      'Nutze deine Existierenden Edupage Anmelde Daten';

  @override
  String get loginUsername => 'Nutzername';

  @override
  String get loginPassword => 'Password';

  @override
  String get loginServer => 'Server (z. B. Schule.edupage.org)';

  @override
  String get loginLogin => 'Anmelden';

  @override
  String get loggingIn => 'Anmeden....';

  @override
  String get loginCustomEndpointCheckbox =>
      'Benutzerdefinierten Endpunkt verwenden';

  @override
  String get loginCustomEndpoint => 'Benutzerdefinierte Endpunkt-URL eingeben';

  @override
  String get loginDemoButton => 'Oder Benutzte die Demo Version';

  @override
  String get loginCredentialsRequired =>
      'Benutzername und Passwort sind erforderlich';

  @override
  String get loginInvalidCredentials => 'Ungültiger Benutzername oder Passwort';

  @override
  String get loginServerOptional =>
      'Der Server ist optional, kann jedoch hilfreich sein, wenn Sie sich nicht anmelden können und sicher sind, dass Sie über die richtigen Anmeldedaten verfügen';

  @override
  String get setupWelcomeTitle => 'Willkommen auf Edupage2';

  @override
  String get setupWelcomeBody =>
      'EduPage2 ist ein moderner Client für Edupage, der sich auf Geschwindigkeit, Effizienz und Benutzerfreundlichkeit konzentriert. EduPage2 ist vollständig Open Source und kostenlos nutzbar. Treten Sie unserem Discord-Server bei, um Neuigkeiten und Updates zu erhalten';

  @override
  String get setupQuickStartTitle => 'Schnell Start';

  @override
  String get setupQuickStartExplanation =>
      'Experimentelle Funktion zur Beschleunigung der App Ladezeiten';

  @override
  String get setupQuickStartEnable => 'Schnellstart aktivieren';

  @override
  String get setupQuickStartDetails =>
      'Durch Aktivieren von „Schnellstart“ bevorzugt die App zwischengespeicherte Daten gegenüber Daten, die vom Server abgerufen werden. Diese Option kann im Nachhinein deaktiviert werden.';

  @override
  String get setupQuickStartInfo => 'Schnellstart Ist immernoch Experimentell';

  @override
  String get setupQuickStartBenefits =>
      'Mit „Schnellstart“ wird die App fast sofort gestartet und ruft Daten im Hintergrund vom Server ab, anstatt auf die Antwort des Servers zu warten.';

  @override
  String get setupQuickStartDrawbacks =>
      'Dies beschleunigt zwar die anfängliche Ladezeit, kann jedoch dazu führen, dass kurzzeitig veraltete Daten angezeigt werden.';

  @override
  String get setupDataStorageTitle => 'Datenspeicherung';

  @override
  String get setupDataStorageExplanation =>
      'EduPage2 kann optional einige Benutzerdaten auf dem EduPage2-Server speichern, um erweiterte Funktionen bereitzustellen. Die App funktioniert auch ohne diese Speicherung einwandfrei, jedoch können einige Funktionen eingeschränkt sein.';

  @override
  String get setupDataStorageDisabled => 'Der Serverspeicher ist deaktiviert';

  @override
  String get setupDataStorageDisabledExplanation =>
      'Der Serverspeicher ist auf der EduPage2-Serverinstanz, mit der Sie sich verbinden, deaktiviert.';

  @override
  String get setupDataStoragePrivacyEncrypted =>
      'Ihre Daten SInd verschlüsselt';

  @override
  String get setupDataStoragePrivacyUnencrypted =>
      'Ihre Daten sind nicht verschlüsselt';

  @override
  String get setupDataStoragePrivacyDetailsEncrypted =>
      'Der Server, mit dem Sie sich verbinden, speichert Ihre Anmeldedaten auf sichere und verschlüsselte Weise';

  @override
  String get setupDataStoragePrivacyDetailsUnencrypted =>
      'The server that you are connecting to does not encrypt your data. We would recommend either enabling encryption on the server, or using the official EduPage2 server to store your data securely.';

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
  String get setupDataStoragePrivacyDetails =>
      'The EduPage2 server stores data securely and in an encrypted manner on a private dedicated server. No data is shared with any external parties.';

  @override
  String get setupFeaturesAvailable => 'Working features';

  @override
  String get setupFeatureBasic =>
      'Basic app functionality (messages, timetables, grades, ...)';

  @override
  String get setupFeatureNotifications => 'Push notificatons';

  @override
  String get setupFeatureSearch => 'Full-text search';

  @override
  String get setupCompleteTitle => 'Setup Complete';

  @override
  String get setupCompleteBody =>
      'Your setup is complete. You can now start using EduPage2.';

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
  String get loadErrorDescription =>
      'There was an error loading data. This error has been reported.';

  @override
  String get iCanteenLoading => 'Loading lunches (this could take a while)';

  @override
  String get iCanteenCantLoad => 'Unable to load lunches';

  @override
  String get iCanteenSetupPleaseLogin => 'Login to iCanteen';

  @override
  String get iCanteenSetupDetails =>
      'URL address in this format: https://lunches.yourschool.com/login';

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
  String get createMessageDiscardDescription =>
      'The message has not been sent yet. Are you sure you want to discard it?';

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
  String get createMessageNotifErrorBody =>
      'There was an issue sending your message, it has been reported!';

  @override
  String get qrLoginPleaseLogin => 'EduPage2 QR Login';

  @override
  String get qrLoginUseExistingCredentials =>
      'You are about to login to EduPage2 using a QR code';

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
