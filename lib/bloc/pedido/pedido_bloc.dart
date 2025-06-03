import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/pedido_service.dart';
import 'pedido_event.dart';
import 'pedido_state.dart';

class PedidoBloc extends Bloc<PedidoEvent, PedidoState> {
  final PedidoService pedidoService;

  PedidoBloc({required this.pedidoService}) : super(PedidoInitial()) {
    on<CargarPedidosEvent>(_onCargarPedidos);
    on<CargarDetallePedidoEvent>(_onCargarDetallePedido);
    on<RefrescarPedidosEvent>(_onRefrescarPedidos);
  }

  // Manejar evento de cargar pedidos
  Future<void> _onCargarPedidos(
    CargarPedidosEvent event,
    Emitter<PedidoState> emit,
  ) async {
    try {
      emit(PedidoCargando());
      print('PedidoBloc: Cargando pedidos...');
      
      final pedidos = await pedidoService.obtenerPedidosUsuario();
      
      if (pedidos.isEmpty) {
        print('PedidoBloc: No hay pedidos');
        emit(PedidosVacio());
      } else {
        print('PedidoBloc: ${pedidos.length} pedidos cargados');
        emit(PedidosLoaded(pedidos: pedidos));
      }
    } catch (e) {
      print('PedidoBloc: Error al cargar pedidos - $e');
      emit(PedidoError(message: 'Error al cargar los pedidos: $e'));
    }
  }

  // Manejar evento de cargar detalle de pedido
  Future<void> _onCargarDetallePedido(
    CargarDetallePedidoEvent event,
    Emitter<PedidoState> emit,
  ) async {
    try {
      emit(PedidoDetalleCargando());
      print('PedidoBloc: Cargando detalle del pedido ${event.pedidoId}...');
      
      final pedido = await pedidoService.obtenerDetallePedido(event.pedidoId);
      
      print('PedidoBloc: Detalle del pedido cargado');
      emit(PedidoDetalleLoaded(pedido: pedido));
    } catch (e) {
      print('PedidoBloc: Error al cargar detalle del pedido - $e');
      emit(PedidoError(message: 'Error al cargar el detalle del pedido: $e'));
    }
  }

  // Manejar evento de refrescar pedidos
  Future<void> _onRefrescarPedidos(
    RefrescarPedidosEvent event,
    Emitter<PedidoState> emit,
  ) async {
    // Reutilizar la lógica de cargar pedidos
    add(CargarPedidosEvent());
  }
} 