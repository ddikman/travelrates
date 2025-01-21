import 'package:flutter/material.dart';
import 'package:travelconverter/app_core/widgets/separated_extension.dart';
import 'package:travelconverter/app_core/theme/app_theme.dart';

typedef SegmentedSelectorCallback<T> = void Function(T value);

class SegmentedSelector<T> extends StatefulWidget {
  final List<String> labels;
  final List<T> values;
  final T initialSelection;
  final SegmentedSelectorCallback<T> onSelectionChanged;

  SegmentedSelector(
      {super.key,
      List<String>? labels,
      required this.values,
      required this.initialSelection,
      required this.onSelectionChanged})
      : this.labels = labels ?? values.map((e) => e.toString()).toList();

  @override
  State<SegmentedSelector<T>> createState() => _SegmentedSelectorState<T>();
}

class _SegmentedSelectorState<T> extends State<SegmentedSelector<T>> {
  late T _selectedValue;

  @override
  void initState() {
    _selectedValue = widget.initialSelection;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        color: context.themeColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(Rounding.small),
      ),
      child: Row(
          mainAxisSize: MainAxisSize.max,
          children: List.generate(
              widget.labels.length,
              (index) => Expanded(
                    child: _SegmentButton(
                      isSelected: _selectedValue == widget.values[index],
                      label: widget.labels[index],
                      onPressed: () {
                        final value = widget.values[index];
                        setState(() => _selectedValue = value);
                        widget.onSelectionChanged(value);
                      },
                    ),
                  )).separatedWith(const SizedBox(width: Paddings.medium))),
    );
  }
}

class _SegmentButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onPressed;

  const _SegmentButton(
      {required this.label, required this.isSelected, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      behavior: HitTestBehavior.translucent,
      child: Container(
        decoration: BoxDecoration(
            color: isSelected ? context.themeColors.accent : Colors.transparent,
            borderRadius: BorderRadius.circular(Rounding.small)),
        padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
        child: Text(label,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: isSelected
                    ? context.themeColors.contrastText
                    : context.themeColors.text)),
      ),
    );
  }
}
