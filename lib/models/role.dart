class Role {
  final int id;
  final String nombre;
  final List<dynamic> permisos;

  Role({
    required this.id,
    required this.nombre,
    required this.permisos,
  });

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      id: json['id'],
      nombre: json['nombre'],
      permisos: json['permisos'] ?? [],
    );
  }
}