import 'package:flutter/material.dart';
import 'package:flutter_template/core/utils/debouncer.dart';
import 'package:flutter_template/shared/widgets/inputs/app_text_field.dart';

/// Debounced search input field with clear action and leading search icon.
class SearchField extends StatefulWidget {
  const SearchField({
    super.key,
    required this.onSearch,
    this.hintText = 'Search...',
    this.debounceDuration = const Duration(milliseconds: 400),
    this.initialValue,
  });

  final ValueChanged<String> onSearch;
  final String hintText;
  final Duration debounceDuration;
  final String? initialValue;

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  late final TextEditingController _controller;
  late final Debouncer _debouncer;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
    _debouncer = Debouncer(duration: widget.debounceDuration);
    _hasText = _controller.text.isNotEmpty;
  }

  @override
  void dispose() {
    _controller.dispose();
    _debouncer.dispose();
    super.dispose();
  }

  void _onChanged(String query) {
    setState(() {
      _hasText = query.isNotEmpty;
    });
    _debouncer.run(() => widget.onSearch(query.trim()));
  }

  void _clear() {
    _controller.clear();
    setState(() {
      _hasText = false;
    });
    widget.onSearch('');
  }

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: _controller,
      hintText: widget.hintText,
      onChanged: _onChanged,
      prefixIcon: const Icon(Icons.search),
      suffixIcon: _hasText
          ? IconButton(
              icon: const Icon(Icons.clear),
              onPressed: _clear,
            )
          : null,
    );
  }
}
