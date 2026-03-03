class Address {
  final String id;
  final String label; // Casa, Trabalho, Outro
  final String zipCode;
  final String street;
  final String number;
  final String complement;
  final String neighborhood;
  final String city;
  final String state;
  final bool isDefault;

  const Address({
    required this.id,
    required this.label,
    required this.zipCode,
    required this.street,
    required this.number,
    this.complement = '',
    required this.neighborhood,
    required this.city,
    required this.state,
    this.isDefault = false,
  });

  String get fullAddress =>
      '$street, $number${complement.isNotEmpty ? ' - $complement' : ''}, $neighborhood, $city/$state';

  Address copyWith({
    String? label,
    String? zipCode,
    String? street,
    String? number,
    String? complement,
    String? neighborhood,
    String? city,
    String? state,
    bool? isDefault,
  }) {
    return Address(
      id: id,
      label: label ?? this.label,
      zipCode: zipCode ?? this.zipCode,
      street: street ?? this.street,
      number: number ?? this.number,
      complement: complement ?? this.complement,
      neighborhood: neighborhood ?? this.neighborhood,
      city: city ?? this.city,
      state: state ?? this.state,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'label': label,
        'zipCode': zipCode,
        'street': street,
        'number': number,
        'complement': complement,
        'neighborhood': neighborhood,
        'city': city,
        'state': state,
        'isDefault': isDefault,
      };

  factory Address.fromMap(Map<String, dynamic> map) => Address(
        id: map['id'] as String,
        label: map['label'] as String,
        zipCode: map['zipCode'] as String,
        street: map['street'] as String,
        number: map['number'] as String,
        complement: (map['complement'] as String?) ?? '',
        neighborhood: map['neighborhood'] as String,
        city: map['city'] as String,
        state: map['state'] as String,
        isDefault: (map['isDefault'] as bool?) ?? false,
      );
}
