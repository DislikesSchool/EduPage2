import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Czech (`cs`).
class AppLocalizationsCs extends AppLocalizations {
  AppLocalizationsCs([String locale = 'cs']) : super(locale);

  @override
  String get loading => 'Načítání';

  @override
  String get mainHome => 'Domů';

  @override
  String get mainTimetable => 'Rozvrh';

  @override
  String get mainICanteen => 'iCanteen';

  @override
  String get mainMessages => 'Zprávy';

  @override
  String get mainHomework => 'Úkoly';

  @override
  String get mainGrades => 'Známky';

  @override
  String get homeLunchesNotLoaded => 'Obědy nebyly načteny';

  @override
  String get homeNoLunchToday => 'Na dnešek nemáš objednaný oběd';

  @override
  String homeLunchToday(int lunch) {
    return 'Dneska máš oběd číslo $lunch';
  }

  @override
  String homeLunchDontForget(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return 'Nezapomeň si objednat oběd na $dateString';
  }

  @override
  String get homeLogout => 'Odhlásit se';

  @override
  String get homeOnboarding => 'Onboarding';

  @override
  String get homeSetupICanteen => 'Nastavit iCanteen';

  @override
  String get homeNoClasses => 'Dneska nemáš skolu! :D';

  @override
  String get homeUpdateTitle => 'Nová verze dostupná';

  @override
  String get homeUpdateDescription => 'Prosím navštivte https://github.com/DislikesSchool/EduPage2/releases pro nejnovější verzi';

  @override
  String get homeQuickstart => 'Rychlý start';

  @override
  String get homePreview => 'Náhled';

  @override
  String get homePatchAvailable => 'Instaluje se nový patch…';

  @override
  String get homePatchDownloaded => 'Patch byl stažen, restartujte aplikaci pro instalaci';

  @override
  String get homeGrades => 'Známky';

  @override
  String get homeHomework => 'Úkoly';

  @override
  String get homeworkTitle => 'Domácí úkoly';

  @override
  String get messagesTitle => 'Zprávy';

  @override
  String get loginPleaseLogin => 'Přihlašte se prosím';

  @override
  String get loginUseExistingCredentials => 'Použijte svoje existující přihlašovací údaje';

  @override
  String get loginUsername => 'Přihlašovací jméno';

  @override
  String get loginPassword => 'Heslo';

  @override
  String get loginServer => 'Server (např. skola.edupage.org)';

  @override
  String get loginLogin => 'Přihlásit se';

  @override
  String get loggingIn => 'Logging in...';

  @override
  String get loginCustomEndpointCheckbox => 'Použít valstní endpoint';

  @override
  String get loginCustomEndpoint => 'URL vlastního endpointu';

  @override
  String get loginDemoButton => 'Anebo si prohledněte demo';

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
  String get tomorrow => 'Zítra';

  @override
  String timetableTeacher(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
      
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString Učitelů',
      few: '$countString Učitelé',
      one: 'Učitel',
    );
    return '$_temp0';
  }

  @override
  String get loadCredentials => 'Načítání přihlašovacích údajů…';

  @override
  String get loadLoggingIn => 'Přihlašování…';

  @override
  String get loadLoggedIn => 'Přihlášeno';

  @override
  String get loadAccessToken => 'Získávání přihlašovacího tokenu…';

  @override
  String get loadVerify => 'Ověřování';

  @override
  String get loadDownloadTimetable => 'Stahování rozvrhu…';

  @override
  String get loadDownloadGrades => 'Stahování známek…';

  @override
  String get loadDownloadMessages => 'Stahování zpráv…';

  @override
  String get loadDone => 'Hotovo!';

  @override
  String get loadError => 'Chyba';

  @override
  String get loadErrorDescription => 'Při načítání dat došlo k chybě. Tato chyba byla nahlášena.';

  @override
  String get iCanteenLoading => 'Načítání obědů (tohle by mohlo chvíli zabrat)';

  @override
  String get iCanteenCantLoad => 'Nelze načst obědy';

  @override
  String get iCanteenSetupPleaseLogin => 'Přihlašte se do systému iCanteen';

  @override
  String get iCanteenSetupDetails => 'Adresu URL zadejte ve formátu https://stravovani.skola.cz/login';

  @override
  String get iCanteenSetupServer => 'Adresa URL';

  @override
  String get iCanteenSetupEmail => 'Přihlašovací jméno';

  @override
  String get iCanteenSetupPassword => 'Heslo';

  @override
  String get iCanteenSetupError => 'Nastala chyba při příhlášení';

  @override
  String get messagesLoadingAttachment => 'Načítání pdf souboru…';

  @override
  String messagesAttachments(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
      
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString Přípon',
      few: '$countString Přípony',
      one: '1 Přípona',
    );
    return '$_temp0';
  }

  @override
  String get messagesPoll => 'Anketa';

  @override
  String get createMessageDiscard => 'Zahodit zprávu?';

  @override
  String get createMessageDiscardDescription => 'Zpráva ještě nebyla odeslána. Opravdu ji chcete zahodit?';

  @override
  String get createMessageDiscardCancel => 'Zrušit';

  @override
  String get createMessageDiscardDiscard => 'Zahodit';

  @override
  String get createMessageTitle => 'Nová zpráva';

  @override
  String get createMessageSelectRecipient => 'Vyberte příjemce';

  @override
  String get createMessageMessageHere => 'Vaše zpráva zde';

  @override
  String get createMessageImportant => 'Důležité';

  @override
  String get createMessageIncludePoll => 'Vložit anketu';

  @override
  String get createMessagePollEnableMultiple => 'Povolit více odpovědí';

  @override
  String get createMessageNewPollOptionPlaceholder => 'Nová možnost';

  @override
  String get createMessageErrorSelectRecipient => 'Vyberte prosím příjemce';

  @override
  String get createMessageErrorNoMessage => 'Napište prosím zprávu';

  @override
  String get createMessageSend => 'Odeslat';

  @override
  String get createMessageNotifSending => 'Odesílání zprávy';

  @override
  String get createMessageNotifSendingBody => 'Vaše zpráva se odesílá…';

  @override
  String get createMessageNotifSent => 'Zpráva odeslána';

  @override
  String get createMessageNotifSentBody => 'Vaše zpráva se odeslala úspěšně';

  @override
  String get createMessageNotifError => 'Chyba';

  @override
  String get createMessageNotifErrorBody => 'Při odesílání zprávy se vyskytla chyba, tato chyba byla nahlášena!';

  @override
  String get qrLoginPleaseLogin => 'EduPage2 QR Přihlášení';

  @override
  String get qrLoginUseExistingCredentials => 'Chystáte se přihlásit pomocí QR kódu';

  @override
  String get gradesTitle => 'Známky';

  @override
  String get messagesSearchTitle => 'Prohledat zprávy';

  @override
  String get messagesSearchHint => 'Zadejte hledaný výraz…';

  @override
  String get messagesSearchInstructions => 'Zadejte vyhledávací výraz výše';

  @override
  String get messagesNoResults => 'Nebyly nalezeny žádné výsledky';
}
