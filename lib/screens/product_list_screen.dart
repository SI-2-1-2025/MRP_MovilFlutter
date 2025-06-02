import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mrp_aplicacion_movil_flutter/bloc/producto/producto_bloc.dart';
import 'package:mrp_aplicacion_movil_flutter/bloc/producto/producto_event.dart';
import 'package:mrp_aplicacion_movil_flutter/bloc/producto/producto_state.dart';
import 'package:mrp_aplicacion_movil_flutter/bloc/auth/auth_bloc.dart';
import '../models/producto.dart';

class ProductListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Productos Disponibles'),
        backgroundColor: Colors.green,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.green,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 40, color: Colors.grey),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Menú',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Mi Perfil'),
              onTap: () {
                Navigator.pushNamed(context, '/profile');
              },
            ),
            ListTile(
              leading: Icon(Icons.shopping_cart),
              title: Text('Catálogo'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
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
      body: BlocBuilder<ProductoBloc, ProductoState>(
        builder: (context, state) {
          if (state is ProductoInitial) {
            context.read<ProductoBloc>().add(LoadProductos());
            return Center(child: CircularProgressIndicator());
          }
          
          if (state is ProductoLoading) {
            return Center(child: CircularProgressIndicator());
          }
          
          if (state is ProductoLoaded) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<ProductoBloc>().add(RefreshProductos());
              },
              child: ListView.builder(
                itemCount: state.productos.length,
                itemBuilder: (context, index) {
                  final producto = state.productos[index];
                  return _buildProductCard(producto);
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
    );
  }

  Widget _buildProductCard(Producto producto) {
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}