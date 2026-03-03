import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/catalog_provider.dart';
import '../../domain/entities/part.dart';
import '../../../cart/presentation/providers/cart_provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/formatters.dart';

class PartDetailScreen extends ConsumerStatefulWidget {
  final String partId;

  const PartDetailScreen({super.key, required this.partId});

  @override
  ConsumerState<PartDetailScreen> createState() => _PartDetailScreenState();
}

class _PartDetailScreenState extends ConsumerState<PartDetailScreen> {
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    Part? part;
    try {
      part = ref.read(catalogRepositoryProvider).getPartById(widget.partId);
    } catch (_) {}

    if (part == null) {
      return Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        appBar: AppBar(),
        body: const Center(child: Text('Peça não encontrada')),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: AppTheme.primaryColor,
            iconTheme: const IconThemeData(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                part.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: const Color(0xFF1A2F45),
                  child: const Icon(
                    Icons.settings_suggest,
                    size: 80,
                    color: Colors.white24,
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category + rating
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.accentColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          part.category,
                          style: const TextStyle(
                            color: AppTheme.accentColor,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Row(
                        children: List.generate(5, (i) {
                          return Icon(
                            i < part!.rating.floor()
                                ? Icons.star
                                : Icons.star_border,
                            size: 16,
                            color: Colors.amber,
                          );
                        }),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        part.rating.toStringAsFixed(1),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Name
                  Text(
                    part.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        'Cód: ${part.code}',
                        style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Por: ${part.supplierName}',
                        style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Price box
                  Container(
                    padding: const EdgeInsets.all(16),
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
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Preço unitário',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              Formatters.currency(part.price),
                              style: const TextStyle(
                                color: AppTheme.primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 26,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: part.isAvailable
                                ? Colors.green.withOpacity(0.1)
                                : Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            part.isAvailable
                                ? '${part.stock} em estoque'
                                : 'ESGOTADO',
                            style: TextStyle(
                              color: part.isAvailable
                                  ? Colors.green.shade700
                                  : Colors.red.shade700,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Description
                  _SectionTitle('Descrição'),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      part.description,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                        height: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Compatibility
                  _SectionTitle('Compatibilidade'),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: part.compatibilities
                          .asMap()
                          .entries
                          .map((entry) {
                        final isLast =
                            entry.key == part!.compatibilities.length - 1;
                        final c = entry.value;
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 10),
                              child: Row(
                                children: [
                                  Container(
                                    width: 28,
                                    height: 28,
                                    decoration: BoxDecoration(
                                      color: Colors.green.withOpacity(0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.check,
                                        size: 14, color: Colors.green),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      '${c.brand} ${c.model} (${c.yearFrom}–${c.yearTo})',
                                      style: const TextStyle(
                                          fontSize: 13,
                                          color: AppTheme.primaryColor),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (!isLast)
                              const Divider(height: 1, indent: 52),
                          ],
                        );
                      }).toList(),
                    ),
                  ),

                  // Reviews
                  if (part.reviews.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    _SectionTitle('Avaliações'),
                    const SizedBox(height: 8),
                    ...part.reviews.map(
                      (r) => Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  r.author,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.primaryColor,
                                  ),
                                ),
                                Row(
                                  children: List.generate(
                                    5,
                                    (i) => Icon(
                                      i < r.rating.floor()
                                          ? Icons.star
                                          : Icons.star_border,
                                      size: 13,
                                      color: Colors.amber,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              r.comment,
                              style: const TextStyle(
                                  fontSize: 13, color: Colors.black87),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              r.date,
                              style: TextStyle(
                                  fontSize: 11, color: Colors.grey.shade400),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: part.isAvailable
          ? Container(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 28),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 12,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Quantity selector
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove, size: 18),
                          onPressed: _quantity > 1
                              ? () => setState(() => _quantity--)
                              : null,
                          color: AppTheme.primaryColor,
                        ),
                        Text(
                          '$_quantity',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add, size: 18),
                          onPressed: _quantity < part.stock
                              ? () => setState(() => _quantity++)
                              : null,
                          color: AppTheme.primaryColor,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.shopping_cart_outlined,
                            color: Colors.white),
                        label: const Text(
                          'ADICIONAR AO CARRINHO',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.accentColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          ref
                              .read(cartProvider.notifier)
                              .addItem(part!, quantity: _quantity);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${part.name} adicionado!'),
                              backgroundColor: AppTheme.primaryColor,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              action: SnackBarAction(
                                label: 'Ver carrinho',
                                textColor: AppTheme.accentColor,
                                onPressed: () => context.push('/cart'),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            )
          : null,
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
        color: AppTheme.primaryColor,
      ),
    );
  }
}
