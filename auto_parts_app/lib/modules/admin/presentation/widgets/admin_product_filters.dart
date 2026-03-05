import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/product_category.dart';
import '../../domain/entities/admin_product.dart';
import '../providers/admin_product_provider.dart';

class AdminProductFilters extends ConsumerWidget {
  const AdminProductFilters({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(adminProductFilterProvider);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título
          const Text(
            'Filtros',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          // Filtro por Categoria
          const Text(
            'Categoria',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButton<ProductCategory?>(
              value: filter.category,
              isExpanded: true,
              underline: const SizedBox(),
              items: [
                const DropdownMenuItem(
                  value: null,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text('Todas as categorias'),
                  ),
                ),
                ...ProductCategory.values.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(category.label),
                    ),
                  );
                }),
              ],
              onChanged: (value) {
                ref
                    .read(adminProductFilterProvider.notifier)
                    .updateCategory(value);
              },
            ),
          ),
          const SizedBox(height: 16),

          // Filtro por Status
          const Text(
            'Status',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButton<ProductStatus?>(
              value: filter.status,
              isExpanded: true,
              underline: const SizedBox(),
              items: [
                const DropdownMenuItem(
                  value: null,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text('Todos os status'),
                  ),
                ),
                ...ProductStatus.values.map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(status.label),
                    ),
                  );
                }),
              ],
              onChanged: (value) {
                ref
                    .read(adminProductFilterProvider.notifier)
                    .updateStatus(value);
              },
            ),
          ),
          const SizedBox(height: 16),

          // Botão Limpar Filtros
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                ref.read(adminProductFilterProvider.notifier).reset();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[300],
                foregroundColor: Colors.black87,
              ),
              child: const Text('Limpar Filtros'),
            ),
          ),
        ],
      ),
    );
  }
}
