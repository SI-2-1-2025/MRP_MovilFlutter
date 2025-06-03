import 'package:equatable/equatable.dart';
import '../../models/pedido.dart';

abstract class PedidoState extends Equatable {
  const PedidoState();

  @override
  List<Object?> get props => [];
}

// Estado inicial
class PedidoInitial extends PedidoState {}

// Estado de carga
class PedidoCargando extends PedidoState {}

// Estado cuando los pedidos se cargaron exitosamente
class PedidosLoaded extends PedidoState {
  final List<Pedido> pedidos;

  const PedidosLoaded({required this.pedidos});

  @override
  List<Object?> get props => [pedidos];
}

// Estado cuando no hay pedidos
class PedidosVacio extends PedidoState {}

// Estado de error
class PedidoError extends PedidoState {
  final String message;

  const PedidoError({required this.message});

  @override
  List<Object?> get props => [message];
}

// Estado cuando se está cargando el detalle de un pedido
class PedidoDetalleCargando extends PedidoState {}

// Estado cuando se cargó el detalle de un pedido
class PedidoDetalleLoaded extends PedidoState {
  final Pedido pedido;

  const PedidoDetalleLoaded({required this.pedido});

  @override
  List<Object?> get props => [pedido];
} 