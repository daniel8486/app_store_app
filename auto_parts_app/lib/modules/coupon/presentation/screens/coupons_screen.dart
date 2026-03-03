import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../coupon/domain/entities/coupon.dart';
import '../../../coupon/presentation/providers/coupon_provider.dart';
import '../../../coupon/presentation/widgets/coupon_card.dart';

class CouponsScreen extends ConsumerStatefulWidget {
  const CouponsScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<CouponsScreen> createState() => _CouponsScreenState();
}

class _CouponsScreenState extends ConsumerState<CouponsScreen> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final couponsAsyncValue = ref.watch(availableCouponsProvider);
    final selectedCoupon = ref.watch(selectedCouponProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cupons Disponíveis',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Color(0xFF0D1B2A),
        elevation: 1,
      ),
      body: Column(
        children: [
          // Search/Input for coupon code
          Padding(
            padding: EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Ou insira seu código de cupom',
                prefixIcon:
                    Icon(Icons.local_offer_outlined, color: Color(0xFFF3722C)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Color(0xFFF3722C), width: 2),
                ),
              ),
              onSubmitted: (value) {
                _validateCoupon(value);
              },
            ),
          ),

          // Coupons List
          Expanded(
            child: couponsAsyncValue.when(
              data: (coupons) {
                if (coupons.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.local_offer_outlined,
                          size: 64,
                          color: Colors.grey.shade300,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Nenhum cupom disponível',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  itemCount: coupons.length,
                  itemBuilder: (context, index) {
                    final coupon = coupons[index];
                    final isSelected = selectedCoupon?.id == coupon.id;

                    return CouponCard(
                      coupon: coupon,
                      isSelected: isSelected,
                      onTap: () {
                        ref.read(selectedCouponProvider.notifier).state =
                            isSelected ? null : coupon;
                      },
                      onRemove: isSelected
                          ? () {
                              ref.read(selectedCouponProvider.notifier).state =
                                  null;
                            }
                          : null,
                    );
                  },
                );
              },
              loading: () => Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(
                child: Text('Erro ao carregar cupons: $err'),
              ),
            ),
          ),

          // Bottom action buttons
          if (selectedCoupon != null)
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Colors.grey.shade200)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Cupom selecionado: ${selectedCoupon.code}',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0D1B2A),
                    ),
                  ),
                  SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context, selectedCoupon);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFF3722C),
                        padding: EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Aplicar Cupom',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
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

  void _validateCoupon(String code) {
    if (code.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Digite um código de cupom')),
      );
      return;
    }

    // Aqui você poderia validar o cupom contra a API
    ref.read(validateCouponProvider(code).future).then((coupon) {
      if (coupon != null) {
        ref.read(selectedCouponProvider.notifier).state = coupon;
        _searchController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Cupom "${coupon.code}" adicionado!')),
        );
      }
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$error'),
          backgroundColor: Colors.red,
        ),
      );
    });
  }
}
