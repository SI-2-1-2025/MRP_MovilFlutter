// register_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mrp_aplicacion_movil_flutter/bloc/register/register_event.dart';
import 'package:mrp_aplicacion_movil_flutter/bloc/register/register_state.dart';
import 'package:mrp_aplicacion_movil_flutter/repositories/auth_repository.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthRepository _authRepository;

  RegisterBloc(this._authRepository) : super(RegisterInitial()) {
    on<RegisterButtonPressed>(_mapRegisterToState);
  }

  void _mapRegisterToState(
      RegisterButtonPressed event,
      Emitter<RegisterState> emit,
      ) async {
    emit(RegisterLoading());
    try {
      final user = await _authRepository.registerClient(
        nombre: event.nombre,
        apellido: event.apellido,
        telefono: event.telefono,
        email: event.email,
        password: event.password,
      );
      emit(RegisterSuccess(user: user));
    } catch (e) {
      emit(RegisterFailure(error: e.toString()));
    }
  }
}