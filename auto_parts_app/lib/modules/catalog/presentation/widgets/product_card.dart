import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/product.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/formatters.dart';
import '../../../favorites/presentation/providers/favorites_provider.dart';

class ProductCard extends ConsumerWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFav = ref.watch(isFavoriteProvider(product.id));
    final imageUrl =
        product.imageUrls.isNotEmpty ? product.imageUrls.first : '';

    return GestureDetector(
      onTap: () => context.push('/product/${product.id}', extra: product),
      child: Container(
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagem
            Expanded(
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(15)),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    imageUrl.isNotEmpty
                        ? Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => _placeholderImage(),
                            loadingBuilder: (_, child, progress) {
                              if (progress == null) return child;
                              return _loadingImage();
                            },
                          )
                        : _placeholderImage(),

                    // Badge estoque
                    if (product.currentStock == 0)
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.red.shade600,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'ESGOTADO',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                    // Botão favorito
                    Positioned(
                      top: 4,
                      right: 4,
                      child: GestureDetector(
                        onTap: () => ref
                            .read(favoritesProvider.notifier)
                            .toggle(product.id),
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isFav ? Icons.favorite : Icons.favorite_border,
                            size: 16,
                            color: isFav
                                ? AppTheme.accentColor
                                : Colors.grey.shade400,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Info
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Badges (Qualidade + Origem)
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: _getQualityColor(product.qualityRanking)
                              .withOpacity(0.15),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          _getQualityShort(product.qualityRanking),
                          style: TextStyle(
                            color: _getQualityColor(product.qualityRanking),
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          product.origin.label.split(' ').first,
                          style: TextStyle(
                            color: Colors.blue.shade700,
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),

                  // SKU
                  Text(
                    'SKU: ${product.sku}',
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 9,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Nome
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: AppTheme.primaryColor,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  // Marca
                  Text(
                    product.brand,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 10,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Compatibilidade Veicular (resumida)
                  if (product.vehicleCompatibilities.isNotEmpty)
                    Text(
                      '${product.vehicleCompatibilities.first.manufacturer} ${product.vehicleCompatibilities.first.model}',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 9,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                  const SizedBox(height: 6),

                  // Estoque + Preço + Rating
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Estoque
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 2),
                        decoration: BoxDecoration(
                          color: product.currentStock > 0
                              ? Colors.green.shade50
                              : Colors.red.shade50,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          product.currentStock > 0
                              ? '${product.currentStock} em estoque'
                              : 'Sem estoque',
                          style: TextStyle(
                            color: product.currentStock > 0
                                ? Colors.green.shade700
                                : Colors.red.shade700,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),

                      // Preço + Rating
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            Formatters.currency(product.price),
                            style: const TextStyle(
                              color: AppTheme.primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(Icons.star,
                                  color: Colors.amber, size: 12),
                              const SizedBox(width: 2),
                              Text(
                                product.rating.toStringAsFixed(1),
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
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

  Widget _placeholderImage() {
    return Container(
      color: const Color(0xFFF0F0F0),
      child: const Icon(
        Icons.settings_suggest,
        size: 48,
        color: Color(0xFFCCCCCC),
      ),
    );
  }

  Widget _loadingImage() {
    return Container(
      color: const Color(0xFFF0F0F0),
      child: const Center(
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    );
  }

  Color _getQualityColor(QualityRanking quality) {
    switch (quality) {
      case QualityRanking.genuine:
        return Colors.green;
      case QualityRanking.original:
        return Colors.blue;
      case QualityRanking.aftermarket:
        return Colors.orange;
    }
  }

  String _getQualityShort(QualityRanking quality) {
    switch (quality) {
      case QualityRanking.genuine:
        return 'GENUÍNA';
      case QualityRanking.original:
        return 'ORIGINAL';
      case QualityRanking.aftermarket:
        return 'GENÉRICA';
    }
  }
}
