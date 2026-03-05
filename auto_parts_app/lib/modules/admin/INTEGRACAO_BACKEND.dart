import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/entities/admin_product.dart';
import '../../domain/entities/product_category.dart';

/// Exemplo de implementação real do repositório com HTTP
/// Use este arquivo como referência para integrar com seu backend

// 1. Primeiramente, adicione 'http' às dependências no pubspec.yaml:
//    dependencies:
//      http: ^1.1.0

// 2. Crie uma classe de configuração:

class ApiConfig {
  static const String baseUrl = 'https://seu-api.com';
  static const String apiVersion = '/api/v1';
  static const String productsEndpoint = '$baseUrl$apiVersion/products';
  static const Duration timeout = Duration(seconds: 30);

  /// Bearer token para autenticação
  static String? _authToken;

  static void setAuthToken(String token) {
    _authToken = token;
  }

  static String get authHeader => 'Bearer $_authToken';
}

// 3. Implemente o repositório com HTTP:

class AdminProductRepositoryImpl implements IAdminProductRepository {
  final http.Client _httpClient;

  AdminProductRepositoryImpl(this._httpClient);

  // Headers padrão para todas as requisições
  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Authorization': ApiConfig.authHeader,
      };

  @override
  Future<List<AdminProduct>> getProducts({
    int? limit,
    int? offset,
    ProductCategory? category,
    ProductStatus? status,
  }) async {
    try {
      final queryParams = <String, String>{};

      if (limit != null) queryParams['limit'] = limit.toString();
      if (offset != null) queryParams['offset'] = offset.toString();
      if (category != null) queryParams['category'] = category.index.toString();
      if (status != null) queryParams['status'] = status.index.toString();

      final uri = Uri.parse(ApiConfig.productsEndpoint).replace(
          queryParameters: queryParams.isNotEmpty ? queryParams : null);

      final response = await _httpClient
          .get(uri, headers: _headers)
          .timeout(ApiConfig.timeout);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data
            .map((json) => AdminProduct.fromMap(json as Map<String, dynamic>))
            .toList();
      } else if (response.statusCode == 401) {
        throw UnauthorizedException('Não autorizado');
      } else {
        throw HttpException('Erro ao buscar produtos: ${response.statusCode}');
      }
    } on http.ClientException catch (e) {
      throw NetworkException('Erro de conexão: $e');
    }
  }

  @override
  Future<AdminProduct?> getProductById(String id) async {
    try {
      final uri = Uri.parse('${ApiConfig.productsEndpoint}/$id');
      final response = await _httpClient
          .get(uri, headers: _headers)
          .timeout(ApiConfig.timeout);

      if (response.statusCode == 200) {
        return AdminProduct.fromMap(jsonDecode(response.body));
      } else if (response.statusCode == 404) {
        return null;
      } else if (response.statusCode == 401) {
        throw UnauthorizedException('Não autorizado');
      } else {
        throw HttpException('Erro ao buscar produto: ${response.statusCode}');
      }
    } on http.ClientException catch (e) {
      throw NetworkException('Erro de conexão: $e');
    }
  }

  @override
  Future<AdminProduct?> getProductByCode(String code) async {
    try {
      final uri = Uri.parse('${ApiConfig.productsEndpoint}/by-code/$code');
      final response = await _httpClient
          .get(uri, headers: _headers)
          .timeout(ApiConfig.timeout);

      if (response.statusCode == 200) {
        return AdminProduct.fromMap(jsonDecode(response.body));
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw HttpException(
            'Erro ao buscar por código: ${response.statusCode}');
      }
    } on http.ClientException catch (e) {
      throw NetworkException('Erro de conexão: $e');
    }
  }

  @override
  Future<AdminProduct> createProduct(AdminProduct product) async {
    try {
      final response = await _httpClient
          .post(
            Uri.parse(ApiConfig.productsEndpoint),
            headers: _headers,
            body: jsonEncode(product.toMap()),
          )
          .timeout(ApiConfig.timeout);

      if (response.statusCode == 201 || response.statusCode == 200) {
        return AdminProduct.fromMap(jsonDecode(response.body));
      } else if (response.statusCode == 401) {
        throw UnauthorizedException('Não autorizado');
      } else if (response.statusCode == 400) {
        final error = jsonDecode(response.body);
        throw ValidationException(error['message'] ?? 'Dados inválidos');
      } else {
        throw HttpException('Erro ao criar produto: ${response.statusCode}');
      }
    } on http.ClientException catch (e) {
      throw NetworkException('Erro de conexão: $e');
    }
  }

  @override
  Future<AdminProduct> updateProduct(AdminProduct product) async {
    try {
      final uri = Uri.parse('${ApiConfig.productsEndpoint}/${product.id}');
      final response = await _httpClient
          .put(
            uri,
            headers: _headers,
            body: jsonEncode(product.toMap()),
          )
          .timeout(ApiConfig.timeout);

      if (response.statusCode == 200) {
        return AdminProduct.fromMap(jsonDecode(response.body));
      } else if (response.statusCode == 404) {
        throw NotFoundException('Produto não encontrado');
      } else if (response.statusCode == 401) {
        throw UnauthorizedException('Não autorizado');
      } else if (response.statusCode == 400) {
        final error = jsonDecode(response.body);
        throw ValidationException(error['message'] ?? 'Dados inválidos');
      } else {
        throw HttpException(
            'Erro ao atualizar produto: ${response.statusCode}');
      }
    } on http.ClientException catch (e) {
      throw NetworkException('Erro de conexão: $e');
    }
  }

  @override
  Future<void> deleteProduct(String id) async {
    try {
      final uri = Uri.parse('${ApiConfig.productsEndpoint}/$id');
      final response = await _httpClient
          .delete(uri, headers: _headers)
          .timeout(ApiConfig.timeout);

      if (response.statusCode == 204 || response.statusCode == 200) {
        return;
      } else if (response.statusCode == 404) {
        throw NotFoundException('Produto não encontrado');
      } else if (response.statusCode == 401) {
        throw UnauthorizedException('Não autorizado');
      } else {
        throw HttpException('Erro ao deletar produto: ${response.statusCode}');
      }
    } on http.ClientException catch (e) {
      throw NetworkException('Erro de conexão: $e');
    }
  }

  @override
  Future<List<AdminProduct>> searchProducts(String query) async {
    try {
      final uri = Uri.parse('${ApiConfig.productsEndpoint}/search')
          .replace(queryParameters: {'q': query});

      final response = await _httpClient
          .get(uri, headers: _headers)
          .timeout(ApiConfig.timeout);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data
            .map((json) => AdminProduct.fromMap(json as Map<String, dynamic>))
            .toList();
      } else {
        throw HttpException('Erro na busca: ${response.statusCode}');
      }
    } on http.ClientException catch (e) {
      throw NetworkException('Erro de conexão: $e');
    }
  }

  @override
  Future<List<AdminProduct>> getProductsByCategory(
      ProductCategory category) async {
    try {
      final uri = Uri.parse(ApiConfig.productsEndpoint)
          .replace(queryParameters: {'category': category.index.toString()});

      final response = await _httpClient
          .get(uri, headers: _headers)
          .timeout(ApiConfig.timeout);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data
            .map((json) => AdminProduct.fromMap(json as Map<String, dynamic>))
            .toList();
      } else {
        throw HttpException(
            'Erro ao buscar por categoria: ${response.statusCode}');
      }
    } on http.ClientException catch (e) {
      throw NetworkException('Erro de conexão: $e');
    }
  }

  @override
  Future<List<AdminProduct>> getLowStockProducts() async {
    try {
      final uri = Uri.parse('${ApiConfig.productsEndpoint}/low-stock');

      final response = await _httpClient
          .get(uri, headers: _headers)
          .timeout(ApiConfig.timeout);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data
            .map((json) => AdminProduct.fromMap(json as Map<String, dynamic>))
            .toList();
      } else {
        throw HttpException(
            'Erro ao buscar estoque baixo: ${response.statusCode}');
      }
    } on http.ClientException catch (e) {
      throw NetworkException('Erro de conexão: $e');
    }
  }

  @override
  Future<void> updateStock(String productId, int newStock) async {
    try {
      final uri = Uri.parse('${ApiConfig.productsEndpoint}/$productId/stock');
      final response = await _httpClient
          .patch(
            uri,
            headers: _headers,
            body: jsonEncode({'stock': newStock}),
          )
          .timeout(ApiConfig.timeout);

      if (response.statusCode != 200) {
        throw HttpException(
            'Erro ao atualizar estoque: ${response.statusCode}');
      }
    } on http.ClientException catch (e) {
      throw NetworkException('Erro de conexão: $e');
    }
  }

  @override
  Future<int> getTotalProductCount() async {
    try {
      final uri = Uri.parse('${ApiConfig.productsEndpoint}/count');
      final response = await _httpClient
          .get(uri, headers: _headers)
          .timeout(ApiConfig.timeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['count'] as int;
      } else {
        throw HttpException('Erro ao contar produtos: ${response.statusCode}');
      }
    } on http.ClientException catch (e) {
      throw NetworkException('Erro de conexão: $e');
    }
  }
}

