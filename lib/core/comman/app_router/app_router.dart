import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../features/admin/data/model/item_model.dart';
import '../../../features/service_provider/presentation/screens/service_provider_add_item_page.dart';
import '../../../features/service_provider/presentation/screens/service_provider_edit_item_page.dart';
import '../../../features/service_provider/presentation/screens/service_provider_item_page.dart';
import 'router_names.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  debugLogDiagnostics: true,
  routes: [
    // Service Provider Routes
    GoRoute(
      path: '/${RouteNames.serviceProviderItems}',
      name: RouteNames.serviceProviderItems,
      builder: (context, state) => const ServiceProviderItemPage(),
    ),
    GoRoute(
      path: '/${RouteNames.serviceProviderAddItem}',
      name: RouteNames.serviceProviderAddItem,
      builder: (context, state) => const ServiceProviderAddItemPage(),
    ),
    GoRoute(
      path: '/${RouteNames.serviceProviderEditItem}',
      name: RouteNames.serviceProviderEditItem,
      builder: (context, state) {
        final ItemModel item = state.extra as ItemModel;
        return ServiceProviderEditItemPage(item: item);
      },
    ),

    // Add other routes as needed
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text('Error: ${state.error}'),
    ),
  ),
);
