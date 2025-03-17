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
  String get homePatchAvailable => 'Inštaluje sa nový patch...';

  @override
  String get homePatchDownloaded => 'Patch bol stiahnutý, pre nainštalovanie reštartujte aplikáciu';

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
  String get loginCustomEndpointCheckbox => 'Použiť valstný endpoint';

  @override
  String get loginCustomEndpoint => 'URL vlastného endpointu';

  @override
  String get loginDemoButton => 'Alebo si pozrite demo';

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
  String get loadCredentials => 'Načítavanie prihlasovacích údajov';

  @override
  String get loadLoggingIn => 'Prihlasovanie...';

  @override
  String get loadLoggedIn => 'Prihlásené';

  @override
  String get loadAccessToken => 'Získavanie prihlasovacieho tokenu...';

  @override
  String get loadVerify => 'Overovanie...';

  @override
  String get loadDownloadTimetable => 'Sťahovanie rozvrhu...';

  @override
  String get loadDownloadGrades => 'Sťahovanie známok...';

  @override
  String get loadDownloadMessages => 'Sťahovanie správ...';

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
  String get messagesLoadingAttachment => 'Načítanie pdf súboru...';

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
  String get createMessageNotifSendingBody => 'Vaša správa sa odosiela';

  @override
  String get createMessageNotifSent => 'Správa odoslaná';

  @override
  String get createMessageNotifSentBody => 'Vaše správa bola úspešne odoslaná';

  @override
  String get createMessageNotifError => 'Chyba';

  @override
  String get createMessageNotifErrorBody => 'Pri odosielaní správy sa vyskytla chyba, táto chyba bola nahlásená.';

  @override
  String get qrLoginPleaseLogin => 'EduPage2 QR Prihlásenie';

  @override
  String get qrLoginUseExistingCredentials => 'Chystáte sa prihlásiť pomocou QR kódu';

  @override
  String get gradesTitle => 'Známky';
}