// 4. Exceções customizadas:

class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  @override
  String toString() => message;
}

class NetworkException extends ApiException {
  NetworkException(String message) : super('Erro de rede: $message');
}

class HttpException extends ApiException {
  final int statusCode;
  HttpException(String message, [this.statusCode = 0]) : super(message);
}

class UnauthorizedException extends ApiException {
  UnauthorizedException(String message) : super('Não autorizado: $message');
}

class ValidationException extends ApiException {
  ValidationException(String message) : super('Validação: $message');
}

class NotFoundException extends ApiException {
  NotFoundException(String message) : super('Não encontrado: $message');
}

// 5. Atualizar o provider em admin_product_provider.dart:

/*
final adminProductRepositoryProvider = Provider<IAdminProductRepository>((ref) {
  return AdminProductRepositoryImpl(http.Client());
});
*/

// 6. Em caso de erro, implemente retry logic:

class RetryableAdminProductRepository implements IAdminProductRepository {
  final AdminProductRepositoryImpl _repository;
  final int _maxRetries;

  RetryableAdminProductRepository(
    this._repository, {
    int maxRetries = 3,
  }) : _maxRetries = maxRetries;

  Future<T> _withRetry<T>(Future<T> Function() operation) async {
    int attempts = 0;
    while (attempts < _maxRetries) {
      try {
        return await operation();
      } on NetworkException {
        attempts++;
        if (attempts >= _maxRetries) rethrow;
        // Aguarde antes de tentar novamente (exponential backoff)
        await Future.delayed(Duration(seconds: 1 << attempts));
      }
    }
    throw Exception('Máximo de tentativas excedido');
  }

