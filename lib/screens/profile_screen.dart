import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mrp_aplicacion_movil_flutter/bloc/auth/auth_bloc.dart';
import 'package:mrp_aplicacion_movil_flutter/bloc/auth/auth_state.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mi Perfil'),
        backgroundColor: Colors.green,
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthSuccess) {
            return SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.green.shade100,
                    child: Icon(
                      Icons.person,
                      size: 50,
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(height: 20),
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          ListTile(
                            leading: Icon(Icons.email, color: Colors.green),
                            title: Text('Correo Electrónico'),
                            subtitle: Text(state.user.email ?? 'No disponible'),
                          ),
                          Divider(),
                          ListTile(
                            leading: Icon(Icons.person, color: Colors.green),
                            title: Text('Nombre de Usuario'),
                            subtitle: Text(state.user.nombre ?? 'No disponible'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return Center(
            child: Text('No se pudo cargar la información del perfil'),
          );
        },
      ),
    );
  }
}