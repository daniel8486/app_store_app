import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/admin_product_repository.dart';
import '../../domain/entities/admin_product.dart';
import '../../domain/entities/product_category.dart';

// Repository Provider
final adminProductRepositoryProvider = Provider<AdminProductRepository>((ref) {
  return AdminProductRepository();
});

// Get all products
final adminProductsProvider = FutureProvider.family<
    List<AdminProduct>,
    ({
      int? limit,
      int? offset,
      ProductCategory? category,
      ProductStatus? status
    })>(
  (ref, params) async {
    final repo = ref.watch(adminProductRepositoryProvider);
    return repo.getProducts(
      limit: params.limit,
      offset: params.offset,
      category: params.category,
      status: params.status,
    );
  },
);

// Get single product by ID
final adminProductByIdProvider = FutureProvider.family<AdminProduct?, String>(
  (ref, id) async {
    final repo = ref.watch(adminProductRepositoryProvider);
    return repo.getProductById(id);
  },
);

// Get products by category
final adminProductsByCategoryProvider =
    FutureProvider.family<List<AdminProduct>, ProductCategory>(
  (ref, category) async {
    final repo = ref.watch(adminProductRepositoryProvider);
    return repo.getProductsByCategory(category);
  },
);

// Get low stock products
final adminLowStockProductsProvider = FutureProvider<List<AdminProduct>>(
  (ref) async {
    final repo = ref.watch(adminProductRepositoryProvider);
    return repo.getLowStockProducts();
  },
);

// Search products
final adminProductSearchProvider =
    FutureProvider.family<List<AdminProduct>, String>(
  (ref, query) async {
    if (query.isEmpty) {
      return [];
    }
    final repo = ref.watch(adminProductRepositoryProvider);
    return repo.searchProducts(query);
  },
);

// Total product count
final adminTotalProductCountProvider = FutureProvider<int>(
  (ref) async {
    final repo = ref.watch(adminProductRepositoryProvider);
    return repo.getTotalProductCount();
  },
);

// State notifier para gerenciar criação/edição de produtos
class AdminProductFormNotifier extends StateNotifier<AdminProduct?> {
  final AdminProductRepository _repository;

  AdminProductFormNotifier(this._repository) : super(null);

  void setProduct(AdminProduct? product) {
    state = product;
  }

  void updateField({
    required String Function(AdminProduct) getter,
    required AdminProduct Function(AdminProduct, dynamic) setter,
    required dynamic value,
  }) {
    if (state != null) {
      state = setter(state!, value);
    }
  }

  Future<void> saveProduct(dynamic ref) async {
    if (state == null) return;

    try {
      final isNew = state!.id.startsWith('temp_');
      final savedProduct = isNew
          ? await _repository.createProduct(state!)
          : await _repository.updateProduct(state!);

      state = savedProduct;
      // Invalidate related providers
      ref.invalidate(adminProductsProvider);
      ref.invalidate(adminProductByIdProvider);
      ref.invalidate(adminTotalProductCountProvider);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteProduct(dynamic ref, String id) async {
    try {
      await _repository.deleteProduct(id);
      state = null;
      ref.invalidate(adminProductsProvider);
      ref.invalidate(adminProductByIdProvider);
      ref.invalidate(adminTotalProductCountProvider);
    } catch (e) {
      rethrow;
    }
  }
}

final adminProductFormProvider =
    StateNotifierProvider<AdminProductFormNotifier, AdminProduct?>((ref) {
  final repo = ref.watch(adminProductRepositoryProvider);
  return AdminProductFormNotifier(repo);
});

// Filter and search state
class AdminProductFilterState {
  final ProductCategory? category;
  final ProductStatus? status;
  final String? searchQuery;
  final int page;
  final int limit;

  const AdminProductFilterState({
    this.category,
    this.status,
    this.searchQuery,
    this.page = 0,
    this.limit = 20,
  });

  AdminProductFilterState copyWith({
    ProductCategory? category,
    ProductStatus? status,
    String? searchQuery,
    int? page,
    int? limit,
  }) {
    return AdminProductFilterState(
      category: category ?? this.category,
      status: status ?? this.status,
      searchQuery: searchQuery ?? this.searchQuery,
      page: page ?? this.page,
      limit: limit ?? this.limit,
    );
  }
}

class AdminProductFilterNotifier
    extends StateNotifier<AdminProductFilterState> {
  AdminProductFilterNotifier() : super(const AdminProductFilterState());

  void updateCategory(ProductCategory? category) {
    state = state.copyWith(category: category, page: 0);
  }

  void updateStatus(ProductStatus? status) {
    state = state.copyWith(status: status, page: 0);
  }

  void updateSearch(String query) {
    state = state.copyWith(searchQuery: query, page: 0);
  }

  void nextPage() {
    state = state.copyWith(page: state.page + 1);
  }

  void previousPage() {
    if (state.page > 0) {
      state = state.copyWith(page: state.page - 1);
    }
  }

  void reset() {
    state = const AdminProductFilterState();
  }
}

final adminProductFilterProvider =
    StateNotifierProvider<AdminProductFilterNotifier, AdminProductFilterState>(
  (ref) => AdminProductFilterNotifier(),
);

// Filtered products provider
final adminFilteredProductsProvider =
    FutureProvider<List<AdminProduct>>((ref) async {
  final filter = ref.watch(adminProductFilterProvider);
  final repo = ref.watch(adminProductRepositoryProvider);

  if (filter.searchQuery != null && filter.searchQuery!.isNotEmpty) {
    return repo.searchProducts(filter.searchQuery!);
  }

  return repo.getProducts(
    limit: filter.limit,
    offset: filter.page * filter.limit,
    category: filter.category,
    status: filter.status,
  );
});
