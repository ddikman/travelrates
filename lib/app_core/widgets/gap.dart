import 'package:flutter/material.dart';
import 'package:travelconverter/app_core/theme/theme_sizes.dart';

abstract class Gap {
  static const small = SizedBox(height: Paddings.small, width: Paddings.small);
  static const medium =
      SizedBox(height: Paddings.medium, width: Paddings.medium);
  static const list =
      const SizedBox(height: Paddings.listGap, width: Paddings.listGap);
}
