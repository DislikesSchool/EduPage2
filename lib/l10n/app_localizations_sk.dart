import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Slovak (`sk`).
class AppLocalizationsSk extends AppLocalizations {
  AppLocalizationsSk([String locale = 'sk']) : super(locale);

  @override
  String get loading => 'Načítava sa';

  @override
  String get mainHome => 'Domov';

  @override
  String get mainTimetable => 'Rozvrh';

  @override
  String get mainICanteen => 'iCanteen';

  @override
  String get mainMessages => 'Správy';

  @override
  String get mainHomework => 'Úlohy';

  @override
  String get mainGrades => 'Známky';

  @override
  String get homeLunchesNotLoaded => 'Obedy neboli načítané';

  @override
  String get homeNoLunchToday => 'Na dnešný deň nemáš objednaný obed';

  @override
  String homeLunchToday(int lunch) {
    return 'Dnes máš obed číslo $lunch';
  }

  @override
  String homeLunchDontForget(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return 'Nezabudni si objednať obed na $dateString';
  }

  @override
  String get homeLogout => 'Odhlásiť sa';

  @override
  String get homeOnboarding => 'Onboarding';

  @override
  String get homeSetupICanteen => 'Nastaviť iCanteen';

  @override
  String get homeNoClasses => 'Dnes nemáš skolu! :D';

  @override
  String get homeUpdateTitle => 'Nová verzia dostupná';

  @override
  String get homeUpdateDescription => 'Prosím navštívte https://github.com/DislikesSchool/EduPage2/releases pre najnovšiu verziu';

  @override
  String get homeQuickstart => 'Rýchly štart';

  @override
  String get homePreview => 'Náhľad';

  @override
  String get homePatchAvailable => 'Inštaluje sa nový patch…';

  @override
  String get homePatchDownloaded => 'Patch bol stiahnutý, pre nainštalovanie reštartujte aplikáciu';

  @override
  String get homeDeleteData => 'Delete data';

  @override
  String get homeDeleteDataTitle => 'Delete data';

  @override
  String get homeDeleteDataConfirmation => 'Are you sure you want to request data deletion from the server?';

  @override
  String get homeDeleteDataProcessing => 'Deleting data…';

  @override
  String get homeDeleteDataSuccess => 'Data deleted successfully';

  @override
  String get homeDeleteDataError => 'Failed to delete data';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get homeGrades => 'Známky';

  @override
  String get homeHomework => 'Úlohy';

  @override
  String get homeworkTitle => 'Domáce úlohy';

  @override
  String get messagesTitle => 'Správy';

  @override
  String get loginPleaseLogin => 'Prihláste sa prosím';

  @override
  String get loginUseExistingCredentials => 'Použite svoje existujúce prihlasovacie údaje';

  @override
  String get loginUsername => 'Prihlasovacie meno';

  @override
  String get loginPassword => 'Heslo';

  @override
  String get loginServer => 'Server (napr. skola.edupage.org)';

  @override
  String get loginLogin => 'Prihlásiť sa';

  @override
  String get loggingIn => 'Logging in...';

  @override
  String get loginCustomEndpointCheckbox => 'Použiť valstný endpoint';

  @override
  String get loginCustomEndpoint => 'URL vlastného endpointu';

  @override
  String get loginDemoButton => 'Alebo si pozrite demo';

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
  String get today => 'Dnes';

  @override
  String get tomorrow => 'Zajtra';

