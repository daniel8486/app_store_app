import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/seller_provider.dart';
import '../../../auth/data/repositories/auth_repository.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/validators.dart';

class SellerLoginScreen extends ConsumerStatefulWidget {
  const SellerLoginScreen({super.key});

  @override
  ConsumerState<SellerLoginScreen> createState() => _SellerLoginScreenState();
}

class _SellerLoginScreenState extends ConsumerState<SellerLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController(text: 'loja@autopecas.com');
  final _passCtrl = TextEditingController(text: '123456');
  bool _loading = false;
  bool _obscure = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      final repo = AuthRepository();
      final user = await repo.login(_emailCtrl.text.trim(), _passCtrl.text);
      if (!user.isSeller) throw Exception('Esta conta não é de lojista');
      ref.read(sellerIsLoggedInProvider.notifier).state = true;
      if (mounted) context.go('/seller/dashboard');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.red.shade700,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(title: const Text('Área do lojista')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),

              // Icon
              Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.08),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.store,
                    size: 40,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Acesso restrito\nàrea do lojista',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: AppTheme.primaryColor,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 36),

              TextFormField(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                validator: Validators.email,
                decoration: const InputDecoration(
                  labelText: 'E-mail',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passCtrl,
                obscureText: _obscure,
                textInputAction: TextInputAction.done,
                validator: Validators.password,
                onFieldSubmitted: (_) => _login(),
                decoration: InputDecoration(
                  labelText: 'Senha',
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                        _obscure ? Icons.visibility_off : Icons.visibility),
                    onPressed: () => setState(() => _obscure = !_obscure),
                  ),
                ),
              ),
              const SizedBox(height: 28),

              SizedBox(
                height: 55,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.store, color: Colors.white),
                  label: _loading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'ACESSAR PAINEL',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.accentColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: _loading ? null : _login,
                ),
              ),
              const SizedBox(height: 20),

              // Test credentials hint
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline,
                            size: 14, color: Colors.grey.shade500),
                        const SizedBox(width: 6),
                        Text(
                          'Conta de teste',
                          style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 12,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'loja@autopecas.com / 123456',
                      style: TextStyle(
                          color: Colors.grey.shade600, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
