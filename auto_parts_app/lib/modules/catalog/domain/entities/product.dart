// Enum para ranking de qualidade
enum QualityRanking { genuine, original, aftermarket }

extension QualityRankingExt on QualityRanking {
  String get label {
    switch (this) {
      case QualityRanking.genuine:
        return 'Peça Genuína';
      case QualityRanking.original:
        return 'Original';
      case QualityRanking.aftermarket:
        return 'Genérica (Aftermarket)';
    }
  }
}

// Enum para combustível
enum FuelType { flex, diesel, gasoline, hybrid, electric }

extension FuelTypeExt on FuelType {
  String get label {
    switch (this) {
      case FuelType.flex:
        return 'Flex';
      case FuelType.diesel:
        return 'Diesel';
      case FuelType.gasoline:
        return 'Gasolina';
      case FuelType.hybrid:
        return 'Híbrido';
      case FuelType.electric:
        return 'Elétrico';
    }
  }
}

// Enum para origem da mercadoria
enum MerchandiseOrigin { national, directImport, internalMarket }

extension MerchandiseOriginExt on MerchandiseOrigin {
  String get label {
    switch (this) {
      case MerchandiseOrigin.national:
        return 'Nacional';
      case MerchandiseOrigin.directImport:
        return 'Importação Direta';
      case MerchandiseOrigin.internalMarket:
        return 'Mercado Interno';
    }
  }
}

// Enum para tecnologia de bateria
enum BatteryTechnology { sli, efb, agm }

extension BatteryTechnologyExt on BatteryTechnology {
  String get label {
    switch (this) {
      case BatteryTechnology.sli:
        return 'SLI';
      case BatteryTechnology.efb:
        return 'EFB';
      case BatteryTechnology.agm:
        return 'AGM';
    }
  }
}

// Enum para base química de óleo
enum OilChemicalBase { synthetic, semiSynthetic, mineral }

extension OilChemicalBaseExt on OilChemicalBase {
  String get label {
    switch (this) {
      case OilChemicalBase.synthetic:
        return 'Sintético';
      case OilChemicalBase.semiSynthetic:
        return 'Semissintético';
      case OilChemicalBase.mineral:
        return 'Mineral';
    }
  }
}

// Compatibilidade veicular completa
class VehicleCompatibility {
  final String manufacturer; // Montadora
  final String model; // Modelo
  final String version; // Versão
  final int yearFrom;
  final int yearTo;
  final String motorization; // Ex: 1.0 8V
  final FuelType fuelType;
  final String? mountPosition; // Ex: Dianteiro Esquerdo
  final String? licensePlate; // Para integração futura

  const VehicleCompatibility({
    required this.manufacturer,
    required this.model,
    required this.version,
    required this.yearFrom,
    required this.yearTo,
    required this.motorization,
    required this.fuelType,
    this.mountPosition,
    this.licensePlate,
  });

  factory VehicleCompatibility.fromMap(Map<String, dynamic> map) {
    return VehicleCompatibility(
      manufacturer: map['manufacturer'] as String,
      model: map['model'] as String,
      version: map['version'] as String,
      yearFrom: map['yearFrom'] as int,
      yearTo: map['yearTo'] as int,
      motorization: map['motorization'] as String,
      fuelType: FuelType.values[map['fuelType'] as int? ?? 0],
      mountPosition: map['mountPosition'] as String?,
      licensePlate: map['licensePlate'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'manufacturer': manufacturer,
      'model': model,
      'version': version,
      'yearFrom': yearFrom,
      'yearTo': yearTo,
      'motorization': motorization,
      'fuelType': fuelType.index,
      'mountPosition': mountPosition,
      'licensePlate': licensePlate,
    };
  }
}

// Especificações para óleos
class OilSpecs {
  final String sapGrade; // Ex: 5W30
  final OilChemicalBase chemicalBase;
  final String apiNorm; // Ex: API SP
  final String? aceaNorm; // Ex: ACEA C3
  final String? jasonNorm; // Para motos
  final String? anpRegistry; // Número de registro ANP

  const OilSpecs({
    required this.sapGrade,
    required this.chemicalBase,
    required this.apiNorm,
    this.aceaNorm,
    this.jasonNorm,
    this.anpRegistry,
  });

  factory OilSpecs.fromMap(Map<String, dynamic> map) {
    return OilSpecs(
      sapGrade: map['sapGrade'] as String,
      chemicalBase: OilChemicalBase.values[map['chemicalBase'] as int? ?? 0],
      apiNorm: map['apiNorm'] as String,
      aceaNorm: map['aceaNorm'] as String?,
      jasonNorm: map['jasonNorm'] as String?,
      anpRegistry: map['anpRegistry'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'sapGrade': sapGrade,
      'chemicalBase': chemicalBase.index,
      'apiNorm': apiNorm,
      'aceaNorm': aceaNorm,
      'jasonNorm': jasonNorm,
      'anpRegistry': anpRegistry,
    };
  }
}

// Especificações para baterias
class BatterySpecs {
  final int amperageAh; // Capacidade em Ah
  final int ccaColdStart; // Corrente de partida a frio
  final bool polarityRight; // true = direito, false = esquerdo
  final BatteryTechnology technology;

