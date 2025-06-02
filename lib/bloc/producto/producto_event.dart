import 'package:equatable/equatable.dart';

abstract class ProductoEvent extends Equatable {
  const ProductoEvent();

  @override
  List<Object> get props => [];
}

class LoadProductos extends ProductoEvent {}

class RefreshProductos extends ProductoEvent {}