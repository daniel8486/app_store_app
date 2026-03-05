# 🏢 Módulo Administrativo - Sistema de Peças Automotivas

## Visão Geral

O módulo administrativo é um sistema completo de gerenciamento de produtos (peças automotivas) para linha leve, pesada e acessórios. Oferece funcionalidades robustas de criação, edição, exclusão e gerenciamento de estoque com uma arquitetura escalável.

## 📁 Estrutura do Projeto

```
admin/
├── domain/
│   └── entities/
│       ├── admin_product.dart          # Entidade principal de produto
│       └── product_category.dart       # Categorias e enums
├── data/
│   └── repositories/
│       └── admin_product_repository.dart  # Camada de dados com mock
├── presentation/
│   ├── screens/
│   │   ├── admin_dashboard_screen.dart      # Dashboard principal
│   │   ├── admin_products_list_screen.dart  # Listagem de produtos
│   │   ├── admin_product_form_screen.dart   # Formulário criar/editar
│   │   └── admin_product_detail_screen.dart # Detalhes do produto
│   ├── providers/
│   │   └── admin_product_provider.dart      # State management com Riverpod
│   ├── widgets/
│   │   ├── admin_product_card.dart      # Card customizado de produto
│   │   ├── admin_product_filters.dart   # Widget de filtros
│   │   └── admin_form_field.dart        # Campo de formulário reutilizável
│   └── utils/
│       └── validators.dart              # Validadores de formulário
```

## 🏗️ Arquitetura

### Clean Architecture + Riverpod

O módulo segue os princípios de Clean Architecture:

- **Domain Layer**: Entidades puras, sem dependências externas
- **Data Layer**: Repositórios e modelos de dados
- **Presentation Layer**: UI, state management e validações

### State Management com Riverpod

Todos os estados são gerenciados via Riverpod providers:

```dart
// Obter lista de produtos
final productsAsync = ref.watch(adminFilteredProductsProvider);

// Obter um produto específico
final product = ref.watch(adminProductByIdProvider('produto_id'));

// Filtros
final filters = ref.watch(adminProductFilterProvider);

// Formulário
final form = ref.watch(adminProductFormProvider);
```

## 📦 Entidades Principais

### AdminProduct

```dart
AdminProduct(
  id: 'prod_001',
  name: 'Filtro de Óleo Mobil',
  code: 'FO-MOB-001',
  description: 'Descrição breve',
  longDescription: 'Descrição detalhada...',
  price: 45.00,
  promotionalPrice: 39.90,  // Opcional
  stock: 150,
  minStock: 20,
  imageUrl: 'https://...',
  category: ProductCategory.oilFilter,
  status: ProductStatus.active,
  supplierId: 'sup_001',
  supplierName: 'Mobil Brasil',
  tags: ['filtro', 'óleo', 'manutenção'],
  specifications: {'Tipo': 'Rosca', 'Diâmetro': '76mm'},
  // ... campos adicionais
)
```

### ProductCategory

Categorias predefinidas para linha leve e pesada:

```dart
// Linha Leve
ProductCategory.oilFilter         // Filtro de Óleo
ProductCategory.airFilter         // Filtro de Ar
ProductCategory.batteryLight      // Bateria (Leve)
ProductCategory.breakPads         // Pastilhas de Freio
// ... mais 6 categorias leves

// Linha Pesada
ProductCategory.batteryHeavy      // Bateria (Pesada)
ProductCategory.dieselFilter      // Filtro Diesel
ProductCategory.turboIntermediate // Turbo/Intermediário
// ... mais 7 categorias pesadas

// Acessórios
ProductCategory.carMat            // Tapete de Carro
ProductCategory.lightLED          // Luz LED
// ... mais 3 categorias de acessórios
```

### ProductStatus

```dart
ProductStatus.draft         // Rascunho
ProductStatus.active        // Ativo na loja
ProductStatus.inactive      // Inativo (oculto)
ProductStatus.discontinued  // Descontinuado
```

## 🛣️ Rotas Disponíveis

```dart
// Dashboard principal
'/admin/dashboard'                    → AdminDashboardScreen

// Listagem de produtos
'/admin/produtos'                     → AdminProductsListScreen

// Criar novo produto
'/admin/produto/novo'                 → AdminProductFormScreen

// Ver detalhes do produto
'/admin/produto/:id'                  → AdminProductDetailScreen

// Editar produto
'/admin/produto/:id/editar'           → AdminProductFormScreen (isEditing: true)
```

## 🎯 Funcionalidades Principais

