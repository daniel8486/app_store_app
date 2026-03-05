import 'package:uuid/uuid.dart';
import '../../domain/entities/admin_product.dart';
import '../../domain/entities/product_category.dart';

abstract class IAdminProductRepository {
  Future<List<AdminProduct>> getProducts({
    int? limit,
    int? offset,
    ProductCategory? category,
    ProductStatus? status,
  });

  Future<AdminProduct?> getProductById(String id);
  Future<AdminProduct?> getProductByCode(String code);
  Future<AdminProduct> createProduct(AdminProduct product);
  Future<AdminProduct> updateProduct(AdminProduct product);
  Future<void> deleteProduct(String id);
  Future<List<AdminProduct>> searchProducts(String query);
  Future<List<AdminProduct>> getProductsByCategory(ProductCategory category);
  Future<List<AdminProduct>> getLowStockProducts();
  Future<void> updateStock(String productId, int newStock);
  Future<int> getTotalProductCount();
}

class AdminProductRepository implements IAdminProductRepository {
  // Mock data storage
  final Map<String, AdminProduct> _products = {};

  AdminProductRepository() {
    _initializeMockData();
  }

  void _initializeMockData() {
    final now = DateTime.now();
    final mockProducts = [
      AdminProduct(
        id: 'prod_001',
        name: 'Filtro de Óleo Mobil',
        code: 'FO-MOB-001',
        description: 'Filtro de óleo de alta qualidade',
        longDescription:
            'Filtro de óleo premium Mobil para motores 1.0 a 2.0. Garante melhor lubrificação e proteção do motor.',
        price: 45.00,
        promotionalPrice: 39.90,
        stock: 150,
        minStock: 20,
        imageUrl: 'https://via.placeholder.com/300?text=Filtro+Oleo',
        category: ProductCategory.oilFilter,
        status: ProductStatus.active,
        supplierId: 'sup_001',
        supplierName: 'Mobil Brasil',
        rating: 4.8,
        reviewCount: 245,
        tags: ['filtro', 'oleo', 'manutencao'],
        specifications: {
          'Tipo': 'Rosca',
          'Diâmetro': '76mm',
          'Altura': '95mm',
          'Compatibilidade': 'Motores 1.0 a 2.0',
        },
        isNewProduct: false,
        createdAt: now.subtract(Duration(days: 30)),
        updatedAt: now,
        sku: 'MOB-OIL-001',
        barcode: '8717057000234',
        weight: 0.25,
        dimensions: '76x95mm',
        guaranteeMonths: 12,
      ),
      AdminProduct(
        id: 'prod_002',
        name: 'Pastilha de Freio Brembo',
        code: 'PF-BRE-002',
        description: 'Pastilhas de freio semi-metálicas',
        longDescription:
            'Pastilhas de freio Brembo fabricadas com composição semi-metálica para maior durabilidade e eficiência de frenagem.',
        price: 120.00,
        stock: 80,
        minStock: 15,
        imageUrl: 'https://via.placeholder.com/300?text=Pastilha+Freio',
        category: ProductCategory.breakPads,
        status: ProductStatus.active,
        supplierId: 'sup_002',
        supplierName: 'Brembo',
        rating: 4.9,
        reviewCount: 412,
        tags: ['freio', 'segurança', 'performance'],
        specifications: {
          'Tipo': 'Semi-metálica',
          'Espessura': '8.5mm',
          'Comprimento': '94mm',
          'Largura': '43mm',
        },
        isNewProduct: false,
        createdAt: now.subtract(Duration(days: 45)),
        updatedAt: now,
        sku: 'BRE-PAD-002',
        barcode: '8717057000245',
        weight: 0.35,
        guaranteeMonths: 24,
      ),
      AdminProduct(
        id: 'prod_003',
        name: 'Bateria Moura 60Ah',
        code: 'BAT-MOU-60',
        description: 'Bateria automotiva 60Ah',
        longDescription:
            'Bateria automotiva Moura 60Ah com tecnologia de placas positivas espessas. Ideal para veículos de linha leve com consumo energético moderado.',
        price: 280.00,
        promotionalPrice: 249.90,
        stock: 45,
        minStock: 10,
        imageUrl: 'https://via.placeholder.com/300?text=Bateria',
        category: ProductCategory.batteryLight,
        status: ProductStatus.active,
        supplierId: 'sup_003',
        supplierName: 'Moura',
        rating: 4.7,
        reviewCount: 389,
        tags: ['bateria', 'energia', 'partida'],
        specifications: {
          'Capacidade': '60Ah',
          'Tensão': '12V',
          'Tipo': 'Chumbo-ácido',
          'Corrente Fria': '450A',
        },
        isNewProduct: false,
        createdAt: now.subtract(Duration(days: 60)),
        updatedAt: now,
        sku: 'MOU-BAT-60',
        barcode: '8717057000256',
        weight: 18.5,
        guaranteeMonths: 24,
      ),
      AdminProduct(
        id: 'prod_004',
        name: 'Filtro de Ar Fram',
        code: 'FA-FRA-001',
        description: 'Filtro de ar esportivo',
        longDescription:
            'Filtro de ar Fram com tecnologia de fluxo de ar otimizado. Aumenta a respirabilidade do motor e melhora seu desempenho.',
        price: 35.00,
        stock: 200,
        minStock: 30,
        imageUrl: 'https://via.placeholder.com/300?text=Filtro+Ar',
        category: ProductCategory.airFilter,
        status: ProductStatus.active,
        supplierId: 'sup_004',
        supplierName: 'Fram',
        rating: 4.6,
        reviewCount: 156,
        tags: ['filtro', 'ar', 'motor'],
        specifications: {
          'Tipo': 'Seco',
          'Diâmetro': '68mm',
          'Altura': '120mm',
          'Formato': 'Cilíndrico',
        },
        isNewProduct: true,
        createdAt: now.subtract(Duration(days: 5)),
        updatedAt: now,
        sku: 'FRA-AIR-001',
        barcode: '8717057000267',
        weight: 0.15,
        guaranteeMonths: 12,
      ),
    ];

    for (var product in mockProducts) {
      _products[product.id] = product;
    }
  }

