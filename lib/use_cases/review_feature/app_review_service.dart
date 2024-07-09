import 'package:travelconverter/services/logger.dart';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:app_review_plus/app_review_plus.dart';

class AppReviewService {
  static final _logger = Logger<AppReview>();

  Future<void> request() async {
    if (await _canPromptReview()) {
      final result = await AppReview.requestReview;
      _logger.debug(result?.toString() ?? 'No review result');
    } else {
      final result = await AppReview.storeListing;
      _logger.debug(result?.toString() ?? 'No review result');
    }
  }

  /// Actually need to check if the platform supports the reviews.
  /// This isn't handled properly in the app_review package.
  Future<bool> _canPromptReview() async {
    if (!Platform.isIOS) {
      return true;
    }
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    final iosVersion = iosInfo.systemVersion;
    _logger.debug("Running on ios version $iosVersion");

    final versionParts = iosVersion.split('.');
    final major = int.parse(versionParts[0]);
    final minor = int.parse(versionParts[1]);
    return major > 10 || (major == 10 && minor > 3);
  }
}
