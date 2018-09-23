// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ja locale. All the
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
  get localeName => 'ja';

  static m0(currencyName) => "${currencyName}すでに選択されています!";

  static m1(currencyCode) => "${currencyCode}入力";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "ADD CURRENCY" : MessageLookupByLibrary.simpleMessage("レート追加"),
    "ConvertScreen_screenTitle" : MessageLookupByLibrary.simpleMessage("換算"),
    "Edit" : MessageLookupByLibrary.simpleMessage("編集"),
    "Search country or currency code" : MessageLookupByLibrary.simpleMessage("名または国別コードを検索"),
    "_alreadySelectedWarning" : m0,
    "_convertTitle" : m1,
    "_editButtonLabel" : MessageLookupByLibrary.simpleMessage("編集"),
    "_submitLabel" : MessageLookupByLibrary.simpleMessage("換算")
  };
}