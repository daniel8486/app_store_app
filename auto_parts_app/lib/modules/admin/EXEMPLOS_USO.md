# 📚 Exemplo de Uso - Módulo Administrativo

## Acessar o Painel Admin Programaticamente

### 1. Do seu App Main

```dart
// Em qualquer lugar do seu app, você pode acessar o admin com:

// A partir de um botão em Settings
FloatingActionButton(
  onPressed: () {
    context.push('/admin/dashboard');
  },
  tooltip: 'Painel Admin',
  child: const Icon(Icons.admin_panel_settings),
)
```

### 2. Adicionar ao Menu Principal

```dart
// Em um menu de opções, adicione:
ListTile(
  leading: const Icon(Icons.admin_panel_settings),
  title: const Text('Painel Administrativo'),
  subtitle: const Text('Gerenciar produtos'),
  onTap: () {
    context.push('/admin/dashboard');
  },
)
```

## Exemplos de Código

### Exemplo 1: Criar um Novo Produto

```dart
// Navegar para a tela de novo produto
context.push('/admin/produto/novo');

// No formulário, preencher:
// - Nome: "Filtro de Óleo Mobil"
// - Código: "FO-MOB-001"
// - Descrição: "Filtro de óleo de alta qualidade"
// - Preço: "45.00"
// - Estoque: "150"
// - Categoria: "Filtro de Óleo"
// - Status: "Ativo"
// - Clicar em "Criar"
```

### Exemplo 2: Editar um Produto Existente

```dart
// A partir de uma lista, clique em "Editar"
context.push('/admin/produto/prod_001/editar');

// Ou programaticamente:
final productId = 'prod_001';
context.push('/admin/produto/$productId/editar');
```

### Exemplo 3: Visualizar Detalhes

```dart
// Clicar no card do produto na listagem
context.push('/admin/produto/prod_001');

// Ou:
final productId = 'prod_001';
context.push('/admin/produto/$productId');
```

### Exemplo 4: Usar State Management

```dart
// Em um ConsumerWidget qualquer:

class MyAdminView extends ConsumerWidget {
  const MyAdminView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Obter todos os produtos
    final productsAsync = ref.watch(adminFilteredProductsProvider);
    
    // Obter um produto específico
    final product = ref.watch(adminProductByIdProvider('prod_001'));
    
    // Obter produtos com baixo estoque
    final lowStock = ref.watch(adminLowStockProductsProvider);
    
    // Obter total de produtos
    final total = ref.watch(adminTotalProductCountProvider);
    
    // Acessar filtros
    final filters = ref.watch(adminProductFilterProvider);
    
    return productsAsync.when(
      data: (products) {
        return ListView(
          children: products.map((product) {
            return ListTile(
              title: Text(product.name),
              subtitle: Text('R\$ ${product.price}'),
              onTap: () {
                context.push('/admin/produto/${product.id}');
              },
            );
          }).toList(),
        );
      },
      loading: () => const CircularProgressIndicator(),
      error: (error, stack) => Text('Erro: $error'),
    );
  }
}
```

### Exemplo 5: Filtrar Produtos

```dart
// No provider de filtros
ref.read(adminProductFilterProvider.notifier)
    .updateCategory(ProductCategory.oilFilter);

ref.read(adminProductFilterProvider.notifier)
    .updateStatus(ProductStatus.active);

ref.read(adminProductFilterProvider.notifier)
    .updateSearch('filtro');

// Para navegar para página anterior/próxima
ref.read(adminProductFilterProvider.notifier).nextPage();
ref.read(adminProductFilterProvider.notifier).previousPage();

// Para limpar todos os filtros
ref.read(adminProductFilterProvider.notifier).reset();
```

### Exemplo 6: Salvar Produto Programaticamente

```dart
// Criar um novo produto
final newProduct = AdminProduct(
  id: 'temp_nova',
  name: 'Novo Filtro',
  code: 'NFI-001',
  description: 'Descrição curta',
  longDescription: 'Descrição detalhada...',
  price: 50.00,
  stock: 100,
  minStock: 10,
  imageUrl: 'https://via.placeholder.com/300',
  category: ProductCategory.oilFilter,
  status: ProductStatus.draft,
  supplierId: 'sup_001',
  supplierName: 'Fornecedor',
  createdAt: DateTime.now(),
  updatedAt: DateTime.now(),
);

// Definir no formulário
ref.read(adminProductFormProvider.notifier).setProduct(newProduct);

// Salvar
await ref.read(adminProductFormProvider.notifier).saveProduct(ref);
```

### Exemplo 7: Deletar Produto

```dart
// Usando o notifier do formulário
await ref.read(adminProductFormProvider.notifier)
    .deleteProduct(ref, 'prod_001');

// Com Try-Catch para tratamento de erros
try {
  await ref.read(adminProductFormProvider.notifier)
      .deleteProduct(ref, productId);
  
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Produto deletado com sucesso!'),
      backgroundColor: Colors.green,
    ),
  );
} catch (e) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Erro: $e'),
      backgroundColor: Colors.red,
    ),
  );
}
```

### Exemplo 8: Validar Formulário

