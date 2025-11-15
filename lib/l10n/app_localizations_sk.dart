// ignore: unused_import
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
  String get homeOnboarding => 'zaučovanie';

  @override
  String get homeSetupICanteen => 'Nastaviť iCanteen';

  @override
  String get homeNoClasses => 'Dnes nemáš školu! :D';

  @override
  String get homeUpdateTitle => 'Nová verzia dostupná';

  @override
  String get homeUpdateDescription =>
      'Prosím navštívte https://github.com/DislikesSchool/EduPage2/releases pre najnovšiu verziu';

  @override
  String get homeQuickstart => 'Rýchly štart';

  @override
  String get homePreview => 'Náhľad';

  @override
  String get homePatchAvailable => 'Inštaluje sa nový patch…';

  @override
  String get homePatchDownloaded =>
      'Patch bol stiahnutý, pre nainštalovanie reštartujte aplikáciu';

  @override
  String get homeDeleteData => 'Zmazať dáta';

  @override
  String get homeDeleteDataTitle => 'Vymazať dáta';

  @override
  String get homeDeleteDataConfirmation =>
      'Si si istý, že chceš požiadať o vymazanie dát zo serveru?';

  @override
  String get homeDeleteDataProcessing => 'Vymazávam dáta…';

  @override
  String get homeDeleteDataSuccess => 'Dáta úspešne vymazané';

  @override
  String get homeDeleteDataError => 'Mazanie dát zlyhalo';

  @override
  String get cancel => 'Zrušiť';

  @override
  String get confirm => 'Potvrdiť';

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
  String get loginUseExistingCredentials =>
      'Použite svoje existujúce prihlasovacie údaje';

  @override
  String get loginUsername => 'Prihlasovacie meno';

  @override
  String get loginPassword => 'Heslo';

  @override
  String get loginServer => 'Server (napr. skola.edupage.org)';

  @override
  String get loginLogin => 'Prihlásiť sa';

  @override
  String get loggingIn => 'Prihlasujem...';

  @override
  String get loginCustomEndpointCheckbox => 'Použiť valstný endpoint';

  @override
  String get loginCustomEndpoint => 'URL vlastného endpointu';

  @override
  String get loginDemoButton => 'Alebo si pozrite demo';

  @override
  String get loginCredentialsRequired => 'Meno a heslo musia byť zadané';

  @override
  String get loginInvalidCredentials => 'Neplatné meno alebo heslo';

  @override
  String get loginServerOptional =>
      'Server zadajte ak sa nemôžete prihlásiť a ste si istí, že máte správne prihlasovacie údaje';

  @override
  String get setupWelcomeTitle => 'Vitaj v EduPage2';

  @override
  String get setupWelcomeBody =>
      'EduPage2 je moderný klient pre Edupage zameraný na rýchlosť, efektivitu a použiteľnosť. EduPage2 je plne open-source. Nezabudni sa pripojiť na náš Discord server pre novinky a aktualizácie.';

  @override
  String get setupQuickStartTitle => 'Rýchly štart';

  @override
  String get setupQuickStartExplanation =>
      'Experimentálna funkcia na výrazné zrýchlenie štartu aplikácie.';

  @override
  String get setupQuickStartEnable => 'Povoliť rýchly štart';

  @override
  String get setupQuickStartDetails =>
      'Po povolení rýchleho spustenia bude aplikácia uprednostňovať údaje uložené vo vyrovnávacej pamäti pred načítaním údajov zo servera. Toto je možné neskôr deaktivovať.';

  @override
  String get setupQuickStartInfo => 'Rýchly štart je stále experimentálny';

  @override
  String get setupQuickStartBenefits =>
      'Rýchly štart spôsobí, že sa aplikácia spustí takmer okamžite a načíta údaje zo servera na pozadí, namiesto čakania na odpoveď servera.';

  @override
  String get setupQuickStartDrawbacks =>
      'Aj keď sa tým zrýchli počiatočný čas načítania, môže to viesť ku krátkemu zobrazeniu starých údajov.';

  @override
  String get setupDataStorageTitle => 'Úložisko dát';

  @override
  String get setupDataStorageExplanation =>
      'EduPage2 môže voliteľne ukladať niektoré používateľské údaje na server EduPage2, aby poskytoval pokročilé funkcie. Aplikácia bude fungovať aj bez toho, ale niektoré funkcie môžu byť obmedzené.';

  @override
  String get setupDataStorageDisabled => 'Ukladanie dát na serveri je vypnuté';

  @override
  String get setupDataStorageDisabledExplanation =>
      'Ukladanie dát na serveri je zakázané na inštancii servera EduPage2, ku ktorej sa pripájate.';

  @override
  String get setupDataStoragePrivacyEncrypted => 'Tvoje dáta sú šifrované';

  @override
  String get setupDataStoragePrivacyUnencrypted =>
      'Tvoje dáta nie sú šifrované';

  @override
  String get setupDataStoragePrivacyDetailsEncrypted =>
      'Server ku ktorému sa pripájaš ukladá tvoje prihlasovacie údaje bezpečne a šifrovane.';

  @override
  String get setupDataStoragePrivacyDetailsUnencrypted =>
      'Server, ku ktorému sa pripájaš, nešifruje tvoje údaje. Odporúčame ti buď povoliť šifrovanie na serveri, alebo použiť oficiálny server EduPage2 na bezpečné ukladanie vašich údajov.';

  @override
  String get setupDataStorageEnable => 'Povoliť ukladanie dát';

  @override
  String get setupDataStorageChoose => 'Vyber dáta, ktoré sa budú ukladať';

  @override
  String get setupDataStorageAttendance => 'Prihlasovacie údaje';

  @override
  String get setupDataStorageGrades => 'Úložisko textových správ';

  @override
  String get setupDataStorageMessages => 'Ukladanie rozvrhov';

  @override
  String get setupDataStoragePrivacy => 'Bezpečnosť úložiska dát EduPage2';

  @override
  String get setupDataStoragePrivacyDetails =>
      'Server EduPage2 ukladá dáta bezpečne a šifrovane na súkromnom dedikovanom serveri. Žiadne údaje sa nezdieľajú so žiadnymi externými stranami.';

  @override
  String get setupFeaturesAvailable => 'Dostupné funkcie';

  @override
  String get setupFeatureBasic =>
      'Základné funkcie aplikácie (správy, rozvrhy, známky, ...)';

  @override
  String get setupFeatureNotifications => 'Push notifikácie';

  @override
  String get setupFeatureSearch => 'Fulltextové vyhľadávanie';

  @override
  String get setupCompleteTitle => 'Nastavenie je dokončené';

  @override
  String get setupCompleteBody =>
      'Tvoje nastavenie je dokončené. Teraz môžeš začať používať EduPage2.';

  @override
  String get setupDone => 'Nastavenie dokončené';

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
  String get loadErrorDescription =>
      'Při načítavaní dát došlo k chybe. Tato chyba byla nahlásena.';

  @override
  String get iCanteenLoading => 'Načítavanie obedov (toto môže chvíľu trvať)';

  @override
  String get iCanteenCantLoad => 'Nepodarilo sa načítať obedy';

  @override
  String get iCanteenSetupPleaseLogin => 'Prihláste sa do systému iCanteen';

  @override
  String get iCanteenSetupDetails =>
      'Adresu URL zadajte ve formáte https://stravovanie.skola.sk/login';

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
  String get createMessageDiscardDescription =>
      'Správa ešte nebola odoslaná. Naozaj ju chcete zahodiť ?';

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
  String get createMessageNotifErrorBody =>
      'Pri odosielaní správy sa vyskytla chyba, táto chyba bola nahlásená!';

  @override
  String get qrLoginPleaseLogin => 'EduPage2 QR Prihlásenie';

  @override
  String get qrLoginUseExistingCredentials =>
      'Chystáte sa prihlásiť pomocou QR kódu';

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
