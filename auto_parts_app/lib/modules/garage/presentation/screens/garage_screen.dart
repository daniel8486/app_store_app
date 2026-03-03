import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/garage_provider.dart';
import '../../domain/entities/vehicle.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import 'package:uuid/uuid.dart';

class GarageScreen extends ConsumerWidget {
  const GarageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final garageAsync = ref.watch(garageProvider);
    final user = ref.watch(currentUserProvider).value;

    if (user == null) {
      WidgetsBinding.instance.addPostFrameCallback(
          (_) => Navigator.of(context).pop());
      return const SizedBox.shrink();
    }

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Minha Garagem'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppTheme.accentColor,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Adicionar veículo',
            style: TextStyle(fontWeight: FontWeight.bold)),
        onPressed: () => _showAddVehicleSheet(context, ref),
      ),
      body: garageAsync.when(
        loading: () => const Center(
            child: CircularProgressIndicator(color: AppTheme.primaryColor)),
        error: (e, _) => Center(child: Text('Erro: $e')),
        data: (vehicles) {
          if (vehicles.isEmpty) {
            return _EmptyGarage(
                onAdd: () => _showAddVehicleSheet(context, ref));
          }
          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
            itemCount: vehicles.length,
            itemBuilder: (_, i) => _VehicleCard(
              vehicle: vehicles[i],
              onDelete: () => ref
                  .read(garageProvider.notifier)
                  .delete(vehicles[i].id),
            ),
          );
        },
      ),
    );
  }

  void _showAddVehicleSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AddVehicleSheet(
        onSave: (v) => ref.read(garageProvider.notifier).add(v),
      ),
    );
  }
}

// ─── EMPTY STATE ───────────────────────────────────────────────────────────────

class _EmptyGarage extends StatelessWidget {
  final VoidCallback onAdd;
  const _EmptyGarage({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.garage_outlined,
                  size: 52, color: AppTheme.primaryColor),
            ),
            const SizedBox(height: 24),
            const Text(
              'Sua garagem está vazia',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor),
            ),
            const SizedBox(height: 8),
            const Text(
              'Cadastre seus veículos para filtrar\npeças compatíveis rapidamente.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 28),
            SizedBox(
              height: 50,
              child: ElevatedButton.icon(
                onPressed: onAdd,
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text('Adicionar veículo',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── VEHICLE CARD ─────────────────────────────────────────────────────────────

class _VehicleCard extends StatelessWidget {
  final Vehicle vehicle;
  final VoidCallback onDelete;

  const _VehicleCard({required this.vehicle, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
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
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: AppTheme.primaryColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.directions_car,
              color: AppTheme.accentColor, size: 26),
        ),
        title: Text(
          vehicle.displayName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryColor,
            fontSize: 14,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${vehicle.brand} · ${vehicle.model} · ${vehicle.year}',
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
            if (vehicle.color != null)
              Text(
                vehicle.color!,
                style: TextStyle(color: Colors.grey.shade400, fontSize: 11),
              ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.red),
          onPressed: () => _confirmDelete(context),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Remover veículo'),
        content: Text(
            'Deseja remover "${vehicle.displayName}" da sua garagem?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onDelete();
            },
            style:
                TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Remover'),
          ),
        ],
      ),
    );
  }
}

// ─── ADD VEHICLE BOTTOM SHEET ─────────────────────────────────────────────────

const _brands = ['Toyota', 'Ford', 'Volkswagen', 'Honda', 'Chevrolet'];

const _models = {
  'Toyota': ['Corolla', 'Hilux', 'Yaris', 'Etios', 'RAV4'],
  'Ford': ['Ka', 'Ranger', 'EcoSport', 'Focus', 'Edge'],
  'Volkswagen': ['Gol', 'T-Cross', 'Polo', 'Virtus', 'Tiguan'],
  'Honda': ['Civic', 'HR-V', 'City', 'Fit', 'CR-V'],
  'Chevrolet': ['Onix', 'S10', 'Tracker', 'Cruze', 'Spin'],
};

class _AddVehicleSheet extends StatefulWidget {
  final Future<void> Function(Vehicle) onSave;

  const _AddVehicleSheet({required this.onSave});

  @override
  State<_AddVehicleSheet> createState() => _AddVehicleSheetState();
}

class _AddVehicleSheetState extends State<_AddVehicleSheet> {
  String? _brand;
  String? _model;
  int? _year;
  final _nicknameCtrl = TextEditingController();
  final _colorCtrl = TextEditingController();
  bool _loading = false;

  final _currentYear = DateTime.now().year;

  List<int> get _years =>
      List.generate(_currentYear - 1989, (i) => _currentYear - i);

  List<String> get _modelOptions =>
      _brand != null ? (_models[_brand] ?? []) : [];

  Future<void> _save() async {
    if (_brand == null || _model == null || _year == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecione marca, modelo e ano'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    setState(() => _loading = true);
    try {
      final vehicle = Vehicle(
        id: const Uuid().v4(),
        brand: _brand!,
        model: _model!,
        year: _year!,
        nickname: _nicknameCtrl.text.trim().isEmpty
            ? null
            : _nicknameCtrl.text.trim(),
        color: _colorCtrl.text.trim().isEmpty
            ? null
            : _colorCtrl.text.trim(),
      );
      await widget.onSave(vehicle);
      if (mounted) Navigator.pop(context);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _nicknameCtrl.dispose();
    _colorCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(
          24, 16, 24, MediaQuery.of(context).viewInsets.bottom + 24),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Adicionar veículo',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor),
            ),
            const SizedBox(height: 20),

            // Marca
            _buildDropdown(
              label: 'Marca',
              value: _brand,
              items: _brands,
              onChanged: (v) => setState(() {
                _brand = v;
                _model = null;
              }),
            ),
            const SizedBox(height: 14),

            // Modelo
            _buildDropdown(
              label: 'Modelo',
              value: _model,
              items: _modelOptions,
              enabled: _brand != null,
              onChanged: (v) => setState(() => _model = v),
            ),
            const SizedBox(height: 14),

            // Ano
            _buildDropdown<int>(
              label: 'Ano',
              value: _year,
              items: _years,
              itemLabel: (y) => y.toString(),
              onChanged: (v) => setState(() => _year = v),
            ),
            const SizedBox(height: 14),

            // Apelido (opcional)
            TextFormField(
              controller: _nicknameCtrl,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Apelido (opcional)',
                hintText: 'Ex: Meu Corolla',
                prefixIcon: Icon(Icons.label_outline),
              ),
            ),
            const SizedBox(height: 14),

            // Cor (opcional)
            TextFormField(
              controller: _colorCtrl,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Cor (opcional)',
                hintText: 'Ex: Prata',
                prefixIcon: Icon(Icons.palette_outlined),
              ),
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _loading ? null : _save,
                child: _loading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2),
                      )
                    : const Text(
                        'SALVAR VEÍCULO',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown<T>({
    required String label,
    required T? value,
    required List<T> items,
    String Function(T)? itemLabel,
    bool enabled = true,
    required void Function(T?) onChanged,
  }) {
    return DropdownButtonFormField<T>(
      value: value,
      decoration: InputDecoration(labelText: label),
      hint: Text('Selecione $label'),
      items: items
          .map((item) => DropdownMenuItem(
                value: item,
                child: Text(itemLabel != null
                    ? itemLabel(item)
                    : item.toString()),
              ))
          .toList(),
      onChanged: enabled ? onChanged : null,
    );
  }
}
