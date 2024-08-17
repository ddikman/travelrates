import 'package:expressions/expressions.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:travelconverter/app_core/theme/app_theme.dart';
import 'package:travelconverter/app_core/widgets/utility_extensions.dart';
import 'package:travelconverter/use_cases/home/services/currency_input_formatter.dart';

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
  static const multiplication = '×';
  static const division = '÷';

  static const _expressionEvaluator = const ExpressionEvaluator();

  late final TextEditingController _inputController;

  String _multiplyOrDivide = multiplication;

  final CurrencyInputFormatter _currencyInputFormatter =
      CurrencyInputFormatter();

  @override
  void initState() {
    _inputController = TextEditingController();
    _inputController.addListener(() {
      final lastCharacter = _inputController.text.characters.lastOrNull;
      setState(() {
        _multiplyOrDivide =
            lastCharacter == multiplication ? division : multiplication;
      });
    });
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
                  _KeyboardButton.character(
                      text: '+', onPressed: () => _addOperator('+')),
                  _KeyboardButton.character(
                      text: '4', onPressed: () => _addDigit(4)),
                  _KeyboardButton.character(
                      text: '5', onPressed: () => _addDigit(5)),
                  _KeyboardButton.character(
                      text: '6', onPressed: () => _addDigit(6)),
                  _KeyboardButton.character(
                      text: '-', onPressed: () => _addOperator('-')),
                  _KeyboardButton.character(
                      text: '1', onPressed: () => _addDigit(1)),
                  _KeyboardButton.character(
                      text: '2', onPressed: () => _addDigit(2)),
                  _KeyboardButton.character(
                      text: '3', onPressed: () => _addDigit(3)),
                  _KeyboardButton.character(
                      text: _multiplyOrDivide,
                      onPressed: () => _addOperator(_multiplyOrDivide)),
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

  _addOperator(String operator) {
    final text = _inputController.text;
    if (_isOperator(text.characters.last)) {
      final newText = text.substring(0, text.length - 1) + operator;
      _inputController.text = newText;
    } else {
      _inputController.text = text + operator;
    }
  }

  _submit(BuildContext context) {
    // If it's just a simple value, return as-is
    final asValue = double.tryParse(_inputController.text);
    if (asValue != null) {
      context.pop(asValue);
      return;
    }

    // otherwise, clean the string and evaluate the expression
    final text = _inputController.text.replaceAll(RegExp(r'\D+$'), '');

    // replace the multiplication and division symbols
    final cleanedText =
        text.replaceAll(multiplication, '*').replaceAll(division, '/');

    final expression = Expression.parse(cleanedText);
    final result = _expressionEvaluator.eval(expression, {});
    if (result is int) {
      context.pop(result.toDouble());
    } else {
      context.pop(result);
    }
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

  bool _isOperator(String character) {
    return character == '+' ||
        character == '-' ||
        character == multiplication ||
        character == division;
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
        color: context.themeColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(100),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(100),
        onTap: () => onPressed(),
        splashColor: context.themeColors.text30,
        child: Center(child: child),
      ),
    );
  }
}
