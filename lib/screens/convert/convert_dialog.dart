import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:travelconverter/app_core/theme/colors.dart';
import 'package:travelconverter/screens/convert/currency_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:travelconverter/services/logger.dart';

class ConvertDialog extends StatelessWidget {
  final logger = new Logger<ConvertDialog>();

  final ValueChanged<double> onSubmitted;

  final String currencyCode;

  final CurrencyInputFormatter _currencyInputFormatter =
      new CurrencyInputFormatter();

  final textFieldController = new TextEditingController();

  ConvertDialog(
      {Key? key, required this.onSubmitted, required this.currencyCode})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textField = new TextField(
      controller: textFieldController,
      autofocus: true,
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [_currencyInputFormatter],
      onSubmitted: (value) => _submit(context),
      decoration: InputDecoration(
          border: OutlineInputBorder(), labelText: _convertTitle(currencyCode)),
    );

    final submitButton = new Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: new Center(
        child: new TextButton(
            onPressed: () => _submit(context),
            child: new Text(
              _submitLabel,
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium!
                  .copyWith(fontSize: 16.0),
            ),
            style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(lightTheme.accent))),
      ),
    );

    return new Dialog(
      child: new Padding(
        padding: const EdgeInsets.all(16.0),
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[textField, submitButton],
        ),
      ),
    );
  }

  String get _submitLabel => Intl.message("CONVERT",
      name: '_submitLabel', desc: "Convert dialog button text");

  String _convertTitle(String currencyCode) {
    return Intl.message('$currencyCode to convert',
        name: "_convertTitle",
        desc: "Text displayed at the top of the convert dialog.",
        args: [currencyCode]);
  }

  _submit(BuildContext context) {
    context.pop();
    final stringValue = textFieldController.text;
    final value = CurrencyInputFormatter.toDouble(stringValue);
    if (value != null) {
      onSubmitted(value);
    } else {
      logger.event('parseFailure', "Failed to parse $stringValue to integer",
          parameters: {'failedValue': stringValue});
    }
  }
}