### 1. Dashboard
- **Resumo geral**: Total de produtos, baixo estoque
- **Produtos recentes**: Últimos 5 produtos adicionados
- **Alertas**: Produtos com estoque baixo
- **Ações rápidas**: Novo produto, editar, detalhes

### 2. Listagem de Produtos
- **Grid view customizada**: Cards com informações essenciais
- **Busca em tempo real**: Por nome, código ou descrição
- **Filtros avançados**: Por categoria e status
- **Paginação**: Suporte para grandes volumes
- **Ações**: Editar, deletar, visualizar detalhes

### 3. Formulário de Produtos
Campos abrangentes organizados em seções:

#### Informações Básicas
- Nome do produto
- Código (SKU alfanumérico)
- Descrição curta e longa
- SKU interno

#### Categoria e Status
- Seleção de categoria (com 23 opções)
- Status do produto

#### Preços
- Preço original
- Preço promocional (opcional)
- Cálculo automático de desconto

#### Estoque
- Quantidade em estoque
- Estoque mínimo (alerta automático)

#### Imagens
- URL da imagem principal
- Preview da imagem
- Suporte para imagens adicionais (estrutura)

#### Especificações
- Adicionar especificações dinâmicas
- Chave e valor customizáveis
- Remover especificações

#### Tags
- Tags para melhor categorização
- Adicionar/remover tags

#### Informações Adicionais
- Código de barras
- Peso (kg)
- Dimensões
- Meses de garantia

### 4. Detalhes do Produto
- **Visualização completa**: Todos os dados do produto
- **Imagem grande**: Preview para cliente
- **Badges informativos**: Status, baixo estoque, promoção
- **Cards de informações**: Estoque, categoria, fornecedor, avaliação
- **Especificações**: Tabulação organizada
- **Tags**: Visualização em chips
- **Histórico**: Data de criação e atualização

## ✅ Validações

Validadores completos para todos os campos:

```dart
// Textos
AdminProductValidators.validateProductName()        // Min 3, máx 100
AdminProductValidators.validateProductCode()        // Apenas maiúsculas e números
AdminProductValidators.validateDescription()        // Min 10, máx 500
AdminProductValidators.validateLongDescription()    // Min 20, máx 2000

// Preços
AdminProductValidators.validatePrice()              // > 0
AdminProductValidators.validatePromotionalPrice()   // < preço original

// Estoque
AdminProductValidators.validateStock()              // >= 0
AdminProductValidators.validateMinStock()           // >= 0

// URLs
AdminProductValidators.validateImageUrl()           // URL válida
AdminProductValidators.validateUrl()                // URL válida

// Especificações
AdminProductValidators.validateSpecificationKey()   // Máx 50 caracteres
AdminProductValidators.validateSpecificationValue() // Máx 200 caracteres

// Códigos
AdminProductValidators.validateBarcode()            // 8-20 dígitos
AdminProductValidators.validateSKU()                // Min 3, máx 50

// Adicionais
AdminProductValidators.validateWeight()             // > 0 (opcional)
AdminProductValidators.validateDimensions()         // Máx 50 caracteres
AdminProductValidators.validateGuaranteeMonths()    // 1-120 meses
```

## 📊 State Management (Riverpod)

### Providers Disponíveis

```dart
// Repositório
final adminProductRepositoryProvider          // Acesso ao repositório

// Dados
final adminProductsProvider                   // Lista paginada
final adminProductByIdProvider                // Produto por ID
final adminProductsByCategoryProvider         // Por categoria
final adminLowStockProductsProvider          // Produtos com estoque baixo
final adminProductSearchProvider             // Busca
final adminTotalProductCountProvider         // Contagem total

// Filtros
final adminProductFilterProvider             // Estado dos filtros
final adminFilteredProductsProvider          // Produtos filtrados

// Formulário
final adminProductFormProvider               // Estado do formulário
```

### Exemplo de Uso

```dart
// Obter produtos com filtros
final filter = ref.watch(adminProductFilterProvider);
final products = ref.watch(adminFilteredProductsProvider);

// Atualizar filtros
ref.read(adminProductFilterProvider.notifier).updateCategory(category);
ref.read(adminProductFilterProvider.notifier).updateStatus(status);
ref.read(adminProductFilterProvider.notifier).updateSearch(query);

// Salvar produto
ref.read(adminProductFormProvider.notifier).setProduct(product);
await ref.read(adminProductFormProvider.notifier).saveProduct(ref);

// Deletar produto
await ref.read(adminProductFormProvider.notifier).deleteProduct(ref, productId);
```

