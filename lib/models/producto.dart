class Material {
  final int materialId;
  final int cantidad;

  Material({
    required this.materialId,
    required this.cantidad,
  });

  factory Material.fromJson(Map<String, dynamic> json) {
    return Material(
      materialId: json['materialId'],
      cantidad: json['cantidad'],
    );
  }
}

class Producto {
  final String nombre;
  final String descripcion;
  final int stock;
  final int stockMinimo;
  final double precioUnitario;
  final String tiempo;
  final String imagen;
  final List<Material> materiales;

  Producto({
    required this.nombre,
    required this.descripcion,
    required this.stock,
    required this.stockMinimo,
    required this.precioUnitario,
    required this.tiempo,
    required this.imagen,
    required this.materiales,
  });

  factory Producto.fromJson(Map<String, dynamic> json) {
    var materialesList = (json['materiales'] as List?)
        ?.map((item) => Material.fromJson(item))
        .toList() ?? [];

    return Producto(
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      stock: json['stock'],
      stockMinimo: json['stock_minimo'],
      precioUnitario: json['precioUnitario'].toDouble(),
      tiempo: json['tiempo'],
      imagen: json['imagen'],
      materiales: materialesList,
    );
  }
}