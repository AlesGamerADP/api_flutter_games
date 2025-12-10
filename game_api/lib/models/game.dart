class Game {
  final int? id;
  final String nombre;
  final String genero;
  final String plataforma;
  final String descripcion;
  final int anioLanzamiento;
  final String? imagenUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Game({
    this.id,
    required this.nombre,
    required this.genero,
    required this.plataforma,
    required this.descripcion,
    required this.anioLanzamiento,
    this.imagenUrl,
    this.createdAt,
    this.updatedAt,
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      id: json['id'],
      nombre: json['nombre'],
      genero: json['genero'],
      plataforma: json['plataforma'],
      descripcion: json['descripcion'],
      anioLanzamiento: json['año_lanzamiento'],
      imagenUrl: json['imagen_url'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'nombre': nombre,
      'genero': genero,
      'plataforma': plataforma,
      'descripcion': descripcion,
      'año_lanzamiento': anioLanzamiento,
      if (imagenUrl != null) 'imagen_url': imagenUrl,
    };
  }

  Game copyWith({
    int? id,
    String? nombre,
    String? genero,
    String? plataforma,
    String? descripcion,
    int? anioLanzamiento,
    String? imagenUrl,
  }) {
    return Game(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      genero: genero ?? this.genero,
      plataforma: plataforma ?? this.plataforma,
      descripcion: descripcion ?? this.descripcion,
      anioLanzamiento: anioLanzamiento ?? this.anioLanzamiento,
      imagenUrl: imagenUrl ?? this.imagenUrl,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

