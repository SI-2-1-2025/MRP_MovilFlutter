import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mrp_aplicacion_movil_flutter/bloc/auth/auth_bloc.dart';
import 'package:mrp_aplicacion_movil_flutter/bloc/auth/auth_event.dart';
import 'package:mrp_aplicacion_movil_flutter/bloc/auth/auth_state.dart';
import 'package:mrp_aplicacion_movil_flutter/models/user.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthSuccess) {
          return _buildHomeContent(context, state.user);
        }
        return Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }

  Widget _buildHomeContent(BuildContext context, User user) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bienvenido'),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(LogoutEvent());
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            },
          )
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/img/background3.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.6),
              BlendMode.darken,
            ),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 80, color: Colors.grey),
                ),
                SizedBox(height: 20), // Mantener un espacio razonable
                Text(
                  '¡Hola, ${user.nombre} ${user.apellido}!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10), // Mantener un espacio razonable
                Text(
                  'Email: ${user.email}',
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  'Rol: ${user.role.nombre}',
                  style: TextStyle(color: Colors.white),
                ),
                Spacer(), // Expandir el contenido hacia abajo
                ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, '/products'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.shopping_cart, color: Colors.white),
                      SizedBox(width: 10),
                      Text(
                        'Ver Productos',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}