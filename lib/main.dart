import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mrp_aplicacion_movil_flutter/bloc/auth/auth_bloc.dart';
import 'package:mrp_aplicacion_movil_flutter/bloc/producto/producto_bloc.dart';
import 'package:mrp_aplicacion_movil_flutter/bloc/register/register_bloc.dart';
import 'package:mrp_aplicacion_movil_flutter/bloc/carrito/carrito_bloc.dart';
import 'package:mrp_aplicacion_movil_flutter/bloc/pedido/pedido_bloc.dart';
//import 'package:mrp_aplicacion_movil_flutter/bloc/register/register_bloc.dart';
import 'package:mrp_aplicacion_movil_flutter/repositories/auth_repository.dart';
import 'package:mrp_aplicacion_movil_flutter/services/producto_service.dart';
import 'package:mrp_aplicacion_movil_flutter/services/carrito_service.dart';
import 'package:mrp_aplicacion_movil_flutter/services/pedido_service.dart';
import 'package:mrp_aplicacion_movil_flutter/screens/product_list_screen.dart';
import 'package:mrp_aplicacion_movil_flutter/screens/register_screen.dart';
import 'package:mrp_aplicacion_movil_flutter/screens/profile_screen.dart';
import 'package:mrp_aplicacion_movil_flutter/screens/carrito_screen.dart';
import 'package:mrp_aplicacion_movil_flutter/screens/pedidos_screen.dart';

import 'screens/login_screen.dart';

void main() {
  final authRepository = AuthRepository();
  final carritoService = CarritoService();
  final pedidoService = PedidoService();
  
  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(
          value: authRepository,
        ),
        RepositoryProvider.value(
          value: carritoService,
        ),
        RepositoryProvider.value(
          value: pedidoService,
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthBloc(authRepository),
          ),
          BlocProvider(
            create: (context) => ProductoBloc(ProductoService()),
          ),
          BlocProvider(
            create: (context) => CarritoBloc(carritoService: carritoService),
          ),
          BlocProvider(
            create: (context) => PedidoBloc(pedidoService: pedidoService),
          ),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authRepository = RepositoryProvider.of<AuthRepository>(context);
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MRP App',
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.white,
      ),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (_) =>  LoginScreen());
          case '/products':
            return MaterialPageRoute(builder: (_) =>  ProductListScreen());
          case '/carrito':
            return MaterialPageRoute(builder: (_) => CarritoScreen());
          case '/pedidos':
            return MaterialPageRoute(builder: (_) => PedidosScreen());
          case '/profile':
            return MaterialPageRoute(builder: (_) => ProfileScreen());
          case '/register':
            return MaterialPageRoute(
              builder: (context) {
                final authRepository = RepositoryProvider.of<AuthRepository>(context);
                return BlocProvider(
                  create: (context) => RegisterBloc(authRepository),
                  child: RegisterScreen(),
                );
              },
            );
          default:
            return MaterialPageRoute(builder: (_) =>  LoginScreen());
        }
      },
    );
  }
}