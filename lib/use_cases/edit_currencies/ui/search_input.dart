import 'package:flutter/material.dart';
import 'package:travelconverter/app_core/theme/colors.dart';
import 'package:travelconverter/app_core/theme/sizes.dart';

class SearchInput extends StatefulWidget {
  final ValueChanged<String> onChange;
  final bool autoFocus;

  const SearchInput({super.key, required this.onChange, this.autoFocus = true});

  @override
  State<SearchInput> createState() => _SearchInputState();
}

class _SearchInputState extends State<SearchInput> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      autofocus: widget.autoFocus,
      onChanged: (value) => widget.onChange(value),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(Paddings.small),
        hintStyle: TextStyle(color: lightTheme.text30),
        prefixIconColor: widgetStateColor,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: lightTheme.text30, width: 2.0),
          borderRadius: BorderRadius.circular(Rounding.small),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: lightTheme.text, width: 2.0),
          borderRadius: BorderRadius.circular(Rounding.small),
        ),
        hintText: 'Search',
        prefixIcon: Icon(Icons.search),
      ),
    );
  }

  WidgetStateColor get widgetStateColor =>
      WidgetStateColor.resolveWith((states) {
        return states.contains(WidgetState.focused)
            ? lightTheme.text
            : lightTheme.text30;
      });
}
