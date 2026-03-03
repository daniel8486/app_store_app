import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../modules/auth/presentation/providers/auth_provider.dart';
import '../../modules/auth/presentation/screens/splash_screen.dart';
import '../../modules/auth/presentation/screens/login_screen.dart';
import '../../modules/auth/presentation/screens/register_screen.dart';
import '../../modules/auth/presentation/screens/profile_edit_screen.dart';
import '../../modules/auth/presentation/screens/change_password_screen.dart';
import '../../modules/catalog/domain/entities/product.dart';
import '../../modules/catalog/presentation/screens/home_screen.dart';
import '../../modules/catalog/presentation/screens/part_detail_screen.dart';
import '../../modules/catalog/presentation/screens/product_detail_screen.dart';
import '../../modules/catalog/presentation/providers/catalog_provider.dart';
import '../../modules/cart/presentation/screens/cart_screen.dart';
import '../../modules/order/presentation/screens/order_list_screen.dart';
import '../../modules/order/presentation/screens/order_detail_screen.dart';
import '../../modules/payment/presentation/screens/payment_screen.dart';
import '../../modules/payment/presentation/screens/payment_success_screen.dart';
import '../../modules/delivery/presentation/screens/tracking_screen.dart';
import '../../modules/seller/presentation/screens/seller_login_screen.dart';
import '../../modules/seller/presentation/screens/seller_main_screen.dart';
import '../../modules/seller/presentation/screens/seller_orders_screen.dart';
import '../../modules/seller/presentation/screens/seller_order_detail_screen.dart';
import '../../modules/seller/presentation/screens/seller_inventory_screen.dart';
import '../../modules/address/presentation/screens/address_list_screen.dart';
import '../../modules/address/presentation/screens/address_form_screen.dart';
import '../../modules/address/domain/entities/address.dart';
import '../../modules/favorites/presentation/screens/favorites_screen.dart';
import '../../modules/garage/presentation/screens/garage_screen.dart';
import '../../modules/seller/presentation/screens/seller_financial_screen.dart';
import '../../modules/seller/presentation/screens/seller_reviews_screen.dart';
import '../../modules/seller/presentation/screens/seller_reports_screen.dart';
import '../../modules/seller/presentation/screens/seller_coupons_screen.dart';
import '../../modules/review/presentation/screens/product_reviews_screen.dart';
import '../../modules/coupon/presentation/screens/coupons_screen.dart';
import '../../modules/settings/presentation/screens/settings_screen.dart';

/// Notifica o GoRouter quando o estado de auth muda — sem recriar o router.
class _RouterRefreshNotifier extends ChangeNotifier {
  late final ProviderSubscription<AsyncValue<dynamic>> _sub;

  _RouterRefreshNotifier(Ref ref) {
    _sub = ref.listen<AsyncValue<dynamic>>(
      currentUserProvider,
      (_, __) => notifyListeners(),
    );
  }

  @override
  void dispose() {
    _sub.close();
    super.dispose();
  }
}

