import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mrp_aplicacion_movil_flutter/bloc/auth/auth_bloc.dart';
import 'package:mrp_aplicacion_movil_flutter/bloc/register/register_bloc.dart';
import 'package:mrp_aplicacion_movil_flutter/repositories/auth_repository.dart';
import 'package:mrp_aplicacion_movil_flutter/screens/home_screen.dart';
import 'package:mrp_aplicacion_movil_flutter/screens/register_screen.dart';
import 'package:provider/provider.dart';
import 'screens/login_screen.dart';


void main() {
  runApp(
    BlocProvider(
      create: (context) => AuthBloc(AuthRepository()),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/home': (context) => BlocProvider.value(
          value: BlocProvider.of<AuthBloc>(context),
          child: HomeScreen(),
        ),
        '/home': (context) => BlocProvider.value(
          value: BlocProvider.of<AuthBloc>(context),
          child: HomeScreen(),
        ),
        '/register': (context) => BlocProvider(
          create: (context) => RegisterBloc(AuthRepository()),
          child: RegisterScreen(),
        ),
      },
    );
  }
}
//repositories/auth_repository.dart

/*routes: {
        '/': (context) => BlocProvider(
          create: (context) => AuthBloc(AuthRepository()),
          child: LoginScreen(),
        ),
        '/home': (context) => HomeScreen(),
        '/register': (context) => BlocProvider(
          create: (context) => RegisterBloc(AuthRepository()),
          child: RegisterScreen(),
        ),
      },*/