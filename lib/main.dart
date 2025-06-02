import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mrp_aplicacion_movil_flutter/bloc/auth/auth_bloc.dart';
import 'package:mrp_aplicacion_movil_flutter/bloc/producto/producto_bloc.dart';
import 'package:mrp_aplicacion_movil_flutter/bloc/register/register_bloc.dart';
//import 'package:mrp_aplicacion_movil_flutter/bloc/register/register_bloc.dart';
import 'package:mrp_aplicacion_movil_flutter/repositories/auth_repository.dart';
import 'package:mrp_aplicacion_movil_flutter/services/producto_service.dart';
import 'package:mrp_aplicacion_movil_flutter/screens/product_list_screen.dart';
import 'package:mrp_aplicacion_movil_flutter/screens/register_screen.dart';
import 'package:mrp_aplicacion_movil_flutter/screens/profile_screen.dart';

import 'screens/login_screen.dart';

void main() {
  final authRepository = AuthRepository();
  
  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(
          value: authRepository,
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