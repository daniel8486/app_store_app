import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/catalog_provider.dart';
import '../widgets/part_card.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../cart/presentation/providers/cart_provider.dart';
import '../../../order/presentation/screens/order_list_screen.dart';
import '../../../../core/theme/app_theme.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _searchCtrl = TextEditingController();
  int _selectedIndex = 0;

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _showSearchDialog() {
    final searchCtrl = TextEditingController();
    searchCtrl.text = _searchCtrl.text;
    final suggestions = [
      'Pastilha freio',
      'Óleo motor',
      'Bateria automotiva',
      'Pneu',
      'Correia distribuição',
      'Filtro ar'
    ];

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header compacto
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.primaryColor,
                        AppTheme.primaryColor.withOpacity(0.85),
                      ],
                    ),
                  ),
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.search,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Buscar Peça',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Encontre a peça que você procura',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.white.withOpacity(0.7),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Conteúdo
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: StatefulBuilder(
                    builder: (context, setDialogState) => Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // TextField
                        TextField(
                          controller: searchCtrl,
                          autofocus: true,
                          onChanged: (v) {
                            setDialogState(() {});
                          },
                          style: const TextStyle(fontSize: 15),
                          decoration: InputDecoration(
                            hintText: 'Ex: Pastilha freio, Óleo motor...',
                            hintStyle: TextStyle(
                              color: Colors.grey.shade400,
                              fontSize: 13,
                            ),
                            prefixIcon: Icon(
                              Icons.search,
                              color: AppTheme.primaryColor,
                              size: 20,
                            ),
                            suffixIcon: searchCtrl.text.isNotEmpty
                                ? IconButton(
                                    icon: Icon(
                                      Icons.close_rounded,
                                      color: AppTheme.primaryColor,
                                      size: 20,
                                    ),
                                    onPressed: () {
                                      searchCtrl.clear();
                                      setDialogState(() {});
                                    },
                                  )
                                : null,
                            filled: true,
                            fillColor: Colors.grey.shade50,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                                width: 1,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                                width: 1,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: AppTheme.primaryColor,
                                width: 2,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 12,
                            ),
                          ),
                        ),

                        // Sugestões
                        if (searchCtrl.text.isEmpty) ...[
                          const SizedBox(height: 14),
                          Text(
                            'Buscas populares',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: suggestions
                                .map((sugg) => GestureDetector(
                                      onTap: () {
                                        searchCtrl.text = sugg;
                                        setDialogState(() {});
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 5,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade100,
                                          borderRadius:
                                              BorderRadius.circular(18),
                                          border: Border.all(
                                            color: Colors.grey.shade300,
                                            width: 0.5,
                                          ),
                                        ),
                                        child: Text(
                                          sugg,
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.grey.shade700,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ))
                                .toList(),
                          ),
                        ],

                        const SizedBox(height: 16),

                        // Botões
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => Navigator.pop(context),
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(
                                    color: AppTheme.primaryColor,
                                    width: 1.5,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text(
                                  'Cancelar',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.primaryColor,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  _searchCtrl.text = searchCtrl.text;
                                  ref
                                      .read(searchFilterProvider.notifier)
                                      .updateQuery(searchCtrl.text);
                                  Navigator.pop(context);
                                  setState(() => _selectedIndex = 0);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.primaryColor,
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text(
                                  'Buscar',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomTabs() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 0, 25, 30),
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          color: const Color(0xFF0D1B2A),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _navItem(Icons.directions_car, _selectedIndex == 0, onTap: () {
              setState(() => _selectedIndex = 0);
            }),
            _navItem(Icons.search, false, onTap: () {
              _showSearchDialog();
            }),
            _navItem(Icons.shopping_cart_outlined, false, onTap: () {
              context.push('/cart');
            }),
            _navItem(Icons.person_outline, _selectedIndex == 2, onTap: () {
              setState(() => _selectedIndex = 2);
            }),
          ],
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, bool isActive, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isActive
                ? const Color(0xFFF3722C)
                : Colors.white.withOpacity(0.4),
            size: 28,
          ),
          if (isActive)
            Container(
              margin: const EdgeInsets.only(top: 4),
              height: 4,
              width: 4,
              decoration: const BoxDecoration(
                color: Color(0xFFF3722C),
                shape: BoxShape.circle,
              ),
            )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartCount = ref.watch(cartItemCountProvider);
    final user = ref.watch(currentUserProvider).value;

    final pages = [
      const _CatalogPage(),
      const OrderListScreen(embedded: true),
      _ProfilePage(user: user),
    ];

    return Scaffold(
      extendBody: true,
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'AutoPart Market',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryColor,
            fontSize: 18,
          ),
        ),
        actions: [
          if (_selectedIndex == 0)
            Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.shopping_cart_outlined,
                      color: AppTheme.primaryColor),
                  onPressed: () {
                    if (user != null) {
                      context.push('/cart');
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Faça login para acessar o carrinho'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                      context.push('/login');
                    }
                  },
                ),
                if (cartCount > 0)
                  Positioned(
                    right: 6,
                    top: 6,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: AppTheme.accentColor,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '$cartCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          // Botão de Perfil/Login
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Center(
              child: user != null
                  ? IconButton(
                      icon: const Icon(Icons.account_circle,
                          color: AppTheme.primaryColor, size: 28),
                      onPressed: () => setState(() => _selectedIndex = 2),
                    )
                  : TextButton(
                      onPressed: () => context.push('/login'),
                      style: TextButton.styleFrom(
                        foregroundColor: AppTheme.primaryColor,
                      ),
                      child: const Text(
                        'Login',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
            ),
          ),
        ],
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: _buildBottomTabs(),
    );
  }
}

