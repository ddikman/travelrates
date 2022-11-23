// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, always_declare_return_types

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = MessageLookup();

typedef String MessageIfAbsent(String? messageStr, List<Object>? args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static m0(currencyName) => "${currencyName} is already selected!";

  static m1(currencyCode) => "${currencyCode} to convert";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function> {
    "ConvertScreen_screenTitle" : MessageLookupByLibrary.simpleMessage("Convert"),
    "Edit" : MessageLookupByLibrary.simpleMessage("Edit"),
    "ReviewWidgetState_acceptReviewButtonText" : MessageLookupByLibrary.simpleMessage("Sure!"),
    "ReviewWidgetState_toastMessage" : MessageLookupByLibrary.simpleMessage("Is this app helping you? Could you spare a minute to do a review? It really helps."),
    "Search country or currency code" : MessageLookupByLibrary.simpleMessage("Search country or currency code"),
    "_AddCurrencyScreenState__screenTitle" : MessageLookupByLibrary.simpleMessage("Add Currency"),
    "_alreadySelectedWarning" : m0,
    "_convertTitle" : m1,
    "_editButtonLabel" : MessageLookupByLibrary.simpleMessage("Edit"),
    "_submitLabel" : MessageLookupByLibrary.simpleMessage("CONVERT")
  };
}
