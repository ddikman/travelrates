import 'package:backpacking_currency_converter/app_theme.dart';
import 'package:backpacking_currency_converter/currency_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ConvertDialog extends StatelessWidget {
  final ValueChanged<String> onSubmitted;

  final String currencyCode;

  final textFieldController = new TextEditingController();

  ConvertDialog({Key key, this.onSubmitted, this.currencyCode})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textField = new TextField(
      controller: textFieldController,
      autofocus: true,
      keyboardType: TextInputType.number,
      inputFormatters: [
        new WhitelistingTextInputFormatter(new RegExp(r'[\d\.]+')),
        new CurrencyInputFormatter()
      ],
      onSubmitted: (value) => _submit(context),
      decoration: InputDecoration(
          border: OutlineInputBorder(), labelText: '$currencyCode to convert'),
    );

    final submitButton = new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Center(
        child: new FlatButton(
          onPressed: () => _submit(context),
          child: new Text(
            'Convert',
            style: TextStyle(color: AppTheme.accentColor),
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

  _submit(BuildContext context) {
    Navigator.of(context).pop();
    onSubmitted(textFieldController.text);
  }
}