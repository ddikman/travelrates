import 'package:intl/intl.dart';
import 'package:travelconverter/app_theme.dart';
import 'package:travelconverter/screens/convert/currency_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ConvertDialog extends StatelessWidget {
  final ValueChanged<double> onSubmitted;

  final String currencyCode;

  final textFieldController = new TextEditingController();

  ConvertDialog({Key key, this.onSubmitted, this.currencyCode})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textField = new TextField(
      key: Key('convertTextField'),
      controller: textFieldController,
      autofocus: true,
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        new CurrencyInputFormatter()
      ],
      onSubmitted: (value) => _submit(context),
      decoration: InputDecoration(
          border: OutlineInputBorder(), labelText: _convertTitle(currencyCode)),
    );

    final submitButton = new Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: new Center(
        child: new FlatButton(
          key: Key('convertButton'),
          onPressed: () => _submit(context),
          child: new Text(
            _submitLabel,
            style: Theme.of(context).textTheme.display1.copyWith(
              fontSize: 16.0
            ),
          ),
          color: AppTheme.primaryColor,
        ),
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

  String get _submitLabel => Intl.message(
      "CONVERT",
      name: '_submitLabel',
      desc: "Convert dialog button text"
  );

  String _convertTitle(String currencyCode) {
    return Intl.message(
        '$currencyCode to convert',
        name: "_convertTitle",
        desc: "Text displayed at the top of the convert dialog.",
        args: [currencyCode]
    );
  }

  _submit(BuildContext context) {
    Navigator.of(context).pop();
    final value = double.tryParse(textFieldController.text.replaceAll(',', ''));
    if (value != null)
      onSubmitted(value);
  }
}