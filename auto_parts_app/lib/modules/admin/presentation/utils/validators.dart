class AdminProductValidators {
  // Validações de texto
  static String? validateProductName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nome do produto é obrigatório';
    }
    if (value.length < 3) {
      return 'Nome deve ter no mínimo 3 caracteres';
    }
    if (value.length > 100) {
      return 'Nome não pode exceder 100 caracteres';
    }
    return null;
  }

  static String? validateProductCode(String? value) {
    if (value == null || value.isEmpty) {
      return 'Código do produto é obrigatório';
    }
    if (value.length < 3) {
      return 'Código deve ter no mínimo 3 caracteres';
    }
    if (value.length > 50) {
      return 'Código não pode exceder 50 caracteres';
    }
    if (!RegExp(r'^[A-Z0-9\-]+$').hasMatch(value)) {
      return 'Código deve conter apenas letras maiúsculas, números e hífens';
    }
    return null;
  }

  static String? validateDescription(String? value) {
    if (value == null || value.isEmpty) {
      return 'Descrição é obrigatória';
    }
    if (value.length < 10) {
      return 'Descrição deve ter no mínimo 10 caracteres';
    }
    if (value.length > 500) {
      return 'Descrição não pode exceder 500 caracteres';
    }
    return null;
  }

  static String? validateLongDescription(String? value) {
    if (value == null || value.isEmpty) {
      return 'Descrição longa é obrigatória';
    }
    if (value.length < 20) {
      return 'Descrição longa deve ter no mínimo 20 caracteres';
    }
    if (value.length > 2000) {
      return 'Descrição longa não pode exceder 2000 caracteres';
    }
    return null;
  }

  static String? validateSKU(String? value) {
    if (value == null || value.isEmpty) {
      return 'SKU é obrigatório';
    }
    if (value.length < 3) {
      return 'SKU deve ter no mínimo 3 caracteres';
    }
    if (value.length > 50) {
      return 'SKU não pode exceder 50 caracteres';
    }
    return null;
  }

  static String? validateBarcode(String? value) {
    if (value == null || value.isEmpty) {
      return 'Código de barras é obrigatório';
    }
    if (value.length < 8) {
      return 'Código de barras deve ter no mínimo 8 dígitos';
    }
    if (value.length > 20) {
      return 'Código de barras não pode exceder 20 dígitos';
    }
    if (!RegExp(r'^\d+$').hasMatch(value)) {
      return 'Código de barras deve conter apenas números';
    }
    return null;
  }

  // Validações de preço
  static String? validatePrice(String? value) {
    if (value == null || value.isEmpty) {
      return 'Preço é obrigatório';
    }
    final price = double.tryParse(value);
    if (price == null) {
      return 'Preço deve ser um número válido';
    }
    if (price <= 0) {
      return 'Preço deve ser maior que zero';
    }
    if (price > 999999.99) {
      return 'Preço não pode exceder 999.999,99';
    }
    return null;
  }

  static String? validatePromotionalPrice(
      String? value, double? originalPrice) {
    if (value == null || value.isEmpty) {
      return null; // Preço promocional é opcional
    }
    final price = double.tryParse(value);
    if (price == null) {
      return 'Preço promocional deve ser um número válido';
    }
    if (price <= 0) {
      return 'Preço promocional deve ser maior que zero';
    }
    if (originalPrice != null && price >= originalPrice) {
      return 'Preço promocional deve ser menor que o preço original';
    }
    return null;
  }

  // Validações de estoque
  static String? validateStock(String? value) {
    if (value == null || value.isEmpty) {
      return 'Quantidade em estoque é obrigatória';
    }
    final stock = int.tryParse(value);
    if (stock == null) {
      return 'Estoque deve ser um número inteiro';
    }
    if (stock < 0) {
      return 'Estoque não pode ser negativo';
    }
    if (stock > 999999) {
      return 'Estoque não pode exceder 999.999';
    }
    return null;
  }

  static String? validateMinStock(String? value) {
    if (value == null || value.isEmpty) {
      return 'Estoque mínimo é obrigatório';
    }
    final stock = int.tryParse(value);
    if (stock == null) {
      return 'Estoque mínimo deve ser um número inteiro';
    }
    if (stock < 0) {
      return 'Estoque mínimo não pode ser negativo';
    }
    if (stock > 999999) {
      return 'Estoque mínimo não pode exceder 999.999';
    }
    return null;
  }

  // Validações de URL
  static String? validateImageUrl(String? value) {
    if (value == null || value.isEmpty) {
      return 'URL da imagem é obrigatória';
    }
    final uri = Uri.tryParse(value);
    if (uri == null || !uri.isAbsolute) {
      return 'URL da imagem inválida';
    }
    return null;
  }

  static String? validateUrl(String? value) {
    if (value == null || value.isEmpty) {
      return 'URL é obrigatória';
    }
    final uri = Uri.tryParse(value);
    if (uri == null || !uri.isAbsolute) {
      return 'URL inválida';
    }
    return null;
  }

  // Validações de especificações
  static String? validateSpecificationKey(String? value) {
    if (value == null || value.isEmpty) {
      return 'Chave da especificação é obrigatória';
    }
    if (value.length > 50) {
      return 'Chave não pode exceder 50 caracteres';
    }
    return null;
  }

  static String? validateSpecificationValue(String? value) {
    if (value == null || value.isEmpty) {
      return 'Valor da especificação é obrigatório';
    }
    if (value.length > 200) {
      return 'Valor não pode exceder 200 caracteres';
    }
    return null;
  }

  // Validações de tags
  static String? validateTag(String? value) {
    if (value == null || value.isEmpty) {
      return 'Tag é obrigatória';
    }
    if (value.length > 30) {
      return 'Tag não pode exceder 30 caracteres';
    }
    if (value.contains(' ')) {
      return 'Tag não pode conter espaços';
    }
    return null;
  }

  // Validações de peso e dimensões
  static String? validateWeight(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Peso é opcional
    }
    final weight = double.tryParse(value);
    if (weight == null) {
      return 'Peso deve ser um número válido';
    }
    if (weight <= 0) {
      return 'Peso deve ser maior que zero';
    }
    return null;
  }

  static String? validateDimensions(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Dimensões são opcionais
    }
    if (value.length > 50) {
      return 'Dimensões não podem exceder 50 caracteres';
    }
    return null;
  }

  // Validação de meses de garantia
  static String? validateGuaranteeMonths(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Garantia é opcional
    }
    final months = int.tryParse(value);
    if (months == null) {
      return 'Meses de garantia deve ser um número inteiro';
    }
    if (months <= 0) {
      return 'Meses de garantia deve ser maior que zero';
    }
    if (months > 120) {
      return 'Meses de garantia não pode exceder 120 (10 anos)';
    }
    return null;
  }
}