// ─── CATÁLOGO ─────────────────────────────────────────────────────────────────

class _CatalogPage extends ConsumerStatefulWidget {
  const _CatalogPage();

  @override
  ConsumerState<_CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends ConsumerState<_CatalogPage> {
  final _searchCtrl = TextEditingController();
  bool _showFilters = false;

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final parts = ref.watch(filteredPartsProvider);
    final filter = ref.watch(searchFilterProvider);
    final brands = ref.watch(brandsProvider);
    final categories = ref.watch(categoriesProvider);

    return Column(
      children: [
        // Search + filtros
        Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchCtrl,
                  onChanged: (v) =>
                      ref.read(searchFilterProvider.notifier).updateQuery(v),
                  decoration: InputDecoration(
                    hintText: 'Ex: Corolla 2015 pastilha',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchCtrl.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              _searchCtrl.clear();
                              ref
                                  .read(searchFilterProvider.notifier)
                                  .updateQuery('');
                            },
                          )
                        : null,
                    constraints: const BoxConstraints(maxHeight: 48),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () => setState(() => _showFilters = !_showFilters),
                child: Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: filter.hasFilters
                        ? AppTheme.accentColor
                        : AppTheme.primaryColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.tune, color: Colors.white, size: 20),
                ),
              ),
            ],
          ),
        ),

        if (_showFilters)
          _FilterBar(
            filter: filter,
            brands: brands,
            categories: categories,
          ),

        // Garagem virtual banner
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                const Icon(Icons.car_repair,
                    color: AppTheme.accentColor, size: 22),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Filtrando para:',
                        style: TextStyle(color: Colors.white54, fontSize: 10),
                      ),
                      Text(
                        filter.brand != null && filter.model != null
                            ? '${filter.brand} ${filter.model}'
                            : filter.brand ?? 'Todos os veículos',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () =>
                      ref.read(searchFilterProvider.notifier).clearAll(),
                  style: TextButton.styleFrom(
                    foregroundColor: AppTheme.accentColor,
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text('Limpar',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ),

        // Grid de peças
        Expanded(
          child: parts.isEmpty
              ? const _EmptyState()
              : GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.72,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                  ),
                  itemCount: parts.length,
                  itemBuilder: (_, i) => PartCard(part: parts[i]),
                ),
        ),
      ],
    );
  }
}

class _FilterBar extends ConsumerWidget {
  final SearchFilter filter;
  final List<String> brands;
  final List<String> categories;

