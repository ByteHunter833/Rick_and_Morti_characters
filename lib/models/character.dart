class Character {
  final int id;
  final String name;
  final String status;
  final String species;
  final String type;
  final String gender;
  final String image;
  final String locationName;
  final String originName;
  bool isFavorite;

  Character({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.type,
    required this.gender,
    required this.image,
    required this.locationName,
    required this.originName,
    this.isFavorite = false,
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      id: json['id'] as int,
      name: json['name'] as String,
      status: json['status'] as String,
      species: json['species'] as String,
      type: json['type'] as String? ?? '',
      gender: json['gender'] as String,
      image: json['image'] as String,
      locationName: json['location']['name'] as String,
      originName: json['origin']['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'status': status,
      'species': species,
      'type': type,
      'gender': gender,
      'image': image,
      'locationName': locationName,
      'originName': originName,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'status': status,
      'species': species,
      'type': type,
      'gender': gender,
      'image': image,
      'locationName': locationName,
      'originName': originName,
      'isFavorite': isFavorite ? 1 : 0,
    };
  }

  factory Character.fromMap(Map<String, dynamic> map) {
    return Character(
      id: map['id'] as int,
      name: map['name'] as String,
      status: map['status'] as String,
      species: map['species'] as String,
      type: map['type'] as String? ?? '',
      gender: map['gender'] as String,
      image: map['image'] as String,
      locationName: map['locationName'] as String,
      originName: map['originName'] as String,
      isFavorite: (map['isFavorite'] as int) == 1,
    );
  }

  Character copyWith({bool? isFavorite}) {
    return Character(
      id: id,
      name: name,
      status: status,
      species: species,
      type: type,
      gender: gender,
      image: image,
      locationName: locationName,
      originName: originName,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
