import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/carrito_service.dart';
import 'carrito_event.dart';
import 'carrito_state.dart';

class CarritoBloc extends Bloc<CarritoEvent, CarritoState> {
  final CarritoService carritoService;

  CarritoBloc({required this.carritoService}) : super(CarritoInitial()) {
    on<CargarCarritoEvent>(_onCargarCarrito);
    on<AgregarProductoCarritoEvent>(_onAgregarProducto);
    on<ActualizarCantidadCarritoEvent>(_onActualizarCantidad);
    on<EliminarProductoCarritoEvent>(_onEliminarProducto);
    on<LimpiarCarritoEvent>(_onLimpiarCarrito);
    on<ComprarCarritoEvent>(_onComprarCarrito);
    on<ObtenerTotalCarritoEvent>(_onObtenerTotal);
  }

  // Manejar evento de cargar carrito
  Future<void> _onCargarCarrito(
    CargarCarritoEvent event,
    Emitter<CarritoState> emit,
  ) async {
    try {
      emit(CarritoCargando());
      print('CarritoBloc: Cargando carrito...');
      
      final carrito = await carritoService.obtenerCarrito();
      
      if (carrito.isEmpty) {
        print('CarritoBloc: Carrito vacío');
        emit(CarritoVacio());
      } else {
        print('CarritoBloc: Carrito cargado con ${carrito.items.length} items');
        emit(CarritoLoaded(carrito: carrito));
      }
    } catch (e) {
      print('CarritoBloc: Error al cargar carrito - $e');
      emit(CarritoError(message: 'Error al cargar el carrito: $e'));
    }
  }

  // Manejar evento de agregar producto
  Future<void> _onAgregarProducto(
    AgregarProductoCarritoEvent event,
    Emitter<CarritoState> emit,
  ) async {
    try {
      emit(CarritoAgregandoProducto());
      print('CarritoBloc: Agregando producto ${event.productoId}...');
      
      final carrito = await carritoService.agregarProducto(
        event.productoId,
        event.cantidad,
      );
      
      print('CarritoBloc: Producto agregado exitosamente');
      emit(CarritoProductoAgregado(
        carrito: carrito,
        message: 'Producto agregado al carrito',
      ));
      
      // Después de mostrar el mensaje, cambiar al estado normal
      emit(CarritoLoaded(carrito: carrito));
    } catch (e) {
      print('CarritoBloc: Error al agregar producto - $e');
      emit(CarritoError(message: 'Error al agregar producto: $e'));
    }
  }

  // Manejar evento de actualizar cantidad
  Future<void> _onActualizarCantidad(
    ActualizarCantidadCarritoEvent event,
    Emitter<CarritoState> emit,
  ) async {
    try {
      emit(CarritoActualizandoCantidad());
      print('CarritoBloc: Actualizando cantidad del producto ${event.productoId}...');
      
      final carrito = await carritoService.actualizarCantidad(
        event.productoId,
        event.cantidad,
      );
      
      print('CarritoBloc: Cantidad actualizada exitosamente');
      emit(CarritoCantidadActualizada(carrito: carrito));
      
      // Después de actualizar, cambiar al estado normal
      emit(CarritoLoaded(carrito: carrito));
    } catch (e) {
      print('CarritoBloc: Error al actualizar cantidad - $e');
      emit(CarritoError(message: 'Error al actualizar cantidad: $e'));
    }
  }

  // Manejar evento de eliminar producto
  Future<void> _onEliminarProducto(
    EliminarProductoCarritoEvent event,
    Emitter<CarritoState> emit,
  ) async {
    try {
      emit(CarritoEliminandoProducto());
      print('CarritoBloc: Eliminando producto ${event.productoId}...');
      
      await carritoService.eliminarProducto(event.productoId);
      
      // Después de eliminar, recargar el carrito
      final carrito = await carritoService.obtenerCarrito();
      
      print('CarritoBloc: Producto eliminado exitosamente');
      emit(CarritoProductoEliminado(
        carrito: carrito,
        message: 'Producto eliminado del carrito',
      ));
      
      // Verificar si el carrito quedó vacío
      if (carrito.isEmpty) {
        emit(CarritoVacio());
      } else {
        emit(CarritoLoaded(carrito: carrito));
      }
    } catch (e) {
      print('CarritoBloc: Error al eliminar producto - $e');
      emit(CarritoError(message: 'Error al eliminar producto: $e'));
    }
  }

  // Manejar evento de limpiar carrito
  Future<void> _onLimpiarCarrito(
    LimpiarCarritoEvent event,
    Emitter<CarritoState> emit,
  ) async {
    try {
      print('CarritoBloc: Limpiando carrito...');
      // Este evento podría ser usado después de una compra exitosa
      emit(CarritoVacio());
    } catch (e) {
      print('CarritoBloc: Error al limpiar carrito - $e');
      emit(CarritoError(message: 'Error al limpiar carrito: $e'));
    }
  }

  // Manejar evento de comprar carrito
  Future<void> _onComprarCarrito(
    ComprarCarritoEvent event,
    Emitter<CarritoState> emit,
  ) async {
    try {
      emit(CarritoComprando());
      print('CarritoBloc: Procesando compra...');
      
      final exitoso = await carritoService.comprarCarrito();
      
      if (exitoso) {
        print('CarritoBloc: Compra procesada exitosamente');
        emit(CarritoCompraExitosa(
          message: 'Compra realizada con éxito. Se ha creado tu pedido.',
        ));
        
        // Después de la compra exitosa, limpiar el carrito
        emit(CarritoVacio());
      } else {
        emit(CarritoError(message: 'Error al procesar la compra'));
      }
    } catch (e) {
      print('CarritoBloc: Error al comprar - $e');
      emit(CarritoError(message: 'Error al procesar la compra: $e'));
    }
  }

  // Manejar evento de obtener total
  Future<void> _onObtenerTotal(
    ObtenerTotalCarritoEvent event,
    Emitter<CarritoState> emit,
  ) async {
    try {
      print('CarritoBloc: Obteniendo total del carrito...');
      
      final total = await carritoService.obtenerTotal();
      
      print('CarritoBloc: Total obtenido: $total');
      emit(CarritoTotalObtenido(total: total));
    } catch (e) {
      print('CarritoBloc: Error al obtener total - $e');
      emit(CarritoError(message: 'Error al obtener total: $e'));
    }
  }
} 