import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mrp_aplicacion_movil_flutter/bloc/producto/producto_bloc.dart';
import 'package:mrp_aplicacion_movil_flutter/bloc/producto/producto_event.dart';
import 'package:mrp_aplicacion_movil_flutter/bloc/producto/producto_state.dart';
import 'package:mrp_aplicacion_movil_flutter/bloc/auth/auth_bloc.dart';
import 'package:mrp_aplicacion_movil_flutter/bloc/carrito/carrito_bloc.dart';
import 'package:mrp_aplicacion_movil_flutter/bloc/carrito/carrito_event.dart';
import 'package:mrp_aplicacion_movil_flutter/bloc/carrito/carrito_state.dart';
import '../models/producto.dart';

class ProductListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Productos Disponibles'),
        backgroundColor: Colors.green,
        actions: [
          // Ícono del carrito con badge
          BlocBuilder<CarritoBloc, CarritoState>(
            builder: (context, state) {
              int itemCount = 0;
              if (state is CarritoLoaded) {
                itemCount = state.carrito.cantidadTotal;
              }
              
              return Stack(
                children: [
                  IconButton(
                    icon: Icon(Icons.shopping_cart),
                    onPressed: () {
                      Navigator.pushNamed(context, '/carrito');
                    },
                  ),
                  if (itemCount > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          '$itemCount',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.green,
              ),
              child: Text(
                'Menú Principal',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.shopping_cart),
              title: Text('Mi Carrito'),
              onTap: () {
                Navigator.pop(context); // Cerrar drawer
                Navigator.pushNamed(context, '/carrito');
              },
            ),
            ListTile(
              leading: Icon(Icons.shopping_bag),
              title: Text('Mis Pedidos'),
              onTap: () {
                Navigator.pop(context); // Cerrar drawer
                Navigator.pushNamed(context, '/pedidos');
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Mi Perfil'),
              onTap: () {
                Navigator.pop(context); // Cerrar drawer
                Navigator.pushNamed(context, '/profile');
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Cerrar Sesión'),
              onTap: () {
                // Aquí puedes agregar la lógica para cerrar sesión
                Navigator.pushNamedAndRemoveUntil(
                  context, 
                  '/', 
                  (route) => false
                );
              },
            ),
          ],
        ),
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<CarritoBloc, CarritoState>(
            listener: (context, state) {
              if (state is CarritoProductoAgregado) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.green,
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
              }
            },
          ),
        ],
        child: BlocBuilder<ProductoBloc, ProductoState>(
          builder: (context, state) {
            if (state is ProductoInitial) {
              context.read<ProductoBloc>().add(LoadProductos());
              // También cargar el carrito al inicializar
              context.read<CarritoBloc>().add(CargarCarritoEvent());
              return Center(child: CircularProgressIndicator());
            }
            
            if (state is ProductoLoading) {
              return Center(child: CircularProgressIndicator());
            }
            
            if (state is ProductoLoaded) {
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<ProductoBloc>().add(RefreshProductos());
                  context.read<CarritoBloc>().add(CargarCarritoEvent());
                },
                child: ListView.builder(
                  itemCount: state.productos.length,
                  itemBuilder: (context, index) {
                    final producto = state.productos[index];
                    return _buildProductCard(context, producto);
                  },
                ),
              );
            }
            
            if (state is ProductoError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Error: ${state.message}',
                      style: TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        context.read<ProductoBloc>().add(LoadProductos());
                      },
                      child: Text('Reintentar'),
                    ),
                  ],
                ),
              );
            }
            
            return Center(child: Text('Estado no manejado'));
          },
        ),
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, Producto producto) {
    return Card(
      margin: EdgeInsets.all(8),
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CachedNetworkImage(
            imageUrl: producto.imagen,
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
            placeholder: (context, url) => Center(
              child: CircularProgressIndicator(),
            ),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  producto.nombre,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(producto.descripcion),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Precio: \$${producto.precioUnitario.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Stock: ${producto.stock}',
                      style: TextStyle(
                        fontSize: 16,
                        color: producto.stock > producto.stockMinimo
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text('Tiempo estimado: ${producto.tiempo}'),
                SizedBox(height: 16),
                // Botón para agregar al carrito
                Row(
                  children: [
                    Expanded(
                      child: BlocBuilder<CarritoBloc, CarritoState>(
                        builder: (context, carritoState) {
                          bool isLoading = carritoState is CarritoAgregandoProducto;
                          bool hasStock = producto.stock > 0;
                          
                          return ElevatedButton.icon(
                            onPressed: hasStock && !isLoading ? () {
                              _showAddToCartDialog(context, producto);
                            } : null,
                            icon: isLoading 
                                ? SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  )
                                : Icon(Icons.add_shopping_cart),
                            label: Text(hasStock ? 'Agregar al Carrito' : 'Sin Stock'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: hasStock ? Colors.green : Colors.grey,
                              foregroundColor: Colors.white,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAddToCartDialog(BuildContext context, Producto producto) {
    int cantidad = 1;
    
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Agregar al Carrito'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('${producto.nombre}'),
                  SizedBox(height: 16),
                  Text('Precio: \$${producto.precioUnitario.toStringAsFixed(2)}'),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: cantidad > 1 ? () {
                          setState(() {
                            cantidad--;
                          });
                        } : null,
                        icon: Icon(Icons.remove),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '$cantidad',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      IconButton(
                        onPressed: cantidad < producto.stock ? () {
                          setState(() {
                            cantidad++;
                          });
                        } : null,
                        icon: Icon(Icons.add),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text('Total: \$${(producto.precioUnitario * cantidad).toStringAsFixed(2)}'),
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
                    context.read<CarritoBloc>().add(
                      AgregarProductoCarritoEvent(
                        productoId: producto.id!,
                        cantidad: cantidad,
                      ),
                    );
                  },
                  child: Text('Agregar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}