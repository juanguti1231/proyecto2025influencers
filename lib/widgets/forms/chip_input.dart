import 'package:flutter/material.dart';
import '../../utils/theme.dart';

class ChipInput extends StatefulWidget {
  final String? label;
  final String? hint;
  final List<String> chips;
  final void Function(List<String>)? onChanged;
  final List<String>? suggestions;
  final String? Function(String?)? validator;

  const ChipInput({
    super.key,
    this.label,
    this.hint,
    required this.chips,
    this.onChanged,
    this.suggestions,
    this.validator,
  });

  @override
  State<ChipInput> createState() => _ChipInputState();
}

class _ChipInputState extends State<ChipInput> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: AppTheme.spacingS),
        ],
        
        // Chips display
        if (widget.chips.isNotEmpty)
          Wrap(
            spacing: AppTheme.spacingS,
            runSpacing: AppTheme.spacingS,
            children: widget.chips.map((chip) => Chip(
              label: Text(chip),
              onDeleted: () {
                final newChips = List<String>.from(widget.chips)..remove(chip);
                widget.onChanged?.call(newChips);
              },
              deleteIcon: const Icon(Icons.close, size: 16),
            )).toList(),
          ),
        
        if (widget.chips.isNotEmpty) const SizedBox(height: AppTheme.spacingS),
        
        // Input field
        TextFormField(
          controller: _controller,
          focusNode: _focusNode,
          decoration: InputDecoration(
            hintText: widget.hint,
            suffixIcon: IconButton(
              icon: const Icon(Icons.add),
              onPressed: _addChip,
            ),
          ),
          onFieldSubmitted: (_) => _addChip(),
          validator: widget.validator,
        ),
        
        // Suggestions
        if (widget.suggestions != null && _controller.text.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: AppTheme.spacingS),
            child: Wrap(
              spacing: AppTheme.spacingS,
              runSpacing: AppTheme.spacingS,
              children: widget.suggestions!
                  .where((suggestion) => 
                      suggestion.toLowerCase().contains(_controller.text.toLowerCase()) &&
                      !widget.chips.contains(suggestion))
                  .take(5)
                  .map((suggestion) => ActionChip(
                    label: Text(suggestion),
                    onPressed: () {
                      _controller.clear();
                      final newChips = List<String>.from(widget.chips)..add(suggestion);
                      widget.onChanged?.call(newChips);
                    },
                  ))
                  .toList(),
            ),
          ),
      ],
    );
  }

  void _addChip() {
    final text = _controller.text.trim();
    if (text.isNotEmpty && !widget.chips.contains(text)) {
      final newChips = List<String>.from(widget.chips)..add(text);
      widget.onChanged?.call(newChips);
      _controller.clear();
    }
  }
}
