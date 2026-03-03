import 'package:riverpod/riverpod.dart';
import '../../../review/domain/entities/review.dart';

// Mock reviews data
final _mockReviews = <Review>[
  Review(
    id: '1',
    userId: 'user1',
    userName: 'João Silva',
    productId: '1',
    productName: 'Pastilha Freio Cerâmica',
    rating: 5,
    comment:
        'Excelente qualidade! Chegou rápido e bem embalado. Já testei e funciona perfeitamente.',
    createdAt: DateTime.now().subtract(Duration(days: 5)),
    helpfulCount: 12,
  ),
  Review(
    id: '2',
    userId: 'user2',
    userName: 'Maria Santos',
    productId: '1',
    productName: 'Pastilha Freio Cerâmica',
    rating: 4,
    comment: 'Boa qualidade, preço justo. Recomendo!',
    createdAt: DateTime.now().subtract(Duration(days: 10)),
    helpfulCount: 8,
  ),
  Review(
    id: '3',
    userId: 'user3',
    userName: 'Carlos Oliveira',
    productId: '2',
    productName: 'Óleo Motor Sintético 5W-30',
    rating: 5,
    comment: 'Melhor óleo que já usei. Motor rodando suave e silencioso.',
    createdAt: DateTime.now().subtract(Duration(days: 15)),
    helpfulCount: 23,
  ),
];

// Reviews para um produto específico
final reviewsByProductProvider =
    FutureProvider.family<List<Review>, String>((ref, productId) async {
  // Simula uma chamada de API
  await Future.delayed(Duration(milliseconds: 500));
  return _mockReviews.where((review) => review.productId == productId).toList();
});

// Todas as reviews de um usuário
final userReviewsProvider =
    FutureProvider.family<List<Review>, String>((ref, userId) async {
  await Future.delayed(Duration(milliseconds: 500));
  return _mockReviews.where((review) => review.userId == userId).toList();
});

// Rating médio de um produto
final productRatingProvider =
    FutureProvider.family<double, String>((ref, productId) async {
  final reviews = await ref.watch(reviewsByProductProvider(productId).future);
  if (reviews.isEmpty) return 0;
  final total = reviews.fold<double>(0, (sum, review) => sum + review.rating);
  return total / reviews.length;
});

// Provider para adicionar nova review
final addReviewProvider =
    FutureProvider.family<Review, Review>((ref, newReview) async {
  await Future.delayed(Duration(seconds: 1)); // Simula API call
  // Em um app real, isso enviaria para um servidor
  return newReview;
});
