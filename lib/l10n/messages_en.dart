// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

// ignore: unused_element
final _keepAnalysisHappy = Intl.defaultLocale;

// ignore: non_constant_identifier_names
typedef MessageIfAbsent(String message_str, List args);

class MessageLookup extends MessageLookupByLibrary {
  get localeName => 'en';

  static m0(currencyName) => "${currencyName} is already selected!";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "ADD CURRENCY" : MessageLookupByLibrary.simpleMessage("ADD CURRENCY"),
    "CONVERT" : MessageLookupByLibrary.simpleMessage("CONVERT"),
    "Search country or currency code" : MessageLookupByLibrary.simpleMessage("Search country or currency code"),
    "_alreadySelectedWarning" : m0
  };
}
