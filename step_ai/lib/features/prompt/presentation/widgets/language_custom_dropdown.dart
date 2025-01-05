import 'package:flutter/material.dart';
import 'package:step_ai/shared/styles/vertical_spacing.dart';

import '../../../../shared/styles/colors.dart';

class LanguageCustomDropdown extends StatefulWidget {
  final String? value;
  final Map<String, String> items;
  final ValueChanged<String?> onChanged;
  final String hintText;

  const LanguageCustomDropdown({
    Key? key,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.hintText,
  }) : super(key: key);

  @override
  State<LanguageCustomDropdown> createState() => _LanguageCustomDropdownState();
}

class _LanguageCustomDropdownState extends State<LanguageCustomDropdown> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isDropdownOpen = false;

  void _toggleDropdown() {
    if (_isDropdownOpen) {
      _closeDropdown();
    } else {
      _openDropdown();
    }
  }

  void _openDropdown() {
    if (_overlayEntry != null) return; // Prevent multiple overlays
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    setState(() {
      _isDropdownOpen = true;
    });
  }

  void _closeDropdown() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
      setState(() {
        _isDropdownOpen = false;
      });
    }
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    Offset offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            // Detect taps outside to dismiss the dropdown
            GestureDetector(
              onTap: _closeDropdown,
              behavior: HitTestBehavior.opaque,
              child: Container(
                color: Colors.transparent, // Ensures the tap gesture is captured
              ),
            ),
            // Dropdown overlay
            Positioned(
              width: renderBox.size.width,
              top: offset.dy + renderBox.size.height,
              left: offset.dx,
              child: CompositedTransformFollower(
                link: _layerLink,
                showWhenUnlinked: false,
                child: Material(
                  color: TColor.doctorWhite,
                  elevation: 4,
                  borderRadius: BorderRadius.circular(8),
                  child: SizedBox(
                    width: 400,
                    height: 400,
                    child: ListView(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      children: widget.items.entries.map((entry) {
                        String language = entry.key;
                        String description = entry.value;

                        return GestureDetector(
                          onTap: () {
                            widget.onChanged(language);
                            _closeDropdown();
                          },
                          child: ListTile(
                            title: Text(
                              language,
                              style: const TextStyle(fontSize: 16),
                            ),
                            subtitle: Text(
                              description,
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.grey),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _closeDropdown(); // Ensure cleanup
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: _toggleDropdown,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: TColor.doctorWhite,
            border: Border.all(color: TColor.petRock),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.value != null
                    ? widget.value! ?? widget.hintText
                    : widget.hintText,
                style: TextStyle(
                  color: TColor.squidInk,
                  fontSize: 15,
                  fontWeight: FontWeight.w600
                ),
                overflow: TextOverflow.ellipsis,
              ),
              Icon(
                _isDropdownOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