## 🎨 Componentes Reutilizáveis

### AdminProductCard
Card customizado para exibição de produtos com:
- Imagem
- Badges de status e promoção
- Preço original e promocional
- Estoque e rating
- Botões de ação

### AdminFormField
Campo de formulário customizado com:
- Label com marcação de obrigatório
- Validação em tempo real
- Estilos padronizados
- Suporte a múltiplas linhas

### AdminProductFilters
Widget de filtros com:
- Dropdown de categoria
- Dropdown de status
- Botão de limpeza de filtros

## 🔌 Integração com Repositório Mock

A implementação padrão usa um repositório mock em `memory`:

```dart
class AdminProductRepository implements IAdminProductRepository {
  final Map<String, AdminProduct> _products = {};
  
  // CRUD operations
  Future<AdminProduct> createProduct(AdminProduct product)
  Future<AdminProduct> updateProduct(AdminProduct product)
  Future<void> deleteProduct(String id)
  Future<AdminProduct?> getProductById(String id)
  
  // Query operations
  Future<List<AdminProduct>> getProducts({...})
  Future<List<AdminProduct>> searchProducts(String query)
  Future<List<AdminProduct>> getProductsByCategory(ProductCategory category)
  Future<List<AdminProduct>> getLowStockProducts()
  
  // Utility
  Future<void> updateStock(String productId, int newStock)
  Future<int> getTotalProductCount()
}
```

## 🚀 Como Usar

### Acessar o Painel Admin

```dart
// No seu app, adicione um botão ou menu para acessar
context.push('/admin/dashboard');

// Ou direto para a listagem
context.push('/admin/produtos');
```

### Criar um Novo Produto

```dart
context.push('/admin/produto/novo');
```

### Editar um Produto

```dart
context.push('/admin/produto/prod_001/editar');
```

### Integração Futura com Backend

Para integrar com um backend real, substitua `AdminProductRepository`:

```dart
class AdminProductRepository extends IAdminProductRepository {
  final http.Client _client;
  
  @override
  Future<AdminProduct> createProduct(AdminProduct product) async {
    final response = await _client.post(
      Uri.parse('$baseUrl/api/products'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(product.toMap()),
    );
    
    if (response.statusCode == 201) {
      return AdminProduct.fromMap(jsonDecode(response.body));
    }
    throw Exception('Erro ao criar produto');
  }
  
  // ... implementar outros métodos
}
```

Depois, atualize o provider:

```dart
final adminProductRepositoryProvider = Provider<IAdminProductRepository>((ref) {
  return AdminProductRepository(http.Client());
});
```

## 📋 Features Implementadas

- ✅ Dashboard com estatísticas
- ✅ CRUD completo (Create, Read, Update, Delete)
- ✅ Validação robusta de formulários
- ✅ Filtros avançados por categoria e status
- ✅ Busca em tempo real
- ✅ Gerenciamento de estoque
- ✅ Preços promocionais
- ✅ Especificações dinâmicas
- ✅ Tags customizáveis
- ✅ Preview de imagem
- ✅ Alertas de baixo estoque
- ✅ Paginação
- ✅ Estado persistente com Riverpod
- ✅ Tratamento de erros
- ✅ Loading states

## 🔄 Fluxo de Dados

```
User (UI)
    ↓
Screen (ConsumerWidget)
    ↓
Provider (Riverpod)
    ↓
Repository (IAdminProductRepository)
    ↓
Data (AdminProduct)
    ↓
Display (Widget)
```

## 📝 Próximos Passos

1. **Backend Integration**: Conectar com API real
2. **Authentication**: Implementar verificação de permissões
3. **Upload de Imagens**: Suporte para múltiplas imagens
4. **Bulk Operations**: Importação/exportação de produtos
5. **Analytics**: Relatórios de vendas por categoria
6. **Webhooks**: Notificações de mudanças
7. **Versioning**: Histórico de alterações de produtos

## 🛠️ Troubleshooting

### Categoria não salva
Certifique-se que uma categoria foi selecionada antes de salvar.

### Imagem não carrega
Verifique se a URL é válida e acessível. Use `https://via.placeholder.com/300` para testes.

### Validação não funciona
Todos os campos obrigatórios devem passar nas validações. Verifique o console para detalhes.

### Produtos não aparecem
Verifique se o status do produto é "Ativo". Use filtros para ajustar a busca.

## 📞 Suporte

Para dúvidas ou melhorias, verifique a documentação do projeto ou entre em contato com a equipe de desenvolvimento.

---

**Desenvolvido com ❤️ para AutoPeças**
