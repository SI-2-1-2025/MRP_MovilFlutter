import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/user.dart';

class AuthService {
  //static const String baseUrl = 'http://143.110.145.162:8081/mrp'; // Ajusta la URL base
  static const String baseUrl = 'http://192.168.0.6:8081/mrp';
  
  Future<User?> login(String email, String password) async {
    try {
      print('Iniciando petición de login a: $baseUrl/auth/login');
      print('Datos de login: email=$email, password=$password');
      
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      ).timeout(const Duration(seconds: 10));

      print('Respuesta recibida. Status code: ${response.statusCode}');
      print('Cuerpo de la respuesta: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        print('JSON decodificado: $jsonResponse');
        return User.fromJson(jsonResponse);
      } else {
        final error = jsonDecode(response.body)['message'] ?? 'Error desconocido';
        print('Error en la respuesta: $error');
        throw Exception(error);
      }
    } catch (e) {
      print('Error durante el login: $e');
      throw Exception('Error de conexión: $e');
    }
  }
  Future<User?> registerClient({
    required String nombre,
    required String apellido,
    required String telefono,
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/registerClient'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nombre': nombre,
        'apellido': apellido,
        'telefono': telefono,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 201) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al registrar usuario');
    }
  }
}