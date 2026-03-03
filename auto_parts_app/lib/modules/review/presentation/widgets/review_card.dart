import 'package:flutter/material.dart';
import '../../../review/domain/entities/review.dart';

class ReviewCard extends StatelessWidget {
  final Review review;
  final VoidCallback? onHelpfulPressed;

  const ReviewCard({
    Key? key,
    required this.review,
    this.onHelpfulPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Avatar, Nome, Data
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Color(0xFF0D1B2A),
                        child: Text(
                          review.userName[0].toUpperCase(),
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              review.userName,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              _formatDate(review.createdAt),
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),

            // Rating Stars
            Row(
              children: [
                ..._buildStars(review.rating),
                SizedBox(width: 8),
                Text(
                  '${review.rating.toStringAsFixed(1)}',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),

            // Comment
            if (review.comment.isNotEmpty)
              Text(
                review.comment,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade800,
                  height: 1.5,
                ),
                maxLines: null,
              ),
            SizedBox(height: 12),

            // Images grid (if any)
            if (review.images.isNotEmpty) ...[
              SizedBox(
                height: 80,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: review.images.length,
                  separatorBuilder: (_, __) => SizedBox(width: 8),
                  itemBuilder: (_, index) => ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      review.images[index],
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 12),
            ],

            // Helpful button and helpful count
            Row(
              children: [
                TextButton.icon(
                  onPressed: onHelpfulPressed,
                  icon: Icon(Icons.thumb_up_outlined, size: 16),
                  label: Text(
                    'Útil (${review.helpfulCount})',
                    style: TextStyle(fontSize: 12),
                  ),
                  style: TextButton.styleFrom(
                    foregroundColor: Color(0xFFF3722C),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildStars(double rating) {
    return List.generate(5, (index) {
      if (index < rating) {
        return Icon(Icons.star, color: Color(0xFFFFC107), size: 16);
      } else if (index < rating && rating % 1 != 0) {
        return Icon(Icons.star_half, color: Color(0xFFFFC107), size: 16);
      } else {
        return Icon(Icons.star_outline, color: Colors.grey.shade300, size: 16);
      }
    });
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return 'Há ${difference.inMinutes} minutos';
      }
      return 'Há ${difference.inHours} horas';
    } else if (difference.inDays == 1) {
      return 'Ontem';
    } else if (difference.inDays < 7) {
      return 'Há ${difference.inDays} dias';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return 'Há $weeks semana${weeks > 1 ? 's' : ''}';
    } else {
      final months = (difference.inDays / 30).floor();
      return 'Há $months mês${months > 1 ? 'es' : ''}';
    }
  }
}
