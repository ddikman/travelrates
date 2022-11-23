// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ja locale. All the
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
  String get localeName => 'ja';

  static m0(currencyName) => "${currencyName}すでに選択されています!";

  static m1(currencyCode) => "${currencyCode}入力";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function> {
    "ConvertScreen_screenTitle" : MessageLookupByLibrary.simpleMessage("換算"),
    "Edit" : MessageLookupByLibrary.simpleMessage("編集"),
    "ReviewWidgetState_acceptReviewButtonText" : MessageLookupByLibrary.simpleMessage("もちろん！"),
    "ReviewWidgetState_toastMessage" : MessageLookupByLibrary.simpleMessage("このアプリはお役に立ちましたか？もしよろしければ、ご意見をお寄せいただけますか？"),
    "Search country or currency code" : MessageLookupByLibrary.simpleMessage("名または国別コードを検索"),
    "_AddCurrencyScreenState__screenTitle" : MessageLookupByLibrary.simpleMessage("レート追加"),
    "_alreadySelectedWarning" : m0,
    "_convertTitle" : m1,
    "_editButtonLabel" : MessageLookupByLibrary.simpleMessage("編集"),
    "_submitLabel" : MessageLookupByLibrary.simpleMessage("換算")
  };
}
