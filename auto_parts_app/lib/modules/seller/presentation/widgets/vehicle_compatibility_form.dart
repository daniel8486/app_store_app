import 'package:flutter/material.dart';
import '../../../catalog/domain/entities/product.dart';
import '../../../../core/theme/app_theme.dart';

class VehicleCompatibilityFormDialog extends StatefulWidget {
  final VehicleCompatibility? compatibility;
  final Function(VehicleCompatibility) onSave;

  const VehicleCompatibilityFormDialog({
    Key? key,
    this.compatibility,
    required this.onSave,
  }) : super(key: key);

  @override
  State<VehicleCompatibilityFormDialog> createState() =>
      _VehicleCompatibilityFormDialogState();
}

class _VehicleCompatibilityFormDialogState
    extends State<VehicleCompatibilityFormDialog> {
  late TextEditingController _manufacturerCtrl;
  late TextEditingController _modelCtrl;
  late TextEditingController _versionCtrl;
  late TextEditingController _yearStartCtrl;
  late TextEditingController _yearEndCtrl;
  late TextEditingController _motorizationCtrl;
  late TextEditingController _positionCtrl;
  late TextEditingController _plateCtrl;

  FuelType _fuel = FuelType.flex;

  @override
  void initState() {
    super.initState();
    _manufacturerCtrl =
        TextEditingController(text: widget.compatibility?.manufacturer ?? '');
    _modelCtrl = TextEditingController(text: widget.compatibility?.model ?? '');
    _versionCtrl =
        TextEditingController(text: widget.compatibility?.version ?? '');
    _yearStartCtrl = TextEditingController(
        text: '${widget.compatibility?.yearFrom ?? 2020}');
    _yearEndCtrl =
        TextEditingController(text: '${widget.compatibility?.yearTo ?? 2024}');
    _motorizationCtrl =
        TextEditingController(text: widget.compatibility?.motorization ?? '');
    _positionCtrl =
        TextEditingController(text: widget.compatibility?.mountPosition ?? '');
    _plateCtrl =
        TextEditingController(text: widget.compatibility?.licensePlate ?? '');
    _fuel = widget.compatibility?.fuelType ?? FuelType.flex;
  }

  @override
  void dispose() {
    _manufacturerCtrl.dispose();
    _modelCtrl.dispose();
    _versionCtrl.dispose();
    _yearStartCtrl.dispose();
    _yearEndCtrl.dispose();
    _motorizationCtrl.dispose();
    _positionCtrl.dispose();
    _plateCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: AppTheme.primaryColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '🚗 Compatibilidade Veicular',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          // Form
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle('Identificação do Veículo'),
                  TextFormField(
                    controller: _manufacturerCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Montadora/Fabricante *',
                      prefixIcon: Icon(Icons.business),
                      helperText: 'Ex: Fiat, Honda, Toyota, Volkswagen',
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _modelCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Modelo do Veículo *',
                      prefixIcon: Icon(Icons.directions_car),
                      helperText: 'Ex: Uno, Civic, Corolla',
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _versionCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Versão/Geração',
                      prefixIcon: Icon(Icons.label_outline),
                      helperText: 'Ex: 1.0 Fire, 1.5 16v, LX, EX',
                    ),
                  ),
                  const SizedBox(height: 16),
                  _sectionTitle('Período de Fabricação'),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _yearStartCtrl,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Ano Início *',
                            prefixIcon: Icon(Icons.calendar_month),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _yearEndCtrl,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Ano Fim *',
                            prefixIcon: Icon(Icons.calendar_month),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _sectionTitle('Especificações Técnicas'),
                  TextFormField(
                    controller: _motorizationCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Motorização *',
                      prefixIcon: Icon(Icons.settings),
                      helperText:
                          'Ex: 1.0, 1.4, 2.0, 2.5 L (cilindrada em litros)',
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<FuelType>(
                    value: _fuel,
                    decoration: const InputDecoration(
                      labelText: 'Combustível *',
                      prefixIcon: Icon(Icons.local_gas_station),
                    ),
                    items: FuelType.values
                        .map((e) => DropdownMenuItem(
                              value: e,
                              child: Text(e.label),
                            ))
                        .toList(),
                    onChanged: (v) {
                      if (v != null) setState(() => _fuel = v);
                    },
                  ),
                  const SizedBox(height: 16),
                  _sectionTitle('Localização da Peça'),
                  TextFormField(
                    controller: _positionCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Posição de Montagem',
                      prefixIcon: Icon(Icons.location_on),
                      helperText:
                          'Ex: Dianteiro Esquerdo, Traseiro Direito, Lado do Motor',
                    ),
                  ),
                  const SizedBox(height: 16),
                  _sectionTitle('Busca por Placa (Opcional)'),
                  TextFormField(
                    controller: _plateCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Formato de Placa',
                      prefixIcon: Icon(Icons.confirmation_number),
                      helperText:
                          'Para integração futura com consulta por placa (Tabela FIPE)',
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.green.withOpacity(0.2)),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.info, color: Colors.green, size: 20),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Adicione múltiplas aplicações para cobrir diferentes versões do mesmo modelo',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.green,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Botões
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.grey.shade200),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.check, color: Colors.white),
                  label: const Text('Adicionar',
                      style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.accentColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    widget.onSave(
                      VehicleCompatibility(
                        manufacturer: _manufacturerCtrl.text,
                        model: _modelCtrl.text,
                        version: _versionCtrl.text,
                        yearFrom: int.tryParse(_yearStartCtrl.text) ?? 2020,
                        yearTo: int.tryParse(_yearEndCtrl.text) ?? 2024,
                        motorization: _motorizationCtrl.text,
                        fuelType: _fuel,
                        mountPosition: _positionCtrl.text.isEmpty
                            ? null
                            : _positionCtrl.text,
                        licensePlate: _plateCtrl.text.isEmpty
                            ? null
                            : _plateCtrl.text,
                      ),
                    );
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
          color: AppTheme.primaryColor,
        ),
      ),
    );
  }
}

// Widget para exibir compatibilidades já adicionadas
class VehicleCompatibilityCard extends StatelessWidget {
  final VehicleCompatibility compatibility;
  final VoidCallback onDelete;

  const VehicleCompatibilityCard({
    Key? key,
    required this.compatibility,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.primaryColor.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${compatibility.manufacturer} ${compatibility.model}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${compatibility.version} • ${compatibility.yearFrom}-${compatibility.yearTo}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      '${compatibility.motorization}L',
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.accentColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        compatibility.fuelType.label,
                        style: TextStyle(
                          fontSize: 10,
                          color: AppTheme.accentColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
            onPressed: onDelete,
            splashRadius: 20,
          ),
        ],
      ),
    );
  }
}
