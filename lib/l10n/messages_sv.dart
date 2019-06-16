// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a sv locale. All the
// messages from the main program should be duplicated here with the same
// function name.

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

// ignore: unnecessary_new
final messages = new MessageLookup();

// ignore: unused_element
final _keepAnalysisHappy = Intl.defaultLocale;

// ignore: non_constant_identifier_names
typedef MessageIfAbsent(String message_str, List args);

class MessageLookup extends MessageLookupByLibrary {
  get localeName => 'sv';

  static m0(currencyName) => "$currencyName är redan tillagd!";

  static m1(currencyCode) => "$currencyCode att konvertera";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "ConvertScreen_screenTitle" : MessageLookupByLibrary.simpleMessage("Konvertera"),
    "Edit" : MessageLookupByLibrary.simpleMessage("Ändra"),
    "ReviewWidgetState_acceptReviewButtonText" : MessageLookupByLibrary.simpleMessage("Ok!"),
    "ReviewWidgetState_toastMessage" : MessageLookupByLibrary.simpleMessage("Hjälper appen? Har du tid för en recension? Det hjälper jättemycket!."),
    "Search country or currency code" : MessageLookupByLibrary.simpleMessage("Sök land eller valuta"),
    "_AddCurrencyScreenState__screenTitle" : MessageLookupByLibrary.simpleMessage("Välj Valuta"),
    "_alreadySelectedWarning" : m0,
    "_convertTitle" : m1,
    "_editButtonLabel" : MessageLookupByLibrary.simpleMessage("Ändra"),
    "_submitLabel" : MessageLookupByLibrary.simpleMessage("KONVERTERA")
  };
}
