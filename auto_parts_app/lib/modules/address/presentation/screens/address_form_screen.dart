import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/address_provider.dart';
import '../../domain/entities/address.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/validators.dart';

class AddressFormScreen extends ConsumerStatefulWidget {
  final Address? existing;

  const AddressFormScreen({super.key, this.existing});

  @override
  ConsumerState<AddressFormScreen> createState() => _AddressFormScreenState();
}

class _AddressFormScreenState extends ConsumerState<AddressFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _label;
  late TextEditingController _zipCtrl;
  late TextEditingController _streetCtrl;
  late TextEditingController _numberCtrl;
  late TextEditingController _complementCtrl;
  late TextEditingController _neighborhoodCtrl;
  late TextEditingController _cityCtrl;
  late TextEditingController _stateCtrl;
  bool _isDefault = false;
  bool _loading = false;

  final _labels = ['Casa', 'Trabalho', 'Outro'];

  @override
  void initState() {
    super.initState();
    final a = widget.existing;
    _label = a?.label ?? 'Casa';
    _zipCtrl = TextEditingController(text: a?.zipCode ?? '');
    _streetCtrl = TextEditingController(text: a?.street ?? '');
    _numberCtrl = TextEditingController(text: a?.number ?? '');
    _complementCtrl = TextEditingController(text: a?.complement ?? '');
    _neighborhoodCtrl = TextEditingController(text: a?.neighborhood ?? '');
    _cityCtrl = TextEditingController(text: a?.city ?? '');
    _stateCtrl = TextEditingController(text: a?.state ?? '');
    _isDefault = a?.isDefault ?? false;
  }

  @override
  void dispose() {
    _zipCtrl.dispose();
    _streetCtrl.dispose();
    _numberCtrl.dispose();
    _complementCtrl.dispose();
    _neighborhoodCtrl.dispose();
    _cityCtrl.dispose();
    _stateCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      final notifier = ref.read(addressProvider.notifier);
      final address = Address(
        id: widget.existing?.id ?? '',
        label: _label,
        zipCode: _zipCtrl.text.replaceAll(RegExp(r'\D'), ''),
        street: _streetCtrl.text.trim(),
        number: _numberCtrl.text.trim(),
        complement: _complementCtrl.text.trim(),
        neighborhood: _neighborhoodCtrl.text.trim(),
        city: _cityCtrl.text.trim(),
        state: _stateCtrl.text.trim().toUpperCase(),
        isDefault: _isDefault,
      );

      if (widget.existing == null) {
        await notifier.add(address);
      } else {
        await notifier.update(address);
      }

      if (mounted) context.pop();
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existing != null;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(isEditing ? 'Editar endereço' : 'Novo endereço'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Label selector
              _buildCard('Identificação', [
                Row(
                  children: _labels.map((l) {
                    final selected = _label == l;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _label = l),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: EdgeInsets.only(
                              right: l == _labels.last ? 0 : 8),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: selected
                                ? AppTheme.primaryColor
                                : Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                l == 'Casa'
                                    ? Icons.home_outlined
                                    : l == 'Trabalho'
                                        ? Icons.work_outline
                                        : Icons.location_on_outlined,
                                size: 20,
                                color: selected
                                    ? Colors.white
                                    : Colors.grey.shade600,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                l,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: selected
                                      ? Colors.white
                                      : Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ]),
              const SizedBox(height: 16),

              // Address fields
              _buildCard('Endereço', [
                _field(_zipCtrl, 'CEP', Icons.pin_drop_outlined,
                    keyboard: TextInputType.number,
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Campo obrigatório';
                      if (v.replaceAll(RegExp(r'\D'), '').length != 8) {
                        return 'CEP inválido';
                      }
                      return null;
                    }),
                const SizedBox(height: 14),
                _field(_streetCtrl, 'Rua / Avenida', Icons.streetview,
                    validator: Validators.required),
                const SizedBox(height: 14),
                Row(
                  children: [
                    SizedBox(
                      width: 100,
                      child: _field(_numberCtrl, 'Número', Icons.tag,
                          keyboard: TextInputType.number,
                          validator: Validators.required),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _field(_complementCtrl, 'Complemento',
                          Icons.apartment_outlined),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                _field(_neighborhoodCtrl, 'Bairro', Icons.map_outlined,
                    validator: Validators.required),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: _field(_cityCtrl, 'Cidade', Icons.location_city,
                          validator: Validators.required),
                    ),
                    const SizedBox(width: 12),
                    SizedBox(
                      width: 80,
                      child: _field(_stateCtrl, 'UF', Icons.flag_outlined,
                          validator: (v) {
                        if (v == null || v.isEmpty) return 'Obrigatório';
                        if (v.trim().length != 2) return 'Ex: SP';
                        return null;
                      }),
                    ),
                  ],
                ),
              ]),
              const SizedBox(height: 16),

              // Default toggle
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 4),
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
                child: SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text(
                    'Definir como endereço padrão',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryColor,
                      fontSize: 14,
                    ),
                  ),
                  subtitle: Text(
                    'Usado automaticamente no checkout',
                    style:
                        TextStyle(color: Colors.grey.shade500, fontSize: 12),
                  ),
                  value: _isDefault,
                  activeColor: AppTheme.accentColor,
                  onChanged: (v) => setState(() => _isDefault = v),
                ),
              ),
              const SizedBox(height: 24),

              SizedBox(
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
                      : Text(
                          isEditing ? 'SALVAR ALTERAÇÕES' : 'ADICIONAR ENDEREÇO',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(String title, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(16),
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
          Text(title,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: AppTheme.primaryColor)),
          const SizedBox(height: 14),
          ...children,
        ],
      ),
    );
  }

  Widget _field(
    TextEditingController ctrl,
    String label,
    IconData icon, {
    TextInputType? keyboard,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: ctrl,
      keyboardType: keyboard,
      textInputAction: TextInputAction.next,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
      ),
    );
  }
}