  const BatterySpecs({
    required this.amperageAh,
    required this.ccaColdStart,
    required this.polarityRight,
    required this.technology,
  });

  factory BatterySpecs.fromMap(Map<String, dynamic> map) {
    return BatterySpecs(
      amperageAh: map['amperageAh'] as int,
      ccaColdStart: map['ccaColdStart'] as int,
      polarityRight: map['polarityRight'] as bool? ?? true,
      technology: BatteryTechnology.values[map['technology'] as int? ?? 0],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'amperageAh': amperageAh,
      'ccaColdStart': ccaColdStart,
      'polarityRight': polarityRight,
      'technology': technology.index,
    };
  }
}

// Especificações para pneus
class TireSpecs {
  final String nominalMeasure; // Ex: 175/70 R14
  final String loadIndex; // Ex: 84
  final String speedIndex; // Ex: T
  final String? dotCode; // Data de fabricação
  final String? fireNumber; // Código de rastreabilidade

  const TireSpecs({
    required this.nominalMeasure,
    required this.loadIndex,
    required this.speedIndex,
    this.dotCode,
    this.fireNumber,
  });

  factory TireSpecs.fromMap(Map<String, dynamic> map) {
    return TireSpecs(
      nominalMeasure: map['nominalMeasure'] as String,
      loadIndex: map['loadIndex'] as String,
      speedIndex: map['speedIndex'] as String,
      dotCode: map['dotCode'] as String?,
      fireNumber: map['fireNumber'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nominalMeasure': nominalMeasure,
      'loadIndex': loadIndex,
      'speedIndex': speedIndex,
      'dotCode': dotCode,
      'fireNumber': fireNumber,
    };
  }
}

// Especificações para kits de transmissão
class TransmissionKitSpecs {
  final String chainStep; // Ex: 428, 520
  final int pinion; // Número de dentes
  final int crown; // Número de dentes
  final bool hasORing; // Com O-Ring/X-Ring

  const TransmissionKitSpecs({
    required this.chainStep,
    required this.pinion,
    required this.crown,
    required this.hasORing,
  });

  factory TransmissionKitSpecs.fromMap(Map<String, dynamic> map) {
    return TransmissionKitSpecs(
      chainStep: map['chainStep'] as String,
      pinion: map['pinion'] as int,
      crown: map['crown'] as int,
      hasORing: map['hasORing'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'chainStep': chainStep,
      'pinion': pinion,
      'crown': crown,
      'hasORing': hasORing,
    };
  }
}

// Entidade completa do Produto
class Product {
  // 1. IDENTIFICAÇÃO GERAL
  final String id;
  final String sku; // Código interno
  final String gtin; // Código de barras
  final String partNumber; // Código do fabricante
  final String? oemCode; // Código OEM
  final String brand; // Marca/Fabricante
  final QualityRanking qualityRanking;
  final List<String> crossReferences; // Códigos equivalentes

  // 2. COMPATIBILIDADE VEICULAR
  final List<VehicleCompatibility> vehicleCompatibilities;

  // 3. CAMPOS FISCAIS
  final String ncm; // Nomenclatura Comum do Mercosul
  final String? cest; // Código de Substituição Tributária
  final String cst; // Código de Situação Tributária
  final bool isMonophasic; // Tributação Monofásica
  final MerchandiseOrigin origin; // Origem da mercadoria
  final String cfop; // Código fiscal

  // 4. ESPECIFICAÇÕES TÉCNICAS
  final OilSpecs? oilSpecs;
  final BatterySpecs? batterySpecs;
  final TireSpecs? tireSpecs;
  final TransmissionKitSpecs? transmissionKitSpecs;

  // 5. GESTÃO DE ESTOQUE
  final String physicalLocation; // Corredor/prateleira
  final int minimumStock;
  final int maximumStock;
  final int leadTimeDays; // Dias de entrega
  final double weight; // Kg
  final double length; // cm
  final double width; // cm
  final double height; // cm
  final String? inmetroRegistry; // Número de registro Inmetro

  // 6. PREÇO E ESTOQUE
  final double price;
  final int currentStock;

  // 7. E-COMMERCE E MARKETING
  final String name;
  final String description;
  final String? seoTitle;
  final List<String> keywords;
  final List<String> imageUrls;
  final double rating;
  final List<Map<String, dynamic>> reviews;

