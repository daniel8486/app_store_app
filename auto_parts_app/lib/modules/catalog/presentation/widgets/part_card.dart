import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/part.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/utils/formatters.dart';
import '../../../favorites/presentation/providers/favorites_provider.dart';

class PartCard extends ConsumerWidget {
  final Part part;

  const PartCard({super.key, required this.part});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFav = ref.watch(isFavoriteProvider(part.id));

    return GestureDetector(
      onTap: () => context.push('/product/${part.id}'),
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
                    Image.network(
                      part.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: const Color(0xFFF0F0F0),
                        child: const Icon(
                          Icons.settings_suggest,
                          size: 48,
                          color: Color(0xFFCCCCCC),
                        ),
                      ),
                      loadingBuilder: (_, child, progress) {
                        if (progress == null) return child;
                        return Container(
                          color: const Color(0xFFF0F0F0),
                          child: const Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        );
                      },
                    ),
                    // Badge estoque
                    if (!part.isAvailable)
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
                            .toggle(part.id),
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
                  // Badges (Compatível + Categoria)
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'COMPATÍVEL',
                          style: TextStyle(
                            color: Colors.green.shade700,
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
                          color: AppTheme.accentColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          part.category,
                          style: const TextStyle(
                            color: AppTheme.accentColor,
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),

                  // SKU
                  Text(
                    'SKU: ${part.code}',
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 9,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Nome
                  Text(
                    part.name,
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
                    part.supplierName,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 10,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Compatibilidade Veicular (resumida)
                  if (part.compatibilities.isNotEmpty)
                    Text(
                      '${part.compatibilities.first.brand} ${part.compatibilities.first.model}',
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
                          color: part.stock > 0
                              ? Colors.blue.shade50
                              : Colors.red.shade50,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          part.stock > 0
                              ? '${part.stock} em estoque'
                              : 'Sem estoque',
                          style: TextStyle(
                            color: part.stock > 0
                                ? Colors.blue.shade700
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
                            Formatters.currency(part.price),
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
                                part.rating.toStringAsFixed(1),
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
}
