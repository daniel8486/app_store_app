import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/validators.dart';
import '../providers/auth_provider.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _cpfCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmPassCtrl = TextEditingController();
  bool _loading = false;
  bool _obscure = true;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _cpfCtrl.dispose();
    _passCtrl.dispose();
    _confirmPassCtrl.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      await ref.read(currentUserProvider.notifier).register(
            name: _nameCtrl.text.trim(),
            email: _emailCtrl.text.trim(),
            phone: _phoneCtrl.text,
            cpf: _cpfCtrl.text,
            password: _passCtrl.text,
          );
      if (mounted) context.go('/home');
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
      appBar: AppBar(
        title: const Text(
          'Criar conta',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryColor,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _Field(
                controller: _nameCtrl,
                label: 'Nome completo',
                icon: Icons.person_outline,
                validator: Validators.required,
                action: TextInputAction.next,
              ),
              const SizedBox(height: 16),
              _Field(
                controller: _emailCtrl,
                label: 'E-mail',
                icon: Icons.email_outlined,
                keyboard: TextInputType.emailAddress,
                validator: Validators.email,
                action: TextInputAction.next,
              ),
              const SizedBox(height: 16),
              _Field(
                controller: _phoneCtrl,
                label: 'Telefone',
                icon: Icons.phone_outlined,
                keyboard: TextInputType.phone,
                validator: Validators.phone,
                action: TextInputAction.next,
              ),
              const SizedBox(height: 16),
              _Field(
                controller: _cpfCtrl,
                label: 'CPF',
                icon: Icons.badge_outlined,
                keyboard: TextInputType.number,
                validator: Validators.cpf,
                action: TextInputAction.next,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passCtrl,
                obscureText: _obscure,
                textInputAction: TextInputAction.next,
                validator: Validators.password,
                decoration: InputDecoration(
                  labelText: 'Senha',
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscure ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () => setState(() => _obscure = !_obscure),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _confirmPassCtrl,
                obscureText: _obscure,
                textInputAction: TextInputAction.done,
                validator: Validators.confirmPassword(_passCtrl.text),
                decoration: const InputDecoration(
                  labelText: 'Confirmar senha',
                  prefixIcon: Icon(Icons.lock_outline),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _loading ? null : _register,
                  child: _loading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text('CADASTRAR'),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => context.pop(),
                child: const Text(
                  'Já tenho conta',
                  style: TextStyle(color: AppTheme.primaryColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final TextInputType? keyboard;
  final String? Function(String?)? validator;
  final TextInputAction? action;

  const _Field({
    required this.controller,
    required this.label,
    required this.icon,
    this.keyboard,
    this.validator,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboard,
      textInputAction: action,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
      ),
    );
  }
}
