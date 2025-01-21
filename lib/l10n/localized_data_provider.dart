import 'package:flutter/widgets.dart';
import 'package:travelconverter/l10n/localized_data.dart';

class LocalizedDataProvider extends InheritedWidget {
  final LocalizedData data;

  const LocalizedDataProvider({
    super.key,
    required this.data,
    required super.child,
  });

  static LocalizedData of(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<LocalizedDataProvider>();
    assert(provider != null, 'No LocalizedDataProvider found in context');
    return provider!.data;
  }

  @override
  bool updateShouldNotify(LocalizedDataProvider oldWidget) {
    return data.locale != oldWidget.data.locale;
  }
}