```dart
// Todos os validadores estão disponíveis em:
import 'package:auto_parts_app/modules/admin/presentation/utils/validators.dart';

// Usar em um TextFormField:
TextFormField(
  controller: _nameController,
  validator: AdminProductValidators.validateProductName,
  decoration: const InputDecoration(
    labelText: 'Nome do Produto',
  ),
)

// Ou validar manualmente:
final error = AdminProductValidators.validatePrice('abc');
if (error != null) {
  print('Erro: $error'); // 'Preço deve ser um número válido'
}
```

### Exemplo 9: Dashboard Customizado

```dart
class CustomAdminDashboard extends ConsumerWidget {
  const CustomAdminDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final total = ref.watch(adminTotalProductCountProvider);
    final lowStock = ref.watch(adminLowStockProductsProvider);
    
    return Column(
      children: [
        // Card: Total de Produtos
        total.when(
          data: (count) => Text('Total: $count'),
          loading: () => const CircularProgressIndicator(),
          error: (error, stack) => Text('Erro: $error'),
        ),
        
        // Card: Baixo Estoque
        lowStock.when(
          data: (products) => Text('Baixo estoque: ${products.length}'),
          loading: () => const CircularProgressIndicator(),
          error: (error, stack) => Text('Erro: $error'),
        ),
      ],
    );
  }
}
```

### Exemplo 10: Integração com Drawer

```dart
// Adicionar um item no Drawer do seu app:
Drawer(
  child: ListView(
    children: [
      const DrawerHeader(
        child: Text('Menu'),
      ),
      ListTile(
        leading: const Icon(Icons.shopping_bag),
        title: const Text('Catálogo'),
        onTap: () => context.push('/home'),
      ),
      const Divider(),
      ListTile(
        leading: const Icon(Icons.admin_panel_settings),
        title: const Text('Administração'),
        onTap: () => context.push('/admin/dashboard'),
      ),
      ListTile(
        leading: const Icon(Icons.inventory),
        title: const Text('Produtos'),
        onTap: () => context.push('/admin/produtos'),
      ),
    ],
  ),
)
```

## Fluxos de Usuário Comuns

### Fluxo 1: Adicionar novo produto linha leve

```
1. Acessar /admin/dashboard
2. Clicar no botão "Novo Produto"
3. Preencher formulário:
   - Nome: "Pastilha de Freio Brembo"
   - Código: "PFB-001"
   - Descrição: "Pastilhas de alta durabilidade"
   - Preço: 120.00
   - Estoque: 80
   - Estoque mínimo: 15
   - Categoria: "Pastilhas de Freio"
   - Status: "Ativo"
   - Imagem: URL válida
   - Especificações: Tipo: "Semi-metálica"
4. Clicar em "Criar"
5. Sistema redireciona para /admin/produtos
6. Novo produto aparece na listagem
```

### Fluxo 2: Gerenciar estoque baixo

```
1. Acessar /admin/dashboard
2. Ver seção "Produtos com Baixo Estoque"
3. Clicar em "Editar" de um produto
4. Alterar quantidade em estoque
5. Clicar em "Atualizar"
6. Sistema atualiza e redireciona
7. Estoque mínimo atualizado
```

### Fluxo 3: Promoção de produto

```
1. Acessar /admin/produtos
2. Encontrar produto desejado
3. Clicar em "Editar"
4. Preencher campo "Preço Promocional": 99.90
5. Campo de desconto é calculado automaticamente
6. Clicar em "Atualizar"
7. Badge de promoção aparece no card
```

## Dicas e Truques

### 💡 Dica 1: Busca Rápida
Use a barra de busca para encontrar produtos por:
- Nome: "Filtro"
- Código: "FO-MOB"
- Descrição: "Óleo"

### 💡 Dica 2: Filtros Combinados
Combine categoria + status para filtros mais precisos:
- Categoria: "Bateria" + Status: "Ativo"
- Categoria: "Filtro de Óleo" + Status: "Draft"

### 💡 Dica 3: Validação Automática
Todos os campos validam automaticamente:
- Preço deve ser > 0
- Preço promocional < preço original
- Estoque deve ser número inteiro
- Código apenas maiúsculas e números

### 💡 Dica 4: Especificações
Use especificações para dados técnicos:
- Tipo: "Sintético"
- Diâmetro: "76mm"
- Voltagem: "12V"
- Capacidade: "60Ah"

### 💡 Dica 5: Tags
Use tags para melhor descobrimento:
- "novo-lançamento"
- "promoção"
- "bestseller"
- "linha-pesada"

## Troubleshooting

### ❌ Problema: Não consigo acessar o admin
**Solução**: Verifique se a rota `/admin/dashboard` está registrada no router.

### ❌ Problema: Produto não salva
**Solução**: Verifique se:
- Uma categoria foi selecionada
- Valores de preço são > 0
- Descrição tem no mínimo 10 caracteres

### ❌ Problema: Imagem não carrega
**Solução**: 
- Verifique se a URL é HTTPS (recomendado)
- Use URLs válidas como `https://via.placeholder.com/300`
- Teste a URL no navegador primeiro

### ❌ Problema: Baixo estoque não aparece
**Solução**: 
- Verifique se `minStock` foi definido corretamente
- Produto deve estar com `status: active`
- Verifique quantidade em estoque vs mínimo

---

**Precisa de mais ajuda? Consulte a documentação em `README.md`**
