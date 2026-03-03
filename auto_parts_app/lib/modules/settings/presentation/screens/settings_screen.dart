import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../settings/presentation/providers/settings_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final preferences = ref.watch(userPreferencesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Configurações',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Color(0xFF0D1B2A),
        elevation: 1,
      ),
      body: ListView(
        children: [
          // Notifications Section
          _buildSectionHeader('Notificações'),
          _buildToggleTile(
            title: 'Notificações Push',
            subtitle: 'Receba atualizações de pedidos e promoções',
            value: preferences.pushNotifications,
            onChanged: (value) {
              ref
                  .read(userPreferencesProvider.notifier)
                  .updatePushNotifications(value);
            },
          ),
          _buildToggleTile(
            title: 'Notificações por Email',
            subtitle: 'Receba informações importantes via email',
            value: preferences.emailNotifications,
            onChanged: (value) {
              ref
                  .read(userPreferencesProvider.notifier)
                  .updateEmailNotifications(value);
            },
          ),
          _buildToggleTile(
            title: 'Notificações por SMS',
            subtitle: 'Receba atualizações críticas por SMS',
            value: preferences.smsNotifications,
            onChanged: (value) {
              ref
                  .read(userPreferencesProvider.notifier)
                  .updateSmsNotifications(value);
            },
          ),
          Divider(height: 24, indent: 16, endIndent: 16),

          // Newsletter Section
          _buildSectionHeader('Newsletters e Promoções'),
          _buildToggleTile(
            title: 'Receber Newsletter',
            subtitle: 'Fique atualizado com nossas promoções e novidades',
            value: preferences.allowNewsletters,
            onChanged: (value) {
              ref
                  .read(userPreferencesProvider.notifier)
                  .updateAllowNewsletters(value);
            },
          ),
          Divider(height: 24, indent: 16, endIndent: 16),

          // Privacy Section
          _buildSectionHeader('Privacidade'),
          _buildToggleTile(
            title: 'Perfil Público',
            subtitle: 'Permita que outros usuários vejam seu perfil',
            value: preferences.showProfile,
            onChanged: (value) {
              ref
                  .read(userPreferencesProvider.notifier)
                  .updateShowProfile(value);
            },
          ),
          _buildToggleTile(
            title: 'Histórico de Compras Visível',
            subtitle:
                'Permita que seu histórico de compras seja visto (com sua permissão)',
            value: preferences.showPurchaseHistory,
            onChanged: (value) {
              ref
                  .read(userPreferencesProvider.notifier)
                  .updateShowPurchaseHistory(value);
            },
          ),
          Divider(height: 24, indent: 16, endIndent: 16),

          // Appearance Section
          _buildSectionHeader('Aparência'),
          _buildDropdownTile(
            title: 'Tema',
            subtitle: 'Escolha o tema do aplicativo',
            value: preferences.theme,
            options: {
              'auto': 'Automático',
              'light': 'Claro',
              'dark': 'Escuro',
            },
            onChanged: (value) {
              if (value != null) {
                ref.read(userPreferencesProvider.notifier).updateTheme(value);
              }
            },
          ),
          _buildDropdownTile(
            title: 'Idioma',
            subtitle: 'Escolha seu idioma preferido',
            value: preferences.language,
            options: {
              'pt_BR': 'Português (Brasil)',
              'en': 'English',
              'es': 'Español',
            },
            onChanged: (value) {
              if (value != null) {
                ref
                    .read(userPreferencesProvider.notifier)
                    .updateLanguage(value);
              }
            },
          ),
          Divider(height: 24, indent: 16, endIndent: 16),

          // Account Section
          _buildSectionHeader('Conta'),
          _buildActionTile(
            icon: Icons.security_outlined,
            title: 'Alterar Senha',
            subtitle: 'Atualize sua senha com frequência',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Navegando para alteração de senha...')),
              );
            },
          ),
          _buildActionTile(
            icon: Icons.download_outlined,
            title: 'Exportar Dados',
            subtitle: 'Baixe seus dados pessoais em formato JSON',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Preparando download dos dados...')),
              );
            },
          ),
          Divider(height: 24, indent: 16, endIndent: 16),

          // Danger Zone
          _buildSectionHeader('Zona de Perigo'),
          _buildActionTile(
            icon: Icons.restore,
            title: 'Restaurar Padrões',
            subtitle: 'Restaurar todas as configurações para o padrão',
            titleColor: Colors.orange,
            onTap: () {
              _showConfirmDialog(
                context,
                'Restaurar Padrões?',
                'Todas as suas configurações serão restauradas para o padrão.',
                () {
                  ref.read(userPreferencesProvider.notifier).resetToDefaults();
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Configurações restauradas')),
                  );
                },
              );
            },
          ),
          _buildActionTile(
            icon: Icons.delete_outline,
            title: 'Deletar Conta',
            subtitle: 'Remover sua conta e todos os dados associados',
            titleColor: Colors.red,
            onTap: () {
              _showConfirmDialog(
                context,
                'Deletar Conta?',
                'Esta ação é irreversível. Todos os seus dados serão removidos permanentemente.',
                () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Solicitação de exclusão enviada')),
                  );
                },
              );
            },
          ),
          SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Color(0xFFF3722C),
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildToggleTile({
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 12),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Color(0xFFF3722C),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    );
  }

  Widget _buildDropdownTile({
    required String title,
    required String subtitle,
    required String value,
    required Map<String, String> options,
    required Function(String?) onChanged,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
          SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              underline: SizedBox(),
              padding: EdgeInsets.symmetric(horizontal: 12),
              items: options.entries
                  .map((e) => DropdownMenuItem(
                        value: e.key,
                        child: Text(e.value),
                      ))
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? titleColor,
  }) {
    return ListTile(
      leading: Icon(icon, color: titleColor ?? Color(0xFF0D1B2A)),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: titleColor,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 12),
      ),
      trailing: Icon(Icons.chevron_right, color: Colors.grey.shade400),
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    );
  }

  void _showConfirmDialog(
    BuildContext context,
    String title,
    String message,
    VoidCallback onConfirm,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: onConfirm,
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text('Confirmar'),
          ),
        ],
      ),
    );
  }
}
