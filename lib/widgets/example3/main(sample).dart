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
    //delay for simulation for see the circular progress indicator
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
