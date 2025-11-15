// ignore: unused_import
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
  String get homeUpdateDescription =>
      'Prosím navštivte https://github.com/DislikesSchool/EduPage2/releases pro nejnovější verzi';

  @override
  String get homeQuickstart => 'Rychlý start';

  @override
  String get homePreview => 'Náhled';

  @override
  String get homePatchAvailable => 'Instaluje se nový patch…';

  @override
  String get homePatchDownloaded =>
      'Patch byl stažen, restartujte aplikaci pro instalaci';

  @override
  String get homeDeleteData => 'Vymazat data';

  @override
  String get homeDeleteDataTitle => 'Vymazat data';

  @override
  String get homeDeleteDataConfirmation =>
      'Jste si jistí že chcete požádat o vymazání dat ze serveru?';

  @override
  String get homeDeleteDataProcessing => 'Mazání dat…';

  @override
  String get homeDeleteDataSuccess => 'Data smazána úspěšně';

  @override
  String get homeDeleteDataError => 'Smazání dat selhalo';

  @override
  String get cancel => 'Zrušit';

  @override
  String get confirm => 'Potvrdit';

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
  String get loginUseExistingCredentials =>
      'Použijte svoje existující přihlašovací údaje';

  @override
  String get loginUsername => 'Přihlašovací jméno';

  @override
  String get loginPassword => 'Heslo';

  @override
  String get loginServer => 'Server (např. skola.edupage.org)';

  @override
  String get loginLogin => 'Přihlásit se';

  @override
  String get loggingIn => 'Přihlašování…';

  @override
  String get loginCustomEndpointCheckbox => 'Použít valstní endpoint';

  @override
  String get loginCustomEndpoint => 'URL vlastního endpointu';

  @override
  String get loginDemoButton => 'Anebo si prohledněte demo';

  @override
  String get loginCredentialsRequired =>
      'Uživatelské jméno a heslo jsou požadovány';

  @override
  String get loginInvalidCredentials => 'Neplatné uživatelské jméno nebo heslo';

  @override
  String get loginServerOptional =>
      'Server není vyžadován, ale může pomoci, když se nemůžete přihlásit a jste si jist(á), že jste zadal(a) správné přihlašovací údaje';

  @override
  String get setupWelcomeTitle => 'Vítejte v EduPage2';

  @override
  String get setupWelcomeBody =>
      'EduPage2 je moderní klient pro EduPage zaměřený na rychlost, efektivitu a uživatelský zážitek. EduPage2 je plně open-source a volně k použití. Připojte se na náš Discord server pro příjem novinek.';

  @override
  String get setupQuickStartTitle => 'Rychlý start';

  @override
  String get setupQuickStartExplanation =>
      'Experimentální funkce která může znatelně zrychlit start aplikace.';

  @override
  String get setupQuickStartEnable => 'Zapnout Rychlý Start';

  @override
  String get setupQuickStartDetails =>
      'Při povolení Rychlého startu aplikace preferuje data z mezipaměti před získáváním dat ze serveru. Toto může být později zakázáno.';

  @override
  String get setupQuickStartInfo => 'Rychlý start je stále experimentální';

  @override
  String get setupQuickStartBenefits =>
      'Rychlý start umožní aplikaci spustit se téměř okamžitě a mezitím načítat data ze serveru na pozadí, místo aby čekala na odpověď serveru.';

  @override
  String get setupQuickStartDrawbacks =>
      'I když to urychlí počáteční načítání, může to krátce zobrazit zastaralá data.';

  @override
  String get setupDataStorageTitle => 'Úložiště dat';

  @override
  String get setupDataStorageExplanation =>
      '„EduPage2 může volitelně ukládat některá uživatelská data na server EduPage2, aby byla dostupná rozšířená funkčnost. Aplikace bude fungovat i bez toho, ale některé funkce mohou být omezené.';

  @override
  String get setupDataStorageDisabled => 'Ukládání na server je vypnuto';

  @override
  String get setupDataStorageDisabledExplanation =>
      'Ukládání na server je vypnuto na instanci serveru EduPage2, ke které se připojujete.';

  @override
  String get setupDataStoragePrivacyEncrypted => 'Vaše data JSOU šifrována';

  @override
  String get setupDataStoragePrivacyUnencrypted => 'Vaša data NEJSOU šifrována';

  @override
  String get setupDataStoragePrivacyDetailsEncrypted =>
      'Server, ke kterému se připojujete, ukládá vaše přihlašovací údaje bezpečně a šifrovaně.';

  @override
  String get setupDataStoragePrivacyDetailsUnencrypted =>
      'Server, ke kterému se připojujete, nešifruje vaše data. Doporučujeme buď zapnout šifrování na serveru, nebo použít oficiální server EduPage2 pro bezpečné uložení vašich dat.';

  @override
  String get setupDataStorageEnable => 'Povolit ukládání dat';

  @override
  String get setupDataStorageChoose => 'Vyberte, která data ukládat';

  @override
  String get setupDataStorageAttendance => 'Přihlašovací údaje';

  @override
  String get setupDataStorageGrades => 'Ukládání textových zpráv';

  @override
  String get setupDataStorageMessages => 'Ukládání časové osy';

  @override
  String get setupDataStoragePrivacy => 'Bezpečnost ukládání dat v EduPage2';

  @override
  String get setupDataStoragePrivacyDetails =>
      'Server EduPage2 ukládá data bezpečně a šifrovaně na soukromém dedikovaném serveru. Žádná data nejsou sdílena s externími stranami.';

  @override
  String get setupFeaturesAvailable => 'Funkční funkce';

  @override
  String get setupFeatureBasic =>
      'Základní funkce aplikace (zprávy, rozvrhy, známky, …)';

  @override
  String get setupFeatureNotifications => 'Notifikace';

  @override
  String get setupFeatureSearch => 'Vyhledávání';

  @override
  String get setupCompleteTitle => 'Nastavení dokončeno';

  @override
  String get setupCompleteBody =>
      'Nastavení je dokončeno. Nyní můžete začít používat EduPage2.';

  @override
  String get setupDone => 'Nastavení hotovo';

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
  String get loadErrorDescription =>
      'Při načítání dat došlo k chybě. Tato chyba byla nahlášena.';

  @override
  String get iCanteenLoading => 'Načítání obědů (tohle by mohlo chvíli zabrat)';

  @override
  String get iCanteenCantLoad => 'Nelze načst obědy';

  @override
  String get iCanteenSetupPleaseLogin => 'Přihlašte se do systému iCanteen';

  @override
  String get iCanteenSetupDetails =>
      'Adresu URL zadejte ve formátu https://stravovani.skola.cz/login';

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
  String get createMessageDiscardDescription =>
      'Zpráva ještě nebyla odeslána. Opravdu ji chcete zahodit?';

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
  String get createMessageNotifErrorBody =>
      'Při odesílání zprávy se vyskytla chyba, tato chyba byla nahlášena!';

  @override
  String get qrLoginPleaseLogin => 'EduPage2 QR Přihlášení';

  @override
  String get qrLoginUseExistingCredentials =>
      'Chystáte se přihlásit pomocí QR kódu';

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
