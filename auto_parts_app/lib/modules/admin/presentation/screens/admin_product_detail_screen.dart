import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/admin_product_provider.dart';
import '../../domain/entities/admin_product.dart';
import '../../domain/entities/product_category.dart';
import '../../../../core/theme/app_theme.dart';

class AdminProductDetailScreen extends ConsumerWidget {
  final String productId;

  const AdminProductDetailScreen({
    Key? key,
    required this.productId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productAsync = ref.watch(adminProductByIdProvider(productId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Produto'),
        elevation: 1,
        scrolledUnderElevation: 0,
        actions: [
          PopupMenuButton<String>(
            itemBuilder: (context) => [
              const PopupMenuItem<String>(
                child: Text('Editar'),
                value: 'edit',
              ),
              const PopupMenuDivider(),
              const PopupMenuItem<String>(
                child: Text('Deletar'),
                value: 'delete',
              ),
            ],
            onSelected: (value) {
              if (value == 'edit') {
                context.push('/admin/produto/$productId/editar');
              } else if (value == 'delete') {
                _showDeleteDialog(context, ref);
              }
            },
          ),
        ],
      ),
      body: productAsync.when(
        data: (product) {
          if (product == null) {
            return const Center(
              child: Text('Produto não encontrado'),
            );
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Imagem do produto
                Container(
                  width: double.infinity,
                  height: 300,
                  color: Colors.grey[100],
                  child: Image.network(
                    product.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Icon(
                          Icons.image_not_supported,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                      );
                    },
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Status badges
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: _getStatusColor(product.status),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              product.status.label,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          if (product.isLowStock)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.red[600],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                'Baixo Estoque',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Nome e código
                      Text(
                        product.name,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Código: ${product.code}',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Preços
                      Row(
                        children: [
                          if (product.hasPromotion) ...[
                            Text(
                              'R\$ ${product.price.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 14,
                                decoration: TextDecoration.lineThrough,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(width: 12),
                          ],
                          Text(
                            'R\$ ${product.finalPrice.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                          if (product.hasPromotion) ...[
                            const SizedBox(width: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green[600],
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                '-${product.discountPercentage.toStringAsFixed(0)}%',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Informações em cards
                      _buildInfoCard(
                        title: 'Estoque',
                        value: '${product.stock} unidades',
                        icon: Icons.inventory,
                        color: product.isLowStock ? Colors.red : Colors.green,
                      ),
                      const SizedBox(height: 8),
                      _buildInfoCard(
                        title: 'Estoque Mínimo',
                        value: '${product.minStock} unidades',
                        icon: Icons.warning_amber,
                        color: Colors.orange,
                      ),
                      const SizedBox(height: 8),
                      _buildInfoCard(
                        title: 'Categoria',
                        value: product.category.label,
                        icon: Icons.category,
                        color: Colors.blue,
                      ),
                      const SizedBox(height: 8),
                      _buildInfoCard(
                        title: 'Fornecedor',
                        value: product.supplierName,
                        icon: Icons.store,
                        color: Colors.purple,
                      ),
                      const SizedBox(height: 8),
                      _buildInfoCard(
                        title: 'Avaliação',
                        value:
                            '${product.rating} (${product.reviewCount} reviews)',
                        icon: Icons.star,
                        color: Colors.amber,
                      ),
                      const SizedBox(height: 24),

                      // Descrição
                      const Text(
                        'Descrição',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        product.description,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Descrição longa
                      const Text(
                        'Descrição Detalhada',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        product.longDescription,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Especificações
                      if (product.specifications.isNotEmpty) ...[
                        const Text(
                          'Especificações',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: product.specifications.entries
                                .mapIndexed((index, entry) {
                              return Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          entry.key,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          entry.value,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (index < product.specifications.length - 1)
                                    const Divider(height: 0),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],

                      // Tags
                      if (product.tags.isNotEmpty) ...[
                        const Text(
                          'Tags',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: product.tags.map((tag) {
                            return Chip(
                              label: Text(tag),
                              backgroundColor: Colors.blue[50],
                              side: BorderSide(color: Colors.blue[200]!),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 24),
                      ],

                      // Informações adicionais
                      const Text(
                        'Informações Adicionais',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildDetailRow(
                        'SKU',
                        product.sku ?? 'N/A',
                      ),
                      _buildDetailRow(
                        'Código de Barras',
                        product.barcode ?? 'N/A',
                      ),
                      _buildDetailRow(
                        'Peso',
                        product.weight != null ? '${product.weight} kg' : 'N/A',
                      ),
                      _buildDetailRow(
                        'Dimensões',
                        product.dimensions ?? 'N/A',
                      ),
                      _buildDetailRow(
                        'Garantia',
                        product.guaranteeMonths != null
                            ? '${product.guaranteeMonths} meses'
                            : 'N/A',
                      ),
                      const SizedBox(height: 8),

                      // Datas
                      const Divider(),
                      const SizedBox(height: 12),
                      _buildDetailRow(
                        'Criado em',
                        _formatDate(product.createdAt),
                      ),
                      _buildDetailRow(
                        'Atualizado em',
                        _formatDate(product.updatedAt),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 48,
                color: Colors.red[300],
              ),
              const SizedBox(height: 16),
              Text(
                'Erro ao carregar produto',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.red[600],
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ref.refresh(adminProductByIdProvider(productId));
                },
                child: const Text('Tentar novamente'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[200]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dateTime) {
    return '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year} às ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  Color _getStatusColor(ProductStatus status) {
    switch (status) {
      case ProductStatus.active:
        return Colors.green;
      case ProductStatus.inactive:
        return Colors.grey;
      case ProductStatus.draft:
        return Colors.orange;
      case ProductStatus.discontinued:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Deletar Produto'),
        content: const Text(
          'Você tem certeza que deseja deletar este produto?\nEsta ação não pode ser desfeita.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await ref
                    .read(adminProductFormProvider.notifier)
                    .deleteProduct(ref, productId);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Produto deletado com sucesso!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  context.go('/admin/produtos');
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Erro ao deletar: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Deletar'),
          ),
        ],
      ),
    );
  }
}

extension on Iterable {
  Iterable<T> mapIndexed<T>(T Function(int, dynamic) convert) {
    int i = 0;
    return map((e) => convert(i++, e));
  }
}
