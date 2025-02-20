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
  String get homePatchAvailable => 'Instaluje se nový patch...';

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
  String get loginCustomEndpointCheckbox => 'Použít valstní endpoint';

  @override
  String get loginCustomEndpoint => 'URL vlastního endpointu';

  @override
  String get loginDemoButton => 'Anebo si prohledněte demo';

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
  String get loadCredentials => 'Načítání přihlašovacích údajů';

  @override
  String get loadLoggingIn => 'Přihlašování...';

  @override
  String get loadLoggedIn => 'Přihlášeno';

  @override
  String get loadAccessToken => 'Získávání přihlašovacího tokenu...';

  @override
  String get loadVerify => 'Ověřování...';

  @override
  String get loadDownloadTimetable => 'Stahování rozvrhu...';

  @override
  String get loadDownloadGrades => 'Stahování známek...';

  @override
  String get loadDownloadMessages => 'Stahování zpráv...';

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
  String get messagesLoadingAttachment => 'Načítání pdf souboru...';

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
  String get createMessageNotifSendingBody => 'Vaše zpráva se odesílá';

  @override
  String get createMessageNotifSent => 'Zpráva odeslána';

  @override
  String get createMessageNotifSentBody => 'Vaše zpráva se odeslala úspěšně';

  @override
  String get createMessageNotifError => 'Chyba';

  @override
  String get createMessageNotifErrorBody => 'Při odesílání zprávy se vyskytla chyba, tato chyba byla nahlášena.';

  @override
  String get qrLoginPleaseLogin => 'EduPage2 QR Přihlášení';

  @override
  String get qrLoginUseExistingCredentials => 'Chystáte se přihlásit pomocí QR kódu';

  @override
  String get gradesTitle => 'Známky';
}
