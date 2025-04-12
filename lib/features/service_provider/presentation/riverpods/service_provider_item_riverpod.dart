import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

import '../../../../core/comman/app_user/app_user_riverpod.dart';
import '../../../../core/erorr/failure.dart';
import '../../../admin/data/model/item_model.dart';
import '../../data/repository/service_provider_item_repository.dart';
import 'service_provider_item_state.dart';
import 'service_provider_item_view_model.dart';

final serviceProviderItemProvider = StateNotifierProvider.autoDispose<
    ServiceProviderItemController, ServiceProviderItemState>((ref) {
  final repository = ref.watch(serviceProviderItemRepositoryProvider);
  final userId = ref.watch(appUserRiverpodProvider).user?.id;

  final controller = ServiceProviderItemController(
    repository: repository,
    userId: userId,
  );

  // Fetch data after initialization
  if (userId != null) {
    Future.microtask(() => controller.fetchItems());
  }

  return controller;
});

final serviceProviderItemViewModelProvider =
    Provider.autoDispose<ServiceProviderItemViewModel>((ref) {
  final viewModel = ServiceProviderItemViewModel();
  ref.onDispose(() => viewModel.dispose());
  return viewModel;
});

class ServiceProviderItemController
    extends StateNotifier<ServiceProviderItemState> {
  final ServiceProviderItemRepository repository;
  final int? userId;
  final _imagePicker = ImagePicker();

  ServiceProviderItemController({
    required this.repository,
    required this.userId,
  }) : super(ServiceProviderItemState.initial()) {
    fetchCategories();
    if (userId != null) {
      fetchItems();
    }
  }

  Future<void> fetchCategories() async {
    final result = await repository.getAllCategories();
    result.fold(
      (failure) => state = state.copyWith(
        status: ServiceProviderItemStateStatus.failure,
        error: failure.message,
      ),
      (categories) => state = state.copyWith(
        categories: categories,
      ),
    );
  }

  Future<void> fetchItems() async {
    if (userId == null) return;

    state = state.copyWith(status: ServiceProviderItemStateStatus.loading);
    final result = await repository.getServiceProviderItems(userId!);
    result.fold(
      (failure) => state = state.copyWith(
        status: ServiceProviderItemStateStatus.failure,
        error: failure.message,
      ),
      (items) => state = state.copyWith(
        status: ServiceProviderItemStateStatus.success,
        items: items,
      ),
    );
  }

  Future<void> deleteItem(String itemId, String imageUrl) async {
    state = state.copyWith(status: ServiceProviderItemStateStatus.loading);
    final result = await repository.deleteItem(itemId, imageUrl);
    result.fold(
      (failure) => state = state.copyWith(
        status: ServiceProviderItemStateStatus.failure,
        error: failure.message,
      ),
      (_) {
        state = state.copyWith(
          status: ServiceProviderItemStateStatus.successDeleteItem,
          isDeleting: false,
        );
        fetchItems();
      },
    );
  }

  Future<void> uploadItem(ItemModel itemModel, File? image) async {
    state = state.copyWith(status: ServiceProviderItemStateStatus.loading);

    // Add the service provider ID in database column
    Map<String, dynamic> itemMap = itemModel.toMap();
    itemMap['user_id'] = userId;
    final customItem = ItemModel.fromMap(itemMap);

    final result = await repository.uploadItem(customItem, image);
    result.fold(
      (failure) => state = state.copyWith(
        status: ServiceProviderItemStateStatus.failure,
        error: failure.message,
      ),
      (item) {
        state = state.copyWith(
          status: ServiceProviderItemStateStatus.success,
        );
        fetchItems();
      },
    );
  }

  Future<void> updateItem(ItemModel item) async {
    state = state.copyWith(status: ServiceProviderItemStateStatus.loading);

    // Ensure the item has user_id
    Map<String, dynamic> itemMap = item.toMap();
    itemMap['user_id'] = userId;
    ItemModel updatedItem = ItemModel.fromMap(itemMap);

    // Update the item
    final result = await repository.updateItem(updatedItem);
    result.fold(
      (failure) => state = state.copyWith(
        status: ServiceProviderItemStateStatus.failure,
        error: failure.message,
      ),
      (updatedItem) {
        state = state.copyWith(
          status: ServiceProviderItemStateStatus.successUpdateItem,
        );
        fetchItems();
      },
    );
  }

  Future<File?> pickImage() async {
    try {
      final pickedFile =
          await _imagePicker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        return File(pickedFile.path);
      }
      return null;
    } catch (e) {
      state = state.copyWith(
        status: ServiceProviderItemStateStatus.failure,
        error: 'Failed to pick image: $e',
      );
      return null;
    }
  }
}
