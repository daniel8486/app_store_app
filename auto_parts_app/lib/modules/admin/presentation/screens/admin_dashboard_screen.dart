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
        elevation: 1,
        scrolledUnderElevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/admin/produto/novo');
        },
        tooltip: 'Novo Produto',
        child: const Icon(Icons.add),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Cards de Estatísticas
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Resumo Geral',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  consumerGridView(ref, totalAsync, lowStockAsync),
                  const SizedBox(height: 24),

                  // Produtos recentes
                  const Text(
                    'Produtos Recentes',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  productsAsync.when(
                    data: (products) {
                      if (products.isEmpty) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Text(
                              'Nenhum produto cadastrado',
                              style: TextStyle(
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                        );
                      }

                      return Column(
                        children: products.take(5).map((product) {
                          return _buildProductListItem(context, product);
                        }).toList(),
                      );
                    },
                    loading: () => const Center(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    error: (error, stack) => Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(
                          'Erro ao carregar produtos',
                          style: TextStyle(color: Colors.red[600]),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        context.push('/admin/produtos');
                      },
                      child: const Text('Ver Todos os Produtos'),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Produtos com baixo estoque
                  const Text(
                    'Produtos com Baixo Estoque',
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
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.check_circle,
                                color: Colors.green[600],
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Todos os produtos têm estoque adequado!',
                                style: TextStyle(
                                  color: Colors.green[700],
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return Column(
                        children: products.map((product) {
                          return _buildLowStockItem(context, product);
                        }).toList(),
                      );
                    },
                    loading: () => const Center(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    error: (error, stack) => Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(
                          'Erro ao carregar produtos',
                          style: TextStyle(color: Colors.red[600]),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget consumerGridView(
    WidgetRef ref,
    AsyncValue<int> totalAsync,
    AsyncValue<List<AdminProduct>> lowStockAsync,
  ) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.2,
      children: [
        totalAsync.when(
          data: (total) => _buildStatCard(
            title: 'Total de Produtos',
            value: total.toString(),
            icon: Icons.shopping_bag,
            color: Colors.blue,
            onTap: () {},
          ),
          loading: () => _buildStatCard(
            title: 'Total de Produtos',
            value: '...',
            icon: Icons.shopping_bag,
            color: Colors.blue,
            onTap: () {},
          ),
          error: (error, stack) => _buildStatCard(
            title: 'Total de Produtos',
            value: '0',
            icon: Icons.shopping_bag,
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
            onTap: () {},
          ),
          loading: () => _buildStatCard(
            title: 'Baixo Estoque',
            value: '...',
            icon: Icons.warning_amber,
            color: Colors.orange,
            onTap: () {},
          ),
          error: (error, stack) => _buildStatCard(
            title: 'Baixo Estoque',
            value: '0',
            icon: Icons.warning_amber,
            color: Colors.orange,
            onTap: () {},
          ),
        ),
      ],
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
          color: color.withOpacity(0.1),
          border: Border.all(color: color.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductListItem(BuildContext context, AdminProduct product) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () {
          context.push('/admin/produto/${product.id}');
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[200]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: Colors.grey[100],
                ),
                child: Image.network(
                  product.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.image_not_supported,
                      color: Colors.grey[400],
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'R\$ ${product.finalPrice.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  border: Border.all(color: Colors.blue[200]!),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  product.status.label,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLowStockItem(BuildContext context, AdminProduct product) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.red[200]!),
          borderRadius: BorderRadius.circular(8),
          color: Colors.red[50],
        ),
        child: Row(
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: Colors.red[600],
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Estoque: ${product.stock}/${product.minStock}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.red[600],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            TextButton(
              onPressed: () {
                context.push('/admin/produto/${product.id}/editar');
              },
              child: const Text('Editar'),
            ),
          ],
        ),
      ),
    );
  }
}
