class CarritoItem {
  final int? id;
  final int productoId;
  final String nombreProducto;
  final int cantidad;
  final double precioUnitario;
  final double subtotal;

  CarritoItem({
    this.id,
    required this.productoId,
    required this.nombreProducto,
    required this.cantidad,
    required this.precioUnitario,
    required this.subtotal,
  });

  factory CarritoItem.fromJson(Map<String, dynamic> json) {
    return CarritoItem(
      id: json['id'],
      productoId: json['productoId'],
      nombreProducto: json['nombreProducto'],
      cantidad: json['cantidad'],
      precioUnitario: json['precioUnitario'].toDouble(),
      subtotal: json['subtotal'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productoId': productoId,
      'nombreProducto': nombreProducto,
      'cantidad': cantidad,
      'precioUnitario': precioUnitario,
      'subtotal': subtotal,
    };
  }

  CarritoItem copyWith({
    int? id,
    int? productoId,
    String? nombreProducto,
    int? cantidad,
    double? precioUnitario,
    double? subtotal,
  }) {
    return CarritoItem(
      id: id ?? this.id,
      productoId: productoId ?? this.productoId,
      nombreProducto: nombreProducto ?? this.nombreProducto,
      cantidad: cantidad ?? this.cantidad,
      precioUnitario: precioUnitario ?? this.precioUnitario,
      subtotal: subtotal ?? this.subtotal,
    );
  }
} 