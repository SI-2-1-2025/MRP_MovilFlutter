import 'package:equatable/equatable.dart';

abstract class PedidoEvent extends Equatable {
  const PedidoEvent();

  @override
  List<Object> get props => [];
}

// Evento para cargar los pedidos del usuario
class CargarPedidosEvent extends PedidoEvent {}

// Evento para cargar el detalle de un pedido específico
class CargarDetallePedidoEvent extends PedidoEvent {
  final int pedidoId;

  const CargarDetallePedidoEvent({required this.pedidoId});

  @override
  List<Object> get props => [pedidoId];
}

// Evento para refrescar la lista de pedidos
class RefrescarPedidosEvent extends PedidoEvent {} 