import 'carrito_item.dart';

class Carrito {
  final int? id;
  final int usuarioId;
  final List<CarritoItem> items;
  final DateTime fechaCreacion;
  final bool activo;

  Carrito({
    this.id,
    required this.usuarioId,
    required this.items,
    required this.fechaCreacion,
    required this.activo,
  });

  factory Carrito.fromJson(Map<String, dynamic> json) {
    var itemsList = (json['items'] as List?)
        ?.map((item) => CarritoItem.fromJson(item))
        .toList() ?? [];

    return Carrito(
      id: json['id'],
      usuarioId: json['usuarioId'],
      items: itemsList,
      fechaCreacion: DateTime.parse(json['fechaCreacion']),
      activo: json['activo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'usuarioId': usuarioId,
      'items': items.map((item) => item.toJson()).toList(),
      'fechaCreacion': fechaCreacion.toIso8601String(),
      'activo': activo,
    };
  }

  // Métodos de utilidad
  double get total {
    return items.fold(0.0, (sum, item) => sum + item.subtotal);
  }

  int get cantidadTotal {
    return items.fold(0, (sum, item) => sum + item.cantidad);
  }

  bool get isEmpty {
    return items.isEmpty;
  }

  bool get isNotEmpty {
    return items.isNotEmpty;
  }

  Carrito copyWith({
    int? id,
    int? usuarioId,
    List<CarritoItem>? items,
    DateTime? fechaCreacion,
    bool? activo,
  }) {
    return Carrito(
      id: id ?? this.id,
      usuarioId: usuarioId ?? this.usuarioId,
      items: items ?? this.items,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      activo: activo ?? this.activo,
    );
  }
} 