  @override
  String timetableTeacher(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
      
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString Učiteľov',
      few: '$countString Učitelia',
      one: 'Učiteľ',
    );
    return '$_temp0';
  }

  @override
  String get loadCredentials => 'Načítavanie prihlasovacích údajov…';

  @override
  String get loadLoggingIn => 'Prihlasovanie…';

  @override
  String get loadLoggedIn => 'Prihlásené';

  @override
  String get loadAccessToken => 'Získavanie prihlasovacieho tokenu…';

  @override
  String get loadVerify => 'Overovanie';

  @override
  String get loadDownloadTimetable => 'Sťahovanie rozvrhu…';

  @override
  String get loadDownloadGrades => 'Sťahovanie známok…';

  @override
  String get loadDownloadMessages => 'Sťahovanie správ…';

  @override
  String get loadDone => 'Hotovo!';

  @override
  String get loadError => 'Chyba';

  @override
  String get loadErrorDescription => 'Při načítavaní dát došlo k chybe. Tato chyba byla nahlásena.';

  @override
  String get iCanteenLoading => 'Načítavanie obedov (toto môže chvíľu trvať)';

  @override
  String get iCanteenCantLoad => 'Nepodarilo sa načítať obedy';

  @override
  String get iCanteenSetupPleaseLogin => 'Prihláste sa do systému iCanteen';

  @override
  String get iCanteenSetupDetails => 'Adresu URL zadajte ve formáte https://stravovanie.skola.sk/login';

  @override
  String get iCanteenSetupServer => 'Adresa URL';

  @override
  String get iCanteenSetupEmail => 'Prihlasovacie meno';

  @override
  String get iCanteenSetupPassword => 'Heslo';

  @override
  String get iCanteenSetupError => 'Nastala chyba pri prihlasovaní';

  @override
  String get messagesLoadingAttachment => 'Načítavanie pdf súboru…';

  @override
  String messagesAttachments(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
      
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString Prípon',
      few: '$countString Prípony',
      one: '1 Prípona',
    );
    return '$_temp0';
  }

  @override
  String get messagesPoll => 'Anketa';

  @override
  String get createMessageDiscard => 'Zahodiť správu?';

  @override
  String get createMessageDiscardDescription => 'Správa ešte nebola odoslaná. Naozaj ju chcete zahodiť ?';

  @override
  String get createMessageDiscardCancel => 'Zrušiť';

  @override
  String get createMessageDiscardDiscard => 'Zahodiť';

  @override
  String get createMessageTitle => 'Nová správa';

  @override
  String get createMessageSelectRecipient => 'Vyberte príjemcu';

  @override
  String get createMessageMessageHere => 'Vaša správa tu';

  @override
  String get createMessageImportant => 'Dôležité';

  @override
  String get createMessageIncludePoll => 'Vložiť anketu';

  @override
  String get createMessagePollEnableMultiple => 'Povoliť viac odpovedí';

  @override
  String get createMessageNewPollOptionPlaceholder => 'Nová možnosť';

  @override
  String get createMessageErrorSelectRecipient => 'Vyberte prosím príjemcu';

  @override
  String get createMessageErrorNoMessage => 'Napíšte prosím správu';

  @override
  String get createMessageSend => 'Odoslať';

  @override
  String get createMessageNotifSending => 'Odosielanie správy';

  @override
  String get createMessageNotifSendingBody => 'Vaša správa sa odosiela…';

  @override
  String get createMessageNotifSent => 'Správa odoslaná';

  @override
  String get createMessageNotifSentBody => 'Vaše správa bola úspešne odoslaná';

  @override
  String get createMessageNotifError => 'Chyba';

  @override
  String get createMessageNotifErrorBody => 'Pri odosielaní správy sa vyskytla chyba, táto chyba bola nahlásená!';

  @override
  String get qrLoginPleaseLogin => 'EduPage2 QR Prihlásenie';

  @override
  String get qrLoginUseExistingCredentials => 'Chystáte sa prihlásiť pomocou QR kódu';

  @override
  String get gradesTitle => 'Známky';

  @override
  String get messagesSearchTitle => 'Hľadať správy';

  @override
  String get messagesSearchHint => 'Vložte vyhľadávací pojem…';

  @override
  String get messagesSearchInstructions => 'Vyššie zadajte hľadaný pojem';

  @override
  String get messagesNoResults => 'Nenašli sa žiadne výsledky';
}
