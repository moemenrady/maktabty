import '../../../admin/data/model/item_model.dart';
import '../../../../core/comman/entitys/categories.dart';

enum ServiceProviderItemStateStatus {
  initial,
  loading,
  success,
  successDeleteItem,
  successUpdateItem,
  failure,
}

class ServiceProviderItemState {
  final ServiceProviderItemStateStatus status;
  final List<ItemModel> items;
  final List<Categories> categories;
  final String? error;
  final bool isDeleting;

  ServiceProviderItemState({
    required this.status,
    required this.items,
    required this.categories,
    this.error,
    this.isDeleting = false,
  });

  factory ServiceProviderItemState.initial() {
    return ServiceProviderItemState(
      status: ServiceProviderItemStateStatus.initial,
      items: [],
      categories: [],
    );
  }

  bool isInitial() => status == ServiceProviderItemStateStatus.initial;
  bool isLoading() => status == ServiceProviderItemStateStatus.loading;
  bool isSuccess() => status == ServiceProviderItemStateStatus.success;
  bool isError() => status == ServiceProviderItemStateStatus.failure;

  ServiceProviderItemState copyWith({
    ServiceProviderItemStateStatus? status,
    List<ItemModel>? items,
    List<Categories>? categories,
    String? error,
    bool? isDeleting,
  }) {
    return ServiceProviderItemState(
      status: status ?? this.status,
      items: items ?? this.items,
      categories: categories ?? this.categories,
      error: error ?? this.error,
      isDeleting: isDeleting ?? this.isDeleting,
    );
  }
}
