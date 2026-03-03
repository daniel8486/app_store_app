import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/seller_provider.dart';
import '../../../../core/theme/app_theme.dart';
import 'seller_dashboard_page.dart';
import 'seller_orders_screen.dart';
import 'seller_inventory_screen.dart';
import 'seller_profile_screen.dart';

class SellerMainScreen extends ConsumerStatefulWidget {
  const SellerMainScreen({super.key});

  @override
  ConsumerState<SellerMainScreen> createState() => _SellerMainScreenState();
}

class _SellerMainScreenState extends ConsumerState<SellerMainScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      const SellerDashboardPage(),
      const SellerOrdersScreen(embedded: true),
      const SellerInventoryScreen(),
      const SellerProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Painel do Lojista'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sair',
            onPressed: () {
              ref.read(sellerIsLoggedInProvider.notifier).state = false;
              context.go('/login');
            },
          ),
        ],
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: _buildSellerBottomNav(),
    );
  }

  Widget _buildSellerBottomNav() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 0, 25, 30),
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          color: const Color(0xFF0D1B2A),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _navItem(Icons.dashboard, _selectedIndex == 0, 'Dashboard',
                onTap: () {
              setState(() => _selectedIndex = 0);
            }),
            _navItem(Icons.receipt_long, _selectedIndex == 1, 'Pedidos',
                onTap: () {
              setState(() => _selectedIndex = 1);
            }),
            _navItem(Icons.inventory_2, _selectedIndex == 2, 'Estoque',
                onTap: () {
              setState(() => _selectedIndex = 2);
            }),
            _navItem(Icons.person, _selectedIndex == 3, 'Perfil', onTap: () {
              setState(() => _selectedIndex = 3);
            }),
          ],
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, bool isActive, String label,
      {required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isActive
                ? const Color(0xFFF3722C)
                : Colors.white.withOpacity(0.4),
            size: 24,
          ),
          if (isActive)
            Container(
              margin: const EdgeInsets.only(top: 4),
              height: 3,
              width: 3,
              decoration: const BoxDecoration(
                color: Color(0xFFF3722C),
                shape: BoxShape.circle,
              ),
            )
        ],
      ),
    );
  }
}
