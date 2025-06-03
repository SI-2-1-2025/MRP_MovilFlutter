import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/carrito/carrito_bloc.dart';
import '../bloc/carrito/carrito_event.dart';
import '../bloc/carrito/carrito_state.dart';

class CarritoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mi Carrito'),
        backgroundColor: Colors.green,
      ),
      body: BlocConsumer<CarritoBloc, CarritoState>(
        listener: (context, state) {
          if (state is CarritoProductoEliminado) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.orange,
                duration: Duration(seconds: 2),
              ),
            );
          } else if (state is CarritoError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
                duration: Duration(seconds: 3),
              ),
            );
          } else if (state is CarritoCompraExitosa) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 3),
              ),
            );
            // Navegar de vuelta a la pantalla de productos
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/products',
              (route) => false,
            );
          }
        },
        builder: (context, state) {
          if (state is CarritoInitial || state is CarritoCargando) {
            context.read<CarritoBloc>().add(CargarCarritoEvent());
            return Center(child: CircularProgressIndicator());
          }

          if (state is CarritoVacio) {
            return _buildEmptyCart(context);
          }

          if (state is CarritoLoaded || 
              state is CarritoProductoAgregado || 
              state is CarritoCantidadActualizada ||
              state is CarritoProductoEliminado) {
            
            // Obtener el carrito desde cualquiera de estos estados
            var carrito;
            if (state is CarritoLoaded) {
              carrito = state.carrito;
            } else if (state is CarritoProductoAgregado) {
              carrito = state.carrito;
            } else if (state is CarritoCantidadActualizada) {
              carrito = state.carrito;
            } else if (state is CarritoProductoEliminado) {
              carrito = state.carrito;
            }

            if (carrito?.isEmpty ?? true) {
              return _buildEmptyCart(context);
            }

            return _buildCartContent(context, carrito);
          }

          if (state is CarritoComprando) {
            return _buildPurchasingState();
          }

          if (state is CarritoError) {
            return _buildErrorState(context, state.message);
          }

          // Para estados de carga específicos, mostrar el carrito con loading overlay
          return BlocBuilder<CarritoBloc, CarritoState>(
            builder: (context, state) {
              if (state is CarritoLoaded) {
                return _buildCartContent(context, state.carrito);
              }
              return Center(child: CircularProgressIndicator());
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyCart(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 100,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16),
          Text(
            'Tu carrito está vacío',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Agrega algunos productos para comenzar',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[500],
            ),
          ),
          SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/products');
            },
            child: Text('Ver Productos'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartContent(BuildContext context, carrito) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: carrito.items.length,
            itemBuilder: (context, index) {
              final item = carrito.items[index];
              return _buildCartItem(context, item);
            },
          ),
        ),
        _buildCartSummary(context, carrito),
      ],
    );
  }

  Widget _buildCartItem(BuildContext context, item) {
    return Card(
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            // Imagen del producto (placeholder)
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.shopping_bag,
                color: Colors.grey[400],
              ),
            ),
            SizedBox(width: 16),
            // Información del producto
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.nombreProducto,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Precio: \$${item.precioUnitario.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      // Botones de cantidad
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            BlocBuilder<CarritoBloc, CarritoState>(
                              builder: (context, state) {
                                bool isUpdating = state is CarritoActualizandoCantidad;
                                return IconButton(
                                  onPressed: !isUpdating && item.cantidad > 1 ? () {
                                    context.read<CarritoBloc>().add(
                                      ActualizarCantidadCarritoEvent(
                                        productoId: item.productoId,
                                        cantidad: item.cantidad - 1,
                                      ),
                                    );
                                  } : null,
                                  icon: Icon(Icons.remove, size: 16),
                                  padding: EdgeInsets.all(4),
                                  constraints: BoxConstraints(minWidth: 32, minHeight: 32),
                                );
                              },
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              child: Text(
                                '${item.cantidad}',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            BlocBuilder<CarritoBloc, CarritoState>(
                              builder: (context, state) {
                                bool isUpdating = state is CarritoActualizandoCantidad;
                                return IconButton(
                                  onPressed: !isUpdating ? () {
                                    context.read<CarritoBloc>().add(
                                      ActualizarCantidadCarritoEvent(
                                        productoId: item.productoId,
                                        cantidad: item.cantidad + 1,
                                      ),
                                    );
                                  } : null,
                                  icon: Icon(Icons.add, size: 16),
                                  padding: EdgeInsets.all(4),
                                  constraints: BoxConstraints(minWidth: 32, minHeight: 32),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      // Subtotal
                      Text(
                        '\$${item.subtotal.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Botón eliminar
            BlocBuilder<CarritoBloc, CarritoState>(
              builder: (context, state) {
                bool isDeleting = state is CarritoEliminandoProducto;
                return IconButton(
                  onPressed: !isDeleting ? () {
                    _showDeleteConfirmation(context, item);
                  } : null,
                  icon: isDeleting 
                      ? SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Icon(Icons.delete, color: Colors.red),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartSummary(BuildContext context, carrito) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border(top: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total (${carrito.cantidadTotal} items):',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '\$${carrito.total.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: BlocBuilder<CarritoBloc, CarritoState>(
                  builder: (context, state) {
                    bool isPurchasing = state is CarritoComprando;
                    return ElevatedButton(
                      onPressed: !isPurchasing ? () {
                        _showPurchaseConfirmation(context, carrito);
                      } : null,
                      child: isPurchasing 
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                ),
                                SizedBox(width: 8),
                                Text('Procesando...'),
                              ],
                            )
                          : Text('Comprar Ahora'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        textStyle: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPurchasingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text(
            'Procesando tu compra...',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Por favor espera un momento',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red,
          ),
          SizedBox(height: 16),
          Text(
            'Error',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          SizedBox(height: 8),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ),
          SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              context.read<CarritoBloc>().add(CargarCarritoEvent());
            },
            child: Text('Reintentar'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, item) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Eliminar producto'),
          content: Text('¿Estás seguro de que deseas eliminar "${item.nombreProducto}" del carrito?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                context.read<CarritoBloc>().add(
                  EliminarProductoCarritoEvent(
                    productoId: item.productoId,
                  ),
                );
              },
              child: Text('Eliminar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        );
      },
    );
  }

  void _showPurchaseConfirmation(BuildContext context, carrito) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Confirmar Compra'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Resumen de tu pedido:'),
              SizedBox(height: 16),
              ...carrito.items.map((item) => Padding(
                padding: EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text('${item.nombreProducto} (x${item.cantidad})'),
                    ),
                    Text('\$${item.subtotal.toStringAsFixed(2)}'),
                  ],
                ),
              )).toList(),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '\$${carrito.total.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text(
                'Método de pago: Simulación (sin cargo real)',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                context.read<CarritoBloc>().add(ComprarCarritoEvent());
              },
              child: Text('Confirmar Compra'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        );
      },
    );
  }
} 