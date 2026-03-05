import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/admin_product_provider.dart';
import '../../domain/entities/admin_product.dart';
import '../../domain/entities/product_category.dart';
import '../../../../core/theme/app_theme.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(adminFilteredProductsProvider);
    final totalAsync = ref.watch(adminTotalProductCountProvider);
    final lowStockAsync = ref.watch(adminLowStockProductsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Painel Administrativo'),
        elevation: 0,
        scrolledUnderElevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.admin_panel_settings,
                      size: 16,
                      color: AppTheme.primaryColor,
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      'Administrador',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // HEADER PREMIUM
            Container(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.primaryColor,
                    AppTheme.primaryColor.withOpacity(0.85),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.dashboard,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Bem-vindo ao Painel',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Controle total da sua plataforma',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.85),
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // SEÇÃO 1: KPIs Principais em Cards Destacados
                  const Text(
                    'Indicadores Principais',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 16),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.9,
                    children: [
                      totalAsync.when(
                        data: (total) => _buildPremiumStatCard(
                          context,
                          title: 'Total de Produtos',
                          value: total.toString(),
                          icon: Icons.inventory_2_outlined,
                          color: Colors.blue,
                          trend: '+12%',
                          onTap: () => context.push('/admin/produtos'),
                        ),
                        loading: () => _buildPremiumStatCard(
                          context,
                          title: 'Total de Produtos',
                          value: '...',
                          icon: Icons.inventory_2_outlined,
                          color: Colors.blue,
                          onTap: () {},
                        ),
                        error: (_, __) => _buildPremiumStatCard(
                          context,
                          title: 'Total de Produtos',
                          value: '0',
                          icon: Icons.inventory_2_outlined,
                          color: Colors.blue,
                          onTap: () {},
                        ),
                      ),
                      lowStockAsync.when(
                        data: (products) => _buildPremiumStatCard(
                          context,
                          title: 'Atenção Necessária',
                          value: products.length.toString(),
                          icon: Icons.priority_high,
                          color: Colors.red,
                          trend: products.isEmpty ? 'OK' : 'Crítico',
                          onTap: () => context.push('/admin/produtos'),
                        ),
                        loading: () => _buildPremiumStatCard(
                          context,
                          title: 'Atenção Necessária',
                          value: '...',
                          icon: Icons.priority_high,
                          color: Colors.red,
                          onTap: () {},
                        ),
                        error: (_, __) => _buildPremiumStatCard(
                          context,
                          title: 'Atenção Necessária',
                          value: '0',
                          icon: Icons.priority_high,
                          color: Colors.red,
                          onTap: () {},
                        ),
                      ),
                      _buildPremiumStatCard(
                        context,
                        title: 'Usuários Ativos',
                        value: '248',
                        icon: Icons.people_outline,
                        color: Colors.purple,
                        trend: '+8%',
                        onTap: () {},
                      ),
                      _buildPremiumStatCard(
                        context,
                        title: 'Faturamento',
                        value: 'R\$ 8.5K',
                        icon: Icons.trending_up,
                        color: Colors.green,
                        trend: '+24%',
                        onTap: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // SEÇÃO 2: Módulos do Sistema em Grid Premium
                  const Text(
                    'Módulos do Sistema',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 16),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                    childAspectRatio: 1,
                    children: [
                      _buildModulePremiumCard(
                        context,
                        icon: Icons.shopping_bag_outlined,
                        label: 'Produtos',
                        subtitle: 'Catálogo',
                        color: Colors.blue,
                        onTap: () => context.push('/admin/produtos'),
                      ),
                      _buildModulePremiumCard(
                        context,
                        icon: Icons.people_outline,
                        label: 'Usuários',
                        subtitle: 'Clientes',
                        color: Colors.purple,
                        onTap: () {},
                      ),
                      _buildModulePremiumCard(
                        context,
                        icon: Icons.store_outlined,
                        label: 'Vendedores',
                        subtitle: 'Lojistas',
                        color: Colors.teal,
                        onTap: () => context.push('/seller/dashboard'),
                      ),
                      _buildModulePremiumCard(
                        context,
                        icon: Icons.receipt_long_outlined,
                        label: 'Pedidos',
                        subtitle: 'Vendas',
                        color: Colors.indigo,
                        onTap: () => context.push('/orders'),
                      ),
                      _buildModulePremiumCard(
                        context,
                        icon: Icons.payment_outlined,
                        label: 'Pagamentos',
                        subtitle: 'Transações',
                        color: Colors.green,
                        onTap: () => context.push('/payment'),
                      ),
                      _buildModulePremiumCard(
                        context,
                        icon: Icons.local_offer_outlined,
                        label: 'Promoções',
                        subtitle: 'Cupons',
                        color: Colors.red,
                        onTap: () => context.push('/coupons'),
                      ),
                      _buildModulePremiumCard(
                        context,
                        icon: Icons.local_shipping_outlined,
                        label: 'Entregas',
                        subtitle: 'Logística',
                        color: Colors.orange,
                        onTap: () {},
                      ),
                      _buildModulePremiumCard(
                        context,
                        icon: Icons.star_outline,
                        label: 'Reviews',
                        subtitle: 'Avaliações',
                        color: Colors.amber,
                        onTap: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // SEÇÃO 3: Alertas de Estoque
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.warning_amber_rounded,
                                color: Colors.red[600],
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Text(
                                'Produtos com Baixo Estoque',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        lowStockAsync.when(
                          data: (products) {
                            if (products.isEmpty) {
                              return Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.green[50],
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Colors.green[200]!,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.check_circle,
                                      color: Colors.green[600],
                                      size: 20,
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        'Nenhum produto com estoque crítico',
                                        style: TextStyle(
                                          color: Colors.green[700],
                                          fontWeight: FontWeight.w500,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }

                            return Column(
                              children: products.take(3).map((product) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.red[50],
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: Colors.red[200]!,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                product.name,
                                                maxLines: 1,
                                                overflow:
                                                    TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                'Estoque: ${product.stock}/${product.minStock}',
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  color: Colors.red[600],
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        GestureDetector(
                                          onTap: () => context.push(
                                              '/admin/produto/${product.id}/editar'),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 6,
                                            ),
                                            decoration: BoxDecoration(
                                              color: AppTheme.accentColor,
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            child: const Text(
                                              'Repor',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            );
                          },
                          loading: () => const Center(
                            child: CircularProgressIndicator(),
                          ),
                          error: (_, __) => const SizedBox.shrink(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // SEÇÃO 4: Ações Rápidas
                  const Text(
                    'Ações Rápidas',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: () => context.push('/admin/produto/novo'),
                      icon: const Icon(Icons.add_rounded),
                      label: const Text(
                        'Cadastrar Novo Produto',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.accentColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: OutlinedButton.icon(
                      onPressed: () => context.push('/admin/produtos'),
                      icon: const Icon(Icons.list_rounded),
                      label: const Text(
                        'Gerenciar Produtos',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPremiumStatCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    String? trend,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(color: Colors.grey[200]!),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: color, size: 22),
                ),
                if (trend != null)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      trend,
                      style: TextStyle(
                        color: color,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModulePremiumCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(color: Colors.grey[200]!),
        ),
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
                          title: 'Produtos',
                          value: '0',
                          icon: Icons.inventory_2,
                          color: Colors.blue,
                          onTap: () {},
                        ),
                      ),
                      lowStockAsync.when(
                        data: (products) => _buildStatCard(
                          title: 'Baixo Estoque',
                          value: products.length.toString(),
                          icon: Icons.warning_amber,
                          color: Colors.orange,
                          onTap: () => context.push('/admin/produtos'),
                        ),
                        loading: () => _buildStatCard(
                          title: 'Baixo Estoque',
                          value: '-',
                          icon: Icons.warning_amber,
                          color: Colors.orange,
                          onTap: () {},
                        ),
                        error: (_, __) => _buildStatCard(
                          title: 'Baixo Estoque',
                          value: '0',
                          icon: Icons.warning_amber,
                          color: Colors.orange,
                          onTap: () {},
                        ),
                      ),
                      _buildStatCard(
                        title: 'Usuários',
                        value: '248',
                        icon: Icons.people,
                        color: Colors.purple,
                        onTap: () {},
                      ),
                      _buildStatCard(
                        title: 'Vendedores',
                        value: '12',
                        icon: Icons.store,
                        color: Colors.teal,
                        onTap: () => context.push('/seller/dashboard'),
                      ),
                      _buildStatCard(
                        title: 'Pedidos',
                        value: '156',
                        icon: Icons.receipt,
                        color: Colors.indigo,
                        onTap: () => context.push('/orders'),
                      ),
                      _buildStatCard(
                        title: 'Faturamento',
                        value: 'R\$ 8.5K',
                        icon: Icons.trending_up,
                        color: Colors.green,
                        onTap: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // SEÇÃO 2: Módulos do Sistema
                  const Text(
                    'Módulos do Sistema',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.1,
                    children: [
                      _buildModuleCard(
                        context,
                        icon: Icons.shopping_bag,
                        label: 'Produtos',
                        subtitle: 'Gerenciar catálogo',
                        color: Colors.blue,
                        onTap: () => context.push('/admin/produtos'),
                      ),
                      _buildModuleCard(
                        context,
                        icon: Icons.people,
                        label: 'Usuários',
                        subtitle: 'Clientes registrados',
                        color: Colors.purple,
                        onTap: () {},
                      ),
                      _buildModuleCard(
                        context,
                        icon: Icons.store,
                        label: 'Vendedores',
                        subtitle: 'Gerenciar lojistas',
                        color: Colors.teal,
                        onTap: () => context.push('/seller/dashboard'),
                      ),
                      _buildModuleCard(
                        context,
                        icon: Icons.receipt_long,
                        label: 'Pedidos',
                        subtitle: 'Histórico de vendas',
                        color: Colors.indigo,
                        onTap: () => context.push('/orders'),
                      ),
                      _buildModuleCard(
                        context,
                        icon: Icons.payment,
                        label: 'Pagamentos',
                        subtitle: 'Transações',
                        color: Colors.green,
                        onTap: () => context.push('/payment'),
                      ),
                      _buildModuleCard(
                        context,
                        icon: Icons.discount,
                        label: 'Cupons',
                        subtitle: 'Promoções',
                        color: Colors.red,
                        onTap: () => context.push('/coupons'),
                      ),
                      _buildModuleCard(
                        context,
                        icon: Icons.local_shipping,
                        label: 'Entregas',
                        subtitle: 'Rastreamento',
                        color: Colors.orange,
                        onTap: () {},
                      ),
                      _buildModuleCard(
                        context,
                        icon: Icons.star,
                        label: 'Avaliações',
                        subtitle: 'Reviews dos produtos',
                        color: Colors.amber,
                        onTap: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // SEÇÃO 3: Alertas Importantes
                  const Text(
                    'Alertas Importantes',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  lowStockAsync.when(
                    data: (products) {
                      if (products.isEmpty) {
                        return Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.green[50],
                            border: Border.all(color: Colors.green[200]!),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.check_circle,
                                color: Colors.green[600],
                                size: 28,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Situação Normal',
                                      style: TextStyle(
                                        color: Colors.green[700],
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Todos os produtos têm estoque adequado',
                                      style: TextStyle(
                                        color: Colors.green[600],
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: products.take(3).map((product) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.red[200]!,
                                ),
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.red[50],
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.warning_amber_rounded,
                                    color: Colors.red[600],
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          product.name,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          'Estoque: ${product.stock}/${product.minStock} unidades',
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.red[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  GestureDetector(
                                    onTap: () => context.push(
                                        '/admin/produto/${product.id}/editar'),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppTheme.accentColor,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: const Text(
                                        'Repor',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    },
                    loading: () => const Center(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    error: (_, __) => const SizedBox.shrink(),
                  ),
                  const SizedBox(height: 32),

                  // SEÇÃO 4: Atalhos Rápidos
                  const Text(
                    'Ações Rápidas',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => context.push('/admin/produto/novo'),
                      icon: const Icon(Icons.add),
                      label: const Text('Cadastrar Novo Produto'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.accentColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => context.push('/admin/produtos'),
                      icon: const Icon(Icons.list),
                      label: const Text('Gerenciar Produtos'),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          border: Border.all(color: color.withOpacity(0.2)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModuleCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey[200]!),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          children: [
            Positioned(
              top: -10,
              right: -10,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(icon, color: color, size: 24),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
