import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../../../admin/data/model/item_model.dart';
import 'dart:convert';
import 'dart:async';

class ItemsSearchController extends ChangeNotifier {
  String _searchQuery = '';
  String _sortOrder = 'name_asc';
  double? _minPrice;
  double? _maxPrice;
  List<ItemModel> _items = [];
  List<ItemModel> _filteredItems = [];
  String? aiSuggestion;
  List<String>? relatedItems;
  Timer? _debounceTimer;
  bool showingSuggestionMessage = false;

  String get searchQuery => _searchQuery;
  String get sortOrder => _sortOrder;
  double? get minPrice => _minPrice;
  double? get maxPrice => _maxPrice;
  List<ItemModel> get filteredItems => _filteredItems;

  void setItems(List<ItemModel> items) {
    _items = items;
    _applyFilters();
    if (_searchQuery.isEmpty) {
      _getAISuggestions(); // Show related items when items are first loaded
    }
  }

  void updateSearchQuery(String query) {
    _searchQuery = query;
    showingSuggestionMessage = false; // Reset when searching

    // Cancel previous timer if it exists
    _debounceTimer?.cancel();

    // Set new timer
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      _applyFilters();
      notifyListeners();
    });
  }

  void updateSortOrder(String order) {
    _sortOrder = order;
    _applyFilters();
    notifyListeners();
  }

  void updatePriceRange(double? min, double? max) {
    _minPrice = min;
    _maxPrice = max;
    _applyFilters();
    notifyListeners();
  }

  List<ItemModel> getFilteredAndSortedItems(List<ItemModel> items) {
    if (_items != items) {
      setItems(items);
    }
    return _filteredItems;
  }

  void _applyFilters() {
    var filtered = _items.where((item) {
      final nameMatch =
          item.name.toLowerCase().contains(_searchQuery.toLowerCase());
      final priceMatch =
          (_minPrice == null || item.retailPrice >= _minPrice!) &&
              (_maxPrice == null || item.retailPrice <= _maxPrice!);
      return nameMatch && priceMatch;
    }).toList();

    switch (_sortOrder) {
      case 'name_asc':
        filtered.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'name_desc':
        filtered.sort((a, b) => b.name.compareTo(a.name));
        break;
      case 'price_asc':
        filtered.sort((a, b) => a.retailPrice.compareTo(b.retailPrice));
        break;
      case 'price_desc':
        filtered.sort((a, b) => b.retailPrice.compareTo(a.retailPrice));
        break;
    }

    _filteredItems = filtered;

    // Automatically get AI suggestions if no results found
    if (_filteredItems.isEmpty && _searchQuery.isNotEmpty) {
      _getAISuggestions();
    }
  }

  Future<void> _getAISuggestions() async {
    try {
      final model = GenerativeModel(
        model: 'gemini-1.5-flash-latest',
        apiKey: "",
      );

      final prompt = '''
        User searched for: "${_searchQuery}"
        Available items: ${_items.map((e) => e.name).join(', ')}
        
        Return ONLY a JSON object like this:
        {
          "itemGuess": "what the user might be looking for (e.g., 'Rotring Mechanical Pencil' for 'roto')",
          "relatedItems": [
            Return exactly 3 item names from the available items list that are most relevant
          ]
        }
        
        Important: relatedItems MUST be exact matches of names from the available items list.
      ''';

      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);

      if (response.text != null) {
        try {
          final cleanedText = response.text!
              .replaceAll("```json", "")
              .replaceAll("```", "")
              .replaceAll("\n", "")
              .trim();

          final result = json.decode(cleanedText);
          print('AI Response: $result'); // Debug print

          aiSuggestion = result['itemGuess']?.toString();

          if (result['relatedItems'] is List) {
            // Get all item names in lowercase for case-insensitive comparison
            final availableItemNames =
                _items.map((e) => e.name.toLowerCase()).toSet();

            // Filter related items that exist in our inventory
            relatedItems = (result['relatedItems'] as List)
                .map((item) => item.toString())
                .where((suggested) =>
                    availableItemNames.contains(suggested.toLowerCase()))
                .toList();

            // If no exact matches found, take first 3 items as fallback
            if (relatedItems!.isEmpty && _items.isNotEmpty) {
              relatedItems = _items.take(3).map((e) => e.name).toList();
            }
          }

          print('AI Suggestion: $aiSuggestion'); // Debug print
          print('Related Items: $relatedItems'); // Debug print

          notifyListeners();
        } catch (e) {
          print('Error parsing AI response: $e');
          print('Raw response: ${response.text}');
        }
      }
    } catch (e) {
      print('Error in AI search: $e');
    }
  }

  void showSuggestionMessage() {
    showingSuggestionMessage = true;
    notifyListeners();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}
