import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/admin_product.dart';
import '../../domain/entities/product_category.dart';
import '../providers/admin_product_provider.dart';
import '../utils/validators.dart';
import '../widgets/admin_form_field.dart';

class AdminProductFormScreen extends ConsumerStatefulWidget {
  final String? productId;
  final bool isEditing;

  const AdminProductFormScreen({
    Key? key,
    this.productId,
    this.isEditing = false,
  }) : super(key: key);

  @override
  ConsumerState<AdminProductFormScreen> createState() =>
      _AdminProductFormScreenState();
}

class _AdminProductFormScreenState
    extends ConsumerState<AdminProductFormScreen> {
  late final _formKey = GlobalKey<FormState>();
  late final _nameCtrl = TextEditingController();
  late final _codeCtrl = TextEditingController();
  late final _descriptionCtrl = TextEditingController();
  late final _longDescriptionCtrl = TextEditingController();
  late final _priceCtrl = TextEditingController();
  late final _promotionalPriceCtrl = TextEditingController();
  late final _stockCtrl = TextEditingController();
  late final _minStockCtrl = TextEditingController();
  late final _imageUrlCtrl = TextEditingController();
  late final _skuCtrl = TextEditingController();
  late final _barcodeCtrl = TextEditingController();
  late final _weightCtrl = TextEditingController();
  late final _dimensionsCtrl = TextEditingController();
  late final _guaranteeMonthsCtrl = TextEditingController();

  ProductCategory? _selectedCategory;
  ProductStatus? _selectedStatus = ProductStatus.draft;
  String _supplierId = 'sup_001';
  String _supplierName = 'Fornecedor Padrão';
  final List<String> _tags = [];
  final Map<String, String> _specifications = {};
  String? _specKeyInput;
  String? _specValueInput;
  String? _tagInput;
  bool _isLoading = false;
  bool _imagePreviewError = false;

  @override
  void initState() {
    super.initState();
    _loadProductIfEditing();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _codeCtrl.dispose();
    _descriptionCtrl.dispose();
    _longDescriptionCtrl.dispose();
    _priceCtrl.dispose();
    _promotionalPriceCtrl.dispose();
    _stockCtrl.dispose();
    _minStockCtrl.dispose();
    _imageUrlCtrl.dispose();
    _skuCtrl.dispose();
    _barcodeCtrl.dispose();
    _weightCtrl.dispose();
    _dimensionsCtrl.dispose();
    _guaranteeMonthsCtrl.dispose();
    super.dispose();
  }

  void _loadProductIfEditing() {
    if (widget.isEditing && widget.productId != null) {
      Future.microtask(() async {
        final product = await ref
            .read(adminProductRepositoryProvider)
            .getProductById(widget.productId!);

        if (product != null && mounted) {
          _nameCtrl.text = product.name;
          _codeCtrl.text = product.code;
          _descriptionCtrl.text = product.description;
          _longDescriptionCtrl.text = product.longDescription;
          _priceCtrl.text = product.price.toStringAsFixed(2);
          _promotionalPriceCtrl.text =
              product.promotionalPrice?.toStringAsFixed(2) ?? '';
          _stockCtrl.text = product.stock.toString();
          _minStockCtrl.text = product.minStock.toString();
          _imageUrlCtrl.text = product.imageUrl;
          _skuCtrl.text = product.sku ?? '';
          _barcodeCtrl.text = product.barcode ?? '';
          _weightCtrl.text = product.weight?.toStringAsFixed(2) ?? '';
          _dimensionsCtrl.text = product.dimensions ?? '';
          _guaranteeMonthsCtrl.text = product.guaranteeMonths?.toString() ?? '';

          setState(() {
            _selectedCategory = product.category;
            _selectedStatus = product.status;
            _supplierId = product.supplierId;
            _supplierName = product.supplierName;
            _tags.clear();
            _tags.addAll(product.tags);
            _specifications.clear();
            _specifications.addAll(product.specifications);
          });

          ref.read(adminProductFormProvider.notifier).setProduct(product);
        }
      });
    }
  }

  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecione uma categoria'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final product = AdminProduct(
        id: widget.isEditing && widget.productId != null
            ? widget.productId!
            : const Uuid().v4(),
        name: _nameCtrl.text,
        code: _codeCtrl.text,
        description: _descriptionCtrl.text,
        longDescription: _longDescriptionCtrl.text,
        price: double.parse(_priceCtrl.text),
        promotionalPrice: _promotionalPriceCtrl.text.isNotEmpty
            ? double.parse(_promotionalPriceCtrl.text)
            : null,
        stock: int.parse(_stockCtrl.text),
        minStock: int.parse(_minStockCtrl.text),
        imageUrl: _imageUrlCtrl.text,
        category: _selectedCategory!,
        status: _selectedStatus ?? ProductStatus.draft,
        supplierId: _supplierId,
        supplierName: _supplierName,
        tags: _tags,
        specifications: _specifications,
        createdAt:
            ref.read(adminProductFormProvider)?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
        sku: _skuCtrl.text.isNotEmpty ? _skuCtrl.text : null,
        barcode: _barcodeCtrl.text.isNotEmpty ? _barcodeCtrl.text : null,
        weight:
            _weightCtrl.text.isNotEmpty ? double.parse(_weightCtrl.text) : null,
        dimensions:
            _dimensionsCtrl.text.isNotEmpty ? _dimensionsCtrl.text : null,
        guaranteeMonths: _guaranteeMonthsCtrl.text.isNotEmpty
            ? int.parse(_guaranteeMonthsCtrl.text)
            : null,
      );

      ref.read(adminProductFormProvider.notifier).setProduct(product);
      await ref.read(adminProductFormProvider.notifier).saveProduct(ref);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.isEditing
                  ? 'Produto atualizado com sucesso!'
                  : 'Produto criado com sucesso!',
            ),
            backgroundColor: Colors.green,
          ),
        );
        context.go('/admin/produtos');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao salvar: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isEditing ? 'Editar Produto' : 'Novo Produto',
        ),
        elevation: 1,
        scrolledUnderElevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Seção: Informações Básicas
                _buildSectionHeader('Informações Básicas'),
                const SizedBox(height: 16),

                AdminFormField(
                  label: 'Nome do Produto',
                  hint: 'Ex: Filtro de Óleo Mobil 5L',
                  controller: _nameCtrl,
                  validator: AdminProductValidators.validateProductName,
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: AdminFormField(
                        label: 'Código',
                        hint: 'Ex: FO-MOB-001',
                        controller: _codeCtrl,
                        validator: AdminProductValidators.validateProductCode,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: AdminFormField(
                        label: 'SKU',
                        hint: 'Código interno',
                        controller: _skuCtrl,
                        validator: AdminProductValidators.validateSKU,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                AdminFormField(
                  label: 'Descrição Curta',
                  hint: 'Uma breve descrição do produto',
                  controller: _descriptionCtrl,
                  maxLines: 2,
                  validator: AdminProductValidators.validateDescription,
                ),
                const SizedBox(height: 16),

                AdminFormField(
                  label: 'Descrição Longa',
                  hint: 'Descrição detalhada com especificações',
                  controller: _longDescriptionCtrl,
                  maxLines: 4,
                  validator: AdminProductValidators.validateLongDescription,
                ),
                const SizedBox(height: 16),

                // Seção: Categoria e Status
                _buildSectionHeader('Categoria e Status'),
                const SizedBox(height: 16),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Categoria *',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButton<ProductCategory>(
                        value: _selectedCategory,
                        isExpanded: true,
                        underline: const SizedBox(),
                        items: ProductCategory.values.map((category) {
                          return DropdownMenuItem(
                            value: category,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: Text(category.label),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() => _selectedCategory = value);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Status',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButton<ProductStatus>(
                        value: _selectedStatus,
                        isExpanded: true,
                        underline: const SizedBox(),
                        items: ProductStatus.values.map((status) {
                          return DropdownMenuItem(
                            value: status,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: Text(status.label),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() => _selectedStatus = value);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Seção: Preços
                _buildSectionHeader('Preços'),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: AdminFormField(
                        label: 'Preço',
                        hint: '0.00',
                        controller: _priceCtrl,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        validator: AdminProductValidators.validatePrice,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: AdminFormField(
                        label: 'Preço Promocional',
                        hint: 'Opcional',
                        controller: _promotionalPriceCtrl,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        validator: (value) =>
                            AdminProductValidators.validatePromotionalPrice(
                          value,
                          double.tryParse(_priceCtrl.text),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Seção: Estoque
                _buildSectionHeader('Estoque'),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: AdminFormField(
                        label: 'Quantidade',
                        hint: '0',
                        controller: _stockCtrl,
                        keyboardType: TextInputType.number,
                        validator: AdminProductValidators.validateStock,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: AdminFormField(
                        label: 'Estoque Mínimo',
                        hint: '10',
                        controller: _minStockCtrl,
                        keyboardType: TextInputType.number,
                        validator: AdminProductValidators.validateMinStock,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Seção: Imagens
                _buildSectionHeader('Imagens'),
                const SizedBox(height: 16),

                AdminFormField(
                  label: 'URL da Imagem Principal',
                  hint: 'https://...',
                  controller: _imageUrlCtrl,
                  validator: AdminProductValidators.validateImageUrl,
                ),
                const SizedBox(height: 16),

                if (_imageUrlCtrl.text.isNotEmpty && !_imagePreviewError)
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => Dialog(
                          child: GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Image.network(
                              _imageUrlCtrl.text,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[200],
                                  child: const Center(
                                    child: Text('Erro ao carregar imagem'),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    },
                    child: Container(
                      height: 150,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey[50],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          _imageUrlCtrl.text,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              if (mounted) {
                                setState(() => _imagePreviewError = true);
                              }
                            });
                            return Container(
                              color: Colors.grey[200],
                              child: Center(
                                child: Icon(
                                  Icons.image_not_supported,
                                  color: Colors.grey[400],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 24),

                // Seção: Especificações
                _buildSectionHeader('Especificações'),
                const SizedBox(height: 16),

                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Adicionar Especificação',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: 'Chave',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  isDense: true,
                                ),
                                onChanged: (value) => _specKeyInput = value,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              flex: 3,
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: 'Valor',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  isDense: true,
                                ),
                                onChanged: (value) => _specValueInput = value,
                              ),
                            ),
                            const SizedBox(width: 8),
                            SizedBox(
                              height: 40,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_specKeyInput != null &&
                                      _specKeyInput!.isNotEmpty &&
                                      _specValueInput != null &&
                                      _specValueInput!.isNotEmpty) {
                                    setState(() {
                                      _specifications[_specKeyInput!] =
                                          _specValueInput!;
                                      _specKeyInput = '';
                                      _specValueInput = '';
                                    });
                                  }
                                },
                                child: const Icon(Icons.add, size: 18),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        if (_specifications.isNotEmpty) ...[
                          const Divider(),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: _specifications.entries.map((entry) {
                              return Chip(
                                label: Text('${entry.key}: ${entry.value}'),
                                onDeleted: () {
                                  setState(() {
                                    _specifications.remove(entry.key);
                                  });
                                },
                              );
                            }).toList(),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Seção: Tags
                _buildSectionHeader('Tags'),
                const SizedBox(height: 16),

                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: 'Adicionar tag',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  isDense: true,
                                ),
                                onChanged: (value) => _tagInput = value,
                              ),
                            ),
                            const SizedBox(width: 8),
                            SizedBox(
                              height: 40,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_tagInput != null &&
                                      _tagInput!.isNotEmpty &&
                                      !_tags.contains(_tagInput)) {
                                    setState(() {
                                      _tags.add(_tagInput!);
                                      _tagInput = '';
                                    });
                                  }
                                },
                                child: const Icon(Icons.add, size: 18),
                              ),
                            ),
                          ],
                        ),
                        if (_tags.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: _tags.map((tag) {
                              return Chip(
                                label: Text(tag),
                                onDeleted: () {
                                  setState(() {
                                    _tags.remove(tag);
                                  });
                                },
                              );
                            }).toList(),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Seção: Informações Adicionais
                _buildSectionHeader('Informações Adicionais'),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: AdminFormField(
                        label: 'Código de Barras',
                        hint: 'Opcional',
                        controller: _barcodeCtrl,
                        keyboardType: TextInputType.number,
                        validator: (value) => value != null && value.isNotEmpty
                            ? AdminProductValidators.validateBarcode(value)
                            : null,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: AdminFormField(
                        label: 'Peso (kg)',
                        hint: 'Opcional',
                        controller: _weightCtrl,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        validator: AdminProductValidators.validateWeight,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: AdminFormField(
                        label: 'Dimensões',
                        hint: 'Ex: 10x20x30cm',
                        controller: _dimensionsCtrl,
                        validator: AdminProductValidators.validateDimensions,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: AdminFormField(
                        label: 'Garantia (meses)',
                        hint: 'Opcional',
                        controller: _guaranteeMonthsCtrl,
                        keyboardType: TextInputType.number,
                        validator:
                            AdminProductValidators.validateGuaranteeMonths,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Botões de Ação
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : () => context.pop(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[300],
                          foregroundColor: Colors.black87,
                        ),
                        child: const Text('Cancelar'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _saveProduct,
                        child: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                widget.isEditing ? 'Atualizar' : 'Criar',
                              ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFF2563EB), width: 2)),
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Color(0xFF2563EB),
        ),
      ),
    );
  }
}
