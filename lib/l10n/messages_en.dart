// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
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
  get localeName => 'en';

  static m0(currencyName) => "${currencyName} is already selected!";

  static m1(currencyCode) => "${currencyCode} to convert";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "Add Currency" : MessageLookupByLibrary.simpleMessage("Add Currency"),
    "ConvertScreen_screenTitle" : MessageLookupByLibrary.simpleMessage("Convert"),
    "Edit" : MessageLookupByLibrary.simpleMessage("Edit"),
    "ReviewWidgetState_acceptReviewButtonText" : MessageLookupByLibrary.simpleMessage("Sure!"),
    "ReviewWidgetState_toastMessage" : MessageLookupByLibrary.simpleMessage("Is this app helping you? Could you spare a minute to do a review? It really helps."),
    "Search country or currency code" : MessageLookupByLibrary.simpleMessage("Search country or currency code"),
    "_alreadySelectedWarning" : m0,
    "_convertTitle" : m1,
    "_editButtonLabel" : MessageLookupByLibrary.simpleMessage("Edit"),
    "_submitLabel" : MessageLookupByLibrary.simpleMessage("CONVERT")
  };
}
