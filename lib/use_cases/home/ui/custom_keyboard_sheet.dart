import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:travelconverter/app_core/theme/colors.dart';
import 'package:travelconverter/app_core/theme/sizes.dart';
import 'package:travelconverter/app_core/theme/typography.dart';
import 'package:travelconverter/app_core/widgets/utility_extensions.dart';
import 'package:travelconverter/screens/convert/currency_input_formatter.dart';

class CustomKeyboardSheet extends StatefulWidget {
  final String currencyCode;
  final double initialValue;

  CustomKeyboardSheet({
    required this.currencyCode,
    required this.initialValue,
  });

  @override
  State<CustomKeyboardSheet> createState() => _CustomKeyboardSheetState();
}

class _CustomKeyboardSheetState extends State<CustomKeyboardSheet> {
  late final TextEditingController _inputController;

  final CurrencyInputFormatter _currencyInputFormatter =
      CurrencyInputFormatter();

  @override
  void initState() {
    _inputController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(widget.currencyCode, style: ThemeTypography.body)
                    .pad(bottom: Paddings.small),
                Expanded(
                    child: TextField(
                        controller: _inputController,
                        inputFormatters: [_currencyInputFormatter],
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        ),
                        textAlign: TextAlign.end,
                        style: ThemeTypography.inputText)),
              ],
            ).padAll(Paddings.large),
            GridView.count(
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 4,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                shrinkWrap: true,
                children: [
                  _KeyboardButton.character(
                      text: '7', onPressed: () => _addDigit(7)),
                  _KeyboardButton.character(
                      text: '8', onPressed: () => _addDigit(8)),
                  _KeyboardButton.character(
                      text: '9', onPressed: () => _addDigit(9)),
                  _KeyboardButton.character(text: '+', onPressed: () {}),
                  _KeyboardButton.character(
                      text: '4', onPressed: () => _addDigit(4)),
                  _KeyboardButton.character(
                      text: '5', onPressed: () => _addDigit(5)),
                  _KeyboardButton.character(
                      text: '6', onPressed: () => _addDigit(6)),
                  _KeyboardButton.character(text: '-', onPressed: () {}),
                  _KeyboardButton.character(
                      text: '1', onPressed: () => _addDigit(1)),
                  _KeyboardButton.character(
                      text: '2', onPressed: () => _addDigit(2)),
                  _KeyboardButton.character(
                      text: '3', onPressed: () => _addDigit(3)),
                  SizedBox(),
                  _KeyboardButton.character(
                      text: '0', onPressed: () => _addDigit(0)),
                  _KeyboardButton.character(
                      text: '.', onPressed: () => _addPeriod()),
                  _KeyboardButton(
                      child: Icon(Icons.backspace),
                      onPressed: () => _backspace()),
                  _KeyboardButton.character(
                      text: '=', onPressed: () => _submit(context)),
                ]),
          ]).pad(
        left: Paddings.large,
        right: Paddings.large,
        bottom: Paddings.large,
      ),
    );
  }

  _addDigit(int digit) {
    final text = _inputController.text;
    final newText = text + digit.toString();
    _inputController.text = newText;
  }

  _submit(BuildContext context) {
    context.pop(double.parse(_inputController.text));
  }

  _addPeriod() {
    final text = _inputController.text;
    if (!text.contains('.')) {
      final newText = text + '.';
      _inputController.text = newText;
    }
  }

  _backspace() {
    final text = _inputController.text;
    if (text.isNotEmpty) {
      final newText = text.substring(0, text.length - 1);
      _inputController.text = newText;
    }
  }
}

class _KeyboardButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;

  _KeyboardButton({required this.child, required this.onPressed});

  static _KeyboardButton character(
          {required String text, required VoidCallback onPressed}) =>
      _KeyboardButton(
          child: Text(text, style: ThemeTypography.large),
          onPressed: onPressed);

  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: BoxDecoration(
        color: lightTheme.backgroundSecondary,
        borderRadius: BorderRadius.circular(100),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(100),
        onTap: () => onPressed(),
        splashColor: lightTheme.text30,
        child: Center(child: child),
      ),
    );
  }
}
