import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminReviewsScreen extends ConsumerStatefulWidget {
  const AdminReviewsScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AdminReviewsScreen> createState() => _AdminReviewsScreenState();
}

class _AdminReviewsScreenState extends ConsumerState<AdminReviewsScreen> {
  final _searchCtrl = TextEditingController();
  String _filterRating = 'Todos';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reviews = [
      (
        'Excelente qualidade!',
        'João Silva',
        'Filtro de ar modelo X',
        5,
        'Produto excelente, chegou rápido e bem embalado. Com certeza vou comprar mais!',
        'Verificado',
        Colors.green,
        '2025-03-04'
      ),
      (
        'Muito bom!',
        'Maria Santos',
        'Óleo Sintético 5w30',
        4,
        'Produto de qualidade, recomendo. Preço justo também.',
        'Verificado',
        Colors.green,
        '2025-03-03'
      ),
      (
        'Não é o que esperava',
        'Pedro Oliveira',
        'Bateria Automotiva',
        2,
        'Bateria esquentou muito após 2 meses. Qualidade ruim.',
        'Verificado',
        Colors.green,
        '2025-03-02'
      ),
      (
        'Perfeito!',
        'Ana Costa',
        'Pneu Premium 14"',
        5,
        'Melhor pneu que já usei. Ótimo grip e durabilidade.',
        'Verificado',
        Colors.green,
        '2025-03-01'
      ),
      (
        'Regular',
        'Carlos Mendes',
        'Corrente Distribuição',
        3,
        'Produto OK, poderia ter melhor acabamento.',
        'Pendente',
        Colors.orange,
        '2025-02-28'
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestão de Avaliações'),
        elevation: 0,
        scrolledUnderElevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {},
            tooltip: 'Exportar',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _searchCtrl,
                decoration: InputDecoration(
                  hintText: 'Buscar por produto, autor ou conteúdo...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    'Todos',
                    '⭐ 5 estrelas',
                    '⭐ 4 estrelas',
                    '⭐ 3 estrelas',
                    '⭐ 1-2 estrelas'
                  ]
                      .map((rating) => Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: FilterChip(
                              label: Text(rating),
                              selected: _filterRating == rating,
                              onSelected: (selected) {
                                setState(() => _filterRating = rating);
                              },
                            ),
                          ))
                      .toList(),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: _buildMetricCard('Total Avaliações', '2.847',
                        'Este mês', Icons.rate_review, Colors.blue),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildMetricCard('Média Geral', '4.6',
                        'de 5 estrelas', Icons.star, Colors.amber),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildMetricCard('Positivas', '89.2%',
                        '2.538 avaliações', Icons.thumb_up, Colors.green),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildMetricCard('Negativas', '8.1%',
                        '231 avaliações', Icons.thumb_down, Colors.red),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'Avaliações Recentes',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Column(
                children: List.generate(reviews.length, (index) {
                  final review = reviews[index];
                  final stars = List.generate(
                    5,
                    (i) => Icon(
                      Icons.star,
                      size: 14,
                      color: i < review.$4 ? Colors.amber : Colors.grey[300],
                    ),
                  );

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 16,
                                          backgroundColor: Colors.grey[300],
                                          child: Text(
                                            review.$2[0],
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                review.$2,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                ),
                                              ),
                                              Text(
                                                review.$3,
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: review.$7.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  review.$6,
                                  style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                    color: review.$7,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: stars,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            review.$1,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            review.$5,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[700],
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                review.$8,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey[600],
                                ),
                              ),
                              Row(
                                children: [
                                  OutlinedButton.icon(
                                    onPressed: () {},
                                    icon: const Icon(Icons.check, size: 14),
                                    label: const Text('Aprovar'),
                                  ),
                                  const SizedBox(width: 8),
                                  PopupMenuButton(
                                    itemBuilder: (context) => [
                                      const PopupMenuItem(
                                          child: Text('Bloquear')),
                                      const PopupMenuItem(
                                          child: Text('Denunciar')),
                                      const PopupMenuItem(
                                          child: Text('Deletar')),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 24),
              Center(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.analytics),
                  label: const Text('Ver Análise Completa'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricCard(
      String title, String value, String subtitle, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(icon, color: color, size: 14),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(fontSize: 10, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
