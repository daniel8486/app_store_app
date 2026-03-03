import 'package:flutter/material.dart';
import '../../../catalog/domain/entities/product.dart';
import '../../../../core/theme/app_theme.dart';
import 'vehicle_compatibility_form.dart';
import 'specs_form_dialogs.dart';

// ── Local enum for specs category selection ───────────────────────────────────
enum _SpecsType { general, oil, battery, tire, transmissionKit }

extension _SpecsTypeExt on _SpecsType {
  String get label {
    switch (this) {
      case _SpecsType.general:
        return 'Selecionar categoria';
      case _SpecsType.oil:
        return 'Óleo / Lubrificante';
      case _SpecsType.battery:
        return 'Bateria';
      case _SpecsType.tire:
        return 'Pneu';
      case _SpecsType.transmissionKit:
        return 'Kit Transmissão';
    }
  }
}

class ProductFormDialog extends StatefulWidget {
  final Product? product;
  final Function(Product) onSave;

  const ProductFormDialog({
    Key? key,
    this.product,
    required this.onSave,
  }) : super(key: key);

  @override
  State<ProductFormDialog> createState() => _ProductFormDialogState();
}

class _ProductFormDialogState extends State<ProductFormDialog>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _formKey = GlobalKey<FormState>();

  // ── Tab 1: Identificação ──────────────────────────────────────────────────
  late TextEditingController _nameCtrl;
  late TextEditingController _skuCtrl;
  late TextEditingController _gtinCtrl;
  late TextEditingController _partNumberCtrl;
  late TextEditingController _oemCodeCtrl;
  late TextEditingController _brandCtrl;
  late TextEditingController _priceCtrl;
  late TextEditingController _stockCtrl;
  QualityRanking _qualityRanking = QualityRanking.aftermarket;

  // ── Tab 2: Compatibilidade ────────────────────────────────────────────────
  final List<VehicleCompatibility> _compatibilities = [];

  // ── Tab 3: Fiscal ─────────────────────────────────────────────────────────
  bool _monofasica = false;
  MerchandiseOrigin _origin = MerchandiseOrigin.national;

  // ── Tab 4: Especificações ─────────────────────────────────────────────────
  _SpecsType _specsCategory = _SpecsType.general;

  // ── Tab 5: Logística ──────────────────────────────────────────────────────
  late TextEditingController _locationCtrl;
  late TextEditingController _minStockCtrl;
  late TextEditingController _maxStockCtrl;
  late TextEditingController _leadTimeCtrl;
  late TextEditingController _weightCtrl;
  late TextEditingController _lengthCtrl;
  late TextEditingController _widthCtrl;
  late TextEditingController _heightCtrl;
  late TextEditingController _inmetroCtrl;

  // ── Tab 6: E-commerce ─────────────────────────────────────────────────────
  late TextEditingController _seoTitleCtrl;
  late TextEditingController _descriptionCtrl;
  late TextEditingController _keywordsCtrl;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this)
      ..addListener(() => setState(() {}));

    final p = widget.product;
    _nameCtrl = TextEditingController(text: p?.name ?? '');
    _skuCtrl = TextEditingController(text: p?.sku ?? '');
    _gtinCtrl = TextEditingController(text: p?.gtin ?? '');
    _partNumberCtrl = TextEditingController(text: p?.partNumber ?? '');
    _oemCodeCtrl = TextEditingController(text: p?.oemCode ?? '');
    _brandCtrl = TextEditingController(text: p?.brand ?? '');
    _priceCtrl = TextEditingController(text: '${p?.price ?? ''}');
    _stockCtrl = TextEditingController(text: '${p?.currentStock ?? ''}');
    _qualityRanking = p?.qualityRanking ?? QualityRanking.aftermarket;
    _origin = p?.origin ?? MerchandiseOrigin.national;

    _locationCtrl = TextEditingController(text: p?.physicalLocation ?? '');
    _minStockCtrl = TextEditingController(text: '${p?.minimumStock ?? 5}');
    _maxStockCtrl = TextEditingController(text: '${p?.maximumStock ?? 50}');
    _leadTimeCtrl = TextEditingController(text: '${p?.leadTimeDays ?? 7}');
    _weightCtrl = TextEditingController(text: '${p?.weight ?? ''}');
    _lengthCtrl = TextEditingController(text: '${p?.length ?? ''}');
    _widthCtrl = TextEditingController(text: '${p?.width ?? ''}');
    _heightCtrl = TextEditingController(text: '${p?.height ?? ''}');
    _inmetroCtrl = TextEditingController(text: p?.inmetroRegistry ?? '');

    _seoTitleCtrl = TextEditingController(text: p?.seoTitle ?? '');
    _descriptionCtrl = TextEditingController(text: p?.description ?? '');
    _keywordsCtrl = TextEditingController(text: p?.keywords.join(', ') ?? '');
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nameCtrl.dispose();
    _skuCtrl.dispose();
    _gtinCtrl.dispose();
    _partNumberCtrl.dispose();
    _oemCodeCtrl.dispose();
    _brandCtrl.dispose();
    _priceCtrl.dispose();
    _stockCtrl.dispose();
    _locationCtrl.dispose();
    _minStockCtrl.dispose();
    _maxStockCtrl.dispose();
    _leadTimeCtrl.dispose();
    _weightCtrl.dispose();
    _lengthCtrl.dispose();
    _widthCtrl.dispose();
    _heightCtrl.dispose();
    _inmetroCtrl.dispose();
    _seoTitleCtrl.dispose();
    _descriptionCtrl.dispose();
    _keywordsCtrl.dispose();
    super.dispose();
  }

  // ── Labels and icons for each tab ─────────────────────────────────────────
  static const _tabLabels = [
    'Identificação',
    'Compatibilidade',
    'Fiscal',
    'Especificações',
    'Logística',
    'E-commerce',
  ];
  static const _tabIcons = [
    Icons.assignment_outlined,
    Icons.directions_car_outlined,
    Icons.receipt_long_outlined,
    Icons.settings_outlined,
    Icons.local_shipping_outlined,
    Icons.shopping_bag_outlined,
  ];

  @override
  Widget build(BuildContext context) {
    final currentStep = _tabController.index;
    final isEditing = widget.product != null;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // ── Drag handle ─────────────────────────────────────────────────
          Container(
            width: 44,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // ── Gradient header ──────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.fromLTRB(20, 16, 16, 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.primaryColor,
                  AppTheme.primaryColor.withOpacity(0.82),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryColor.withOpacity(0.18),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    _tabIcons[currentStep],
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isEditing ? 'Editar Produto' : 'Novo Produto',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Passo ${currentStep + 1} de 6 · ${_tabLabels[currentStep]}',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.78),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                  tooltip: 'Cancelar',
                ),
              ],
            ),
          ),

          // ── Step progress dots ───────────────────────────────────────────
          Container(
            color: AppTheme.primaryColor.withOpacity(0.04),
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(6, (i) {
                final done = i < currentStep;
                final active = i == currentStep;
                return GestureDetector(
                  onTap: () => _tabController.animateTo(i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: active ? 28 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: active
                          ? AppTheme.accentColor
                          : done
                              ? AppTheme.primaryColor.withOpacity(0.4)
                              : Colors.grey.shade300,
                    ),
                  ),
                );
              }),
            ),
          ),

          // ── Scrollable tab bar ───────────────────────────────────────────
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade200),
              ),
            ),
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              indicatorSize: TabBarIndicatorSize.label,
              indicator: UnderlineTabIndicator(
                borderSide: const BorderSide(
                  color: AppTheme.accentColor,
                  width: 3,
                ),
                insets: const EdgeInsets.symmetric(horizontal: -4),
              ),
              labelColor: AppTheme.accentColor,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
              unselectedLabelColor: Colors.grey.shade500,
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
              tabs: List.generate(
                  6,
                  (i) => Tab(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(_tabIcons[i], size: 14),
                            const SizedBox(width: 5),
                            Text(_tabLabels[i]),
                          ],
                        ),
                      )),
            ),
          ),

          // ── Tab content ──────────────────────────────────────────────────
          Expanded(
            child: Form(
              key: _formKey,
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildTab1Identification(),
                  _buildTab2Compatibility(),
                  _buildTab3Fiscal(),
                  _buildTab4Specifications(),
                  _buildTab5Logistics(),
                  _buildTab6Ecommerce(),
                ],
              ),
            ),
          ),

          // ── Footer ───────────────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Colors.grey.shade200),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                // Cancel
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.grey.shade600,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 12),
                  ),
                  child: const Text('Cancelar'),
                ),
                const Spacer(),
                // Previous
                if (currentStep > 0)
                  OutlinedButton.icon(
                    onPressed: () => _tabController.animateTo(currentStep - 1),
                    icon: const Icon(Icons.arrow_back, size: 16),
                    label: const Text('Anterior'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.primaryColor,
                      side: BorderSide(color: Colors.grey.shade300),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 12),
                    ),
                  ),
                const SizedBox(width: 10),
                // Next or Save
                if (currentStep < 5)
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 150),
                    child: ElevatedButton.icon(
                      onPressed: () =>
                          _tabController.animateTo(currentStep + 1),
                      icon: const Icon(Icons.arrow_forward, size: 16),
                      label: const Text('Próximo'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  )
                else
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 200),
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.check_circle_outline, size: 18),
                      label: const Text('Salvar produto'),
                      onPressed: _saveProduct,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.accentColor,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── TAB 1: IDENTIFICAÇÃO ───────────────────────────────────────────────────
  Widget _buildTab1Identification() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Dados principais', Icons.inventory_2_outlined),
          TextFormField(
            controller: _nameCtrl,
            decoration: _input(
              label: 'Nome do produto *',
              icon: Icons.inventory_2_outlined,
            ),
            validator: (v) =>
                v?.trim().isEmpty ?? true ? 'Campo obrigatório' : null,
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _skuCtrl,
                  decoration: _input(
                    label: 'SKU *',
                    icon: Icons.qr_code_2_outlined,
                    hint: 'Ex: PAST-TOY-001',
                  ),
                  validator: (v) =>
                      v?.trim().isEmpty ?? true ? 'Campo obrigatório' : null,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  controller: _gtinCtrl,
                  decoration: _input(
                    label: 'GTIN / EAN *',
                    icon: Icons.barcode_reader,
                    hint: '13 dígitos',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (v) =>
                      v?.trim().isEmpty ?? true ? 'Campo obrigatório' : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: _partNumberCtrl,
            decoration: _input(
              label: 'Part Number (fabricante) *',
              icon: Icons.tag_outlined,
              hint: 'Ex: BP1234, 0986AB1234',
              helper: 'Referência do fabricante da peça',
            ),
            validator: (v) =>
                v?.trim().isEmpty ?? true ? 'Campo obrigatório' : null,
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: _oemCodeCtrl,
            decoration: _input(
              label: 'Código OEM (montadora)',
              icon: Icons.confirmation_number_outlined,
              hint: 'Ex: 1K0 615 107',
              helper: 'Código original do fabricante do veículo (opcional)',
            ),
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: _brandCtrl,
            decoration: _input(
              label: 'Marca / Fabricante *',
              icon: Icons.business_outlined,
              hint: 'Ex: Bosch, Nakata, LUK',
            ),
            validator: (v) =>
                v?.trim().isEmpty ?? true ? 'Campo obrigatório' : null,
          ),
          const SizedBox(height: 20),
          _sectionTitle('Qualidade', Icons.star_outline),
          DropdownButtonFormField<QualityRanking>(
            value: _qualityRanking,
            decoration: _input(
              label: 'Ranking de qualidade *',
              icon: Icons.workspace_premium_outlined,
            ),
            items: QualityRanking.values
                .map((e) => DropdownMenuItem(value: e, child: Text(e.label)))
                .toList(),
            onChanged: (v) {
              if (v != null) setState(() => _qualityRanking = v);
            },
          ),
        ],
      ),
    );
  }

  // ── TAB 2: COMPATIBILIDADE ─────────────────────────────────────────────────
  Widget _buildTab2Compatibility() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Aplicações veiculares', Icons.directions_car_outlined),

          // Info banner
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.shade100),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline, color: Colors.blue.shade400, size: 18),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    'Adicione todos os veículos compatíveis com esta peça. '
                    'Cada aplicação pode ter versão, motorização, combustível e posição distintos.',
                    style: TextStyle(fontSize: 12, color: Colors.black87),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // List of added compatibilities
          if (_compatibilities.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.grey.shade200,
                  style: BorderStyle.solid,
                ),
              ),
              child: Column(
                children: [
                  Icon(Icons.directions_car_outlined,
                      size: 40, color: Colors.grey.shade400),
                  const SizedBox(height: 10),
                  Text(
                    'Nenhuma aplicação cadastrada',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Adicione os veículos compatíveis abaixo',
                    style: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            )
          else ...[
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${_compatibilities.length} aplicação(ões)',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ..._compatibilities.asMap().entries.map((entry) {
              return VehicleCompatibilityCard(
                compatibility: entry.value,
                onDelete: () =>
                    setState(() => _compatibilities.removeAt(entry.key)),
              );
            }),
          ],
          const SizedBox(height: 16),

          // Add button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.add_circle_outline, size: 18),
              label: const Text('Adicionar aplicação veicular'),
              onPressed: _showAddVehicleDialog,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accentColor,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          const SizedBox(height: 14),
          // Compatibility guide
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.green.shade100),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.checklist_outlined,
                        color: Colors.green.shade600, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      'Dados necessários por aplicação',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ...[
                  'Montadora (ex: Fiat, Honda, Toyota)',
                  'Modelo e versão/geração',
                  'Ano de início e fim',
                  'Motorização (cilindrada)',
                  'Combustível (Flex, Diesel, etc.)',
                  'Posição de montagem (Diant. Esq., etc.)',
                ].map(
                  (t) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.check_circle_outline,
                            size: 13, color: Colors.green.shade500),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(t, style: const TextStyle(fontSize: 11)),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── TAB 3: FISCAL ──────────────────────────────────────────────────────────
  Widget _buildTab3Fiscal() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Codificação fiscal', Icons.receipt_long_outlined),
          TextFormField(
            initialValue: widget.product?.ncm ?? '',
            decoration: _input(
              label: 'NCM *',
              icon: Icons.list_alt_outlined,
              hint: '8 dígitos',
              helper: 'Nomenclatura Comum Mercosul — define tributação federal',
              counterText: '',
            ),
            maxLength: 8,
            keyboardType: TextInputType.number,
            validator: (v) {
              if (v?.trim().isEmpty ?? true) return 'Campo obrigatório';
              if (v!.trim().length != 8) return 'NCM deve ter 8 dígitos';
              return null;
            },
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  initialValue: widget.product?.cst ?? '',
                  decoration: _input(
                    label: 'CST / CSOSN *',
                    icon: Icons.code_outlined,
                    hint: 'Ex: 000, 102',
                  ),
                  validator: (v) =>
                      v?.trim().isEmpty ?? true ? 'Campo obrigatório' : null,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  initialValue: widget.product?.cfop ?? '',
                  decoration: _input(
                    label: 'CFOP *',
                    icon: Icons.swap_horiz_outlined,
                    hint: 'Ex: 5102, 6102',
                  ),
                  validator: (v) =>
                      v?.trim().isEmpty ?? true ? 'Campo obrigatório' : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          TextFormField(
            initialValue: widget.product?.cest ?? '',
            decoration: _input(
              label: 'CEST (substituição tributária)',
              icon: Icons.receipt_outlined,
              hint: 'Ex: 01.001.00',
              helper: 'Deixe vazio se não se aplica',
            ),
          ),
          const SizedBox(height: 14),
          // Monofásica toggle
          Container(
            decoration: BoxDecoration(
              color: _monofasica
                  ? AppTheme.primaryColor.withOpacity(0.05)
                  : Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _monofasica
                    ? AppTheme.primaryColor.withOpacity(0.25)
                    : Colors.grey.shade200,
              ),
            ),
            child: SwitchListTile(
              value: _monofasica,
              activeColor: AppTheme.primaryColor,
              onChanged: (v) => setState(() => _monofasica = v),
              title: const Text(
                'Tributação Monofásica',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: const Text(
                'PIS/COFINS recolhido na fonte (alíquota zero)',
                style: TextStyle(fontSize: 11),
              ),
            ),
          ),
          const SizedBox(height: 20),
          _sectionTitle('Origem da mercadoria', Icons.public_outlined),
          DropdownButtonFormField<MerchandiseOrigin>(
            value: _origin,
            decoration: _input(
              label: 'Origem *',
              icon: Icons.flight_land_outlined,
            ),
            items: MerchandiseOrigin.values
                .map((e) => DropdownMenuItem(value: e, child: Text(e.label)))
                .toList(),
            onChanged: (v) {
              if (v != null) setState(() => _origin = v);
            },
          ),
        ],
      ),
    );
  }

  // ── TAB 4: ESPECIFICAÇÕES ──────────────────────────────────────────────────
  Widget _buildTab4Specifications() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(
              'Especificações técnicas', Icons.settings_suggest_outlined),

          // Category picker
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Categoria do produto',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade600,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _SpecsType.values.map((cat) {
                    final selected = _specsCategory == cat;
                    return GestureDetector(
                      onTap: () => setState(() => _specsCategory = cat),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: selected ? AppTheme.accentColor : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: selected
                                ? AppTheme.accentColor
                                : Colors.grey.shade300,
                          ),
                          boxShadow: selected
                              ? [
                                  BoxShadow(
                                    color:
                                        AppTheme.accentColor.withOpacity(0.3),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  )
                                ]
                              : null,
                        ),
                        child: Text(
                          cat.label,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color:
                                selected ? Colors.white : Colors.grey.shade700,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Context message per category
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.green.shade100),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.lightbulb_outline,
                    color: Colors.green.shade600, size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    _specsHintFor(_specsCategory),
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Open specs dialog button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.tune_outlined, size: 18),
              label: Text('Preencher especificações: ${_specsCategory.label}'),
              onPressed: _specsCategory == _SpecsType.general
                  ? null
                  : _showSpecsDialog,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade600,
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.grey.shade200,
                disabledForegroundColor: Colors.grey.shade500,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          if (_specsCategory == _SpecsType.general)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                'Selecione uma categoria acima para habilitar o formulário de especificações.',
                style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
              ),
            ),
        ],
      ),
    );
  }

  // ── TAB 5: LOGÍSTICA ────────────────────────────────────────────────────────
  Widget _buildTab5Logistics() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Localização no estoque', Icons.inventory_2_outlined),
          TextFormField(
            controller: _locationCtrl,
            decoration: _input(
              label: 'Localização física *',
              icon: Icons.location_on_outlined,
              hint: 'Ex: Corredor A4, Prateleira 3',
              helper: 'Facilita a separação do pedido',
            ),
            validator: (v) =>
                v?.trim().isEmpty ?? true ? 'Campo obrigatório' : null,
          ),
          const SizedBox(height: 20),
          _sectionTitle('Controle de estoque', Icons.inventory_outlined),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _minStockCtrl,
                  decoration: _input(
                    label: 'Estoque mínimo',
                    icon: Icons.warning_amber_outlined,
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  controller: _maxStockCtrl,
                  decoration: _input(
                    label: 'Estoque máximo',
                    icon: Icons.check_circle_outline,
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: _leadTimeCtrl,
            decoration: _input(
              label: 'Lead time (dias)',
              icon: Icons.schedule_outlined,
              hint: 'Ex: 7',
              helper: 'Prazo médio de reabastecimento do fornecedor',
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 20),
          _sectionTitle('Dimensões e peso', Icons.straighten),
          TextFormField(
            controller: _weightCtrl,
            decoration: _input(
              label: 'Peso (kg)',
              icon: Icons.scale,
              hint: 'Ex: 0.350',
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _lengthCtrl,
                  decoration:
                      _input(label: 'Comp. (cm)', icon: Icons.straighten),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  controller: _widthCtrl,
                  decoration:
                      _input(label: 'Larg. (cm)', icon: Icons.swap_horiz),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  controller: _heightCtrl,
                  decoration: _input(label: 'Alt. (cm)', icon: Icons.height),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: _inmetroCtrl,
            decoration: _input(
              label: 'Registro Inmetro',
              icon: Icons.verified_outlined,
              helper: 'Obrigatório para componentes de segurança',
            ),
          ),
        ],
      ),
    );
  }

  // ── TAB 6: E-COMMERCE ──────────────────────────────────────────────────────
  Widget _buildTab6Ecommerce() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Preço e disponibilidade', Icons.attach_money),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _priceCtrl,
                  decoration: _input(
                    label: 'Preço de venda *',
                    icon: Icons.attach_money,
                    hint: '0,00',
                  ),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  validator: (v) =>
                      v?.trim().isEmpty ?? true ? 'Campo obrigatório' : null,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  controller: _stockCtrl,
                  decoration: _input(
                    label: 'Estoque atual *',
                    icon: Icons.inventory_2_outlined,
                    hint: '0',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (v) =>
                      v?.trim().isEmpty ?? true ? 'Campo obrigatório' : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _sectionTitle('SEO e descrição', Icons.search_outlined),
          TextFormField(
            controller: _seoTitleCtrl,
            decoration: _input(
              label: 'Título SEO',
              icon: Icons.title_outlined,
              hint: 'Ex: Pastilha Freio Toyota Corolla 2015–2019',
              helper: 'Máximo 100 caracteres',
            ),
            maxLength: 100,
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: _descriptionCtrl,
            decoration: _input(
              label: 'Descrição do produto',
              icon: Icons.description_outlined,
            ),
            maxLines: 4,
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: _keywordsCtrl,
            decoration: _input(
              label: 'Palavras-chave',
              icon: Icons.tag_outlined,
              hint: 'pastilha, freio, toyota, corolla',
              helper: 'Separe por vírgula',
            ),
          ),
          const SizedBox(height: 20),
          _sectionTitle('Imagens', Icons.photo_library_outlined),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.grey.shade200,
                style: BorderStyle.solid,
              ),
            ),
            child: Column(
              children: [
                Icon(Icons.add_photo_alternate_outlined,
                    size: 40, color: Colors.grey.shade400),
                const SizedBox(height: 10),
                Text(
                  '${widget.product?.imageUrls.length ?? 0} imagem(ns) adicionada(s)',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  icon: const Icon(Icons.add_a_photo_outlined, size: 18),
                  label: const Text('Selecionar imagens'),
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.primaryColor,
                    side: BorderSide(color: Colors.grey.shade400),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'PNG ou JPG · até 5MB por imagem · máx. 8 fotos',
                  style: TextStyle(fontSize: 10, color: Colors.grey.shade400),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Helpers ─────────────────────────────────────────────────────────────────

  Widget _sectionTitle(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 16, color: AppTheme.primaryColor),
          ),
          const SizedBox(width: 10),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: AppTheme.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _input({
    required String label,
    required IconData icon,
    String? hint,
    String? helper,
    String? counterText,
  }) {
    return InputDecoration(
      counterText: counterText,
      labelText: label,
      labelStyle: TextStyle(
        color: Colors.grey.shade600,
        fontWeight: FontWeight.w500,
        fontSize: 14,
      ),
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
      helperText: helper,
      helperMaxLines: 2,
      prefixIcon: Icon(icon, size: 19, color: Colors.grey.shade500),
      filled: true,
      fillColor: Colors.grey.shade50,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppTheme.primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
    );
  }

  String _specsHintFor(_SpecsType cat) {
    switch (cat) {
      case _SpecsType.oil:
        return 'Preencha: SAE, base química (sintético/semi), API, ACEA, JASO e registro ANP.';
      case _SpecsType.battery:
        return 'Preencha: amperagem (Ah), corrente de partida (CCA), polaridade e tecnologia da bateria.';
      case _SpecsType.tire:
        return 'Preencha: medida nominal, índice de carga, índice de velocidade, código DOT e número de incêndio.';
      case _SpecsType.transmissionKit:
        return 'Preencha: passo da corrente, dentes do pinhão, dentes da coroa e tipo de O-ring.';
      default:
        return 'Selecione uma categoria para ver quais especificações são necessárias.';
    }
  }

  void _showAddVehicleDialog() {
    showDialog(
      context: context,
      builder: (_) => VehicleCompatibilityFormDialog(
        onSave: (vc) => setState(() => _compatibilities.add(vc)),
      ),
    );
  }

  void _showSpecsDialog() {
    switch (_specsCategory) {
      case _SpecsType.oil:
        showDialog(
          context: context,
          builder: (_) => OilSpecsFormDialog(onSave: (_) {}),
        );
        break;
      case _SpecsType.battery:
        showDialog(
          context: context,
          builder: (_) => BatterySpecsFormDialog(onSave: (_) {}),
        );
        break;
      case _SpecsType.tire:
        showDialog(
          context: context,
          builder: (_) => TireSpecsFormDialog(onSave: (_) {}),
        );
        break;
      case _SpecsType.transmissionKit:
        showDialog(
          context: context,
          builder: (_) => TransmissionKitSpecsFormDialog(onSave: (_) {}),
        );
        break;
      default:
        break;
    }
  }

  void _saveProduct() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Produto salvo com sucesso!'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.pop(context);
    } else {
      _tabController.animateTo(0);
    }
  }
}

// ── BulletPoint (kept for backward compatibility) ─────────────────────────────
class BulletPoint extends StatelessWidget {
  final String text;
  const BulletPoint(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 16)),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