  @override
  Future<List<AdminProduct>> getProducts({
    int? limit,
    int? offset,
    ProductCategory? category,
    ProductStatus? status,
  }) async {
    var result = _products.values.toList();

    if (category != null) {
      result = result.where((p) => p.category == category).toList();
    }

    if (status != null) {
      result = result.where((p) => p.status == status).toList();
    }

    result.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

    final start = offset ?? 0;
    final end = limit != null ? start + limit : result.length;

    return result.sublist(start, end.clamp(0, result.length));
  }

  @override
  Future<AdminProduct?> getProductById(String id) async {
    return _products[id];
  }

  @override
  Future<AdminProduct?> getProductByCode(String code) async {
    try {
      return _products.values.firstWhere((p) => p.code == code);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<AdminProduct> createProduct(AdminProduct product) async {
    // Simula delay de API
    await Future.delayed(const Duration(milliseconds: 500));

    final newProduct = product.copyWith(
      id: const Uuid().v4(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    _products[newProduct.id] = newProduct;
    return newProduct;
  }

  @override
  Future<AdminProduct> updateProduct(AdminProduct product) async {
    // Simula delay de API
    await Future.delayed(const Duration(milliseconds: 500));

    final updatedProduct = product.copyWith(
      updatedAt: DateTime.now(),
    );

    _products[product.id] = updatedProduct;
    return updatedProduct;
  }

  @override
  Future<void> deleteProduct(String id) async {
    // Simula delay de API
    await Future.delayed(const Duration(milliseconds: 500));
    _products.remove(id);
  }

  @override
  Future<List<AdminProduct>> searchProducts(String query) async {
    final lowerQuery = query.toLowerCase();
    return _products.values
        .where((p) =>
            p.name.toLowerCase().contains(lowerQuery) ||
            p.code.toLowerCase().contains(lowerQuery) ||
            p.description.toLowerCase().contains(lowerQuery))
        .toList();
  }

  @override
  Future<List<AdminProduct>> getProductsByCategory(
      ProductCategory category) async {
    return _products.values.where((p) => p.category == category).toList();
  }

  @override
  Future<List<AdminProduct>> getLowStockProducts() async {
    return _products.values
        .where((p) => p.stock <= p.minStock && p.status == ProductStatus.active)
        .toList();
  }

  @override
  Future<void> updateStock(String productId, int newStock) async {
    final product = _products[productId];
    if (product != null) {
      _products[productId] = product.copyWith(stock: newStock);
    }
  }

  @override
  Future<int> getTotalProductCount() async {
    return _products.length;
  }
}
