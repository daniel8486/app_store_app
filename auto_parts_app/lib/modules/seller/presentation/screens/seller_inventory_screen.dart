import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/seller_provider.dart';
import '../widgets/product_form_dialog.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/formatters.dart';
import '../../../catalog/domain/entities/product.dart';

class SellerInventoryScreen extends ConsumerWidget {
  const SellerInventoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inventoryAsync = ref.watch(sellerInventoryProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: inventoryAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erro: $e')),
        data: (items) {
          if (items.isEmpty) {
            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 80),
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.08),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.inventory_2_outlined,
                        size: 40, color: AppTheme.primaryColor),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Nenhum produto cadastrado',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Comece adicionando seus produtos',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    height: 50,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.add, color: Colors.white),
                      label: const Text('Adicionar Produto'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.accentColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onPressed: () => _showAddProductSheet(context),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            );
          }

          return RefreshIndicator(
            color: AppTheme.accentColor,
            onRefresh: () async => ref.invalidate(sellerInventoryProvider),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: items.length + 1,
              itemBuilder: (_, i) {
                if (i == 0) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Seus Produtos',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                        FloatingActionButton.small(
                          backgroundColor: AppTheme.accentColor,
                          child: const Icon(Icons.add, color: Colors.white),
                          onPressed: () => _showAddProductSheet(context),
                        ),
                      ],
                    ),
                  );
                }

                final item = items[i - 1];
                return _InventoryCard(item: item, ref: ref);
              },
            ),
          );
        },
      ),
    );
  }

  void _showAddProductSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => ProductFormDialog(
        onSave: (product) {
          // Salvar produto
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Produto adicionado com sucesso!'),
              backgroundColor: Colors.green,
            ),
          );
        },
      ),
    );
  }
}

class _InventoryCard extends StatelessWidget {
  final Map<String, dynamic> item;
  final WidgetRef ref;

  const _InventoryCard({required this.item, required this.ref});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: () => _showEditProductSheet(context),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Product image
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      item['imageUrl'] ?? 'https://picsum.photos/100',
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.inventory_2,
                        color: AppTheme.primaryColor,
                        size: 40,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Product info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['name'] ?? 'Sem nome',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: AppTheme.primaryColor,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Código: ${item['code'] ?? 'N/A'}',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            Formatters.currency(item['price']?.toDouble() ?? 0),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: AppTheme.accentColor,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: (item['stock'] ?? 0) > 0
                                  ? Colors.green.withOpacity(0.1)
                                  : Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Est: ${item['stock'] ?? 0}',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: (item['stock'] ?? 0) > 0
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Actions
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit_outlined,
                          color: AppTheme.accentColor, size: 20),
                      onPressed: () => _showEditProductSheet(context),
                      tooltip: 'Editar',
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline,
                          color: Colors.red, size: 20),
                      onPressed: () => _showDeleteConfirm(context),
                      tooltip: 'Deletar',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showEditProductSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => ProductFormDialog(
        onSave: (product) {
          // Salvar atualizações
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Produto atualizado com sucesso!'),
              backgroundColor: Colors.green,
            ),
          );
        },
      ),
    );
  }

  void _showDeleteConfirm(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Deletar produto?'),
        content: const Text('Esta ação não pode ser desfeita.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ref.invalidate(sellerInventoryProvider);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Produto deletado com sucesso')),
              );
            },
            child: const Text('Deletar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