  const Product({
    required this.id,
    required this.sku,
    required this.gtin,
    required this.partNumber,
    this.oemCode,
    required this.brand,
    required this.qualityRanking,
    this.crossReferences = const [],
    required this.vehicleCompatibilities,
    required this.ncm,
    this.cest,
    required this.cst,
    this.isMonophasic = false,
    required this.origin,
    required this.cfop,
    this.oilSpecs,
    this.batterySpecs,
    this.tireSpecs,
    this.transmissionKitSpecs,
    required this.physicalLocation,
    required this.minimumStock,
    required this.maximumStock,
    required this.leadTimeDays,
    required this.weight,
    required this.length,
    required this.width,
    required this.height,
    this.inmetroRegistry,
    required this.price,
    required this.currentStock,
    required this.name,
    required this.description,
    this.seoTitle,
    this.keywords = const [],
    this.imageUrls = const [],
    this.rating = 0,
    this.reviews = const [],
  });

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] as String,
      sku: map['sku'] as String,
      gtin: map['gtin'] as String,
      partNumber: map['partNumber'] as String,
      oemCode: map['oemCode'] as String?,
      brand: map['brand'] as String,
      qualityRanking: QualityRanking.values[map['qualityRanking'] as int? ?? 0],
      crossReferences: List<String>.from(map['crossReferences'] as List? ?? []),
      vehicleCompatibilities: (map['vehicleCompatibilities'] as List?)
              ?.map((e) =>
                  VehicleCompatibility.fromMap(e as Map<String, dynamic>))
              .toList() ??
          [],
      ncm: map['ncm'] as String,
      cest: map['cest'] as String?,
      cst: map['cst'] as String,
      isMonophasic: map['isMonophasic'] as bool? ?? false,
      origin: MerchandiseOrigin.values[map['origin'] as int? ?? 0],
      cfop: map['cfop'] as String,
      oilSpecs: map['oilSpecs'] != null
          ? OilSpecs.fromMap(map['oilSpecs'] as Map<String, dynamic>)
          : null,
      batterySpecs: map['batterySpecs'] != null
          ? BatterySpecs.fromMap(map['batterySpecs'] as Map<String, dynamic>)
          : null,
      tireSpecs: map['tireSpecs'] != null
          ? TireSpecs.fromMap(map['tireSpecs'] as Map<String, dynamic>)
          : null,
      transmissionKitSpecs: map['transmissionKitSpecs'] != null
          ? TransmissionKitSpecs.fromMap(
              map['transmissionKitSpecs'] as Map<String, dynamic>)
          : null,
      physicalLocation: map['physicalLocation'] as String,
      minimumStock: map['minimumStock'] as int,
      maximumStock: map['maximumStock'] as int,
      leadTimeDays: map['leadTimeDays'] as int,
      weight: (map['weight'] as num?)?.toDouble() ?? 0,
      length: (map['length'] as num?)?.toDouble() ?? 0,
      width: (map['width'] as num?)?.toDouble() ?? 0,
      height: (map['height'] as num?)?.toDouble() ?? 0,
      inmetroRegistry: map['inmetroRegistry'] as String?,
      price: (map['price'] as num?)?.toDouble() ?? 0,
      currentStock: map['currentStock'] as int? ?? 0,
      name: map['name'] as String,
      description: map['description'] as String,
      seoTitle: map['seoTitle'] as String?,
      keywords: List<String>.from(map['keywords'] as List? ?? []),
      imageUrls: List<String>.from(map['imageUrls'] as List? ?? []),
      rating: (map['rating'] as num?)?.toDouble() ?? 0,
      reviews: List<Map<String, dynamic>>.from(map['reviews'] as List? ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sku': sku,
      'gtin': gtin,
      'partNumber': partNumber,
      'oemCode': oemCode,
      'brand': brand,
      'qualityRanking': qualityRanking.index,
      'crossReferences': crossReferences,
      'vehicleCompatibilities':
          vehicleCompatibilities.map((e) => e.toMap()).toList(),
      'ncm': ncm,
      'cest': cest,
      'cst': cst,
      'isMonophasic': isMonophasic,
      'origin': origin.index,
      'cfop': cfop,
      'oilSpecs': oilSpecs?.toMap(),
      'batterySpecs': batterySpecs?.toMap(),
      'tireSpecs': tireSpecs?.toMap(),
      'transmissionKitSpecs': transmissionKitSpecs?.toMap(),
      'physicalLocation': physicalLocation,
      'minimumStock': minimumStock,
      'maximumStock': maximumStock,
      'leadTimeDays': leadTimeDays,
      'weight': weight,
      'length': length,
      'width': width,
      'height': height,
      'inmetroRegistry': inmetroRegistry,
      'price': price,
      'currentStock': currentStock,
      'name': name,
      'description': description,
      'seoTitle': seoTitle,
      'keywords': keywords,
      'imageUrls': imageUrls,
      'rating': rating,
      'reviews': reviews,
    };
  }
}