  @override
  Future<List<AdminProduct>> getProducts({
    int? limit,
    int? offset,
    ProductCategory? category,
    ProductStatus? status,
  }) =>
      _withRetry(() => _repository.getProducts(
            limit: limit,
            offset: offset,
            category: category,
            status: status,
          ));

  @override
  Future<AdminProduct?> getProductById(String id) =>
      _withRetry(() => _repository.getProductById(id));

  @override
  Future<AdminProduct?> getProductByCode(String code) =>
      _withRetry(() => _repository.getProductByCode(code));

  @override
  Future<AdminProduct> createProduct(AdminProduct product) =>
      _withRetry(() => _repository.createProduct(product));

  @override
  Future<AdminProduct> updateProduct(AdminProduct product) =>
      _withRetry(() => _repository.updateProduct(product));

  @override
  Future<void> deleteProduct(String id) =>
      _withRetry(() => _repository.deleteProduct(id));

  @override
  Future<List<AdminProduct>> searchProducts(String query) =>
      _withRetry(() => _repository.searchProducts(query));

  @override
  Future<List<AdminProduct>> getProductsByCategory(ProductCategory category) =>
      _withRetry(() => _repository.getProductsByCategory(category));

  @override
  Future<List<AdminProduct>> getLowStockProducts() =>
      _withRetry(() => _repository.getLowStockProducts());

  @override
  Future<void> updateStock(String productId, int newStock) =>
      _withRetry(() => _repository.updateStock(productId, newStock));

  @override
  Future<int> getTotalProductCount() =>
      _withRetry(() => _repository.getTotalProductCount());
}

// 7. No seu main.dart ou ao inicializar:

/*
void main() {
  // Configurar token de autenticação
  ApiConfig.setAuthToken('seu_token_aqui');
  
  runApp(const AutoPartsApp());
}
*/

// 8. Endpoints esperados na sua API:

/*
GET     /api/v1/products                    - Listar produtos
POST    /api/v1/products                    - Criar produto
GET     /api/v1/products/:id                - Obter produto
PUT     /api/v1/products/:id                - Atualizar produto
DELETE  /api/v1/products/:id                - Deletar produto
GET     /api/v1/products/by-code/:code      - Buscar por código
GET     /api/v1/products/search?q=query     - Buscar
GET     /api/v1/products?category=X&status=Y - Filtrar
GET     /api/v1/products/low-stock          - Estoque baixo
PATCH   /api/v1/products/:id/stock          - Atualizar estoque
GET     /api/v1/products/count              - Contar total
*/

// Formato esperado de resposta POST/PUT:
/*
{
  "id": "prod_001",
  "name": "Filtro de Óleo",
  "code": "FO-001",
  "description": "...",
  "longDescription": "...",
  "price": 45.00,
  "promotionalPrice": 39.90,
  "stock": 150,
  "minStock": 20,
  "imageUrl": "...",
  "additionalImages": [],
  "category": 0,
  "status": 1,
  "supplierId": "sup_001",
  "supplierName": "Fornecedor",
  "rating": 4.8,
  "reviewCount": 245,
  "tags": ["filtro", "oleo"],
  "specifications": {"Tipo": "Rosca"},
  "isNewProduct": false,
  "createdAt": "2024-03-05T10:30:00Z",
  "updatedAt": "2024-03-05T10:30:00Z",
  "sku": "MOB-OIL-001",
  "barcode": "8717057000234",
  "weight": 0.25,
  "dimensions": "76x95mm",
  "guaranteeMonths": 12
}
*/
