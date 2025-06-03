import 'package:equatable/equatable.dart';
import '../../models/carrito.dart';

abstract class CarritoState extends Equatable {
  const CarritoState();

  @override
  List<Object?> get props => [];
}

// Estado inicial
class CarritoInitial extends CarritoState {}

// Estado de carga
class CarritoLoading extends CarritoState {}

// Estado cuando se está cargando el carrito
class CarritoCargando extends CarritoState {}

// Estado cuando se está agregando un producto
class CarritoAgregandoProducto extends CarritoState {}

// Estado cuando se está actualizando cantidad
class CarritoActualizandoCantidad extends CarritoState {}

// Estado cuando se está eliminando un producto
class CarritoEliminandoProducto extends CarritoState {}

// Estado cuando se está procesando la compra
class CarritoComprando extends CarritoState {}

// Estado de carrito cargado exitosamente
class CarritoLoaded extends CarritoState {
  final Carrito carrito;

  const CarritoLoaded({required this.carrito});

  @override
  List<Object?> get props => [carrito];

  CarritoLoaded copyWith({Carrito? carrito}) {
    return CarritoLoaded(carrito: carrito ?? this.carrito);
  }
}

// Estado de carrito vacío
class CarritoVacio extends CarritoState {}

// Estado de error
class CarritoError extends CarritoState {
  final String message;

  const CarritoError({required this.message});

  @override
  List<Object?> get props => [message];
}

// Estado cuando el producto se agregó exitosamente
class CarritoProductoAgregado extends CarritoState {
  final Carrito carrito;
  final String message;

  const CarritoProductoAgregado({
    required this.carrito,
    required this.message,
  });

  @override
  List<Object?> get props => [carrito, message];
}

// Estado cuando la cantidad se actualizó exitosamente
class CarritoCantidadActualizada extends CarritoState {
  final Carrito carrito;

  const CarritoCantidadActualizada({required this.carrito});

  @override
  List<Object?> get props => [carrito];
}

// Estado cuando el producto se eliminó exitosamente
class CarritoProductoEliminado extends CarritoState {
  final Carrito carrito;
  final String message;

  const CarritoProductoEliminado({
    required this.carrito,
    required this.message,
  });

  @override
  List<Object?> get props => [carrito, message];
}

// Estado cuando la compra se completó exitosamente
class CarritoCompraExitosa extends CarritoState {
  final String message;

  const CarritoCompraExitosa({required this.message});

  @override
  List<Object?> get props => [message];
}

// Estado con el total del carrito
class CarritoTotalObtenido extends CarritoState {
  final double total;

  const CarritoTotalObtenido({required this.total});

  @override
  List<Object?> get props => [total];
} 