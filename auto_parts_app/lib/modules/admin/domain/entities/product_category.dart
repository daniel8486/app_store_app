enum ProductCategory {
  // Linha Leve
  oilFilter,
  airFilter,
  cabinFilter,
  sparkPlugs,
  batteryLight,
  breakPads,
  breakFluid,
  wiperBlade,
  coolant,
  transmissionFluid,

  // Linha Pesada
  batteryHeavy,
  dieselFilter,
  oilHeavy,
  turboIntermediate,
  breakPadsHeavy,
  beltHeavy,
  waterPump,
  alternator,
  starter,
  radiator,

  // Acessórios
  carMat,
  trunk,
  protector,
  lightLED,
  accessories,
}

extension ProductCategoryExt on ProductCategory {
  String get label {
    switch (this) {
      // Linha Leve
      case ProductCategory.oilFilter:
        return 'Filtro de Óleo';
      case ProductCategory.airFilter:
        return 'Filtro de Ar';
      case ProductCategory.cabinFilter:
        return 'Filtro de Cabine';
      case ProductCategory.sparkPlugs:
        return 'Velas de Ignição';
      case ProductCategory.batteryLight:
        return 'Bateria (Linha Leve)';
      case ProductCategory.breakPads:
        return 'Pastilhas de Freio';
      case ProductCategory.breakFluid:
        return 'Fluido de Freio';
      case ProductCategory.wiperBlade:
        return 'Lâmina Limpador';
      case ProductCategory.coolant:
        return 'Líquido Arrefecimento';
      case ProductCategory.transmissionFluid:
        return 'Fluido Câmbio';

      // Linha Pesada
      case ProductCategory.batteryHeavy:
        return 'Bateria (Linha Pesada)';
      case ProductCategory.dieselFilter:
        return 'Filtro Diesel';
      case ProductCategory.oilHeavy:
        return 'Óleo Motor Pesado';
      case ProductCategory.turboIntermediate:
        return 'Turbo/Intermediário';
      case ProductCategory.breakPadsHeavy:
        return 'Pastilhas Freio Pesadas';
      case ProductCategory.beltHeavy:
        return 'Correia Pesada';
      case ProductCategory.waterPump:
        return 'Bomba de Água';
      case ProductCategory.alternator:
        return 'Alternador';
      case ProductCategory.starter:
        return 'Motor de Partida';
      case ProductCategory.radiator:
        return 'Radiador';

      // Acessórios
      case ProductCategory.carMat:
        return 'Tapete de Carro';
      case ProductCategory.trunk:
        return 'Porta-malas';
      case ProductCategory.protector:
        return 'Protetor';
      case ProductCategory.lightLED:
        return 'Luz LED';
      case ProductCategory.accessories:
        return 'Acessórios Gerais';
    }
  }

  String get groupName {
    switch (this) {
      case ProductCategory.oilFilter ||
            ProductCategory.airFilter ||
            ProductCategory.cabinFilter ||
            ProductCategory.sparkPlugs ||
            ProductCategory.batteryLight ||
            ProductCategory.breakPads ||
            ProductCategory.breakFluid ||
            ProductCategory.wiperBlade ||
            ProductCategory.coolant ||
            ProductCategory.transmissionFluid:
        return 'Linha Leve';

      case ProductCategory.batteryHeavy ||
            ProductCategory.dieselFilter ||
            ProductCategory.oilHeavy ||
            ProductCategory.turboIntermediate ||
            ProductCategory.breakPadsHeavy ||
            ProductCategory.beltHeavy ||
            ProductCategory.waterPump ||
            ProductCategory.alternator ||
            ProductCategory.starter ||
            ProductCategory.radiator:
        return 'Linha Pesada';

      case ProductCategory.carMat ||
            ProductCategory.trunk ||
            ProductCategory.protector ||
            ProductCategory.lightLED ||
            ProductCategory.accessories:
        return 'Acessórios';
    }
  }
}
