import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:travelconverter/app_core/theme/theme_typography.dart';

class VersionDisplay extends StatelessWidget {
  const VersionDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PackageInfo>(
      future: PackageInfo.fromPlatform(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final info = snapshot.data!;
          return Center(
            child: Text(
              'v${info.version}+${info.buildNumber}',
              style: ThemeTypography.small,
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
