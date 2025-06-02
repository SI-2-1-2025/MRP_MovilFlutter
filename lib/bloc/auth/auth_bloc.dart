import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mrp_aplicacion_movil_flutter/bloc/auth/auth_event.dart';
import 'package:mrp_aplicacion_movil_flutter/bloc/auth/auth_state.dart';
import 'package:mrp_aplicacion_movil_flutter/repositories/auth_repository.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc(this._authRepository) : super(AuthInitial()) {
    on<LoginButtonPressed>((event, emit) async {
      print('Evento recibido: LoginButtonPressed');
      print('Intentando login con email: ${event.email}');
      emit(AuthLoading());

      try {
        print('Llamando al repositorio de autenticación...');
        final user = await _authRepository.login(event.email, event.password);
        print('Respuesta exitosa del repositorio');
        print('Usuario autenticado: ${user.email}');
        
        // Guardar el token
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', user.token);
        print('Token guardado en SharedPreferences');
        
        emit(AuthSuccess(user: user));
      } catch (e) {
        print('Error en AuthBloc durante login: $e');
        emit(AuthFailure(error: e.toString()));
      }
    });

    on<LogoutEvent>((event, emit) async {
      // Limpiar el token al cerrar sesión
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');
      emit(AuthInitial());
    });
  }
}