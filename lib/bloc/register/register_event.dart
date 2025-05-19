import 'package:equatable/equatable.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();
}

class RegisterButtonPressed extends RegisterEvent {
  final String nombre;
  final String apellido;
  final String telefono;
  final String email;
  final String password;

  RegisterButtonPressed({
    required this.nombre,
    required this.apellido,
    required this.telefono,
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [nombre, apellido, telefono, email, password];
}