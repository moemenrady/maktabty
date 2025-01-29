import 'package:flutter/material.dart';
import '../../../admin/data/model/item_model.dart';

class ItemsSearchController extends ChangeNotifier {
  String _searchQuery = '';
  String _sortOrder = 'name_asc';
  double? _minPrice;
  double? _maxPrice;
  List<ItemModel> _items = [];
  List<ItemModel> _filteredItems = [];

  String get searchQuery => _searchQuery;
  String get sortOrder => _sortOrder;
  double? get minPrice => _minPrice;
  double? get maxPrice => _maxPrice;
  List<ItemModel> get filteredItems => _filteredItems;

  void setItems(List<ItemModel> items) {
    _items = items;
    _applyFilters();
  }

  void updateSearchQuery(String query) {
    _searchQuery = query;
    _applyFilters();
    notifyListeners();
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
  }
}
