import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/admin_product_provider.dart';
import '../widgets/admin_product_card.dart';
import '../widgets/admin_product_filters.dart';
import '../../domain/entities/admin_product.dart';

class AdminProductsListScreen extends ConsumerStatefulWidget {
  const AdminProductsListScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AdminProductsListScreen> createState() =>
      _AdminProductsListScreenState();
}

class _AdminProductsListScreenState
    extends ConsumerState<AdminProductsListScreen> {
  final _searchCtrl = TextEditingController();
  bool _showFilters = false;

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filter = ref.watch(adminProductFilterProvider);
    final productsAsync = ref.watch(adminFilteredProductsProvider);
    final totalAsync = ref.watch(adminTotalProductCountProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestão de Produtos'),
        elevation: 1,
        scrolledUnderElevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              setState(() => _showFilters = !_showFilters);
            },
            tooltip: 'Filtros',
          ),
          SizedBox(width: 8),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/admin/produto/novo');
        },
        tooltip: 'Novo Produto',
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          // Barra de busca
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchCtrl,
              decoration: InputDecoration(
                hintText: 'Buscar por nome, código ou descrição...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchCtrl.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchCtrl.clear();
                          ref
                              .read(adminProductFilterProvider.notifier)
                              .updateSearch('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
              ),
              onChanged: (value) {
                ref
                    .read(adminProductFilterProvider.notifier)
                    .updateSearch(value);
              },
            ),
          ),

          // Filtros (expansível)
          if (_showFilters)
            Container(
              color: Colors.grey[50],
              child: const AdminProductFilters(),
            ),

          // Estatísticas
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: totalAsync.when(
              data: (total) => Text(
                'Total de produtos: $total',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              loading: () => const SizedBox.shrink(),
              error: (error, stack) => const SizedBox.shrink(),
            ),
          ),

          // Lista de produtos
          Expanded(
            child: productsAsync.when(
              data: (products) {
                if (products.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shopping_bag_outlined,
                          size: 64,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Nenhum produto encontrado',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () {
                            context.push('/admin/produto/novo');
                          },
                          child: const Text('Adicionar novo produto'),
                        ),
                      ],
                    ),
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(8),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return AdminProductCard(
                      name: product.name,
                      code: product.code,
                      price: product.price,
                      promotionalPrice: product.promotionalPrice,
                      stock: product.stock,
                      minStock: product.minStock,
                      imageUrl: product.imageUrl,
                      status: product.status.label,
                      rating: product.rating,
                      reviewCount: product.reviewCount,
                      onTap: () {
                        context.push('/admin/produto/${product.id}');
                      },
                      onEdit: () {
                        context.push('/admin/produto/${product.id}/editar');
                      },
                      onDelete: () {
                        _showDeleteDialog(context, ref, product);
                      },
                    );
                  },
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
                      'Erro ao carregar produtos',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.red[600],
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        ref.refresh(adminFilteredProductsProvider);
                      },
                      child: const Text('Tentar novamente'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(
    BuildContext context,
    WidgetRef ref,
    AdminProduct product,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Deletar Produto'),
        content: Text(
          'Você tem certeza que deseja deletar "${product.name}"?\nEsta ação não pode ser desfeita.',
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
                    .deleteProduct(ref, product.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Produto deletado com sucesso!'),
                    backgroundColor: Colors.green,
                  ),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Erro ao deletar: $e'),
                    backgroundColor: Colors.red,
                  ),
                );
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
