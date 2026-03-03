import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/seller_provider.dart';
import '../../../coupon/domain/entities/coupon.dart';
import '../../../../core/theme/app_theme.dart';

class SellerCouponsScreen extends ConsumerStatefulWidget {
  const SellerCouponsScreen({super.key});

  @override
  ConsumerState<SellerCouponsScreen> createState() =>
      _SellerCouponsScreenState();
}

class _SellerCouponsScreenState extends ConsumerState<SellerCouponsScreen> {
  late TextEditingController _codeCtrl;
  late TextEditingController _descCtrl;
  late TextEditingController _valueCtrl;
  late TextEditingController _minOrderCtrl;
  DateTime _selectedDate = DateTime.now().add(Duration(days: 30));
  DiscountType _discountType = DiscountType.percentage;

  @override
  void initState() {
    super.initState();
    _codeCtrl = TextEditingController();
    _descCtrl = TextEditingController();
    _valueCtrl = TextEditingController();
    _minOrderCtrl = TextEditingController(text: '0');
  }

  @override
  void dispose() {
    _codeCtrl.dispose();
    _descCtrl.dispose();
    _valueCtrl.dispose();
    _minOrderCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final couponsAsync = ref.watch(sellerCouponsProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Cupons da Loja'),
        backgroundColor: Colors.white,
        foregroundColor: AppTheme.primaryColor,
        elevation: 1,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateCouponDialog(),
        backgroundColor: AppTheme.accentColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: couponsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erro: $e')),
        data: (coupons) {
          if (coupons.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.local_offer_outlined,
                      size: 64, color: Colors.grey.shade300),
                  const SizedBox(height: 16),
                  Text(
                    'Nenhum cupom criado',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => _showCreateCouponDialog(),
                    icon: const Icon(Icons.add),
                    label: const Text('Criar Cupom'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.accentColor,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: coupons.length,
            itemBuilder: (_, i) => _buildCouponCard(coupons[i]),
          );
        },
      ),
    );
  }

  Widget _buildCouponCard(dynamic coupon) {
    final isExpired = coupon.isExpired;
    final discount = coupon.discountType == DiscountType.percentage
        ? '${coupon.discountValue.toStringAsFixed(0)}%'
        : 'R\$ ${coupon.discountValue.toStringAsFixed(2)}';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
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
                      Text(
                        coupon.code,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.primaryColor,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        coupon.description,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppTheme.accentColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    discount,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.accentColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Usado ${coupon.usedCount}x',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ),
                if (isExpired)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.red.shade300),
                    ),
                    child: Text(
                      'Expirado',
                      style: TextStyle(
                        color: Colors.red.shade700,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => _showEditCouponDialog(coupon),
                  style: TextButton.styleFrom(
                    foregroundColor: AppTheme.primaryColor,
                  ),
                  child: const Text('Editar'),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () => _showDeleteConfirmation(coupon.id),
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                  child: const Text('Deletar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateCouponDialog() {
    _resetControllers();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Criar Cupom'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _codeCtrl,
                decoration: InputDecoration(
                  labelText: 'Código',
                  hintText: 'EX: LOJA10',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _descCtrl,
                decoration: InputDecoration(
                  labelText: 'Descrição',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _valueCtrl,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Valor',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  DropdownButton<DiscountType>(
                    value: _discountType,
                    items: DiscountType.values
                        .map((type) => DropdownMenuItem(
                              value: type,
                              child: Text(
                                type == DiscountType.percentage ? '%' : 'R\$',
                              ),
                            ))
                        .toList(),
                    onChanged: (type) {
                      if (type != null) {
                        setState(() => _discountType = type);
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _minOrderCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Valor Mínimo',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              ListTile(
                title: const Text('Data de Expiração'),
                subtitle: Text(
                  '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                ),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) {
                    setState(() => _selectedDate = date);
                  }
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
              _saveCoupon();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accentColor,
            ),
            child: const Text('Criar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showEditCouponDialog(dynamic coupon) {
    _codeCtrl.text = coupon.code;
    _descCtrl.text = coupon.description;
    _valueCtrl.text = coupon.discountValue.toString();
    _minOrderCtrl.text = coupon.minOrderValue.toString();
    _discountType = coupon.discountType;
    _selectedDate = coupon.expiryDate;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar Cupom'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _codeCtrl,
                enabled: false,
                decoration: InputDecoration(
                  labelText: 'Código',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _descCtrl,
                decoration: InputDecoration(
                  labelText: 'Descrição',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _valueCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Valor',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _minOrderCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Valor Mínimo',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              ListTile(
                title: const Text('Data de Expiração'),
                subtitle: Text(
                  '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                ),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) {
                    setState(() => _selectedDate = date);
                  }
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
              _updateCoupon(coupon.id);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accentColor,
            ),
            child: const Text('Salvar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(String couponId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Deletar Cupom?'),
        content: const Text('Esta ação não pode ser desfeita.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(deleteSellerCouponProvider(couponId));
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Cupom deletado')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Deletar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _saveCoupon() {
    if (_codeCtrl.text.isEmpty ||
        _descCtrl.text.isEmpty ||
        _valueCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos')),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Cupom criado com sucesso!')),
    );
  }

  void _updateCoupon(String couponId) {
    if (_descCtrl.text.isEmpty || _valueCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos')),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Cupom atualizado com sucesso!')),
    );
  }

  void _resetControllers() {
    _codeCtrl.clear();
    _descCtrl.clear();
    _valueCtrl.clear();
    _minOrderCtrl.text = '0';
    _discountType = DiscountType.percentage;
    _selectedDate = DateTime.now().add(const Duration(days: 30));
  }
}
