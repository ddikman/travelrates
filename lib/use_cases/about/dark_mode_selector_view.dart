import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travelconverter/app_core/theme/theme_sizes.dart';
import 'package:travelconverter/app_core/theme/theme_typography.dart';
import 'package:travelconverter/app_core/widgets/segmented_selector.dart';
import 'package:travelconverter/l10n/l10n_extension.dart';
import 'package:travelconverter/use_cases/dark_mode/state/theme_brightness_notifier_provider.dart';

class DarkModeSelectorView extends ConsumerWidget {
  const DarkModeSelectorView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeBrightnessSetting = ref.watch(themeBrightnessNotifierProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(context.l10n.theme_title, style: ThemeTypography.title),
        const SizedBox(height: Paddings.listGap),
        SegmentedSelector(
            values: [
              ThemeMode.system,
              ThemeMode.dark,
              ThemeMode.light,
            ],
            labels: [
              context.l10n.theme_system,
              context.l10n.theme_dark,
              context.l10n.theme_light
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
