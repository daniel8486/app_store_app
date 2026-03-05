import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/product_category.dart';

class AdminProductCard extends StatelessWidget {
  final String name;
  final String code;
  final double price;
  final double? promotionalPrice;
  final int stock;
  final int minStock;
  final String imageUrl;
  final String status;
  final VoidCallback onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final double rating;
  final int reviewCount;

  const AdminProductCard({
    Key? key,
    required this.name,
    required this.code,
    required this.price,
    this.promotionalPrice,
    required this.stock,
    required this.minStock,
    required this.imageUrl,
    required this.status,
    required this.onTap,
    this.onEdit,
    this.onDelete,
    this.rating = 0.0,
    this.reviewCount = 0,
  }) : super(key: key);

  bool get isLowStock => stock <= minStock;
  bool get hasPromotion =>
      promotionalPrice != null && promotionalPrice! < price;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 2,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagem com badges
            Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(12)),
                  child: Container(
                    height: 120,
                    width: double.infinity,
                    color: Colors.grey[200],
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                          child: Icon(
                            Icons.image_not_supported,
                            color: Colors.grey[400],
                          ),
                        );
                      },
                    ),
                  ),
                ),
                // Badge Status
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      status,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                // Badge Estoque Baixo
                if (isLowStock)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red[600],
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'Baixo Estoque',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                // Badge Promoção
                if (hasPromotion)
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green[600],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '-${((price - promotionalPrice!) / price * 100).toStringAsFixed(0)}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            // Informações
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nome
                  Text(
                    name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Código
                  Text(
                    code,
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Preço
                  Row(
                    children: [
                      if (hasPromotion) ...[
                        Text(
                          'R\$ ${price.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 11,
                            decoration: TextDecoration.lineThrough,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(width: 6),
                      ],
                      Text(
                        'R\$ ${(promotionalPrice ?? price).toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  // Rating
                  Row(
                    children: [
                      const Icon(Icons.star, size: 12, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(
                        '$rating ($reviewCount)',
                        style: const TextStyle(fontSize: 10),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Estoque
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: isLowStock ? Colors.red[50] : Colors.green[50],
                      border: Border.all(
                        color:
                            isLowStock ? Colors.red[200]! : Colors.green[200]!,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Estoque: $stock',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: isLowStock ? Colors.red[700] : Colors.green[700],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Ações
                  Row(
                    children: [
                      if (onEdit != null)
                        Expanded(
                          child: SizedBox(
                            height: 32,
                            child: ElevatedButton.icon(
                              onPressed: onEdit,
                              icon: const Icon(Icons.edit, size: 14),
                              label: const Text(
                                'Editar',
                                style: TextStyle(fontSize: 11),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue[500],
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      if (onEdit != null && onDelete != null)
                        const SizedBox(width: 8),
                      if (onDelete != null)
                        Expanded(
                          child: SizedBox(
                            height: 32,
                            child: ElevatedButton.icon(
                              onPressed: onDelete,
                              icon: const Icon(Icons.delete, size: 14),
                              label: const Text(
                                'Deletar',
                                style: TextStyle(fontSize: 11),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red[500],
                                foregroundColor: Colors.white,
                              ),
                            ),
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

  Color _getStatusColor() {
    switch (status.toLowerCase()) {
      case 'ativo':
        return Colors.green;
      case 'inativo':
        return Colors.grey;
      case 'rascunho':
        return Colors.orange;
      case 'descontinuado':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
