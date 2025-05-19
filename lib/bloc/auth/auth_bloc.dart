import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mrp_aplicacion_movil_flutter/bloc/auth/auth_event.dart';
import 'package:mrp_aplicacion_movil_flutter/bloc/auth/auth_state.dart';
import 'package:mrp_aplicacion_movil_flutter/repositories/auth_repository.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc(this._authRepository) : super(AuthInitial()) {
    on<LoginButtonPressed>((event, emit) async {
      print('Evento recibido: LoginButtonPressed'); // Log 1
      emit(AuthLoading());

      try {
        final user = await _authRepository.login(event.email, event.password);
        print('Login exitoso: $user'); // Log 2
        emit(AuthSuccess(user: user));
      } catch (e) {
        print('Error en login: $e'); // Log 3
        emit(AuthFailure(error: e.toString()));
      }
    });

    on<LogoutEvent>((event, emit) {
      emit(AuthInitial()); // Vuelve al estado inicial (no autenticado)
    });
  }
}