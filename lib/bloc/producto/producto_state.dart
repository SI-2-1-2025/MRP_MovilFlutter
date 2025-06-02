import 'package:equatable/equatable.dart';
import '../../models/producto.dart';

abstract class ProductoState extends Equatable {
  const ProductoState();

  @override
  List<Object> get props => [];
}

class ProductoInitial extends ProductoState {}

class ProductoLoading extends ProductoState {}

class ProductoLoaded extends ProductoState {
  final List<Producto> productos;

  const ProductoLoaded(this.productos);

  @override
  List<Object> get props => [productos];
}

class ProductoError extends ProductoState {
  final String message;

  const ProductoError(this.message);

  @override
  List<Object> get props => [message];
}