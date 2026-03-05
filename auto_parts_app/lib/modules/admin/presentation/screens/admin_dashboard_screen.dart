import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/admin_product_provider.dart';
import '../../domain/entities/admin_product.dart';
import '../../../../core/theme/app_theme.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
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
            // HEADER
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
              child: Row(
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
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bem-vindo ao Painel',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Controle total da sua plataforma',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // KPIs
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
                        data: (total) => _buildStatCard(
                          'Produtos',
                          total.toString(),
                          Icons.inventory_2,
                          Colors.blue,
                          '+12%',
                          () => context.push('/admin/produtos'),
                        ),
                        loading: () => _buildStatCard(
                          'Produtos',
                          '-',
                          Icons.inventory_2,
                          Colors.blue,
                          null,
                          () {},
                        ),
                        error: (_, __) => _buildStatCard(
                          'Produtos',
                          '0',
                          Icons.inventory_2,
                          Colors.blue,
                          null,
                          () {},
                        ),
                      ),
                      lowStockAsync.when(
                        data: (products) => _buildStatCard(
                          'Atenção',
                          products.length.toString(),
                          Icons.warning,
                          Colors.red,
                          products.isEmpty ? 'OK' : 'Crítico',
                          () => context.push('/admin/produtos'),
                        ),
                        loading: () => _buildStatCard(
                          'Atenção',
                          '-',
                          Icons.warning,
                          Colors.red,
                          null,
                          () {},
                        ),
                        error: (_, __) => _buildStatCard(
                          'Atenção',
                          '0',
                          Icons.warning,
                          Colors.red,
                          null,
                          () {},
                        ),
                      ),
                      _buildStatCard(
                        'Usuários',
                        '248',
                        Icons.people,
                        Colors.purple,
                        '+8%',
                        () {},
                      ),
                      _buildStatCard(
                        'Faturamento',
                        'R\$ 8.5K',
                        Icons.trending_up,
                        Colors.green,
                        '+24%',
                        () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Módulos
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
                      _buildModuleCard(
                          context,
                          'Produtos',
                          'Catálogo',
                          Icons.shopping_bag,
                          Colors.blue,
                          () => context.push('/admin/produtos')),
                      _buildModuleCard(context, 'Usuários', 'Clientes',
                          Icons.people, Colors.purple, () {}),
                      _buildModuleCard(
                          context,
                          'Vendedores',
                          'Lojistas',
                          Icons.store,
                          Colors.teal,
                          () => context.push('/seller/dashboard')),
                      _buildModuleCard(
                          context,
                          'Pedidos',
                          'Vendas',
                          Icons.receipt_long,
                          Colors.indigo,
                          () => context.push('/orders')),
                      _buildModuleCard(
                          context,
                          'Pagamentos',
                          'Transações',
                          Icons.payment,
                          Colors.green,
                          () => context.push('/payment')),
                      _buildModuleCard(
                          context,
                          'Promoções',
                          'Cupons',
                          Icons.local_offer,
                          Colors.red,
                          () => context.push('/coupons')),
                      _buildModuleCard(context, 'Entregas', 'Logística',
                          Icons.local_shipping, Colors.orange, () {}),
                      _buildModuleCard(context, 'Avaliações', 'Reviews',
                          Icons.star, Colors.amber, () {}),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Alertas
                  _buildAlertsSection(context, lowStockAsync),
                  const SizedBox(height: 32),

                  // Botões
                  const Text('Ações Rápidas',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.3)),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: () => context.push('/admin/produto/novo'),
                      icon: const Icon(Icons.add),
                      label: const Text('Cadastrar Novo Produto',
                          style: TextStyle(fontWeight: FontWeight.w600)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.accentColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: OutlinedButton.icon(
                      onPressed: () => context.push('/admin/produtos'),
                      icon: const Icon(Icons.list),
                      label: const Text('Gerenciar Produtos',
                          style: TextStyle(fontWeight: FontWeight.w600)),
                      style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
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

  Widget _buildStatCard(String title, String value, IconData icon, Color color,
      String? trend, VoidCallback onTap) {
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
                offset: const Offset(0, 2))
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
                      borderRadius: BorderRadius.circular(10)),
                  child: Icon(icon, color: color, size: 22),
                ),
                if (trend != null)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                        color: color.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(6)),
                    child: Text(trend,
                        style: TextStyle(
                            color: color,
                            fontSize: 10,
                            fontWeight: FontWeight.bold)),
                  ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(title,
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModuleCard(BuildContext context, String label, String subtitle,
      IconData icon, Color color, VoidCallback onTap) {
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
                offset: const Offset(0, 2))
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
                  borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: color, size: 24),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(height: 2),
                Text(subtitle,
                    style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 11,
                        fontWeight: FontWeight.w500)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertsSection(
      BuildContext context, AsyncValue<List<AdminProduct>> lowStockAsync) {
    return Container(
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
                    borderRadius: BorderRadius.circular(8)),
                child: Icon(Icons.warning, color: Colors.red[600], size: 20),
              ),
              const SizedBox(width: 12),
              const Expanded(
                  child: Text('Produtos com Baixo Estoque',
                      style: TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold))),
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
                    border: Border.all(color: Colors.green[200]!),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle,
                          color: Colors.green[600], size: 20),
                      const SizedBox(width: 10),
                      const Expanded(
                          child: Text('Nenhum produto com estoque crítico',
                              style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13))),
                    ],
                  ),
                );
              }
              return Column(
                children: products.take(3).map((product) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.red[200]!),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(product.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12)),
                              const SizedBox(height: 4),
                              Text(
                                  'Estoque: ${product.stock}/${product.minStock}',
                                  style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.red[600],
                                      fontWeight: FontWeight.w500)),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () => context
                              .push('/admin/produto/${product.id}/editar'),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                                color: AppTheme.accentColor,
                                borderRadius: BorderRadius.circular(6)),
                            child: const Text('Repor',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
