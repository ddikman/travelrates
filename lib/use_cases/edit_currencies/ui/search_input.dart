import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travelconverter/app_core/theme/colors.dart';
import 'package:travelconverter/app_core/theme/sizes.dart';
import 'package:travelconverter/use_cases/edit_currencies/state/search_filter_provider.dart';

class SearchInput extends ConsumerStatefulWidget {
  final bool autoFocus;

  const SearchInput({super.key, this.autoFocus = true});

  @override
  _SearchInputState createState() => _SearchInputState();
}

class _SearchInputState extends ConsumerState<SearchInput> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: (value) =>
          ref.read(searchFilterProvider.notifier).state = value,
      autofocus: widget.autoFocus,
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
