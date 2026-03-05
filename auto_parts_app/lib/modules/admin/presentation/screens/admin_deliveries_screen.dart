import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminDeliveriesScreen extends ConsumerStatefulWidget {
  const AdminDeliveriesScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AdminDeliveriesScreen> createState() =>
      _AdminDeliveriesScreenState();
}

class _AdminDeliveriesScreenState extends ConsumerState<AdminDeliveriesScreen> {
  final _searchCtrl = TextEditingController();
  String _filterStatus = 'Todos';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deliveries = [
      (
        '#EX-2841',
        'João Silva',
        'Rua A, 123 - SP',
        'Em Rota',
        Colors.blue,
        Icons.local_shipping,
        '85% completo',
        'Chega às 14:30',
        Colors.blue
      ),
      (
        '#EX-2840',
        'Maria Santos',
        'Avenida B, 456 - RJ',
        'Entregue',
        Colors.green,
        Icons.check_circle,
        'Completado',
        'Hoje às 10:15',
        Colors.green
      ),
      (
        '#EX-2839',
        'Pedro Oliveira',
        'Rua C, 789 - MG',
        'Saiu para Entrega',
        Colors.orange,
        Icons.directions_run,
        '50% completo',
        'Previsto para hoje',
        Colors.orange
      ),
      (
        '#EX-2838',
        'Ana Costa',
        'Rua D, 321 - BA',
        'Em Trânsito',
        Colors.blue,
        Icons.train,
        '25% completo',
        'Chega em 2 dias',
        Colors.blue
      ),
      (
        '#EX-2837',
        'Carlos Mendes',
        'Avenida E, 654 - PR',
        'Entregue',
        Colors.green,
        Icons.check_circle,
        'Completado',
        'Ontem às 16:45',
        Colors.green
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestão de Entregas'),
        elevation: 0,
        scrolledUnderElevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.map),
            onPressed: () {},
            tooltip: 'Ver Mapa',
          ),
          const SizedBox(width: 4),
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
                  hintText: 'Buscar por rastreamento ou destino...',
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
                  children:
                      ['Todos', 'Pendente', 'Em Rota', 'Entregue', 'Problema']
                          .map((status) => Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: FilterChip(
                                  label: Text(status),
                                  selected: _filterStatus == status,
                                  onSelected: (selected) {
                                    setState(() => _filterStatus = status);
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
                    child: _buildMetricCard('Total Entregas', '1.247',
                        '+15% vs. mês', Icons.local_shipping, Colors.blue),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildMetricCard('Entregues', '1.156', '92.7% taxa',
                        Icons.check_circle, Colors.green),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildMetricCard('Em Rota', '67', 'Hoje',
                        Icons.directions_run, Colors.orange),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildMetricCard('Problemas', '24', 'Atenção',
                        Icons.warning, Colors.red),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'Rastreamento de Entregas',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Column(
                children: List.generate(deliveries.length, (index) {
                  final delivery = deliveries[index];
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
                            children: [
                              Container(
                                width: 45,
                                height: 45,
                                decoration: BoxDecoration(
                                  color: delivery.$9.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  delivery.$6,
                                  color: delivery.$9,
                                  size: 22,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${delivery.$1} - ${delivery.$2}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      delivery.$3,
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: delivery.$9.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  delivery.$4,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: delivery.$9,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          // Barra de progresso
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Progresso',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    delivery.$7,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: delivery.$9,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: int.parse(delivery.$7.split('%')[0]) /
                                      100,
                                  minHeight: 6,
                                  backgroundColor: Colors.grey[300],
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    delivery.$9,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                delivery.$8,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey[600],
                                ),
                              ),
                              OutlinedButton.icon(
                                onPressed: () {},
                                icon: const Icon(Icons.location_on, size: 16),
                                label: const Text('Rastrear'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }),
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
