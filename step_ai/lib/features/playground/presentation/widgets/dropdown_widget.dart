import 'package:flutter/material.dart';

import '../../../../shared/styles/colors.dart';

class DropdownWidget extends StatefulWidget {
  final List<String> items;
  final String? initialValue;
  final ValueChanged<String> onSelected;

  const DropdownWidget({
    Key? key,
    required this.items,
    this.initialValue,
    required this.onSelected,
  }) : super(key: key);

  @override
  _DropdownWidgetState createState() => _DropdownWidgetState();
}

class _DropdownWidgetState extends State<DropdownWidget> {
  late String _selectedItem;

  @override
  void initState() {
    super.initState();
    _selectedItem = widget.initialValue ?? widget.items.first;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: PopupMenuButton<String>(
        color: TColor.doctorWhite,
        onOpened: () {
          setState(() {});
        },
        onCanceled: () {
          setState(() {});
        },
        initialValue: _selectedItem,
        onSelected: (value) {
          setState(() {
            _selectedItem = value;
          });
          widget.onSelected(value);
        },
        itemBuilder: (context) {
          return widget.items.map((item) {
            return PopupMenuItem<String>(
              labelTextStyle: WidgetStatePropertyAll(Theme.of(context).textTheme.bodyMedium),
              value: item,
              child: Text(
                item,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            );
          }).toList();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24.0),
            border: Border.all(
              width: 0,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _selectedItem,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Icon(
                Icons.arrow_drop_down_rounded,
                size: 24,
                color: Colors.grey.shade600,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
