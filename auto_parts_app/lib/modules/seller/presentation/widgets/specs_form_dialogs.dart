import 'package:flutter/material.dart';
import '../../../catalog/domain/entities/product.dart';
import '../../../../core/theme/app_theme.dart';

class OilSpecsFormDialog extends StatefulWidget {
  final OilSpecs? specs;
  final Function(OilSpecs) onSave;

  const OilSpecsFormDialog({
    Key? key,
    this.specs,
    required this.onSave,
  }) : super(key: key);

  @override
  State<OilSpecsFormDialog> createState() => _OilSpecsFormDialogState();
}

class _OilSpecsFormDialogState extends State<OilSpecsFormDialog> {
  late TextEditingController _saeCtrl;
  late TextEditingController _apiCtrl;
  late TextEditingController _aceaCtrl;
  late TextEditingController _jasoCtrl;
  late TextEditingController _anpRegistryCtrl;

  OilChemicalBase _base = OilChemicalBase.synthetic;

  @override
  void initState() {
    super.initState();
    _saeCtrl = TextEditingController(text: widget.specs?.sapGrade ?? '');
    _apiCtrl = TextEditingController(text: widget.specs?.apiNorm ?? '');
    _aceaCtrl = TextEditingController(text: widget.specs?.aceaNorm ?? '');
    _jasoCtrl = TextEditingController(text: widget.specs?.jasonNorm ?? '');
    _anpRegistryCtrl =
        TextEditingController(text: widget.specs?.anpRegistry ?? '');
    _base = widget.specs?.chemicalBase ?? OilChemicalBase.synthetic;
  }

