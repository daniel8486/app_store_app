import '../../../../shared/mock_data/mock_data.dart';
import '../../domain/entities/part.dart';

class CatalogRepository {
  List<Part>? _cache;

  List<Part> getAllParts() {
    _cache ??= MockData.parts
        .map((e) => Part.fromMap(e))
        .toList();
    return List.unmodifiable(_cache!);
  }

  Part? getPartById(String id) {
    return getAllParts().firstWhere(
      (p) => p.id == id,
      orElse: () => throw Exception('Peça não encontrada'),
    );
  }

  List<Part> search({
    String? query,
    String? brand,
    String? model,
    int? year,
    String? category,
  }) {
    var parts = getAllParts();

    if (query != null && query.isNotEmpty) {
      final q = query.toLowerCase();
      parts = parts.where((p) {
        final nameMatch = p.name.toLowerCase().contains(q);
        final codeMatch = p.code.toLowerCase().contains(q);
        final categoryMatch = p.category.toLowerCase().contains(q);
        final compatMatch = p.compatibilities.any(
          (c) =>
              c.brand.toLowerCase().contains(q) ||
              c.model.toLowerCase().contains(q),
        );
        return nameMatch || codeMatch || categoryMatch || compatMatch;
      }).toList();
    }

    if (brand != null && brand.isNotEmpty) {
      parts = parts
          .where((p) => p.compatibilities.any(
                (c) => c.brand.toLowerCase() == brand.toLowerCase(),
              ))
          .toList();
    }

    if (model != null && model.isNotEmpty) {
      parts = parts
          .where((p) => p.compatibilities.any(
                (c) => c.model.toLowerCase() == model.toLowerCase(),
              ))
          .toList();
    }

    if (year != null) {
      parts = parts
          .where((p) => p.compatibilities.any(
                (c) => year >= c.yearFrom && year <= c.yearTo,
              ))
          .toList();
    }

    if (category != null && category.isNotEmpty) {
      parts = parts
          .where((p) => p.category.toLowerCase() == category.toLowerCase())
          .toList();
    }

    return parts;
  }

  List<String> getBrands() {
    final brands = <String>{};
    for (final part in getAllParts()) {
      for (final c in part.compatibilities) {
        brands.add(c.brand);
      }
    }
    return brands.toList()..sort();
  }

  List<String> getModelsForBrand(String brand) {
    final models = <String>{};
    for (final part in getAllParts()) {
      for (final c in part.compatibilities) {
        if (c.brand.toLowerCase() == brand.toLowerCase()) {
          models.add(c.model);
        }
      }
    }
    return models.toList()..sort();
  }

  List<String> getCategories() {
    final categories = <String>{};
    for (final part in getAllParts()) {
      categories.add(part.category);
    }
    return categories.toList()..sort();
  }
}
