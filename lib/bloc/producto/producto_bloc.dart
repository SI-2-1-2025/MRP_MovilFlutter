import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/producto_service.dart';
import 'producto_event.dart';
import 'producto_state.dart';

class ProductoBloc extends Bloc<ProductoEvent, ProductoState> {
  final ProductoService _productoService;

  ProductoBloc(this._productoService) : super(ProductoInitial()) {
    on<LoadProductos>(_onLoadProductos);
    on<RefreshProductos>(_onRefreshProductos);
  }

  Future<void> _onLoadProductos(
    LoadProductos event,
    Emitter<ProductoState> emit,
  ) async {
    try {
      emit(ProductoLoading());
      final productos = await _productoService.getProductos();
      emit(ProductoLoaded(productos));
    } catch (e) {
      emit(ProductoError(e.toString()));
    }
  }

  Future<void> _onRefreshProductos(
    RefreshProductos event,
    Emitter<ProductoState> emit,
  ) async {
    try {
      final productos = await _productoService.getProductos();
      emit(ProductoLoaded(productos));
    } catch (e) {
      emit(ProductoError(e.toString()));
    }
  }
}