final appRouterProvider = Provider<GoRouter>((ref) {
  final notifier = _RouterRefreshNotifier(ref);

  final router = GoRouter(
    initialLocation: '/splash',
    refreshListenable: notifier,
    redirect: (context, state) {
      final authAsync = ref.read(currentUserProvider);

      if (authAsync.isLoading) return null;

      final isLoggedIn = authAsync.value != null;
      final path = state.matchedLocation;

      const protectedPaths = ['/payment', '/orders', '/profile'];
      final isProtected = protectedPaths.any((p) => path.startsWith(p));
      if (isProtected && !isLoggedIn) return '/login';

      return null;
    },
    routes: [
      GoRoute(path: '/splash', builder: (_, __) => const SplashScreen()),
      GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
      GoRoute(path: '/register', builder: (_, __) => const RegisterScreen()),
      GoRoute(path: '/home', builder: (_, __) => const HomeScreen()),
      GoRoute(
        path: '/part/:id',
        builder: (_, state) =>
            PartDetailScreen(partId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/product/:id',
        builder: (_, state) {
          final productId = state.pathParameters['id']!;
          return _ProductDetailWrapper(productId: productId);
        },
      ),
      GoRoute(path: '/cart', builder: (_, __) => const CartScreen()),
      GoRoute(path: '/payment', builder: (_, __) => const PaymentScreen()),
      GoRoute(
        path: '/payment/success',
        builder: (_, state) =>
            PaymentSuccessScreen(orderId: (state.extra as String?) ?? ''),
      ),
      GoRoute(path: '/orders', builder: (_, __) => const OrderListScreen()),
      GoRoute(
        path: '/orders/:id',
        builder: (_, state) =>
            OrderDetailScreen(orderId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/tracking/:id',
        builder: (_, state) =>
            TrackingScreen(orderId: state.pathParameters['id']!),
      ),
      // ── Profile routes ────────────────────────────────────────────
      GoRoute(
          path: '/profile/edit', builder: (_, __) => const ProfileEditScreen()),
      GoRoute(
          path: '/profile/password',
          builder: (_, __) => const ChangePasswordScreen()),
      GoRoute(
          path: '/profile/addresses',
          builder: (_, __) => const AddressListScreen()),
      GoRoute(
        path: '/profile/addresses/new',
        builder: (_, __) => const AddressFormScreen(),
      ),
      GoRoute(
        path: '/profile/addresses/edit',
        builder: (_, state) =>
            AddressFormScreen(existing: state.extra as Address?),
      ),
      GoRoute(
          path: '/profile/favorites',
          builder: (_, __) => const FavoritesScreen()),
      GoRoute(
          path: '/profile/garage', builder: (_, __) => const GarageScreen()),
      GoRoute(
        path: '/product/:id/reviews',
        builder: (_, state) {
          final productId = state.pathParameters['id']!;
          final productName = (state.extra as String?) ?? 'Produto';
          return ProductReviewsScreen(
            productId: productId,
            productName: productName,
          );
        },
      ),
      GoRoute(path: '/coupons', builder: (_, __) => const CouponsScreen()),
      GoRoute(
          path: '/profile/settings',
          builder: (_, __) => const SettingsScreen()),
      // ── Seller routes ─────────────────────────────────────────────
      GoRoute(
          path: '/seller/login', builder: (_, __) => const SellerLoginScreen()),
      GoRoute(
          path: '/seller/dashboard',
          builder: (_, __) => const SellerMainScreen()),
      GoRoute(
          path: '/seller/inventory',
          builder: (_, __) => const SellerInventoryScreen()),
      GoRoute(
          path: '/seller/orders',
          builder: (_, __) => const SellerOrdersScreen()),
      GoRoute(
        path: '/seller/orders/:id',
        builder: (_, state) =>
            SellerOrderDetailScreen(orderId: state.pathParameters['id']!),
      ),
      GoRoute(
          path: '/seller/financial',
          builder: (_, __) => const SellerFinancialScreen()),
      GoRoute(
          path: '/seller/reviews',
          builder: (_, __) => const SellerReviewsScreen()),
      GoRoute(
          path: '/seller/reports',
          builder: (_, __) => const SellerReportsScreen()),
      GoRoute(
          path: '/seller/coupons',
          builder: (_, __) => const SellerCouponsScreen()),
    ],
    errorBuilder: (_, state) => Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Color(0xFFF3722C)),
            const SizedBox(height: 16),
            const Text(
              'Rota não encontrada',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ],
        ),
      ),
    ),
  );

  ref.onDispose(notifier.dispose);
  return router;
});

/// Wrapper que busca o Product usando o provider baseado no ID
class _ProductDetailWrapper extends ConsumerWidget {
  final String productId;

  const _ProductDetailWrapper({required this.productId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final product = ref.watch(productByIdProvider(productId));

    if (product == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(
          child: Text('Produto não encontrado'),
        ),
      );
    }

    return ProductDetailScreen(product: product);
  }
}
