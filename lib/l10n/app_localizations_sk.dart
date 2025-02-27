// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Slovak (`sk`).
class AppLocalizationsSk extends AppLocalizations {
  AppLocalizationsSk([String locale = 'sk']) : super(locale);

  @override
  String get loading => 'Načítavam';

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
  String get homeLunchesNotLoaded => 'Nepodarilo sa načítať obedy';

  @override
  String get homeNoLunchToday => 'Dnes nemáte žiadny obed';

  @override
  String homeLunchToday(int lunch) {
    return 'Dnes máte možnosť obedu číslo $lunch';
  }

  @override
  String homeLunchDontForget(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return 'Nezabudnite si objednať obed pre $dateString';
  }

  @override
  String get homeLogout => 'Odhlásiť sa';

  @override
  String get homeSetupICanteen => 'Nastaviť iCanteen';

  @override
  String get homeNoClasses => 'Dnes sa škola nekoná :D';

  @override
  String get homeUpdateTitle => 'Dostupná nová verzia';

  @override
  String get homeUpdateDescription => 'Prosím navštívte https://github.com/DislikesSchool/EduPage2/releases pre nejnovšiu verziu';

  @override
  String get homeQuickstart => 'Rýchly štart';

  @override
  String get homePreview => 'Náhľad';

  @override
  String get homePatchAvailable => 'Inštaluje se nový patch...';

  @override
  String get homePatchDownloaded => 'Patch bol stiahnutý, prosím reštartujte EduPage2';

  @override
  String get homeGrades => 'Grades';

  @override
  String get homeHomework => 'Homework';

  @override
  String get homeworkTitle => 'Domáce úlohy';

  @override
  String get messagesTitle => 'Správy';

  @override
  String get loginPleaseLogin => 'Prosím, prihláste sa';

  @override
  String get loginUseExistingCredentials => 'Použite svoje existujúce údaje do EduPage';

  @override
  String get loginUsername => 'Prihlasovacie meno';

  @override
  String get loginPassword => 'Heslo';

  @override
  String get loginServer => 'Server (napr. skola.edupage.org)';

  @override
  String get loginLogin => 'Prihlásiť sa';

  @override
  String get loginCustomEndpointCheckbox => 'Použíť valstny endpoint';

  @override
  String get loginCustomEndpoint => 'URL vlastného endpointu';

  @override
  String get loginDemoButton => 'Or try the demo';

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
      other: '$countString Teachers',
      one: 'Teacher',
    );
    return '$_temp0';
  }

  @override
  String get loadCredentials => 'Načítavam prihlasovacie údaje';

  @override
  String get loadLoggingIn => 'Prihlasovanie...';

  @override
  String get loadLoggedIn => 'Prihlásený';

  @override
  String get loadAccessToken => 'Získavanie prístupového tokenu...';

  @override
  String get loadVerify => 'Overovanie...';

  @override
  String get loadDownloadTimetable => 'Sťahovanie rozvrhu...';

  @override
  String get loadDownloadGrades => 'Downloading grades...';

  @override
  String get loadDownloadMessages => 'Sťahovanie zpráv...';

  @override
  String get loadDone => 'Hotovo!';

  @override
  String get loadError => 'Error';

  @override
  String get loadErrorDescription => 'There was an error loading data. This error has been reported.';

  @override
  String get iCanteenLoading => 'Načítavanie obedov (môže to chvíľu trvať)';

  @override
  String get iCanteenCantLoad => 'Nepodarilo sa načítať obedy';

  @override
  String get iCanteenSetupPleaseLogin => 'Prihláste sa do iCanteen';

  @override
  String get iCanteenSetupDetails => 'Adresu URL zadajte vo formáte https://stravovanie.skola.sk/login';

  @override
  String get iCanteenSetupServer => 'Adresa URL';

  @override
  String get iCanteenSetupEmail => 'Prihlasovacie meno';

  @override
  String get iCanteenSetupPassword => 'Heslo';

  @override
  String get iCanteenSetupError => 'There was an error logging in';

  @override
  String get messagesLoadingAttachment => 'Načítavanie pdf súboru...';

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
