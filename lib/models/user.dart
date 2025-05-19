import 'package:mrp_aplicacion_movil_flutter/models/role.dart';

// models/user.dart
class User {
  final String token;
  final String email;
  final String nombre;
  final String apellido;
  final String telefono;
  final int id;
  final Role role;

  User({
    required this.token,
    required this.email,
    required this.nombre,
    required this.apellido,
    required this.telefono,
    required this.id,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      token: json['token'],
      email: json['email'],
      nombre: json['nombre'],
      apellido: json['apellido'],
      telefono: json['telefono'],
      id: json['id'],
      role: Role.fromJson(json['role']),
    );
  }
}

// models/role.dart


