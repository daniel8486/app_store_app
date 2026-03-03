import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/catalog_repository.dart';
import '../../domain/entities/part.dart';
import '../../domain/entities/product.dart';

final catalogRepositoryProvider = Provider<CatalogRepository>((ref) {
  return CatalogRepository();
});

final allPartsProvider = Provider<List<Part>>((ref) {
  return ref.read(catalogRepositoryProvider).getAllParts();
});

final brandsProvider = Provider<List<String>>((ref) {
  return ref.read(catalogRepositoryProvider).getBrands();
});

final categoriesProvider = Provider<List<String>>((ref) {
  return ref.read(catalogRepositoryProvider).getCategories();
});

// Search filter state
class SearchFilter {
  final String query;
  final String? brand;
  final String? model;
  final int? year;
  final String? category;

  const SearchFilter({
    this.query = '',
    this.brand,
    this.model,
    this.year,
    this.category,
  });

  SearchFilter copyWith({
    String? query,
    String? brand,
    String? model,
    int? year,
    String? category,
    bool clearBrand = false,
    bool clearModel = false,
    bool clearYear = false,
    bool clearCategory = false,
  }) {
    return SearchFilter(
      query: query ?? this.query,
      brand: clearBrand ? null : (brand ?? this.brand),
      model: clearModel ? null : (model ?? this.model),
      year: clearYear ? null : (year ?? this.year),
      category: clearCategory ? null : (category ?? this.category),
    );
  }

  bool get hasFilters =>
      query.isNotEmpty ||
      brand != null ||
      model != null ||
      year != null ||
      category != null;
}

final searchFilterProvider =
    StateNotifierProvider<SearchFilterNotifier, SearchFilter>(
  (ref) => SearchFilterNotifier(),
);

class SearchFilterNotifier extends StateNotifier<SearchFilter> {
  SearchFilterNotifier() : super(const SearchFilter());

  void updateQuery(String query) {
    state = state.copyWith(query: query);
  }

  void updateBrand(String? brand) {
    state = state.copyWith(
      brand: brand,
      clearBrand: brand == null,
      clearModel: true,
    );
  }

  void updateModel(String? model) {
    state = state.copyWith(model: model, clearModel: model == null);
  }

  void updateYear(int? year) {
    state = state.copyWith(year: year, clearYear: year == null);
  }

  void updateCategory(String? category) {
    state = state.copyWith(category: category, clearCategory: category == null);
  }

  void clearAll() {
    state = const SearchFilter();
  }
}

final filteredPartsProvider = Provider<List<Part>>((ref) {
  final repo = ref.read(catalogRepositoryProvider);
  final filter = ref.watch(searchFilterProvider);
  return repo.search(
    query: filter.query,
    brand: filter.brand,
    model: filter.model,
    year: filter.year,
    category: filter.category,
  );
});

final modelsForBrandProvider =
    Provider.family<List<String>, String>((ref, brand) {
  return ref.read(catalogRepositoryProvider).getModelsForBrand(brand);
});

// Provider para buscar um Product completo baseado em um ID
final productByIdProvider = Provider.family<Product?, String>((ref, productId) {
  final repo = ref.read(catalogRepositoryProvider);
  final parts = repo.getAllParts();

  // Encontra o Part correspondente
  final part = parts.firstWhere(
    (p) => p.id == productId,
    orElse: () => null as Part,
  );

  if (part == null) return null;

  // Converte Part em Product com dados completos
  return Product(
    id: part.id,
    sku: part.code,
    gtin: 'GTIN-${part.id}',
    partNumber: 'PN-${part.code}',
    oemCode: 'OEM-${part.code}',
    brand: part.supplierName,
    qualityRanking: QualityRanking.original,
    crossReferences: [],
    vehicleCompatibilities: part.compatibilities
        .map((c) => VehicleCompatibility(
              manufacturer: c.brand,
              model: c.model,
              version: '${c.yearFrom}-${c.yearTo}',
              yearFrom: c.yearFrom,
              yearTo: c.yearTo,
              motorization: 'Diversos',
              fuelType: FuelType.flex,
            ))
        .toList(),
    ncm: '8708301000',
    cst: '00',
    isMonophasic: false,
    origin: MerchandiseOrigin.national,
    cfop: '5102',
    physicalLocation: 'Corredor A',
    minimumStock: 5,
    maximumStock: 100,
    leadTimeDays: 3,
    weight: 0.5,
    length: 15.0,
    width: 10.0,
    height: 5.0,
    price: part.price,
    currentStock: part.stock,
    name: part.name,
    description: part.description,
    seoTitle: 'SEO - ${part.name}',
    keywords: [part.category, part.supplierName.toLowerCase()],
    imageUrls: [part.imageUrl],
    rating: part.rating,
    reviews: part.reviews
        .map((r) => {
              'author': r.author,
              'rating': r.rating,
              'comment': r.comment,
              'date': r.date,
            })
        .toList(),
  );
});