  @override
  void dispose() {
    _saeCtrl.dispose();
    _apiCtrl.dispose();
    _aceaCtrl.dispose();
    _jasoCtrl.dispose();
    _anpRegistryCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Especificações de Óleo Lubrificante'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Classificação SAE',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
            const SizedBox(height: 4),
            TextFormField(
              controller: _saeCtrl,
              decoration: const InputDecoration(
                hintText: 'Ex: 10W-40, 5W-30',
                prefixIcon: Icon(Icons.info),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Classificação API',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
            const SizedBox(height: 4),
            TextFormField(
              controller: _apiCtrl,
              decoration: const InputDecoration(
                hintText: 'Ex: SN, SM, SL',
                prefixIcon: Icon(Icons.label),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Especificações ACEA',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
            const SizedBox(height: 4),
            TextFormField(
              controller: _aceaCtrl,
              decoration: const InputDecoration(
                hintText: 'Ex: A3/B3, A3/B4',
                prefixIcon: Icon(Icons.assignment),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Classificação JASO',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
            const SizedBox(height: 4),
            TextFormField(
              controller: _jasoCtrl,
              decoration: const InputDecoration(
                hintText: 'Ex: MA, MA2',
                prefixIcon: Icon(Icons.tag),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Base Química',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
            const SizedBox(height: 8),
            SegmentedButton<OilChemicalBase>(
              segments: OilChemicalBase.values
                  .map(
                    (e) => ButtonSegment(
                      value: e,
                      label: Text(e.label),
                    ),
                  )
                  .toList(),
              selected: {_base},
              onSelectionChanged: (Set<OilChemicalBase> newSelection) {
                setState(() => _base = newSelection.first);
              },
            ),
            const SizedBox(height: 12),
            const Text(
              'Registro ANP',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
            const SizedBox(height: 4),
            TextFormField(
              controller: _anpRegistryCtrl,
              decoration: const InputDecoration(
                hintText: 'Número de registro ANP',
                prefixIcon: Icon(Icons.verified),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onSave(
              OilSpecs(
                sapGrade: _saeCtrl.text,
                chemicalBase: _base,
                apiNorm: _apiCtrl.text,
                aceaNorm: _aceaCtrl.text.isEmpty ? null : _aceaCtrl.text,
                jasonNorm: _jasoCtrl.text.isEmpty ? null : _jasoCtrl.text,
                anpRegistry:
                    _anpRegistryCtrl.text.isEmpty ? null : _anpRegistryCtrl.text,
              ),
            );
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.accentColor,
          ),
          child: const Text('Salvar', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}

class BatterySpecsFormDialog extends StatefulWidget {
  final BatterySpecs? specs;
  final Function(BatterySpecs) onSave;

  const BatterySpecsFormDialog({
    Key? key,
    this.specs,
    required this.onSave,
  }) : super(key: key);

  @override
  State<BatterySpecsFormDialog> createState() => _BatterySpecsFormDialogState();
}

class _BatterySpecsFormDialogState extends State<BatterySpecsFormDialog> {
  late TextEditingController _ampCtrl;
  late TextEditingController _ccaCtrl;
  bool _polarityRight = true; // true = positivo à direita
  BatteryTechnology _tech = BatteryTechnology.sli;

  @override
  void initState() {
    super.initState();
    _ampCtrl =
        TextEditingController(text: '${widget.specs?.amperageAh ?? ''}');
    _ccaCtrl =
        TextEditingController(text: '${widget.specs?.ccaColdStart ?? ''}');
    _polarityRight = widget.specs?.polarityRight ?? true;
    _tech = widget.specs?.technology ?? BatteryTechnology.sli;
  }

  @override
  void dispose() {
    _ampCtrl.dispose();
    _ccaCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Especificações de Bateria'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Amperagem (Ah)',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
            const SizedBox(height: 4),
            TextFormField(
              controller: _ampCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'Ex: 50, 70, 100',
                prefixIcon: Icon(Icons.electric_bolt),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Corrente de Partida (CCA)',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
            const SizedBox(height: 4),
            TextFormField(
              controller: _ccaCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'Ex: 500, 600, 700',
                prefixIcon: Icon(Icons.bolt),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Polaridade',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
            const SizedBox(height: 4),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                _polarityRight ? 'Positivo à Direita' : 'Positivo à Esquerda',
                style: const TextStyle(fontSize: 13),
              ),
              value: _polarityRight,
              onChanged: (v) => setState(() => _polarityRight = v),
            ),
            const Text(
              'Tecnologia de Bateria',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
            const SizedBox(height: 8),
            SegmentedButton<BatteryTechnology>(
              segments: BatteryTechnology.values
                  .map(
                    (e) => ButtonSegment(
                      value: e,
                      label: Text(e.label),
                    ),
                  )
                  .toList(),
              selected: {_tech},
              onSelectionChanged: (Set<BatteryTechnology> newSelection) {
                setState(() => _tech = newSelection.first);
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onSave(
              BatterySpecs(
                amperageAh: int.tryParse(_ampCtrl.text) ?? 0,
                ccaColdStart: int.tryParse(_ccaCtrl.text) ?? 0,
                polarityRight: _polarityRight,
                technology: _tech,
              ),
            );
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.accentColor,
          ),
          child: const Text('Salvar', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}

class TireSpecsFormDialog extends StatefulWidget {
  final TireSpecs? specs;
  final Function(TireSpecs) onSave;

  const TireSpecsFormDialog({
    Key? key,
    this.specs,
    required this.onSave,
  }) : super(key: key);

  @override
  State<TireSpecsFormDialog> createState() => _TireSpecsFormDialogState();
}

class _TireSpecsFormDialogState extends State<TireSpecsFormDialog> {
  late TextEditingController _measureCtrl;
  late TextEditingController _loadIndexCtrl;
  late TextEditingController _speedIndexCtrl;
  late TextEditingController _dotCodeCtrl;
  late TextEditingController _fireNumberCtrl;

  @override
  void initState() {
    super.initState();
    _measureCtrl =
        TextEditingController(text: widget.specs?.nominalMeasure ?? '');
    _loadIndexCtrl =
        TextEditingController(text: widget.specs?.loadIndex ?? '');
    _speedIndexCtrl =
        TextEditingController(text: widget.specs?.speedIndex ?? '');
    _dotCodeCtrl = TextEditingController(text: widget.specs?.dotCode ?? '');
    _fireNumberCtrl =
        TextEditingController(text: widget.specs?.fireNumber ?? '');
  }

  @override
  void dispose() {
    _measureCtrl.dispose();
    _loadIndexCtrl.dispose();
    _speedIndexCtrl.dispose();
    _dotCodeCtrl.dispose();
    _fireNumberCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Especificações de Pneu'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Medida Nominal',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
            const SizedBox(height: 4),
            TextFormField(
              controller: _measureCtrl,
              decoration: const InputDecoration(
                hintText: 'Ex: 175/65R14, 215/55R17',
                prefixIcon: Icon(Icons.format_size),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Índice de Carga',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
            const SizedBox(height: 4),
            TextFormField(
              controller: _loadIndexCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'Ex: 82, 96, 110',
                prefixIcon: Icon(Icons.format_list_numbered_outlined),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Índice de Velocidade',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
            const SizedBox(height: 4),
            TextFormField(
              controller: _speedIndexCtrl,
              decoration: const InputDecoration(
                hintText: 'Ex: H (210km/h), V (240km/h)',
                prefixIcon: Icon(Icons.speed),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Código DOT',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
            const SizedBox(height: 4),
            TextFormField(
              controller: _dotCodeCtrl,
              decoration: const InputDecoration(
                hintText: 'Ex: ABC1424 (ano 24)',
                prefixIcon: Icon(Icons.qr_code),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Número de Incêndio (Fire Number)',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
            const SizedBox(height: 4),
            TextFormField(
              controller: _fireNumberCtrl,
              decoration: const InputDecoration(
                hintText: 'Número da fornalha',
                prefixIcon: Icon(Icons.local_fire_department),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onSave(
              TireSpecs(
                nominalMeasure: _measureCtrl.text,
                loadIndex: _loadIndexCtrl.text,
                speedIndex: _speedIndexCtrl.text,
                dotCode: _dotCodeCtrl.text.isEmpty ? null : _dotCodeCtrl.text,
                fireNumber:
                    _fireNumberCtrl.text.isEmpty ? null : _fireNumberCtrl.text,
              ),
            );
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.accentColor,
          ),
          child: const Text('Salvar', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}

class TransmissionKitSpecsFormDialog extends StatefulWidget {
  final TransmissionKitSpecs? specs;
  final Function(TransmissionKitSpecs) onSave;

  const TransmissionKitSpecsFormDialog({
    Key? key,
    this.specs,
    required this.onSave,
  }) : super(key: key);

  @override
  State<TransmissionKitSpecsFormDialog> createState() =>
      _TransmissionKitSpecsFormDialogState();
}

class _TransmissionKitSpecsFormDialogState
    extends State<TransmissionKitSpecsFormDialog> {
  late TextEditingController _stepCtrl;
  late TextEditingController _pinionCtrl;
  late TextEditingController _crownCtrl;
  bool _hasORing = false;

  @override
  void initState() {
    super.initState();
    _stepCtrl =
        TextEditingController(text: widget.specs?.chainStep ?? '');
    _pinionCtrl =
        TextEditingController(text: '${widget.specs?.pinion ?? ''}');
    _crownCtrl =
        TextEditingController(text: '${widget.specs?.crown ?? ''}');
    _hasORing = widget.specs?.hasORing ?? false;
  }

  @override
  void dispose() {
    _stepCtrl.dispose();
    _pinionCtrl.dispose();
    _crownCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Especificações de Kit Transmissão'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Passo da Corrente',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
            const SizedBox(height: 4),
            TextFormField(
              controller: _stepCtrl,
              decoration: const InputDecoration(
                hintText: 'Ex: 520, 525, 530',
                prefixIcon: Icon(Icons.link),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Número de Dentes do Pinhão',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
            const SizedBox(height: 4),
            TextFormField(
              controller: _pinionCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'Ex: 15, 16, 17',
                prefixIcon: Icon(Icons.settings_outlined),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Número de Dentes da Coroa',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
            const SizedBox(height: 4),
            TextFormField(
              controller: _crownCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'Ex: 45, 48, 50',
                prefixIcon: Icon(Icons.brightness_5),
              ),
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text(
                'Possui O-Ring / X-Ring',
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 12),
              ),
              subtitle: Text(
                _hasORing ? 'Com vedação O-Ring' : 'Sem O-Ring',
                style: const TextStyle(fontSize: 11),
              ),
              value: _hasORing,
              onChanged: (v) => setState(() => _hasORing = v),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onSave(
              TransmissionKitSpecs(
                chainStep: _stepCtrl.text,
                pinion: int.tryParse(_pinionCtrl.text) ?? 0,
                crown: int.tryParse(_crownCtrl.text) ?? 0,
                hasORing: _hasORing,
              ),
            );
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.accentColor,
          ),
          child: const Text('Salvar', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
