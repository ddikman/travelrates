import 'package:expressions/expressions.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:travelconverter/app_core/theme/app_theme.dart';
import 'package:travelconverter/app_core/widgets/utility_extensions.dart';
import 'package:travelconverter/use_cases/home/services/currency_input_formatter.dart';

class CustomKeyboardSheet extends StatefulWidget {
  final String currencyCode;
  final double initialValue;

  const CustomKeyboardSheet({super.key, 
    required this.currencyCode,
    required this.initialValue,
  });

  @override
  State<CustomKeyboardSheet> createState() => _CustomKeyboardSheetState();
}

class _CustomKeyboardSheetState extends State<CustomKeyboardSheet> {
  static const multiplication = '×';
  static const division = '÷';

  static const _expressionEvaluator = ExpressionEvaluator();

  late final TextEditingController _inputController;

  String _multiplyOrDivide = multiplication;

  /// Raw, unformatted source of truth: ASCII digits, '.', and the operators
  /// '+ - × ÷'. The text field displays a locale-grouped derivation of this so
  /// large amounts stay legible while the value remains trivially parseable.
  String _expression = '';

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
                        readOnly: true,
                        showCursor: true,
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

  /// Updates the raw [_expression] and reflects a locale-grouped derivation of
  /// it in the text field. The keypad always edits the raw string; the field is
  /// read-only and purely a formatted view.
  void _setExpression(String expression) {
    setState(() {
      _expression = expression;
      _multiplyOrDivide = expression.characters.lastOrNull == multiplication
          ? division
          : multiplication;
    });
    final display = _formatExpression(expression);
    _inputController.value = TextEditingValue(
      text: display,
      selection: TextSelection.collapsed(offset: display.length),
    );
  }

  /// Groups each numeric operand with thousand separators while leaving
  /// operators and in-progress decimals untouched.
  String _formatExpression(String expression) => expression.replaceAllMapped(
      RegExp(r'\d+\.?\d*'),
      (match) => CurrencyInputFormatter.formatGrouped(match.group(0)!));

  void _addDigit(int digit) {
    _setExpression(_expression + digit.toString());
  }

  void _addOperator(String operator) {
    if (_expression.isEmpty) {
      return;
    }
    if (_isOperator(_expression.characters.last)) {
      _setExpression(
          _expression.substring(0, _expression.length - 1) + operator);
    } else {
      _setExpression(_expression + operator);
    }
  }

  void _submit(BuildContext context) {
    // If it's just a simple value, return as-is
    final asValue = double.tryParse(_expression);
    if (asValue != null) {
      context.pop(asValue);
      return;
    }

    // otherwise, clean the string and evaluate the expression
    final text = _expression.replaceAll(RegExp(r'\D+$'), '');

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

  void _addPeriod() {
    if (!_expression.contains('.')) {
      _setExpression('$_expression.');
    }
  }

  void _backspace() {
    if (_expression.isNotEmpty) {
      _setExpression(_expression.substring(0, _expression.length - 1));
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

  const _KeyboardButton({required this.child, required this.onPressed});

  static _KeyboardButton character(
          {required String text, required VoidCallback onPressed}) =>
      _KeyboardButton(
          onPressed: onPressed,
          child: Text(text, style: ThemeTypography.large));

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
