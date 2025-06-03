import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/pedido/pedido_bloc.dart';
import '../bloc/pedido/pedido_event.dart';
import '../bloc/pedido/pedido_state.dart';
import '../models/pedido.dart';

class PedidosScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mis Pedidos'),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              context.read<PedidoBloc>().add(RefrescarPedidosEvent());
            },
          ),
        ],
      ),
      body: BlocConsumer<PedidoBloc, PedidoState>(
        listener: (context, state) {
          if (state is PedidoError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
                duration: Duration(seconds: 3),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is PedidoInitial || state is PedidoCargando) {
            if (state is PedidoInitial) {
              context.read<PedidoBloc>().add(CargarPedidosEvent());
            }
            return Center(child: CircularProgressIndicator());
          }

          if (state is PedidosVacio) {
            return _buildEmptyPedidos(context);
          }

          if (state is PedidosLoaded) {
            return _buildPedidosList(context, state.pedidos);
          }

          if (state is PedidoError) {
            return _buildErrorState(context, state.message);
          }

          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildEmptyPedidos(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_bag_outlined,
            size: 100,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16),
          Text(
            'No tienes pedidos aún',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Realiza tu primera compra para ver tus pedidos aquí',
            textAlign: TextAlign.center,
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

  Widget _buildPedidosList(BuildContext context, List<Pedido> pedidos) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<PedidoBloc>().add(RefrescarPedidosEvent());
      },
      child: ListView.builder(
        itemCount: pedidos.length,
        padding: EdgeInsets.all(16),
        itemBuilder: (context, index) {
          final pedido = pedidos[index];
          return _buildPedidoCard(context, pedido);
        },
      ),
    );
  }

  Widget _buildPedidoCard(BuildContext context, Pedido pedido) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: InkWell(
        onTap: () {
          _showPedidoDetalle(context, pedido);
        },
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header del pedido
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Pedido #${pedido.id}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: pedido.colorEstado.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: pedido.colorEstado),
                    ),
                    child: Text(
                      pedido.estadoTexto,
                      style: TextStyle(
                        color: pedido.colorEstado,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              
              // Fecha del pedido
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                  SizedBox(width: 4),
                  Text(
                    'Fecha: ${pedido.fechaFormateada}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4),
              
              // Cantidad de items
              Row(
                children: [
                  Icon(Icons.shopping_cart, size: 16, color: Colors.grey[600]),
                  SizedBox(width: 4),
                  Text(
                    '${pedido.cantidadTotal} ${pedido.cantidadTotal == 1 ? 'item' : 'items'}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              
              // Total y botón ver detalle
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total: \$${pedido.total.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      _showPedidoDetalle(context, pedido);
                    },
                    icon: Icon(Icons.visibility, size: 16),
                    label: Text('Ver Detalle'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.green,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
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
              context.read<PedidoBloc>().add(CargarPedidosEvent());
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

  void _showPedidoDetalle(BuildContext context, Pedido pedido) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Pedido #${pedido.id}'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Información del pedido
                _buildInfoRow('Fecha:', pedido.fechaFormateada),
                _buildInfoRow('Estado:', pedido.estadoTexto),
                SizedBox(height: 16),
                
                Text(
                  'Productos:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 8),
                
                // Lista de productos
                ...pedido.items.map((item) => Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.nombreProducto,
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            Text(
                              'Cantidad: ${item.cantidad} x \$${item.precioUnitario.toStringAsFixed(2)}',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '\$${item.subtotal.toStringAsFixed(2)}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                )).toList(),
                
                Divider(),
                
                // Total
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      '\$${pedido.total.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 60,
            child: Text(
              label,
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
} 