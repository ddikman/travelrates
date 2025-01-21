import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travelconverter/app_core/theme/theme_sizes.dart';
import 'package:travelconverter/app_core/theme/theme_typography.dart';
import 'package:travelconverter/app_core/widgets/segmented_selector.dart';
import 'package:travelconverter/use_cases/dark_mode/state/theme_brightness_notifier_provider.dart';

class DarkModeSelectorView extends ConsumerWidget {
  const DarkModeSelectorView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeBrightnessSetting = ref.watch(themeBrightnessNotifierProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Dark mode', style: ThemeTypography.title),
        const SizedBox(height: Paddings.listGap),
        SegmentedSelector(
            values: [
              ThemeMode.system,
              ThemeMode.dark,
              ThemeMode.light,
            ],
            labels: [
              'System',
              'Dark',
              'Light'
            ],
            initialSelection: themeBrightnessSetting,
            onSelectionChanged: (value) {
              ref
                  .read(themeBrightnessNotifierProvider.notifier)
                  .setSetting(value);
            })
      ],
    );
  }
}
