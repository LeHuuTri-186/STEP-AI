import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CopyWithTooltip extends StatefulWidget {
  final String textToCopy;

  const CopyWithTooltip({required this.textToCopy, Key? key}) : super(key: key);

  @override
  State<CopyWithTooltip> createState() => _CopyWithTooltipState();
}

class _CopyWithTooltipState extends State<CopyWithTooltip> {
  OverlayEntry? _overlayEntry;

  void _copyToClipboard() {
    if (widget.textToCopy.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: widget.textToCopy)).then((_) {
        _showTooltip();
        Future.delayed(const Duration(seconds: 1), _hideTooltip);
      }).catchError((error) {
        if (kDebugMode) {
          print("Error copying text to clipboard: $error");
        }
      });
    }
  }

  void _showTooltip() {
    _overlayEntry = _createTooltipOverlay();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hideTooltip() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _createTooltipOverlay() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    Offset offset = renderBox.localToGlobal(Offset.zero);
    Size size = renderBox.size;

    return OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx + size.width / 2 - 30, // Center the tooltip
        top: offset.dy - 30, // Position above the widget
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.black87.withOpacity(0.8),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text(
              'Copied!',
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _copyToClipboard,
      child: Icon(
        Icons.copy_outlined,
        color: Colors.grey.withOpacity(0.7),
      ),
    );
  }
}
