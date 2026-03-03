import 'package:flutter/material.dart';
import '../../../coupon/domain/entities/coupon.dart';

class CouponCard extends StatelessWidget {
  final Coupon coupon;
  final VoidCallback? onTap;
  final bool isSelected;
  final VoidCallback? onRemove;

  const CouponCard({
    Key? key,
    required this.coupon,
    this.onTap,
    this.isSelected = false,
    this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected ? Color(0xFFF3722C) : Colors.grey.shade300,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: !coupon.isValid ? null : onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Code and Badge
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          coupon.code,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0D1B2A),
                            letterSpacing: 1,
                          ),
                        ),
                        SizedBox(height: 4),
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
                  if (isSelected)
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Color(0xFFF3722C),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Selecionado',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: 12),

              // Discount display
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Color(0xFFF3722C).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _getDiscountText(),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFF3722C),
                  ),
                ),
              ),
              SizedBox(height: 12),

              // Additional info
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (coupon.minOrderValue > 0)
                          Text(
                            'Mín: R\$ ${coupon.minOrderValue.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        SizedBox(height: 4),
                        Text(
                          'Expira: ${_formatDate(coupon.expiryDate)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: coupon.isExpired
                                ? Colors.red
                                : Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!coupon.isValid)
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(20),
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

              // Remove button (if selected)
              if (isSelected && onRemove != null) ...[
                SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: onRemove,
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.red,
                    ),
                    child: Text('Remover cupom'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _getDiscountText() {
    switch (coupon.discountType) {
      case DiscountType.percentage:
        return '${coupon.discountValue.toStringAsFixed(0)}% de desconto';
      case DiscountType.fixed:
        return 'R\$ ${coupon.discountValue.toStringAsFixed(2)} de desconto';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
