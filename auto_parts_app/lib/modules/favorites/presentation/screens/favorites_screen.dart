import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/favorites_provider.dart';
import '../../../catalog/presentation/providers/catalog_provider.dart';
import '../../../catalog/presentation/widgets/part_card.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).value;

    if (user == null) {
      WidgetsBinding.instance
          .addPostFrameCallback((_) => Navigator.of(context).pop());
      return const SizedBox.shrink();
    }

    final favoriteIds = ref.watch(favoritesProvider);
    final allParts = ref.watch(allPartsProvider);
    final favoriteParts =
        allParts.where((p) => favoriteIds.contains(p.id)).toList();

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Favoritos'),
        actions: [
          if (favoriteParts.isNotEmpty)
            TextButton.icon(
              icon: const Icon(Icons.delete_sweep_outlined,
                  color: Colors.red, size: 18),
              label: const Text('Limpar',
                  style: TextStyle(color: Colors.red, fontSize: 12)),
              onPressed: () => _confirmClearAll(context, ref),
            ),
        ],
      ),
      body: favoriteParts.isEmpty
          ? _EmptyFavorites(onBrowse: () => context.pop())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: Row(
                    children: [
                      const Icon(Icons.favorite,
                          color: AppTheme.accentColor, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        '${favoriteParts.length} ${favoriteParts.length == 1 ? 'peça salva' : 'peças salvas'}',
                        style: const TextStyle(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.72,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                    ),
                    itemCount: favoriteParts.length,
                    itemBuilder: (_, i) => PartCard(part: favoriteParts[i]),
                  ),
                ),
              ],
            ),
    );
  }

  void _confirmClearAll(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Limpar favoritos'),
        content:
            const Text('Deseja remover todas as peças dos favoritos?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(context);
              final ids = ref.read(favoritesProvider).toList();
              for (final id in ids) {
                ref.read(favoritesProvider.notifier).toggle(id);
              }
            },
            child: const Text('Limpar tudo'),
          ),
        ],
      ),
    );
  }
}

// ─── EMPTY STATE ───────────────────────────────────────────────────────────────

class _EmptyFavorites extends StatelessWidget {
  final VoidCallback onBrowse;

  const _EmptyFavorites({required this.onBrowse});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppTheme.accentColor.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.favorite_border,
                  size: 52, color: AppTheme.accentColor),
            ),
            const SizedBox(height: 24),
            const Text(
              'Nenhum favorito ainda',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor),
            ),
            const SizedBox(height: 8),
            const Text(
              'Toque no coração de qualquer peça\npara salvá-la aqui.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 28),
            SizedBox(
              height: 50,
              child: ElevatedButton.icon(
                onPressed: onBrowse,
                icon: const Icon(Icons.search, color: Colors.white),
                label: const Text('Explorar peças',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
