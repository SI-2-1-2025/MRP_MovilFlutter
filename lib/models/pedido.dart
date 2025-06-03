import 'package:flutter/material.dart';
import 'pedido_item.dart';

class Pedido {
  final int? id;
  final int usuarioId;
  final DateTime fecha;
  final String? descripcion;
  final double importeTotal;
  final double? importeTotalDesc;
  final bool estado;
  final int? metodoPagoId;
  final List<PedidoItem> items;

  Pedido({
    this.id,
    required this.usuarioId,
    required this.fecha,
    this.descripcion,
    required this.importeTotal,
    this.importeTotalDesc,
    required this.estado,
    this.metodoPagoId,
    required this.items,
  });

  factory Pedido.fromJson(Map<String, dynamic> json) {
    var itemsList = <PedidoItem>[];
    
    // Los items vienen en detalle_pedidos
    if (json['detalle_pedidos'] != null) {
      itemsList = (json['detalle_pedidos'] as List)
          .map((item) => PedidoItem.fromJson(item))
          .toList();
    }

    return Pedido(
      id: json['id'],
      usuarioId: json['usuario']?['id'] ?? 0, // Usuario viene como objeto
      fecha: DateTime.parse(json['fecha']),
      descripcion: json['descripcion'],
      importeTotal: (json['importe_total'] ?? 0.0).toDouble(),
      importeTotalDesc: json['importe_total_desc']?.toDouble(),
      estado: json['estado'] ?? false,
      metodoPagoId: json['metodo_pago']?['id'], // Método de pago viene como objeto
      items: itemsList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'usuario': {'id': usuarioId},
      'fecha': fecha.toIso8601String(),
      'descripcion': descripcion,
      'importe_total': importeTotal,
      'importe_total_desc': importeTotalDesc,
      'estado': estado,
      'metodo_pago': metodoPagoId != null ? {'id': metodoPagoId} : null,
      'detalle_pedidos': items.map((item) => item.toJson()).toList(),
    };
  }

  // Métodos de utilidad
  int get cantidadTotal {
    return items.fold(0, (sum, item) => sum + item.cantidad);
  }

  String get fechaFormateada {
    return '${fecha.day}/${fecha.month}/${fecha.year}';
  }

  String get estadoTexto {
    return estado ? 'COMPLETADO' : 'PENDIENTE';
  }

  Color get colorEstado {
    return estado ? Colors.green : Colors.orange;
  }

  // Usar importeTotal como total principal
  double get total {
    return importeTotal;
  }

  Pedido copyWith({
    int? id,
    int? usuarioId,
    DateTime? fecha,
    String? descripcion,
    double? importeTotal,
    double? importeTotalDesc,
    bool? estado,
    int? metodoPagoId,
    List<PedidoItem>? items,
  }) {
    return Pedido(
      id: id ?? this.id,
      usuarioId: usuarioId ?? this.usuarioId,
      fecha: fecha ?? this.fecha,
      descripcion: descripcion ?? this.descripcion,
      importeTotal: importeTotal ?? this.importeTotal,
      importeTotalDesc: importeTotalDesc ?? this.importeTotalDesc,
      estado: estado ?? this.estado,
      metodoPagoId: metodoPagoId ?? this.metodoPagoId,
      items: items ?? this.items,
    );
  }
} 