  const _FilterBar({
    required this.filter,
    required this.brands,
    required this.categories,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(searchFilterProvider.notifier);
    final models = filter.brand != null
        ? ref.watch(modelsForBrandProvider(filter.brand!))
        : <String>[];

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Filtros',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor)),
              TextButton(
                onPressed: notifier.clearAll,
                style:
                    TextButton.styleFrom(foregroundColor: AppTheme.accentColor),
                child: const Text('Limpar tudo'),
              ),
            ],
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _Chip(
                  label: filter.brand ?? 'Marca',
                  active: filter.brand != null,
                  items: brands,
                  onSelect: notifier.updateBrand,
                ),
                const SizedBox(width: 8),
                if (filter.brand != null)
                  _Chip(
                    label: filter.model ?? 'Modelo',
                    active: filter.model != null,
                    items: models,
                    onSelect: notifier.updateModel,
                  ),
                if (filter.brand != null) const SizedBox(width: 8),
                _Chip(
                  label: filter.category ?? 'Categoria',
                  active: filter.category != null,
                  items: categories,
                  onSelect: notifier.updateCategory,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final bool active;
  final List<String> items;
  final void Function(String?) onSelect;

  const _Chip({
    required this.label,
    required this.active,
    required this.items,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final selected = await showModalBottomSheet<String>(
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (_) => _Picker(items: items),
        );
        if (selected == '__clear__') {
          onSelect(null);
        } else if (selected != null) {
          onSelect(selected);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: active ? AppTheme.primaryColor : Colors.white,
          border: Border.all(
              color: active ? AppTheme.primaryColor : Colors.grey.shade300),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color: active ? Colors.white : Colors.grey.shade700,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.keyboard_arrow_down,
              size: 14,
              color: active ? Colors.white : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}

class _Picker extends StatelessWidget {
  final List<String> items;

  const _Picker({required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 8),
        Container(
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.close, color: Colors.red),
          title: const Text('Limpar filtro'),
          onTap: () => Navigator.pop(context, '__clear__'),
        ),
        const Divider(height: 1),
        Flexible(
          child: ListView(
            shrinkWrap: true,
            children: items
                .map((item) => ListTile(
                      title: Text(item),
                      onTap: () => Navigator.pop(context, item),
                    ))
                .toList(),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Nenhuma peça encontrada',
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
        ],
      ),
    );
  }
}

// ─── PERFIL ────────────────────────────────────────────────────────────────────

class _ProfilePage extends ConsumerWidget {
  final dynamic user;

  const _ProfilePage({this.user});

  void _logout(BuildContext context, WidgetRef ref) async {
    await ref.read(currentUserProvider.notifier).logout();
    if (context.mounted) context.go('/home');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (user == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.person_outline,
                    size: 64, color: AppTheme.primaryColor),
              ),
              const SizedBox(height: 24),
              const Text(
                'Faça login para acessar seu perfil',
                style: TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () => context.go('/login'),
                  child: const Text('ENTRAR'),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const SizedBox(height: 16),
        // Avatar
        Center(
          child: Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppTheme.primaryColor, Color(0xFF1E3A5F)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryColor.withOpacity(0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Center(
              child: Text(
                user.name.substring(0, 1).toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          user.name,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryColor,
          ),
        ),
        Text(
          user.email,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 32),

        // ── Minha conta ──────────────────────────────────────────────
        const _ProfileSectionTitle('Minha conta'),
        _ProfileMenuItem(
          icon: Icons.person_outline,
          label: 'Meus dados',
          subtitle: 'Nome, telefone',
          onTap: () => context.push('/profile/edit'),
        ),
        _ProfileMenuItem(
          icon: Icons.lock_outline,
          label: 'Alterar senha',
          onTap: () => context.push('/profile/password'),
        ),
        const SizedBox(height: 16),

        // ── Compras ──────────────────────────────────────────────────
        const _ProfileSectionTitle('Compras'),
        _ProfileMenuItem(
          icon: Icons.receipt_long_outlined,
          label: 'Meus pedidos',
          subtitle: 'Histórico e rastreio',
          onTap: () => context.push('/orders'),
        ),
        _ProfileMenuItem(
          icon: Icons.favorite_border,
          label: 'Favoritos',
          subtitle: 'Peças salvas',
          onTap: () => context.push('/profile/favorites'),
        ),
        const SizedBox(height: 16),

        // ── Endereços e veículos ─────────────────────────────────────
        const _ProfileSectionTitle('Endereços e veículos'),
        _ProfileMenuItem(
          icon: Icons.location_on_outlined,
          label: 'Endereços',
          subtitle: 'Entrega e cobrança',
          onTap: () => context.push('/profile/addresses'),
        ),
        _ProfileMenuItem(
          icon: Icons.garage_outlined,
          label: 'Minha garagem',
          subtitle: 'Veículos cadastrados',
          onTap: () => context.push('/profile/garage'),
        ),
        const SizedBox(height: 16),

        // ── Outros ───────────────────────────────────────────────────
        const _ProfileSectionTitle('Outros'),
        _ProfileMenuItem(
          icon: Icons.local_offer_outlined,
          label: 'Cupons e Promoções',
          subtitle: 'Aproveite descontos especiais',
          onTap: () => context.push('/coupons'),
        ),
        _ProfileMenuItem(
          icon: Icons.star_outlined,
          label: 'Minhas Avaliações',
          subtitle: 'Veja suas reviews e avaliações',
          onTap: () => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Em desenvolvimento')),
          ),
        ),
        _ProfileMenuItem(
          icon: Icons.settings_outlined,
          label: 'Configurações',
          subtitle: 'Notificações, privacidade e mais',
          onTap: () => context.push('/profile/settings'),
        ),
        _ProfileMenuItem(
          icon: Icons.store_outlined,
          label: 'Área do lojista',
          subtitle: 'Gerenciar sua loja',
          onTap: () => context.push('/seller/login'),
        ),
        _ProfileMenuItem(
          icon: Icons.logout,
          label: 'Sair',
          color: Colors.red,
          onTap: () => _logout(context, ref),
        ),
        const SizedBox(height: 80),
      ],
    );
  }
}

class _ProfileSectionTitle extends StatelessWidget {
  final String title;
  const _ProfileSectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title.toUpperCase(),
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

class _ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? subtitle;
  final VoidCallback onTap;
  final Color? color;

  const _ProfileMenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.subtitle,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppTheme.primaryColor;
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
              style: TextStyle(fontWeight: FontWeight.w600, color: c)),
          subtitle: subtitle != null
              ? Text(subtitle!,
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade400))
              : null,
          trailing: Icon(Icons.chevron_right, color: Colors.grey.shade400),
          onTap: onTap,
        ),
        Divider(height: 1, color: Colors.grey.shade100),
      ],
    );
  }
}
