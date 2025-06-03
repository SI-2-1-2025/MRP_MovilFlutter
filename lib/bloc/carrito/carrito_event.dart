import 'package:equatable/equatable.dart';

abstract class CarritoEvent extends Equatable {
  const CarritoEvent();

  @override
  List<Object> get props => [];
}

// Evento para cargar el carrito
class CargarCarritoEvent extends CarritoEvent {}

// Evento para agregar un producto al carrito
class AgregarProductoCarritoEvent extends CarritoEvent {
  final int productoId;
  final int cantidad;

  const AgregarProductoCarritoEvent({
    required this.productoId,
    this.cantidad = 1,
  });

  @override
  List<Object> get props => [productoId, cantidad];
}

// Evento para actualizar la cantidad de un producto
class ActualizarCantidadCarritoEvent extends CarritoEvent {
  final int productoId;
  final int cantidad;

  const ActualizarCantidadCarritoEvent({
    required this.productoId,
    required this.cantidad,
  });

  @override
  List<Object> get props => [productoId, cantidad];
}

// Evento para eliminar un producto del carrito
class EliminarProductoCarritoEvent extends CarritoEvent {
  final int productoId;

  const EliminarProductoCarritoEvent({
    required this.productoId,
  });

  @override
  List<Object> get props => [productoId];
}

// Evento para limpiar el carrito
class LimpiarCarritoEvent extends CarritoEvent {}

// Evento para comprar (convertir carrito a pedido)
class ComprarCarritoEvent extends CarritoEvent {}

// Evento para obtener el total del carrito
class ObtenerTotalCarritoEvent extends CarritoEvent {} 