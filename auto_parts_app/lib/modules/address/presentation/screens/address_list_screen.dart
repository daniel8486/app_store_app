import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/address_provider.dart';
import '../../domain/entities/address.dart';
import '../../../../core/theme/app_theme.dart';

class AddressListScreen extends ConsumerWidget {
  const AddressListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addressAsync = ref.watch(addressProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(title: const Text('Meus endereços')),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppTheme.accentColor,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Novo endereço',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        onPressed: () => context.push('/profile/addresses/new'),
      ),
      body: addressAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erro: $e')),
        data: (addresses) {
          if (addresses.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.08),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.location_off_outlined,
                        size: 40, color: AppTheme.primaryColor),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Nenhum endereço salvo',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Adicione um endereço de entrega',
                    style:
                        TextStyle(color: Colors.grey.shade500, fontSize: 13),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
            itemCount: addresses.length,
            itemBuilder: (_, i) => _AddressCard(address: addresses[i]),
          );
        },
      ),
    );
  }
}

class _AddressCard extends ConsumerWidget {
  final Address address;

  const _AddressCard({required this.address});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(addressProvider.notifier);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: address.isDefault
            ? Border.all(color: AppTheme.accentColor, width: 1.5)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: address.isDefault
                        ? AppTheme.accentColor
                        : AppTheme.primaryColor.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _labelIcon(address.label),
                        size: 12,
                        color: address.isDefault
                            ? Colors.white
                            : AppTheme.primaryColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        address.label,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: address.isDefault
                              ? Colors.white
                              : AppTheme.primaryColor,
                        ),
                      ),
                      if (address.isDefault) ...[
                        const SizedBox(width: 4),
                        const Text(
                          '• Padrão',
                          style: TextStyle(
                              fontSize: 10,
                              color: Colors.white,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ],
                  ),
                ),
                const Spacer(),
                PopupMenuButton<String>(
                  icon: Icon(Icons.more_vert, color: Colors.grey.shade400),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  onSelected: (action) async {
                    if (action == 'edit') {
                      context.push('/profile/addresses/${address.id}',
                          extra: address);
                    } else if (action == 'default') {
                      await notifier.update(address.copyWith(isDefault: true));
                    } else if (action == 'delete') {
                      final confirm = await _confirmDelete(context);
                      if (confirm == true) {
                        await notifier.delete(address.id);
                      }
                    }
                  },
                  itemBuilder: (_) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(children: [
                        Icon(Icons.edit_outlined, size: 18),
                        SizedBox(width: 8),
                        Text('Editar'),
                      ]),
                    ),
                    if (!address.isDefault)
                      const PopupMenuItem(
                        value: 'default',
                        child: Row(children: [
                          Icon(Icons.star_outline, size: 18),
                          SizedBox(width: 8),
                          Text('Definir como padrão'),
                        ]),
                      ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(children: [
                        Icon(Icons.delete_outline,
                            size: 18, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Excluir',
                            style: TextStyle(color: Colors.red)),
                      ]),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              '${address.street}, ${address.number}${address.complement.isNotEmpty ? ' - ${address.complement}' : ''}',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              '${address.neighborhood} · ${address.city}/${address.state}',
              style:
                  TextStyle(color: Colors.grey.shade600, fontSize: 13),
            ),
            Text(
              'CEP: ${_maskCep(address.zipCode)}',
              style:
                  TextStyle(color: Colors.grey.shade400, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  IconData _labelIcon(String label) {
    switch (label) {
      case 'Casa':
        return Icons.home_outlined;
      case 'Trabalho':
        return Icons.work_outline;
      default:
        return Icons.location_on_outlined;
    }
  }

  String _maskCep(String cep) {
    final digits = cep.replaceAll(RegExp(r'\D'), '');
    if (digits.length == 8) {
      return '${digits.substring(0, 5)}-${digits.substring(5)}';
    }
    return cep;
  }

  Future<bool?> _confirmDelete(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Excluir endereço'),
        content: const Text('Tem certeza que deseja remover este endereço?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade700),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Excluir',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
