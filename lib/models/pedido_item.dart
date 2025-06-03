class PedidoItem {
  final int? id;
  final int productoId;
  final String nombreProducto;
  final int cantidad;
  final double precioUnitario;
  final double importeTotal;
  final double? importeTotalDesc;
  final bool? estado;

  PedidoItem({
    this.id,
    required this.productoId,
    required this.nombreProducto,
    required this.cantidad,
    required this.precioUnitario,
    required this.importeTotal,
    this.importeTotalDesc,
    this.estado,
  });

  factory PedidoItem.fromJson(Map<String, dynamic> json) {
    // El nombre del producto viene del objeto producto
    String nombreProducto = '';
    int productoId = 0;
    
    if (json['producto'] != null) {
      nombreProducto = json['producto']['nombre'] ?? '';
      productoId = json['producto']['id'] ?? 0;
    }

    return PedidoItem(
      id: json['id'],
      productoId: productoId,
      nombreProducto: nombreProducto,
      cantidad: json['cantidad'] ?? 0,
      precioUnitario: (json['precioUnitario'] ?? 0.0).toDouble(),
      importeTotal: (json['importe_Total'] ?? 0.0).toDouble(),
      importeTotalDesc: json['importe_Total_Desc']?.toDouble(),
      estado: json['Estado'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'producto': {
        'id': productoId,
        'nombre': nombreProducto,
      },
      'cantidad': cantidad,
      'precioUnitario': precioUnitario,
      'importe_Total': importeTotal,
      'importe_Total_Desc': importeTotalDesc,
      'Estado': estado,
    };
  }

  // Getter para compatibilidad con código existente
  double get subtotal {
    return importeTotal;
  }

  PedidoItem copyWith({
    int? id,
    int? productoId,
    String? nombreProducto,
    int? cantidad,
    double? precioUnitario,
    double? importeTotal,
    double? importeTotalDesc,
    bool? estado,
  }) {
    return PedidoItem(
      id: id ?? this.id,
      productoId: productoId ?? this.productoId,
      nombreProducto: nombreProducto ?? this.nombreProducto,
      cantidad: cantidad ?? this.cantidad,
      precioUnitario: precioUnitario ?? this.precioUnitario,
      importeTotal: importeTotal ?? this.importeTotal,
      importeTotalDesc: importeTotalDesc ?? this.importeTotalDesc,
      estado: estado ?? this.estado,
    );
  }
} 