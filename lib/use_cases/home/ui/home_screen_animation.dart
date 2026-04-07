import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:travelconverter/app_core/theme/theme_extension.dart';

class HomeScreenAnimation extends StatefulWidget {
  const HomeScreenAnimation({super.key});

  @override
  State<HomeScreenAnimation> createState() => _HomeScreenAnimationState();
}

class _HomeScreenAnimationState extends State<HomeScreenAnimation> {
  File? _riveFile;
  RiveWidgetController? _controller;
  BooleanInput? _darkModeInput;

  @override
  void initState() {
    super.initState();
    _loadRiveFile();
  }

  Future<void> _loadRiveFile() async {
    final file = await File.asset(
      'assets/animations/tokyo-skyline.riv',
      riveFactory: Factory.rive,
    );
    final controller = RiveWidgetController(
      file!,
      stateMachineSelector: StateMachineNamed('Idle'),
    );

    _riveFile = file;
    _controller = controller;
    // ignore: deprecated_member_use
    _darkModeInput = controller.stateMachine.boolean('darkMode');

    if (mounted) {
      _darkModeInput?.value = context.isDarkMode;
      setState(() {});
    }
  }

  @override
  void didChangeDependencies() {
    _darkModeInput?.value = context.isDarkMode;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _controller?.dispose();
    _riveFile?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    if (controller == null) {
      return const SizedBox(height: 256);
    }

    return SizedBox(
      height: 256,
      child: RiveWidget(
        controller: controller,
        fit: Fit.fitHeight,
        alignment: Alignment.bottomCenter,
      ),
    );
  }
}
