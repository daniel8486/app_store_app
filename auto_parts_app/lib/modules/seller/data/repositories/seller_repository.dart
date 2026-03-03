import '../../../order/data/repositories/order_repository.dart';
import '../../../order/domain/entities/order.dart';
import '../../domain/entities/seller_product.dart';
import '../../domain/entities/seller_coupon.dart';

class SellerRepository {
  final OrderRepository _orderRepository;

  SellerRepository(this._orderRepository);

  Future<List<AppOrder>> getAllOrders() async {
    return _orderRepository.getAllOrders();
  }

  Future<void> updateOrderStatus(String orderId, OrderStatus status) async {
    await _orderRepository.updateStatus(orderId, status);
  }

  Future<Map<String, dynamic>> getDashboardStats() async {
    final orders = await getAllOrders();
    final totalOrders = orders.length;
    final totalRevenue = orders.fold<double>(0, (sum, o) => sum + o.total);

    // Find best-selling part
    final partSales = <String, int>{};
    for (final order in orders) {
      for (final item in order.items) {
        partSales[item.partName] =
            (partSales[item.partName] ?? 0) + item.quantity;
      }
    }

    String bestSellingPart = '-';
    int bestCount = 0;
    partSales.forEach((part, count) {
      if (count > bestCount) {
        bestCount = count;
        bestSellingPart = part;
      }
    });

    return {
      'totalOrders': totalOrders,
      'totalRevenue': totalRevenue,
      'bestSellingPart': bestSellingPart,
      'bestSellingCount': bestCount,
      'totalProducts': 12,
      'avgRating': 4.7,
    };
  }

  Future<List<Map<String, dynamic>>> getInventory() async {
    // Mock inventory data
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      {
        'id': 'inv001',
        'name': 'Pastilha de Freio Dianteira',
        'code': 'TYC-001',
        'price': 189.90,
        'stock': 15,
        'imageUrl': 'https://picsum.photos/seed/p001/100/100',
        'category': 'Freios',
      },
      {
        'id': 'inv002',
        'name': 'Disco de Freio Dianteiro',
        'code': 'TYC-002',
        'price': 320.00,
        'stock': 8,
        'imageUrl': 'https://picsum.photos/seed/p002/100/100',
        'category': 'Freios',
      },
      {
        'id': 'inv003',
        'name': 'Amortecedor Dianteiro',
        'code': 'TYC-003',
        'price': 450.00,
        'stock': 0,
        'imageUrl': 'https://picsum.photos/seed/p003/100/100',
        'category': 'Suspensão',
      },
      {
        'id': 'inv004',
        'name': 'Filtro de Óleo',
        'code': 'TYC-004',
        'price': 45.00,
        'stock': 50,
        'imageUrl': 'https://picsum.photos/seed/p004/100/100',
        'category': 'Filtros',
      },
    ];
  }

  Future<Map<String, dynamic>> getSellerProfile() async {
    // Mock seller profile data
    await Future.delayed(const Duration(milliseconds: 300));
    return {
      'id': 'seller_test',
      'name': 'Loja AutoPeças',
      'email': 'loja@autopecas.com',
      'phone': '(11) 98888-7777',
      'cnpj': '98.765.432/0001-00',
      'description':
          'Somos especializados em peças automotivas de alta qualidade',
      'logo': 'https://picsum.photos/seed/store/100/100',
      'isActive': true,
    };
  }

  // ── CRUD de Produtos ────────────────────────────────────
  Future<SellerProduct> createProduct(SellerProduct product) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Em um app real, isso salvaria no banco/API
    return product;
  }

  Future<SellerProduct> updateProduct(SellerProduct product) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return product.copyWith(updatedAt: DateTime.now());
  }

  Future<void> deleteProduct(String productId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Em um app real, isso deletaria do banco/API
  }

  Future<SellerProduct?> getProductById(String productId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final inventory = await getInventory();
    final item = inventory.firstWhere(
      (p) => p['id'] == productId,
      orElse: () => <String, dynamic>{},
    );

    if (item.isEmpty) return null;

    return SellerProduct(
      id: item['id'] as String,
      name: item['name'] as String,
      sku: item['code'] as String,
      imageUrl: item['imageUrl'] as String,
      price: item['price'] as double,
      stock: item['stock'] as int,
      category: item['category'] as String,
      description: item['name'] as String,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      updatedAt: DateTime.now(),
    );
  }

  Future<void> updateStock(String productId, int newStock) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Em um app real, atualizaria o estoque no banco/API
  }

  // ── CRUD de Cupons ──────────────────────────────────────
  Future<SellerCoupon> createCoupon(SellerCoupon coupon) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return coupon;
  }

  Future<SellerCoupon> updateCoupon(SellerCoupon coupon) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return coupon;
  }

  Future<void> deleteCoupon(String couponId) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<List<SellerCoupon>> getSellerCoupons() async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Mock coupons
    return [
      SellerCoupon(
        id: '1',
        code: 'LOJA10',
        description: 'Desconto de 10% em primeira compra',
        discountValue: 10,
        discountType: DiscountType.percentage,
        minOrderValue: 50,
        expiryDate: DateTime.now().add(const Duration(days: 30)),
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        usedCount: 23,
        isActive: true,
      ),
      SellerCoupon(
        id: '2',
        code: 'FRETE30',
        description: 'R\$ 30 de desconto no frete',
        discountValue: 30,
        discountType: DiscountType.fixed,
        minOrderValue: 100,
        expiryDate: DateTime.now().add(const Duration(days: 15)),
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
        usedCount: 45,
        isActive: true,
      ),
    ];
  }
}
