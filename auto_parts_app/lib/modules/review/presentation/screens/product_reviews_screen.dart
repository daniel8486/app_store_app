import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../review/domain/entities/review.dart';
import '../../../review/presentation/providers/review_provider.dart';
import '../../../review/presentation/widgets/review_card.dart';

class ProductReviewsScreen extends ConsumerWidget {
  final String productId;
  final String productName;

  const ProductReviewsScreen({
    Key? key,
    required this.productId,
    required this.productName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reviewsAsyncValue = ref.watch(reviewsByProductProvider(productId));
    final ratingAsyncValue = ref.watch(productRatingProvider(productId));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Avaliações',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Color(0xFF0D1B2A),
        elevation: 1,
      ),
      body: reviewsAsyncValue.when(
        data: (reviews) {
          return ratingAsyncValue.when(
            data: (avgRating) {
              return CustomScrollView(
                slivers: [
                  // Rating Summary Card
                  SliverToBoxAdapter(
                    child: _buildRatingSummary(reviews, avgRating),
                  ),

                  // Divider
                  SliverToBoxAdapter(
                    child: Divider(height: 20, indent: 16, endIndent: 16),
                  ),

                  // Reviews List
                  if (reviews.isNotEmpty)
                    SliverPadding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final review = reviews[index];
                            return ReviewCard(
                              review: review,
                              onHelpfulPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Obrigado pela sua ajuda!'),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              },
                            );
                          },
                          childCount: reviews.length,
                        ),
                      ),
                    )
                  else
                    SliverFillRemaining(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.rate_review_outlined,
                              size: 64,
                              color: Colors.grey.shade300,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Nenhuma avaliação ainda',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              );
            },
            loading: () => Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(
              child: Text('Erro ao carregar avaliação: $err'),
            ),
          );
        },
        loading: () => Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Text('Erro ao carregar avaliações: $err'),
        ),
      ),
    );
  }

  Widget _buildRatingSummary(List<Review> reviews, double avgRating) {
    final ratingCounts = <int, int>{};
    for (var review in reviews) {
      final rating = review.rating.toInt();
      ratingCounts[rating] = (ratingCounts[rating] ?? 0) + 1;
    }

    return Card(
      margin: EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            // Main rating
            Row(
              children: [
                Column(
                  children: [
                    Text(
                      avgRating.toStringAsFixed(1),
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0D1B2A),
                      ),
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: List.generate(5, (index) {
                        return Icon(
                          index < avgRating ? Icons.star : Icons.star_outline,
                          color: Color(0xFFFFC107),
                          size: 16,
                        );
                      }),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '${reviews.length} avaliação${reviews.length != 1 ? 'ões' : ''}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(5, (index) {
                      final rating = 5 - index;
                      final count = ratingCounts[rating] ?? 0;
                      final percentage = reviews.isNotEmpty
                          ? (count / reviews.length * 100).toInt()
                          : 0;

                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 30,
                              child: Text(
                                '$rating★',
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: percentage / 100,
                                  minHeight: 6,
                                  backgroundColor: Colors.grey.shade200,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Color(0xFFF3722C),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            SizedBox(
                              width: 25,
                              child: Text(
                                '$percentage%',
                                textAlign: TextAlign.end,
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
