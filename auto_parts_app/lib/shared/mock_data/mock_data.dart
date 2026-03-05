class MockData {
  static const List<Map<String, dynamic>> suppliers = [
    {'id': 'sup1', 'name': 'AutoForce'},
    {'id': 'sup2', 'name': 'Motorcraft Pro'},
    {'id': 'sup3', 'name': 'Continental Parts'},
  ];

  static const Map<String, dynamic> defaultUser = {
    'id': 'user_test',
    'name': 'João da Silva',
    'email': 'joao@email.com',
    'password': '123456',
    'phone': '11999998888',
    'cpf': '12345678901',
    'isSeller': false,
    'isAdmin': false,
  };

  static const Map<String, dynamic> defaultSeller = {
    'id': 'seller_test',
    'name': 'Loja AutoPeças',
    'email': 'loja@autopecas.com',
    'password': '123456',
    'phone': '11988887777',
    'cpf': '98765432100',
    'isSeller': true,
    'isAdmin': false,
  };

  static const Map<String, dynamic> defaultAdmin = {
    'id': 'admin_test',
    'name': 'Admin AutoShop',
    'email': 'admin@autoshop.com',
    'password': '123456',
    'phone': '1133334444',
    'cpf': '11122233344',
    'isSeller': false,
    'isAdmin': true,
  };

  static const List<Map<String, dynamic>> parts = [
    // ─── TOYOTA COROLLA ────────────────────────────────────────────
    {
      'id': 'p001',
      'name': 'Pastilha de Freio Dianteira',
      'code': 'TYC-001',
      'description':
          'Pastilha de freio dianteira de alta performance para Toyota Corolla. Fabricada com material cerâmico, proporciona menor ruído e maior durabilidade.',
      'price': 189.90,
      'stock': 15,
      'imageUrl':
          'https://images.unsplash.com/photo-1486262715619-3417b3999ddd?w=600&h=400&fit=crop',
      'category': 'Freios',
      'supplierId': 'sup1',
      'supplierName': 'AutoForce',
      'compatibilities': [
        {
          'brand': 'Toyota',
          'model': 'Corolla',
          'yearFrom': 2014,
          'yearTo': 2019
        },
      ],
      'reviews': [
        {
          'author': 'Carlos M.',
          'rating': 5.0,
          'comment': 'Excelente produto, frenagem perfeita!',
          'date': '2024-01-15'
        },
        {
          'author': 'Ana P.',
          'rating': 4.0,
          'comment': 'Boa qualidade, instalação fácil.',
          'date': '2024-02-20'
        },
      ],
      'rating': 4.5,
    },
    {
      'id': 'p002',
      'name': 'Disco de Freio Dianteiro',
      'code': 'TYC-002',
      'description':
          'Disco de freio dianteiro ventilado para Toyota Corolla. Alta resistência ao calor e desgaste uniforme.',
      'price': 320.00,
      'stock': 8,
      'imageUrl':
          'https://images.unsplash.com/photo-1563770660-92eb02e0ffc0?w=600&h=400&fit=crop',
      'category': 'Freios',
      'supplierId': 'sup2',
      'supplierName': 'Motorcraft Pro',
      'compatibilities': [
        {
          'brand': 'Toyota',
          'model': 'Corolla',
          'yearFrom': 2014,
          'yearTo': 2019
        },
      ],
      'reviews': [
        {
          'author': 'Roberto S.',
          'rating': 5.0,
          'comment': 'Produto original, chegou rápido.',
          'date': '2024-03-10'
        },
      ],
      'rating': 5.0,
    },
    {
      'id': 'p003',
      'name': 'Amortecedor Dianteiro',
      'code': 'TYC-003',
      'description':
          'Amortecedor dianteiro para Toyota Corolla. Proporciona conforto e estabilidade em qualquer tipo de pista.',
      'price': 450.00,
      'stock': 6,
      'imageUrl':
          'https://images.unsplash.com/photo-1610641818490-a6bd8cdc6b0b?w=600&h=400&fit=crop',
      'category': 'Suspensão',
      'supplierId': 'sup3',
      'supplierName': 'Continental Parts',
      'compatibilities': [
        {
          'brand': 'Toyota',
          'model': 'Corolla',
          'yearFrom': 2008,
          'yearTo': 2014
        },
      ],
      'reviews': [
        {
          'author': 'Marcos L.',
          'rating': 4.0,
          'comment': 'Boa qualidade pelo preço.',
          'date': '2024-01-05'
        },
      ],
      'rating': 4.0,
    },
    {
      'id': 'p004',
      'name': 'Filtro de Óleo',
      'code': 'TYC-004',
      'description':
          'Filtro de óleo original para Toyota Corolla. Filtragem eficiente para proteger o motor.',
      'price': 45.00,
      'stock': 50,
      'imageUrl':
          'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=600&h=400&fit=crop',
      'category': 'Filtros',
      'supplierId': 'sup1',
      'supplierName': 'AutoForce',
      'compatibilities': [
        {
          'brand': 'Toyota',
          'model': 'Corolla',
          'yearFrom': 2008,
          'yearTo': 2024
        },
      ],
      'reviews': [
        {
          'author': 'Juliana F.',
          'rating': 5.0,
          'comment': 'Original e de ótima qualidade.',
          'date': '2024-04-01'
        },
        {
          'author': 'Pedro H.',
          'rating': 5.0,
          'comment': 'Sempre compro aqui!',
          'date': '2024-04-15'
        },
      ],
      'rating': 5.0,
    },
    {
      'id': 'p005',
      'name': 'Correia Dentada',
      'code': 'TYC-005',
      'description':
          'Kit correia dentada completo para Toyota Corolla. Inclui correia, tensor e rolamentos.',
      'price': 380.00,
      'stock': 12,
      'imageUrl':
          'https://images.unsplash.com/photo-1533473359331-35fafa4ff4fa?w=600&h=400&fit=crop',
      'category': 'Motor',
      'supplierId': 'sup2',
      'supplierName': 'Motorcraft Pro',
      'compatibilities': [
        {
          'brand': 'Toyota',
          'model': 'Corolla',
          'yearFrom': 2002,
          'yearTo': 2015
        },
      ],
      'reviews': [
        {
          'author': 'Lucas R.',
          'rating': 4.5,
          'comment': 'Kit completo, tudo perfeito.',
          'date': '2024-03-20'
        },
      ],
      'rating': 4.5,
    },
    // ─── TOYOTA HILUX ─────────────────────────────────────────────
    {
      'id': 'p006',
      'name': 'Pastilha de Freio Traseira Hilux',
      'code': 'TYH-001',
      'description':
          'Pastilha de freio traseira para Toyota Hilux. Alta resistência para uso off-road.',
      'price': 210.00,
      'stock': 10,
      'imageUrl':
          'https://images.unsplash.com/photo-1486262715619-3417b3999ddd?w=600&h=400&fit=crop',
      'category': 'Freios',
      'supplierId': 'sup1',
      'supplierName': 'AutoForce',
      'compatibilities': [
        {'brand': 'Toyota', 'model': 'Hilux', 'yearFrom': 2016, 'yearTo': 2024},
      ],
      'reviews': [
        {
          'author': 'Fernando C.',
          'rating': 5.0,
          'comment': 'Produto excelente para uso pesado!',
          'date': '2024-02-10'
        },
      ],
      'rating': 5.0,
    },
    {
      'id': 'p007',
      'name': 'Filtro de Combustível Hilux',
      'code': 'TYH-002',
      'description':
          'Filtro de combustível para Toyota Hilux diesel. Alta filtragem para motores turbo.',
      'price': 95.00,
      'stock': 20,
      'imageUrl':
          'https://images.unsplash.com/photo-1488646953014-85cb44e25828?w=600&h=400&fit=crop',
      'category': 'Filtros',
      'supplierId': 'sup3',
      'supplierName': 'Continental Parts',
      'compatibilities': [
        {'brand': 'Toyota', 'model': 'Hilux', 'yearFrom': 2012, 'yearTo': 2024},
      ],
      'reviews': [
        {
          'author': 'Eduardo M.',
          'rating': 4.0,
          'comment': 'Bom produto, preço justo.',
          'date': '2024-03-05'
        },
      ],
      'rating': 4.0,
    },
    {
      'id': 'p008',
      'name': 'Amortecedor Traseiro Hilux',
      'code': 'TYH-003',
      'description':
          'Amortecedor traseiro reforçado para Toyota Hilux. Ideal para carga e terrenos irregulares.',
      'price': 580.00,
      'stock': 5,
      'imageUrl':
          'https://images.unsplash.com/photo-1610641818490-a6bd8cdc6b0b?w=600&h=400&fit=crop',
      'category': 'Suspensão',
      'supplierId': 'sup2',
      'supplierName': 'Motorcraft Pro',
      'compatibilities': [
        {'brand': 'Toyota', 'model': 'Hilux', 'yearFrom': 2005, 'yearTo': 2015},
      ],
      'reviews': [
        {
          'author': 'Ricardo B.',
          'rating': 5.0,
          'comment': 'Resistente e de qualidade!',
          'date': '2024-01-25'
        },
      ],
      'rating': 5.0,
    },
    {
      'id': 'p009',
      'name': 'Vela de Ignição Hilux',
      'code': 'TYH-004',
      'description':
          'Jogo de velas de ignição iridium para Toyota Hilux gasolina. Máxima performance.',
      'price': 220.00,
      'stock': 18,
      'imageUrl':
          'https://images.unsplash.com/photo-1599381832335-3d8d1a7f2e9f?w=600&h=400&fit=crop',
      'category': 'Motor',
      'supplierId': 'sup1',
      'supplierName': 'AutoForce',
      'compatibilities': [
        {'brand': 'Toyota', 'model': 'Hilux', 'yearFrom': 2016, 'yearTo': 2024},
      ],
      'reviews': [
        {
          'author': 'Thiago A.',
          'rating': 4.5,
          'comment': 'Melhorou muito o desempenho!',
          'date': '2024-02-28'
        },
      ],
      'rating': 4.5,
    },
    {
      'id': 'p010',
      'name': 'Filtro de Ar Hilux',
      'code': 'TYH-005',
      'description':
          'Filtro de ar de alta performance para Toyota Hilux. Aumenta a eficiência do motor.',
      'price': 75.00,
      'stock': 30,
      'imageUrl':
          'https://images.unsplash.com/photo-1488646953014-85cb44e25828?w=600&h=400&fit=crop',
      'category': 'Filtros',
      'supplierId': 'sup3',
      'supplierName': 'Continental Parts',
      'compatibilities': [
        {'brand': 'Toyota', 'model': 'Hilux', 'yearFrom': 2005, 'yearTo': 2024},
      ],
      'reviews': [
        {
          'author': 'Fábio N.',
          'rating': 4.0,
          'comment': 'Fácil de instalar, bom preço.',
          'date': '2024-04-10'
        },
      ],
      'rating': 4.0,
    },
    // ─── FORD KA ─────────────────────────────────────────────────
    {
      'id': 'p011',
      'name': 'Pastilha de Freio Ford Ka',
      'code': 'FKA-001',
      'description':
          'Pastilha de freio dianteira para Ford Ka. Material de alta fricção para frenagem segura.',
      'price': 145.00,
      'stock': 22,
      'imageUrl':
          'https://images.unsplash.com/photo-1486262715619-3417b3999ddd?w=600&h=400&fit=crop',
      'category': 'Freios',
      'supplierId': 'sup1',
      'supplierName': 'AutoForce',
      'compatibilities': [
        {'brand': 'Ford', 'model': 'Ka', 'yearFrom': 2015, 'yearTo': 2024},
      ],
      'reviews': [
        {
          'author': 'Renata O.',
          'rating': 4.5,
          'comment': 'Ótimo custo-benefício!',
          'date': '2024-01-30'
        },
      ],
      'rating': 4.5,
    },
    {
      'id': 'p012',
      'name': 'Correia Alternador Ford Ka',
      'code': 'FKA-002',
      'description':
          'Correia do alternador para Ford Ka 1.0 e 1.5. Alta durabilidade.',
      'price': 89.00,
      'stock': 15,
      'imageUrl':
          'https://images.unsplash.com/photo-1533473359331-35fafa4ff4fa?w=600&h=400&fit=crop',
      'category': 'Motor',
      'supplierId': 'sup2',
      'supplierName': 'Motorcraft Pro',
      'compatibilities': [
        {'brand': 'Ford', 'model': 'Ka', 'yearFrom': 2014, 'yearTo': 2024},
      ],
      'reviews': [
        {
          'author': 'Vanessa T.',
          'rating': 5.0,
          'comment': 'Original Ford, encaixou perfeitamente.',
          'date': '2024-03-15'
        },
      ],
      'rating': 5.0,
    },
    {
      'id': 'p013',
      'name': 'Bateria 45Ah Ford Ka',
      'code': 'FKA-003',
      'description':
          'Bateria 45Ah para Ford Ka. Alta durabilidade e fácil manutenção.',
      'price': 420.00,
      'stock': 7,
      'imageUrl':
          'https://images.unsplash.com/photo-1596233265183-37f6dd4b1e7a?w=600&h=400&fit=crop',
      'category': 'Elétrica',
      'supplierId': 'sup3',
      'supplierName': 'Continental Parts',
      'compatibilities': [
        {'brand': 'Ford', 'model': 'Ka', 'yearFrom': 2008, 'yearTo': 2024},
      ],
      'reviews': [
        {
          'author': 'Rodrigo V.',
          'rating': 4.0,
          'comment': 'Boa bateria, entrega rápida.',
          'date': '2024-02-12'
        },
      ],
      'rating': 4.0,
    },
    {
      'id': 'p014',
      'name': 'Mola Suspensão Ford Ka',
      'code': 'FKA-004',
      'description':
          'Mola de suspensão dianteira para Ford Ka. Restaura a altura original do veículo.',
      'price': 190.00,
      'stock': 12,
      'imageUrl':
          'https://images.unsplash.com/photo-1610641818490-a6bd8cdc6b0b?w=600&h=400&fit=crop',
      'category': 'Suspensão',
      'supplierId': 'sup1',
      'supplierName': 'AutoForce',
      'compatibilities': [
        {'brand': 'Ford', 'model': 'Ka', 'yearFrom': 2015, 'yearTo': 2024},
      ],
      'reviews': [
        {
          'author': 'Daniela C.',
          'rating': 4.5,
          'comment': 'Produto bom e entrega rápida!',
          'date': '2024-04-05'
        },
      ],
      'rating': 4.5,
    },
    {
      'id': 'p015',
      'name': 'Filtro de Cabine Ford Ka',
      'code': 'FKA-005',
      'description':
          'Filtro de ar condicionado/cabine para Ford Ka. Filtra poeira e ácaros.',
      'price': 55.00,
      'stock': 40,
      'imageUrl':
          'https://images.unsplash.com/photo-1488646953014-85cb44e25828?w=600&h=400&fit=crop',
      'category': 'Filtros',
      'supplierId': 'sup2',
      'supplierName': 'Motorcraft Pro',
      'compatibilities': [
        {'brand': 'Ford', 'model': 'Ka', 'yearFrom': 2015, 'yearTo': 2024},
      ],
      'reviews': [
        {
          'author': 'Aline M.',
          'rating': 5.0,
          'comment': 'Parou de entrar poeira no carro!',
          'date': '2024-03-25'
        },
      ],
      'rating': 5.0,
    },
    // ─── FORD RANGER ──────────────────────────────────────────────
    {
      'id': 'p016',
      'name': 'Disco de Freio Ranger',
      'code': 'FRR-001',
      'description':
          'Disco de freio dianteiro para Ford Ranger. Ventilado e furado para máxima refrigeração.',
      'price': 480.00,
      'stock': 6,
      'imageUrl':
          'https://images.unsplash.com/photo-1563770660-92eb02e0ffc0?w=600&h=400&fit=crop',
      'category': 'Freios',
      'supplierId': 'sup2',
      'supplierName': 'Motorcraft Pro',
      'compatibilities': [
        {'brand': 'Ford', 'model': 'Ranger', 'yearFrom': 2013, 'yearTo': 2022},
      ],
      'reviews': [
        {
          'author': 'Alexandre P.',
          'rating': 5.0,
          'comment': 'Excelente produto para uso pesado!',
          'date': '2024-01-20'
        },
      ],
      'rating': 5.0,
    },
    {
      'id': 'p017',
      'name': 'Coxim do Motor Ranger',
      'code': 'FRR-002',
      'description':
          'Coxim do motor para Ford Ranger. Reduz vibração e ruído no habitáculo.',
      'price': 165.00,
      'stock': 9,
      'imageUrl':
          'https://images.unsplash.com/photo-1533473359331-35fafa4ff4fa?w=600&h=400&fit=crop',
      'category': 'Motor',
      'supplierId': 'sup3',
      'supplierName': 'Continental Parts',
      'compatibilities': [
        {'brand': 'Ford', 'model': 'Ranger', 'yearFrom': 2012, 'yearTo': 2022},
      ],
      'reviews': [
        {
          'author': 'Gustavo L.',
          'rating': 4.0,
          'comment': 'Reduziu bastante a vibração.',
          'date': '2024-02-18'
        },
      ],
      'rating': 4.0,
    },
    {
      'id': 'p018',
      'name': 'Barra Estabilizadora Ranger',
      'code': 'FRR-003',
      'description':
          'Barra estabilizadora dianteira para Ford Ranger. Melhora a estabilidade em curvas.',
      'price': 340.00,
      'stock': 4,
      'imageUrl':
          'https://images.unsplash.com/photo-1610641818490-a6bd8cdc6b0b?w=600&h=400&fit=crop',
      'category': 'Suspensão',
      'supplierId': 'sup1',
      'supplierName': 'AutoForce',
      'compatibilities': [
        {'brand': 'Ford', 'model': 'Ranger', 'yearFrom': 2013, 'yearTo': 2022},
      ],
      'reviews': [
        {
          'author': 'Henrique B.',
          'rating': 4.5,
          'comment': 'Estabilidade muito melhorou!',
          'date': '2024-03-08'
        },
      ],
      'rating': 4.5,
    },
    {
      'id': 'p019',
      'name': 'Alternador Ranger 2.2',
      'code': 'FRR-004',
      'description':
          'Alternador remanufaturado para Ford Ranger 2.2 diesel. Garantia de 12 meses.',
      'price': 890.00,
      'stock': 3,
      'imageUrl':
          'https://images.unsplash.com/photo-1581092918056-0c4c3acd3789?w=600&h=400&fit=crop',
      'category': 'Elétrica',
      'supplierId': 'sup2',
      'supplierName': 'Motorcraft Pro',
      'compatibilities': [
        {'brand': 'Ford', 'model': 'Ranger', 'yearFrom': 2013, 'yearTo': 2022},
      ],
      'reviews': [
        {
          'author': 'Cláudio S.',
          'rating': 5.0,
          'comment': 'Produto de primeira qualidade!',
          'date': '2024-01-10'
        },
      ],
      'rating': 5.0,
    },
    {
      'id': 'p020',
      'name': 'Escapamento Ranger',
      'code': 'FRR-005',
      'description':
          'Tubo de escapamento intermediário para Ford Ranger. Aço inox resistente à corrosão.',
      'price': 520.00,
      'stock': 5,
      'imageUrl':
          'https://images.unsplash.com/photo-1614162692292-7ac56d7f7f1e?w=600&h=400&fit=crop',
      'category': 'Escapamento',
      'supplierId': 'sup3',
      'supplierName': 'Continental Parts',
      'compatibilities': [
        {'brand': 'Ford', 'model': 'Ranger', 'yearFrom': 2012, 'yearTo': 2020},
      ],
      'reviews': [
        {
          'author': 'Bruno A.',
          'rating': 4.0,
          'comment': 'Produto correto e encaixou bem.',
          'date': '2024-04-12'
        },
      ],
      'rating': 4.0,
    },
    // ─── VOLKSWAGEN GOL ───────────────────────────────────────────
    {
      'id': 'p021',
      'name': 'Pastilha de Freio Gol',
      'code': 'VGO-001',
      'description':
          'Pastilha de freio dianteira para Volkswagen Gol. Baixo ruído e alta durabilidade.',
      'price': 129.90,
      'stock': 25,
      'imageUrl':
          'https://images.unsplash.com/photo-1486262715619-3417b3999ddd?w=600&h=400&fit=crop',
      'category': 'Freios',
      'supplierId': 'sup1',
      'supplierName': 'AutoForce',
      'compatibilities': [
        {
          'brand': 'Volkswagen',
          'model': 'Gol',
          'yearFrom': 2008,
          'yearTo': 2024
        },
      ],
      'reviews': [
        {
          'author': 'Mariana K.',
          'rating': 4.5,
          'comment': 'Muito boas, sem barulho!',
          'date': '2024-02-22'
        },
      ],
      'rating': 4.5,
    },
    {
      'id': 'p022',
      'name': 'Vela Iridium Gol 1.0',
      'code': 'VGO-002',
      'description':
          'Jogo de velas iridium para VW Gol 1.0. Motor mais suave e econômico.',
      'price': 185.00,
      'stock': 20,
      'imageUrl':
          'https://images.unsplash.com/photo-1599381832335-3d8d1a7f2e9f?w=600&h=400&fit=crop',
      'category': 'Motor',
      'supplierId': 'sup2',
      'supplierName': 'Motorcraft Pro',
      'compatibilities': [
        {
          'brand': 'Volkswagen',
          'model': 'Gol',
          'yearFrom': 2012,
          'yearTo': 2024
        },
      ],
      'reviews': [
        {
          'author': 'Patrícia F.',
          'rating': 5.0,
          'comment': 'Motor ficou muito mais suave!',
          'date': '2024-03-18'
        },
      ],
      'rating': 5.0,
    },
    {
      'id': 'p023',
      'name': 'Amortecedor Dianteiro Gol',
      'code': 'VGO-003',
      'description':
          'Amortecedor dianteiro para VW Gol. Conforto e controle em qualquer situação.',
      'price': 310.00,
      'stock': 11,
      'imageUrl':
          'https://images.unsplash.com/photo-1610641818490-a6bd8cdc6b0b?w=600&h=400&fit=crop',
      'category': 'Suspensão',
      'supplierId': 'sup3',
      'supplierName': 'Continental Parts',
      'compatibilities': [
        {
          'brand': 'Volkswagen',
          'model': 'Gol',
          'yearFrom': 2008,
          'yearTo': 2016
        },
      ],
      'reviews': [
        {
          'author': 'Leandro S.',
          'rating': 4.0,
          'comment': 'Melhorou muito o conforto.',
          'date': '2024-01-08'
        },
      ],
      'rating': 4.0,
    },
    {
      'id': 'p024',
      'name': 'Bobina de Ignição Gol',
      'code': 'VGO-004',
      'description':
          'Bobina de ignição para VW Gol 1.6 G6. Elimina falhas e perda de potência.',
      'price': 240.00,
      'stock': 14,
      'imageUrl':
          'https://images.unsplash.com/photo-1599381832335-3d8d1a7f2e9f?w=600&h=400&fit=crop',
      'category': 'Elétrica',
      'supplierId': 'sup1',
      'supplierName': 'AutoForce',
      'compatibilities': [
        {
          'brand': 'Volkswagen',
          'model': 'Gol',
          'yearFrom': 2014,
          'yearTo': 2024
        },
      ],
      'reviews': [
        {
          'author': 'Felipe D.',
          'rating': 4.5,
          'comment': 'Resolveu as falhas do motor!',
          'date': '2024-02-15'
        },
      ],
      'rating': 4.5,
    },
    {
      'id': 'p025',
      'name': 'Filtro de Óleo Gol',
      'code': 'VGO-005',
      'description':
          'Filtro de óleo original para VW Gol. Compatível com todos os motores.',
      'price': 38.00,
      'stock': 60,
      'imageUrl':
          'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=600&h=400&fit=crop',
      'category': 'Filtros',
      'supplierId': 'sup2',
      'supplierName': 'Motorcraft Pro',
      'compatibilities': [
        {
          'brand': 'Volkswagen',
          'model': 'Gol',
          'yearFrom': 2000,
          'yearTo': 2024
        },
      ],
      'reviews': [
        {
          'author': 'Tatiana B.',
          'rating': 5.0,
          'comment': 'Original e entrega rápida.',
          'date': '2024-04-18'
        },
      ],
      'rating': 5.0,
    },
    // ─── VOLKSWAGEN T-CROSS ──────────────────────────────────────
    {
      'id': 'p026',
      'name': 'Pastilha de Freio T-Cross',
      'code': 'VTC-001',
      'description':
          'Pastilha de freio dianteira para VW T-Cross. Material semimetálico de alta performance.',
      'price': 220.00,
      'stock': 16,
      'imageUrl':
          'https://images.unsplash.com/photo-1486262715619-3417b3999ddd?w=600&h=400&fit=crop',
      'category': 'Freios',
      'supplierId': 'sup1',
      'supplierName': 'AutoForce',
      'compatibilities': [
        {
          'brand': 'Volkswagen',
          'model': 'T-Cross',
          'yearFrom': 2019,
          'yearTo': 2024
        },
      ],
      'reviews': [
        {
          'author': 'Sabrina L.',
          'rating': 5.0,
          'comment': 'Perfeitas para o T-Cross!',
          'date': '2024-03-28'
        },
      ],
      'rating': 5.0,
    },
    {
      'id': 'p027',
      'name': 'Amortecedor T-Cross',
      'code': 'VTC-002',
      'description':
          'Amortecedor dianteiro para VW T-Cross. Compatível com suspensão original.',
      'price': 490.00,
      'stock': 7,
      'imageUrl':
          'https://images.unsplash.com/photo-1610641818490-a6bd8cdc6b0b?w=600&h=400&fit=crop',
      'category': 'Suspensão',
      'supplierId': 'sup3',
      'supplierName': 'Continental Parts',
      'compatibilities': [
        {
          'brand': 'Volkswagen',
          'model': 'T-Cross',
          'yearFrom': 2019,
          'yearTo': 2024
        },
      ],
      'reviews': [
        {
          'author': 'Otávio C.',
          'rating': 4.5,
          'comment': 'Ótima qualidade!',
          'date': '2024-01-22'
        },
      ],
      'rating': 4.5,
    },
    {
      'id': 'p028',
      'name': 'Filtro de Ar T-Cross 1.0',
      'code': 'VTC-003',
      'description':
          'Filtro de ar para VW T-Cross 1.0 TSI. Protege o motor de impurezas.',
      'price': 65.00,
      'stock': 28,
      'imageUrl':
          'https://images.unsplash.com/photo-1488646953014-85cb44e25828?w=600&h=400&fit=crop',
      'category': 'Filtros',
      'supplierId': 'sup2',
      'supplierName': 'Motorcraft Pro',
      'compatibilities': [
        {
          'brand': 'Volkswagen',
          'model': 'T-Cross',
          'yearFrom': 2019,
          'yearTo': 2024
        },
      ],
      'reviews': [
        {
          'author': 'Camila R.',
          'rating': 4.0,
          'comment': 'Produto certo para o meu carro.',
          'date': '2024-02-25'
        },
      ],
      'rating': 4.0,
    },
    {
      'id': 'p029',
      'name': 'Vela Iridium T-Cross',
      'code': 'VTC-004',
      'description':
          'Jogo de velas iridium para VW T-Cross 1.0 TSI. Melhor partida e menor consumo.',
      'price': 210.00,
      'stock': 18,
      'imageUrl':
          'https://images.unsplash.com/photo-1599381832335-3d8d1a7f2e9f?w=600&h=400&fit=crop',
      'category': 'Motor',
      'supplierId': 'sup1',
      'supplierName': 'AutoForce',
      'compatibilities': [
        {
          'brand': 'Volkswagen',
          'model': 'T-Cross',
          'yearFrom': 2019,
          'yearTo': 2024
        },
      ],
      'reviews': [
        {
          'author': 'Igor P.',
          'rating': 5.0,
          'comment': 'Partida mais fácil no frio!',
          'date': '2024-04-02'
        },
      ],
      'rating': 5.0,
    },
    {
      'id': 'p030',
      'name': 'Limpador de Para-brisa T-Cross',
      'code': 'VTC-005',
      'description':
          'Par de limpadores de para-brisa para VW T-Cross. Silicone de alta durabilidade.',
      'price': 110.00,
      'stock': 35,
      'imageUrl':
          'https://images.unsplash.com/photo-1580274455191-1c62238fa333?w=600&h=400&fit=crop',
      'category': 'Carroceria',
      'supplierId': 'sup3',
      'supplierName': 'Continental Parts',
      'compatibilities': [
        {
          'brand': 'Volkswagen',
          'model': 'T-Cross',
          'yearFrom': 2019,
          'yearTo': 2024
        },
      ],
      'reviews': [
        {
          'author': 'Bianca F.',
          'rating': 4.5,
          'comment': 'Excelente visibilidade na chuva!',
          'date': '2024-03-12'
        },
      ],
      'rating': 4.5,
    },
    // ─── HONDA CIVIC ──────────────────────────────────────────────
    {
      'id': 'p031',
      'name': 'Pastilha de Freio Civic',
      'code': 'HCI-001',
      'description':
          'Pastilha de freio dianteira para Honda Civic. Cerâmica de alta performance.',
      'price': 195.00,
      'stock': 14,
      'imageUrl':
          'https://images.unsplash.com/photo-1486262715619-3417b3999ddd?w=600&h=400&fit=crop',
      'category': 'Freios',
      'supplierId': 'sup2',
      'supplierName': 'Motorcraft Pro',
      'compatibilities': [
        {'brand': 'Honda', 'model': 'Civic', 'yearFrom': 2017, 'yearTo': 2024},
      ],
      'reviews': [
        {
          'author': 'Natália G.',
          'rating': 5.0,
          'comment': 'Silenciosas e eficientes!',
          'date': '2024-02-05'
        },
      ],
      'rating': 5.0,
    },
    {
      'id': 'p032',
      'name': 'Amortecedor Traseiro Civic',
      'code': 'HCI-002',
      'description':
          'Amortecedor traseiro para Honda Civic. Absorção de impacto superior.',
      'price': 420.00,
      'stock': 9,
      'imageUrl':
          'https://images.unsplash.com/photo-1610641818490-a6bd8cdc6b0b?w=600&h=400&fit=crop',
      'category': 'Suspensão',
      'supplierId': 'sup1',
      'supplierName': 'AutoForce',
      'compatibilities': [
        {'brand': 'Honda', 'model': 'Civic', 'yearFrom': 2012, 'yearTo': 2017},
      ],
      'reviews': [
        {
          'author': 'André K.',
          'rating': 4.5,
          'comment': 'Produto original e de qualidade.',
          'date': '2024-01-18'
        },
      ],
      'rating': 4.5,
    },
    {
      'id': 'p033',
      'name': 'Filtro de Óleo Civic',
      'code': 'HCI-003',
      'description':
          'Filtro de óleo para Honda Civic 1.5 turbo. Alta eficiência de filtragem.',
      'price': 52.00,
      'stock': 45,
      'imageUrl':
          'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=600&h=400&fit=crop',
      'category': 'Filtros',
      'supplierId': 'sup3',
      'supplierName': 'Continental Parts',
      'compatibilities': [
        {'brand': 'Honda', 'model': 'Civic', 'yearFrom': 2017, 'yearTo': 2024},
      ],
      'reviews': [
        {
          'author': 'Cecília M.',
          'rating': 4.0,
          'comment': 'Original Honda, preço bom.',
          'date': '2024-03-22'
        },
      ],
      'rating': 4.0,
    },
    {
      'id': 'p034',
      'name': 'Correia Acessórios Civic',
      'code': 'HCI-004',
      'description':
          'Correia de acessórios para Honda Civic. Alta resistência e longa vida útil.',
      'price': 130.00,
      'stock': 17,
      'imageUrl':
          'https://images.unsplash.com/photo-1533473359331-35fafa4ff4fa?w=600&h=400&fit=crop',
      'category': 'Motor',
      'supplierId': 'sup2',
      'supplierName': 'Motorcraft Pro',
      'compatibilities': [
        {'brand': 'Honda', 'model': 'Civic', 'yearFrom': 2012, 'yearTo': 2024},
      ],
      'reviews': [
        {
          'author': 'Paulo J.',
          'rating': 4.5,
          'comment': 'Encaixou perfeitamente, sem ruído.',
          'date': '2024-04-08'
        },
      ],
      'rating': 4.5,
    },
    {
      'id': 'p035',
      'name': 'Bateria 60Ah Civic',
      'code': 'HCI-005',
      'description':
          'Bateria 60Ah selada para Honda Civic. Livre de manutenção e alta durabilidade.',
      'price': 480.00,
      'stock': 6,
      'imageUrl':
          'https://images.unsplash.com/photo-1596233265183-37f6dd4b1e7a?w=600&h=400&fit=crop',
      'category': 'Elétrica',
      'supplierId': 'sup1',
      'supplierName': 'AutoForce',
      'compatibilities': [
        {'brand': 'Honda', 'model': 'Civic', 'yearFrom': 2012, 'yearTo': 2024},
      ],
      'reviews': [
        {
          'author': 'Lúcia T.',
          'rating': 5.0,
          'comment': 'Bateria excelente, já dura 3 anos!',
          'date': '2024-01-30'
        },
      ],
      'rating': 5.0,
    },
    // ─── HONDA HR-V ───────────────────────────────────────────────
    {
      'id': 'p036',
      'name': 'Pastilha de Freio HR-V',
      'code': 'HHR-001',
      'description':
          'Pastilha de freio dianteira para Honda HR-V. Compatível com todas as versões.',
      'price': 215.00,
      'stock': 13,
      'imageUrl':
          'https://images.unsplash.com/photo-1486262715619-3417b3999ddd?w=600&h=400&fit=crop',
      'category': 'Freios',
      'supplierId': 'sup3',
      'supplierName': 'Continental Parts',
      'compatibilities': [
        {'brand': 'Honda', 'model': 'HR-V', 'yearFrom': 2015, 'yearTo': 2024},
      ],
      'reviews': [
        {
          'author': 'Simone A.',
          'rating': 4.5,
          'comment': 'Ótimas pastilhas para o HR-V!',
          'date': '2024-02-28'
        },
      ],
      'rating': 4.5,
    },
    {
      'id': 'p037',
      'name': 'Filtro de Ar HR-V',
      'code': 'HHR-002',
      'description':
          'Filtro de ar para Honda HR-V 1.8. Proteção eficiente do motor.',
      'price': 70.00,
      'stock': 24,
      'imageUrl':
          'https://images.unsplash.com/photo-1488646953014-85cb44e25828?w=600&h=400&fit=crop',
      'category': 'Filtros',
      'supplierId': 'sup2',
      'supplierName': 'Motorcraft Pro',
      'compatibilities': [
        {'brand': 'Honda', 'model': 'HR-V', 'yearFrom': 2015, 'yearTo': 2024},
      ],
      'reviews': [
        {
          'author': 'Victor N.',
          'rating': 4.0,
          'comment': 'Preço bom, produto original.',
          'date': '2024-03-05'
        },
      ],
      'rating': 4.0,
    },
    {
      'id': 'p038',
      'name': 'Amortecedor Dianteiro HR-V',
      'code': 'HHR-003',
      'description':
          'Amortecedor dianteiro para Honda HR-V. Equilíbrio perfeito entre conforto e performance.',
      'price': 440.00,
      'stock': 8,
      'imageUrl':
          'https://images.unsplash.com/photo-1610641818490-a6bd8cdc6b0b?w=600&h=400&fit=crop',
      'category': 'Suspensão',
      'supplierId': 'sup1',
      'supplierName': 'AutoForce',
      'compatibilities': [
        {'brand': 'Honda', 'model': 'HR-V', 'yearFrom': 2015, 'yearTo': 2021},
      ],
      'reviews': [
        {
          'author': 'Diana B.',
          'rating': 5.0,
          'comment': 'Carro ficou novo na suspensão!',
          'date': '2024-01-14'
        },
      ],
      'rating': 5.0,
    },
    {
      'id': 'p039',
      'name': 'Lâmpada LED HR-V',
      'code': 'HHR-004',
      'description':
          'Kit lâmpadas LED para faróis do Honda HR-V. Iluminação 3x superior ao halógeno.',
      'price': 280.00,
      'stock': 16,
      'imageUrl':
          'https://images.unsplash.com/photo-1570129477492-45e003aedd38?w=600&h=400&fit=crop',
      'category': 'Elétrica',
      'supplierId': 'sup3',
      'supplierName': 'Continental Parts',
      'compatibilities': [
        {'brand': 'Honda', 'model': 'HR-V', 'yearFrom': 2015, 'yearTo': 2024},
      ],
      'reviews': [
        {
          'author': 'Rafael G.',
          'rating': 4.5,
          'comment': 'Iluminação fantástica!',
          'date': '2024-04-20'
        },
      ],
      'rating': 4.5,
    },
    {
      'id': 'p040',
      'name': 'Escapamento HR-V',
      'code': 'HHR-005',
      'description':
          'Ponteira de escapamento esportiva para Honda HR-V. Aço inox polido.',
      'price': 350.00,
      'stock': 10,
      'imageUrl':
          'https://images.unsplash.com/photo-1614162692292-7ac56d7f7f1e?w=600&h=400&fit=crop',
      'category': 'Escapamento',
      'supplierId': 'sup2',
      'supplierName': 'Motorcraft Pro',
      'compatibilities': [
        {'brand': 'Honda', 'model': 'HR-V', 'yearFrom': 2015, 'yearTo': 2024},
      ],
      'reviews': [
        {
          'author': 'Larissa O.',
          'rating': 4.0,
          'comment': 'Visual incrível e bom som!',
          'date': '2024-03-30'
        },
      ],
      'rating': 4.0,
    },
    // ─── CHEVROLET ONIX ──────────────────────────────────────────
    {
      'id': 'p041',
      'name': 'Pastilha de Freio Onix',
      'code': 'CON-001',
      'description':
          'Pastilha de freio dianteira para Chevrolet Onix. Alta performance e durabilidade.',
      'price': 155.00,
      'stock': 22,
      'imageUrl':
          'https://images.unsplash.com/photo-1486262715619-3417b3999ddd?w=600&h=400&fit=crop',
      'category': 'Freios',
      'supplierId': 'sup1',
      'supplierName': 'AutoForce',
      'compatibilities': [
        {
          'brand': 'Chevrolet',
          'model': 'Onix',
          'yearFrom': 2013,
          'yearTo': 2024
        },
      ],
      'reviews': [
        {
          'author': 'Mônica S.',
          'rating': 4.5,
          'comment': 'Ótimo produto pelo preço!',
          'date': '2024-02-08'
        },
      ],
      'rating': 4.5,
    },
    {
      'id': 'p042',
      'name': 'Filtro de Óleo Onix',
      'code': 'CON-002',
      'description':
          'Filtro de óleo para Chevrolet Onix 1.0 e 1.4. Original GM.',
      'price': 42.00,
      'stock': 55,
      'imageUrl':
          'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=600&h=400&fit=crop',
      'category': 'Filtros',
      'supplierId': 'sup2',
      'supplierName': 'Motorcraft Pro',
      'compatibilities': [
        {
          'brand': 'Chevrolet',
          'model': 'Onix',
          'yearFrom': 2013,
          'yearTo': 2024
        },
      ],
      'reviews': [
        {
          'author': 'Clarice P.',
          'rating': 5.0,
          'comment': 'Original GM, sempre uso!',
          'date': '2024-03-15'
        },
      ],
      'rating': 5.0,
    },
    {
      'id': 'p043',
      'name': 'Amortecedor Dianteiro Onix',
      'code': 'CON-003',
      'description':
          'Amortecedor dianteiro para Chevrolet Onix. Conforto urbano garantido.',
      'price': 335.00,
      'stock': 12,
      'imageUrl':
          'https://images.unsplash.com/photo-1610641818490-a6bd8cdc6b0b?w=600&h=400&fit=crop',
      'category': 'Suspensão',
      'supplierId': 'sup3',
      'supplierName': 'Continental Parts',
      'compatibilities': [
        {
          'brand': 'Chevrolet',
          'model': 'Onix',
          'yearFrom': 2013,
          'yearTo': 2020
        },
      ],
      'reviews': [
        {
          'author': 'Márcio L.',
          'rating': 4.0,
          'comment': 'Conforto muito melhorou.',
          'date': '2024-01-28'
        },
      ],
      'rating': 4.0,
    },
    {
      'id': 'p044',
      'name': 'Vela de Ignição Onix',
      'code': 'CON-004',
      'description':
          'Jogo de 4 velas de ignição iridium para Chevrolet Onix 1.0 turbo.',
      'price': 200.00,
      'stock': 20,
      'imageUrl':
          'https://images.unsplash.com/photo-1599381832335-3d8d1a7f2e9f?w=600&h=400&fit=crop',
      'category': 'Motor',
      'supplierId': 'sup1',
      'supplierName': 'AutoForce',
      'compatibilities': [
        {
          'brand': 'Chevrolet',
          'model': 'Onix',
          'yearFrom': 2020,
          'yearTo': 2024
        },
      ],
      'reviews': [
        {
          'author': 'Jéssica W.',
          'rating': 4.5,
          'comment': 'Motor muito mais suave agora!',
          'date': '2024-02-18'
        },
      ],
      'rating': 4.5,
    },
    {
      'id': 'p045',
      'name': 'Bateria 40Ah Onix',
      'code': 'CON-005',
      'description':
          'Bateria 40Ah para Chevrolet Onix. Selada, livre de manutenção.',
      'price': 360.00,
      'stock': 9,
      'imageUrl':
          'https://images.unsplash.com/photo-1596233265183-37f6dd4b1e7a?w=600&h=400&fit=crop',
      'category': 'Elétrica',
      'supplierId': 'sup2',
      'supplierName': 'Motorcraft Pro',
      'compatibilities': [
        {
          'brand': 'Chevrolet',
          'model': 'Onix',
          'yearFrom': 2013,
          'yearTo': 2024
        },
      ],
      'reviews': [
        {
          'author': 'Tiago R.',
          'rating': 4.0,
          'comment': 'Boa bateria, preço justo.',
          'date': '2024-04-22'
        },
      ],
      'rating': 4.0,
    },
    // ─── CHEVROLET S10 ────────────────────────────────────────────
    {
      'id': 'p046',
      'name': 'Disco de Freio S10',
      'code': 'CS10-001',
      'description':
          'Disco de freio dianteiro ventilado para Chevrolet S10. Resistência para uso pesado.',
      'price': 460.00,
      'stock': 7,
      'imageUrl':
          'https://images.unsplash.com/photo-1563770660-92eb02e0ffc0?w=600&h=400&fit=crop',
      'category': 'Freios',
      'supplierId': 'sup3',
      'supplierName': 'Continental Parts',
      'compatibilities': [
        {
          'brand': 'Chevrolet',
          'model': 'S10',
          'yearFrom': 2012,
          'yearTo': 2024
        },
      ],
      'reviews': [
        {
          'author': 'Marcelo F.',
          'rating': 5.0,
          'comment': 'Excelente para uso pesado!',
          'date': '2024-01-05'
        },
      ],
      'rating': 5.0,
    },
    {
      'id': 'p047',
      'name': 'Filtro de Combustível S10',
      'code': 'CS10-002',
      'description':
          'Filtro de combustível para Chevrolet S10 2.8 diesel. Alta eficiência.',
      'price': 110.00,
      'stock': 18,
      'imageUrl':
          'https://images.unsplash.com/photo-1488646953014-85cb44e25828?w=600&h=400&fit=crop',
      'category': 'Filtros',
      'supplierId': 'sup1',
      'supplierName': 'AutoForce',
      'compatibilities': [
        {
          'brand': 'Chevrolet',
          'model': 'S10',
          'yearFrom': 2012,
          'yearTo': 2024
        },
      ],
      'reviews': [
        {
          'author': 'Nelson B.',
          'rating': 4.5,
          'comment': 'Bom produto, funcionou perfeitamente.',
          'date': '2024-03-02'
        },
      ],
      'rating': 4.5,
    },
    {
      'id': 'p048',
      'name': 'Amortecedor Traseiro S10',
      'code': 'CS10-003',
      'description':
          'Amortecedor traseiro reforçado para Chevrolet S10. Suporta carga extra.',
      'price': 560.00,
      'stock': 5,
      'imageUrl':
          'https://images.unsplash.com/photo-1610641818490-a6bd8cdc6b0b?w=600&h=400&fit=crop',
      'category': 'Suspensão',
      'supplierId': 'sup2',
      'supplierName': 'Motorcraft Pro',
      'compatibilities': [
        {
          'brand': 'Chevrolet',
          'model': 'S10',
          'yearFrom': 2005,
          'yearTo': 2012
        },
      ],
      'reviews': [
        {
          'author': 'Rogério C.',
          'rating': 4.5,
          'comment': 'Resistente e de boa qualidade!',
          'date': '2024-02-06'
        },
      ],
      'rating': 4.5,
    },
    {
      'id': 'p049',
      'name': 'Alternador S10 2.8',
      'code': 'CS10-004',
      'description':
          'Alternador remanufaturado para Chevrolet S10 2.8 diesel. Garantia 12 meses.',
      'price': 950.00,
      'stock': 3,
      'imageUrl':
          'https://images.unsplash.com/photo-1581092918056-0c4c3acd3789?w=600&h=400&fit=crop',
      'category': 'Elétrica',
      'supplierId': 'sup3',
      'supplierName': 'Continental Parts',
      'compatibilities': [
        {
          'brand': 'Chevrolet',
          'model': 'S10',
          'yearFrom': 2012,
          'yearTo': 2024
        },
      ],
      'reviews': [
        {
          'author': 'Waldenir P.',
          'rating': 5.0,
          'comment': 'Produto de qualidade, resolveu o problema!',
          'date': '2024-01-12'
        },
      ],
      'rating': 5.0,
    },
    {
      'id': 'p050',
      'name': 'Escapamento S10',
      'code': 'CS10-005',
      'description':
          'Silencioso traseiro para Chevrolet S10. Aço inox, reduz ruído e aumenta desempenho.',
      'price': 620.00,
      'stock': 4,
      'imageUrl':
          'https://images.unsplash.com/photo-1614162692292-7ac56d7f7f1e?w=600&h=400&fit=crop',
      'category': 'Escapamento',
      'supplierId': 'sup1',
      'supplierName': 'AutoForce',
      'compatibilities': [
        {
          'brand': 'Chevrolet',
          'model': 'S10',
          'yearFrom': 2012,
          'yearTo': 2022
        },
      ],
      'reviews': [
        {
          'author': 'Cleiton A.',
          'rating': 4.0,
          'comment': 'Acabou com o barulho no motor!',
          'date': '2024-04-16'
        },
      ],
      'rating': 4.0,
    },
  ];
}
