import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/mock_data/mock_data.dart';

class SellerReviewsScreen extends StatefulWidget {
  const SellerReviewsScreen({super.key});

  @override
  State<SellerReviewsScreen> createState() => _SellerReviewsScreenState();
}

class _SellerReviewsScreenState extends State<SellerReviewsScreen> {
  int? _filterRating;

  // Flatten all reviews from mock data
  List<Map<String, dynamic>> get _allReviews {
    final reviews = <Map<String, dynamic>>[];
    for (final part in MockData.parts) {
      final partReviews =
          (part['reviews'] as List?)?.cast<Map<String, dynamic>>() ?? [];
      for (final review in partReviews) {
        reviews.add({
          ...review,
          'partName': part['name'],
          'partCode': part['code'],
        });
      }
    }
    reviews.sort((a, b) {
      final dateA = a['date'] as String? ?? '';
      final dateB = b['date'] as String? ?? '';
      return dateB.compareTo(dateA);
    });
    return reviews;
  }

  List<Map<String, dynamic>> get _filtered {
    if (_filterRating == null) return _allReviews;
    return _allReviews.where((r) {
      final rating = (r['rating'] as num).toInt();
      return rating == _filterRating;
    }).toList();
  }

  double get _avgRating {
    final reviews = _allReviews;
    if (reviews.isEmpty) return 0;
    final sum =
        reviews.fold<double>(0, (s, r) => s + (r['rating'] as num).toDouble());
    return sum / reviews.length;
  }

  Map<int, int> get _ratingCounts {
    final counts = <int, int>{5: 0, 4: 0, 3: 0, 2: 0, 1: 0};
    for (final r in _allReviews) {
      final rating = (r['rating'] as num).round();
      counts[rating] = (counts[rating] ?? 0) + 1;
    }
    return counts;
  }

  @override
  Widget build(BuildContext context) {
    final reviews = _filtered;
    final total = _allReviews.length;
    final avg = _avgRating;
    final counts = _ratingCounts;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Avaliações'),
        actions: [
          if (_filterRating != null)
            TextButton(
              onPressed: () => setState(() => _filterRating = null),
              child: const Text('Limpar',
                  style: TextStyle(color: AppTheme.accentColor)),
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // ── Rating summary ─────────────────────────────────────
          Container(
            padding: const EdgeInsets.all(20),
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
                // Big rating number
                Column(
                  children: [
                    Text(
                      avg.toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 52,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                        height: 1,
                      ),
                    ),
                    Row(
                      children: List.generate(
                        5,
                        (i) => Icon(
                          i < avg.round()
                              ? Icons.star
                              : Icons.star_border,
                          color: Colors.amber,
                          size: 16,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$total avaliações',
                      style: TextStyle(
                          color: Colors.grey.shade500, fontSize: 11),
                    ),
                  ],
                ),
                const SizedBox(width: 20),
                const VerticalDivider(width: 1),
                const SizedBox(width: 20),
                // Bars
                Expanded(
                  child: Column(
                    children: [5, 4, 3, 2, 1].map((star) {
                      final count = counts[star] ?? 0;
                      final pct =
                          total > 0 ? count / total : 0.0;
                      final isSelected = _filterRating == star;
                      return GestureDetector(
                        onTap: () => setState(() =>
                            _filterRating = isSelected ? null : star),
                        child: Padding(
                          padding:
                              const EdgeInsets.symmetric(vertical: 3),
                          child: Row(
                            children: [
                              Text(
                                '$star',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected
                                      ? AppTheme.accentColor
                                      : Colors.grey.shade600,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(Icons.star,
                                  size: 10, color: Colors.amber),
                              const SizedBox(width: 6),
                              Expanded(
                                child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(4),
                                  child: LinearProgressIndicator(
                                    value: pct,
                                    backgroundColor:
                                        Colors.grey.shade100,
                                    valueColor:
                                        AlwaysStoppedAnimation<Color>(
                                      isSelected
                                          ? AppTheme.accentColor
                                          : Colors.amber,
                                    ),
                                    minHeight: 7,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              SizedBox(
                                width: 24,
                                child: Text(
                                  '$count',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // ── Review list ────────────────────────────────────────
          if (_filterRating != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppTheme.accentColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: AppTheme.accentColor.withOpacity(0.4)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star,
                            size: 13, color: AppTheme.accentColor),
                        const SizedBox(width: 4),
                        Text(
                          '$_filterRating estrela${_filterRating == 1 ? '' : 's'} · ${reviews.length} avaliação(ões)',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppTheme.accentColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

          if (reviews.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(40),
                child: Column(
                  children: [
                    const Icon(Icons.reviews_outlined,
                        size: 48, color: Colors.grey),
                    const SizedBox(height: 12),
                    Text(
                      'Nenhuma avaliação para $_filterRating estrela(s)',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            )
          else
            ...reviews.map((r) => _ReviewCard(review: r)),
        ],
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final Map<String, dynamic> review;

  const _ReviewCard({required this.review});

  @override
  Widget build(BuildContext context) {
    final rating = (review['rating'] as num).toDouble();
    final author = review['author'] as String? ?? 'Anônimo';
    final comment = review['comment'] as String? ?? '';
    final date = review['date'] as String? ?? '';
    final partName = review['partName'] as String? ?? '';
    final partCode = review['partCode'] as String? ?? '';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
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
          // Produto referenciado
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.06),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              '$partName · $partCode',
              style: const TextStyle(
                fontSize: 10,
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              // Avatar
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: AppTheme.primaryColor,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    author.substring(0, 1).toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      author,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    Row(
                      children: [
                        ...List.generate(
                          5,
                          (i) => Icon(
                            i < rating.round()
                                ? Icons.star
                                : Icons.star_border,
                            size: 12,
                            color: Colors.amber,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          rating.toStringAsFixed(1),
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Text(
                date,
                style:
                    TextStyle(fontSize: 10, color: Colors.grey.shade400),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            comment,
            style: TextStyle(
                fontSize: 13, color: Colors.grey.shade700, height: 1.4),
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () => _showReplyDialog(context, author),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.reply, size: 14, color: AppTheme.accentColor),
                SizedBox(width: 4),
                Text(
                  'Responder',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.accentColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showReplyDialog(BuildContext context, String author) {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Responder a $author'),
        content: TextField(
          controller: ctrl,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: 'Sua resposta pública...',
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Resposta publicada!'),
                  backgroundColor: Colors.green.shade700,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('Publicar',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
