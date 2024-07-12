import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:travelconverter/app_core/theme/theme_extension.dart';

class HomeScreenAnimation extends StatefulWidget {
  @override
  State<HomeScreenAnimation> createState() => _HomeScreenAnimationState();
}

class _HomeScreenAnimationState extends State<HomeScreenAnimation> {
  StateMachineController? _controller;
  SMIInput<bool>? _darkModeInput;

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    _darkModeInput?.change(context.isDarkMode);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // I have to force the size to avoid a white line appearing at the top in dark mode due to anti-aliasing
    return SizedBox(
      height: 256,
      child: RiveAnimation.asset('assets/animations/tokyo-skyline.riv',
          fit: BoxFit.fitHeight,
          stateMachines: ['Idle'],
          alignment: Alignment.bottomCenter,
          onInit: (artboard) => _initAnimation(artboard, context.isDarkMode)),
    );
  }

  void _initAnimation(Artboard artboard, bool isDarkMode) {
    final controller = StateMachineController.fromArtboard(artboard, 'Idle');
    if (controller == null) {
      throw new Exception('Failed to create controller from artboard');
    }
    artboard.addController(controller);

    // This is a trick to use a difference layer inside the animation to support inverting color
    final darkModeInput = controller.findInput<bool>('darkMode');
    if (darkModeInput == null) {
      throw new Exception('Input "darkMode" not found in the animation');
    }
    darkModeInput.change(isDarkMode);

    _darkModeInput = darkModeInput;
    _controller = controller;
  }
}
