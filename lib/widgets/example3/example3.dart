// search_bar.dart
import 'package:flutter/material.dart';
import 'dart:async';

class AdvancedSearchBar extends StatefulWidget {
  final Future<List<String>> Function(String) onSearch;
  final void Function(String) onItemSelected;
  final String placeholder;
  final Duration debounceDuration;
  final Duration animationDuration;

  const AdvancedSearchBar({
    super.key,
    required this.onSearch,
    required this.onItemSelected,
    this.placeholder = 'Search...',
    this.debounceDuration = const Duration(milliseconds: 300),
    this.animationDuration = const Duration(milliseconds: 200),
  });

  @override
  State<AdvancedSearchBar> createState() => _AdvancedSearchBarState();
}

class _AdvancedSearchBarState extends State<AdvancedSearchBar>
    with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounceTimer;
  List<String> _suggestions = [];
  bool _isLoading = false;
  bool _showError = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutBack,
      ),
    );
    _controller.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_controller.text.isEmpty) {
      setState(() {
        _suggestions = [];
        _showError = false;
      });
      return;
    }

    _debounceTimer?.cancel();
    _debounceTimer = Timer(widget.debounceDuration, () async {
      setState(() {
        _isLoading = true;
        _showError = false;
      });

      try {
        final results = await widget.onSearch(_controller.text);
        setState(() {
          _suggestions = results;
          _isLoading = false;
        });
        if (results.isNotEmpty) {
          _animationController.forward(from: 0.0);
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
          _showError = true;
          _suggestions = [];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: _controller,
          decoration: InputDecoration(
            hintText: widget.placeholder,
            prefixIcon: const Icon(Icons.search),
            suffixIcon: _buildSuffixIcon(),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            errorText: _showError ? 'Error fetching results' : null,
          ),
        ),
        if (_suggestions.isNotEmpty)
          ScaleTransition(
            scale: _scaleAnimation,
            child: Container(
              constraints: const BoxConstraints(maxHeight: 200),
              margin: const EdgeInsets.only(top: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _suggestions.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_suggestions[index]),
                    onTap: () {
                      widget.onItemSelected(_suggestions[index]);
                      _controller.clear();
                      setState(() => _suggestions = []);
                    },
                  );
                },
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSuffixIcon() {
    if (_isLoading) {
      return const Padding(
        padding: EdgeInsets.all(12.0),
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }
    if (_controller.text.isNotEmpty) {
      return IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          _controller.clear();
          setState(() {
            _suggestions = [];
            _showError = false;
          });
        },
      );
    }
    return const SizedBox.shrink();
  }
}

// Main file code (main.dart)

import 'package:flutter/material.dart';
import 'package:flutter_widget_testing/widgets/example3/example3.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Search Example')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: AdvancedSearchBar(
            onSearch: _handleSearch,
            onItemSelected: _handleSelection,
            placeholder: 'Search items...',
          ),
        ),
      ),
    );
  }

  // Simulates API call with sample data
  Future<List<String>> _handleSearch(String query) async {
    //delay for simulation
    await Future.delayed(const Duration(milliseconds: 500));

    final items = [
      'Apple',
      'Banana',
      'Cherry',
      'Date',
      'Elderberry',
      'Fig',
      'Grape',
      'Honeydew'
    ];

    return items
        .where((item) => item.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  void _handleSelection(String item) {
    debugPrint('Selected: $item');
  }
}

