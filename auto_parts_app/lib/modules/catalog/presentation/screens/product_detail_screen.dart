import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/part.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/formatters.dart';
import '../../../cart/presentation/providers/cart_provider.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  final Product product;

  const ProductDetailScreen({
    super.key,
    required this.product,
  });

  @override
  ConsumerState<ProductDetailScreen> createState() =>
      _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  int _quantity = 1;

  /// Converte Product para Part para adicionar ao carrinho
  Part _productToPart(Product product) {
    return Part(
      id: product.id,
      name: product.name,
      code: product.sku,
      description: product.description,
      price: product.price,
      stock: product.currentStock,
      imageUrl: product.imageUrls.isNotEmpty ? product.imageUrls.first : '',
      category: 'Peças',
      supplierId: 'auto-parts',
      supplierName: 'Auto Parts Store',
      compatibilities: [],
      reviews: [],
      rating: product.rating,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: CustomScrollView(
        slivers: [
          // ── HEADER COM IMAGEM ────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: AppTheme.primaryColor,
            iconTheme: const IconThemeData(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              background: widget.product.imageUrls.isNotEmpty
                  ? Image.network(
                      widget.product.imageUrls.first,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _buildPlaceholder(),
                    )
                  : _buildPlaceholder(),
            ),
          ),

          // ── CONTEÚDO PRINCIPAL ────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ──  HEADER COM NOME E AVALIAÇÃO ──
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Nome do Produto
                            Text(
                              widget.product.name,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryColor,
                              ),
                            ),
                            const SizedBox(height: 8),
                            // SKU
                            Text(
                              'SKU: ${widget.product.sku}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Avaliação
                      Column(
                        children: [
                          Row(
                            children: List.generate(5, (i) {
                              return Icon(
                                i < widget.product.rating.floor()
                                    ? Icons.star
                                    : Icons.star_border,
                                size: 18,
                                color: Colors.amber,
                              );
                            }),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.product.rating.toStringAsFixed(1),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // ── IDENTIFICAÇÃO E CÓDIGOS ──
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.purple.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.purple.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Identificação e Códigos',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildSpecRow('SKU Interno', widget.product.sku),
                        _buildSpecRow('GTIN/EAN', widget.product.gtin),
                        _buildSpecRow('Part Number', widget.product.partNumber),
                        if (widget.product.oemCode != null &&
                            widget.product.oemCode!.isNotEmpty)
                          _buildSpecRow('Código OEM', widget.product.oemCode!),
                        _buildSpecRow('Marca', widget.product.brand),
                        if (widget.product.crossReferences.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          const Text(
                            'Códigos Equivalentes:',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children:
                                widget.product.crossReferences.map((code) {
                              return Chip(
                                label: Text(
                                  code,
                                  style: const TextStyle(fontSize: 10),
                                ),
                                visualDensity: VisualDensity.compact,
                                backgroundColor: Colors.purple.shade100,
                              );
                            }).toList(),
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.accentColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Preço',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              Formatters.currency(widget.product.price),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.accentColor,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              'Estoque',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              widget.product.currentStock > 0
                                  ? '${widget.product.currentStock} un.'
                                  : 'Indisponível',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: widget.product.currentStock > 0
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ── DESCRIÇÃO ──
                  if (widget.product.description.isNotEmpty) ...[
                    const Text(
                      'Descrição',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.product.description,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // ── ESPECIFICAÇÕES TÉCNICAS ──
                  if (widget.product.oilSpecs != null ||
                      widget.product.batterySpecs != null ||
                      widget.product.tireSpecs != null ||
                      widget.product.transmissionKitSpecs != null) ...[
                    const Text(
                      'Especificações Técnicas',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (widget.product.oilSpecs != null) ...[
                      _buildSpecRow(
                          'SAP Grade', widget.product.oilSpecs!.sapGrade),
                      _buildSpecRow(
                          'Norma API', widget.product.oilSpecs!.apiNorm),
                      _buildSpecRow('Base Química',
                          widget.product.oilSpecs!.chemicalBase.name),
                    ],
                    if (widget.product.batterySpecs != null) ...[
                      _buildSpecRow('Capacidade',
                          '${widget.product.batterySpecs!.amperageAh}Ah'),
                      _buildSpecRow('Corrente de Partida (CCA)',
                          '${widget.product.batterySpecs!.ccaColdStart}A'),
                      _buildSpecRow(
                          'Polaridade',
                          widget.product.batterySpecs!.polarityRight
                              ? 'Direita'
                              : 'Esquerda'),
                    ],
                    if (widget.product.tireSpecs != null) ...[
                      _buildSpecRow(
                          'Medida', widget.product.tireSpecs!.nominalMeasure),
                      _buildSpecRow('Índice de Carga',
                          widget.product.tireSpecs!.loadIndex),
                      _buildSpecRow('Índice de Velocidade',
                          widget.product.tireSpecs!.speedIndex),
                    ],
                    if (widget.product.transmissionKitSpecs != null) ...[
                      _buildSpecRow('Tipo de Corrente',
                          widget.product.transmissionKitSpecs!.chainStep),
                      _buildSpecRow(
                          'Pinhão (dentes)',
                          widget.product.transmissionKitSpecs!.pinion
                              .toString()),
                      _buildSpecRow(
                          'Coroa (dentes)',
                          widget.product.transmissionKitSpecs!.crown
                              .toString()),
                      _buildSpecRow(
                          'Com O-Ring',
                          widget.product.transmissionKitSpecs!.hasORing
                              ? 'Sim'
                              : 'Não'),
                    ],
                    const SizedBox(height: 20),
                  ],

                  // ── INFORMAÇÕES DE LOGÍSTICA ──
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue.shade200, width: 1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Informações de Logística',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildSpecRow(
                            'Localização', widget.product.physicalLocation),
                        _buildSpecRow('Peso (kg)',
                            widget.product.weight.toStringAsFixed(2)),
                        _buildSpecRow('Dimensões (cm)',
                            '${widget.product.length.toStringAsFixed(1)}L x ${widget.product.width.toStringAsFixed(1)}L x ${widget.product.height.toStringAsFixed(1)}A'),
                        _buildSpecRow('Estoque Mínimo',
                            widget.product.minimumStock.toString()),
                        _buildSpecRow('Estoque Máximo',
                            widget.product.maximumStock.toString()),
                        _buildSpecRow(
                            'Lead Time', '${widget.product.leadTimeDays} dias'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ── INFORMAÇÕES E-COMMERCE ──
                  if (widget.product.seoTitle != null &&
                      widget.product.seoTitle!.isNotEmpty) ...[
                    const Text(
                      'SEO',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Título: ${widget.product.seoTitle}',
                      style: const TextStyle(fontSize: 11),
                    ),
                    if (widget.product.keywords.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children:
                            widget.product.keywords.take(5).map((keyword) {
                          return Chip(
                            label: Text(
                              keyword,
                              style: const TextStyle(fontSize: 10),
                            ),
                            visualDensity: VisualDensity.compact,
                            backgroundColor:
                                AppTheme.accentColor.withOpacity(0.2),
                          );
                        }).toList(),
                      ),
                    ],
                    const SizedBox(height: 20),
                  ],

                  const SizedBox(height: 20),
                  if (widget.product.vehicleCompatibilities.isNotEmpty) ...[
                    const Text(
                      'Compatibilidade Veicular',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...widget.product.vehicleCompatibilities
                        .take(3)
                        .map((compat) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            const Icon(Icons.directions_car,
                                size: 16, color: AppTheme.primaryColor),
                            const SizedBox(width: 8),
                            Text(
                              '${compat.manufacturer} ${compat.model} (${compat.yearFrom}-${compat.yearTo})',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    if (widget.product.vehicleCompatibilities.length > 3)
                      Text(
                        '+${widget.product.vehicleCompatibilities.length - 3} mais',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.accentColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    const SizedBox(height: 20),
                  ],

                  // ── INFORMAÇÕES FISCAIS ──
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Informações Fiscais',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildSpecRow('NCM', widget.product.ncm),
                        _buildSpecRow('CST', widget.product.cst),
                        if (widget.product.cest != null &&
                            widget.product.cest!.isNotEmpty)
                          _buildSpecRow('CEST', widget.product.cest!),
                        _buildSpecRow('CFOP', widget.product.cfop),
                        _buildSpecRow('Origem', widget.product.origin.name),
                        _buildSpecRow(
                          'Tributação Monofásica',
                          widget.product.isMonophasic ? 'Sim' : 'Não',
                        ),
                        if (widget.product.inmetroRegistry != null &&
                            widget.product.inmetroRegistry!.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          _buildSpecRow(
                            'Registro Inmetro',
                            widget.product.inmetroRegistry!,
                          ),
                        ],
                      ],
                    ),
                  ),

                  // ── QUALIDADE DO PRODUTO ──
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.amber.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Qualidade e Classificação',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildSpecRow(
                          'Classificação de Qualidade',
                          widget.product.qualityRanking.name,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  if (widget.product.reviews.isNotEmpty) ...[
                    const Text(
                      'Avaliações',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Classificação Média',
                                style:
                                    TextStyle(fontSize: 11, color: Colors.grey),
                              ),
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  Text(
                                    widget.product.rating.toStringAsFixed(1),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.primaryColor,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Row(
                                    children: List.generate(5, (i) {
                                      return Icon(
                                        i < widget.product.rating.floor()
                                            ? Icons.star
                                            : Icons.star_border,
                                        size: 14,
                                        color: Colors.amber,
                                      );
                                    }),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Chip(
                            label: Text(
                                '${widget.product.reviews.length} reviews'),
                            backgroundColor:
                                AppTheme.accentColor.withOpacity(0.2),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // ── CUPONS APLICÁVEIS ──
                  const Text(
                    'Cupons e Promoções',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Cupons Disponíveis',
                                style:
                                    TextStyle(fontSize: 11, color: Colors.grey),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Verifique cupons aplicáveis',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        TextButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Cupons em breve!'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                          icon: const Icon(Icons.local_offer, size: 16),
                          label: const Text('Cupons',
                              style: TextStyle(fontSize: 10)),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.green.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),

      // ── BOTTOM BAR COM CARRINHO ──
      bottomSheet: widget.product.currentStock > 0
          ? Container(
              color: Colors.white,
              padding: EdgeInsets.fromLTRB(
                16,
                12,
                16,
                12 + MediaQuery.of(context).viewPadding.bottom,
              ),
              child: Row(
                children: [
                  // Seletor de Quantidade
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300, width: 1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          constraints: const BoxConstraints(
                            minHeight: 40,
                            minWidth: 40,
                          ),
                          padding: EdgeInsets.zero,
                          onPressed: _quantity > 1
                              ? () => setState(() => _quantity--)
                              : null,
                          icon: const Icon(Icons.remove, size: 18),
                        ),
                        SizedBox(
                          width: 40,
                          child: Text(
                            _quantity.toString(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        IconButton(
                          constraints: const BoxConstraints(
                            minHeight: 40,
                            minWidth: 40,
                          ),
                          padding: EdgeInsets.zero,
                          onPressed: _quantity < widget.product.currentStock
                              ? () => setState(() => _quantity++)
                              : null,
                          icon: const Icon(Icons.add, size: 18),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Botão Adicionar ao Carrinho
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.shopping_cart_outlined),
                      label: const Text(
                        'Adicionar ao Carrinho',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.accentColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        // Converter Product para Part
                        final part = _productToPart(widget.product);
                        ref
                            .read(cartProvider.notifier)
                            .addItem(part, quantity: _quantity);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '${widget.product.name} adicionado ao carrinho!',
                            ),
                            backgroundColor: AppTheme.primaryColor,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            action: SnackBarAction(
                              label: 'Ver carrinho',
                              textColor: AppTheme.accentColor,
                              onPressed: () => context.push('/cart'),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            )
          : Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 16,
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade300,
                    foregroundColor: Colors.grey.shade600,
                  ),
                  onPressed: null,
                  child: const Text(
                    'Produto Indisponível',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: AppTheme.primaryColor,
      child: const Icon(
        Icons.settings_suggest,
        size: 80,
        color: Colors.white24,
      ),
    );
  }

  Widget _buildSpecRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: Colors.grey,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
