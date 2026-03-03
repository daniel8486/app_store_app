import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/seller_provider.dart';
import '../../../../core/theme/app_theme.dart';

class SellerProfileScreen extends ConsumerWidget {
  const SellerProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(sellerProfileProvider);

    return profileAsync.when(
      loading: () =>
          const Center(child: CircularProgressIndicator(color: AppTheme.primaryColor)),
      error: (e, _) => Center(child: Text('Erro: $e')),
      data: (profile) => _ProfileContent(profile: profile),
    );
  }
}

class _ProfileContent extends ConsumerWidget {
  final Map<String, dynamic> profile;

  const _ProfileContent({required this.profile});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        // ── Store header ──────────────────────────────────────────
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppTheme.primaryColor, Color(0xFF1E3A5F)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryColor.withOpacity(0.3),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: ClipOval(
                      child: Image.network(
                        profile['logo'] ??
                            'https://picsum.photos/seed/store/100',
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(
                          Icons.store,
                          color: Colors.white,
                          size: 44,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: AppTheme.accentColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.edit,
                          color: Colors.white, size: 14),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                profile['name'] ?? 'Sua Loja',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'CNPJ: ${profile['cnpj'] ?? '--'}',
                style:
                    const TextStyle(color: Colors.white70, fontSize: 12),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: Colors.green.withOpacity(0.5)),
                ),
                child: const Text(
                  '● Loja ativa',
                  style: TextStyle(
                    color: Colors.greenAccent,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),

        // ── Minha loja ────────────────────────────────────────────
        const _SectionLabel('MINHA LOJA'),
        _MenuItem(
          icon: Icons.store_outlined,
          label: 'Dados da loja',
          subtitle: 'Nome, e-mail, telefone, descrição',
          onTap: () => _showStoreInfoSheet(context, profile),
        ),
        _MenuItem(
          icon: Icons.schedule_outlined,
          label: 'Horário de atendimento',
          subtitle: 'Dias e horários de funcionamento',
          onTap: () => _showBusinessHoursSheet(context),
        ),
        _MenuItem(
          icon: Icons.policy_outlined,
          label: 'Políticas da loja',
          subtitle: 'Devoluções, trocas, garantias',
          onTap: () => _showPoliciesSheet(context),
        ),
        const SizedBox(height: 16),

        // ── Financeiro ────────────────────────────────────────────
        const _SectionLabel('FINANCEIRO'),
        _MenuItem(
          icon: Icons.bar_chart_outlined,
          label: 'Relatórios de vendas',
          subtitle: 'Performance por período',
          onTap: () => context.push('/seller/reports'),
        ),
        _MenuItem(
          icon: Icons.account_balance_wallet_outlined,
          label: 'Financeiro',
          subtitle: 'Saldo, transações e dados bancários',
          onTap: () => context.push('/seller/financial'),
        ),
        const SizedBox(height: 16),

        // ── Clientes ──────────────────────────────────────────────
        const _SectionLabel('CLIENTES'),
        _MenuItem(
          icon: Icons.star_outline,
          label: 'Avaliações dos produtos',
          subtitle: 'Notas e comentários dos clientes',
          onTap: () => context.push('/seller/reviews'),
        ),
        _MenuItem(
          icon: Icons.headset_mic_outlined,
          label: 'Central de ajuda',
          subtitle: 'Suporte e dúvidas da plataforma',
          onTap: () {},
        ),
        const SizedBox(height: 16),

        // ── Conta ─────────────────────────────────────────────────
        const _SectionLabel('CONTA'),
        _MenuItem(
          icon: Icons.lock_outline,
          label: 'Alterar senha',
          onTap: () => _showChangePasswordDialog(context),
        ),
        _MenuItem(
          icon: Icons.description_outlined,
          label: 'Termos de serviço',
          onTap: () {},
        ),
        const SizedBox(height: 20),

        // ── Logout ────────────────────────────────────────────────
        SizedBox(
          width: double.infinity,
          height: 50,
          child: OutlinedButton.icon(
            icon: const Icon(Icons.logout, color: Colors.red),
            label: const Text('Sair da loja',
                style: TextStyle(color: Colors.red)),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.red),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
            ),
            onPressed: () {
              ref.read(sellerIsLoggedInProvider.notifier).state = false;
              context.go('/home');
            },
          ),
        ),
        const SizedBox(height: 80),
      ],
    );
  }

  // ── Dialogs / Sheets ─────────────────────────────────────────────────────

  void _showStoreInfoSheet(
      BuildContext context, Map<String, dynamic> profile) {
    final nameCtrl =
        TextEditingController(text: profile['name'] ?? '');
    final emailCtrl =
        TextEditingController(text: profile['email'] ?? '');
    final phoneCtrl =
        TextEditingController(text: profile['phone'] ?? '');
    final descCtrl =
        TextEditingController(text: profile['description'] ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => Padding(
        padding: EdgeInsets.fromLTRB(24, 16, 24,
            MediaQuery.of(context).viewInsets.bottom + 24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Dados da loja',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(
                    labelText: 'Nome da loja',
                    prefixIcon: Icon(Icons.store_outlined)),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                    labelText: 'E-mail',
                    prefixIcon: Icon(Icons.email_outlined)),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: phoneCtrl,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                    labelText: 'Telefone',
                    prefixIcon: Icon(Icons.phone_outlined)),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descCtrl,
                maxLines: 3,
                decoration: const InputDecoration(
                    labelText: 'Descrição da loja',
                    prefixIcon: Icon(Icons.description_outlined)),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:
                            const Text('Dados atualizados com sucesso!'),
                        backgroundColor: Colors.green.shade700,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  child: const Text('SALVAR',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showBusinessHoursSheet(BuildContext context) {
    const days = [
      'Segunda', 'Terça', 'Quarta', 'Quinta',
      'Sexta', 'Sábado', 'Domingo'
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) {
        // Declared outside the StatefulBuilder builder so it persists across rebuilds
        final active = List.filled(7, true)..[5] = false..[6] = false;
        return StatefulBuilder(
        builder: (ctx, setState) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2)),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Horário de atendimento',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor),
                ),
                const SizedBox(height: 8),
                ...List.generate(
                  7,
                  (i) => SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(days[i],
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500)),
                    subtitle: active[i]
                        ? const Text('08:00 – 18:00',
                            style: TextStyle(fontSize: 12))
                        : const Text('Fechado',
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey)),
                    value: active[i],
                    activeColor: AppTheme.accentColor,
                    onChanged: (v) => setState(() => active[i] = v),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content:
                              const Text('Horários salvos com sucesso!'),
                          backgroundColor: Colors.green.shade700,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    child: const Text('SALVAR',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                  ),
                ),
              ],
            ),
          );
        },
        );
      },
    );
  }

  void _showPoliciesSheet(BuildContext context) {
    final returnCtrl = TextEditingController(
        text:
            'Aceitamos devoluções em até 7 dias corridos após o recebimento.');
    final warrantyCtrl = TextEditingController(
        text: 'Todos os produtos possuem garantia mínima de 90 dias.');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => Padding(
        padding: EdgeInsets.fromLTRB(24, 16, 24,
            MediaQuery.of(context).viewInsets.bottom + 24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Políticas da loja',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: returnCtrl,
                maxLines: 3,
                decoration: const InputDecoration(
                    labelText: 'Política de devoluções',
                    prefixIcon:
                        Icon(Icons.assignment_return_outlined)),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: warrantyCtrl,
                maxLines: 3,
                decoration: const InputDecoration(
                    labelText: 'Política de garantia',
                    prefixIcon: Icon(Icons.verified_outlined)),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Políticas salvas!'),
                        backgroundColor: Colors.green.shade700,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  child: const Text('SALVAR',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    final currentCtrl = TextEditingController();
    final newCtrl = TextEditingController();
    final confirmCtrl = TextEditingController();
    // Declared outside builder so they persist across rebuilds
    bool o1 = true, o2 = true, o3 = true;

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setState) {
          return AlertDialog(
            title: const Text('Alterar senha'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: currentCtrl,
                    obscureText: o1,
                    decoration: InputDecoration(
                      labelText: 'Senha atual',
                      suffixIcon: IconButton(
                        icon: Icon(o1
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: () => setState(() => o1 = !o1),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: newCtrl,
                    obscureText: o2,
                    decoration: InputDecoration(
                      labelText: 'Nova senha',
                      suffixIcon: IconButton(
                        icon: Icon(o2
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: () => setState(() => o2 = !o2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: confirmCtrl,
                    obscureText: o3,
                    decoration: InputDecoration(
                      labelText: 'Confirmar nova senha',
                      suffixIcon: IconButton(
                        icon: Icon(o3
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: () => setState(() => o3 = !o3),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar')),
              ElevatedButton(
                onPressed: () {
                  if (newCtrl.text != confirmCtrl.text) {
                    ScaffoldMessenger.of(ctx).showSnackBar(
                      const SnackBar(
                          content: Text('As senhas não coincidem')),
                    );
                    return;
                  }
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          const Text('Senha alterada com sucesso!'),
                      backgroundColor: Colors.green.shade700,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                child: const Text('Confirmar',
                    style: TextStyle(color: Colors.white)),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ─── SHARED WIDGETS ───────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade500,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? subtitle;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    const c = AppTheme.primaryColor;
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: c.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: c, size: 20),
          ),
          title: Text(label,
              style:
                  const TextStyle(fontWeight: FontWeight.w600, color: AppTheme.primaryColor)),
          subtitle: subtitle != null
              ? Text(subtitle!,
                  style: TextStyle(
                      fontSize: 11, color: Colors.grey.shade400))
              : null,
          trailing: Icon(Icons.chevron_right,
              color: Colors.grey.shade400),
          onTap: onTap,
        ),
        Divider(height: 1, color: Colors.grey.shade100),
      ],
    );
  }
}
