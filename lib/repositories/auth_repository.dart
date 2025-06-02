import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../models/user.dart';

class AuthRepository {
  // Usamos la misma URL base que antes
  final String baseUrl = 'http://192.168.0.6:8081/mrp';

  // Método para login
  Future<User> login(String email, String password) async {
    try {
      print('AuthRepository: Iniciando petición de login');
      print('URL: $baseUrl/auth/login');
      
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      ).timeout(Duration(seconds: 15));

      print('AuthRepository: Respuesta recibida');
      print('Status code: ${response.statusCode}');
      print('Respuesta: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return User.fromJson(jsonResponse);
      } else {
        final error = jsonDecode(response.body)['message'] ?? 'Error desconocido';
        print('AuthRepository: Error en la respuesta - $error');
        throw Exception(error);
      }
    } catch (e) {
      print('AuthRepository: Error durante la petición - $e');
      if (e is TimeoutException) {
        throw Exception('El servidor no responde. Por favor, verifica tu conexión.');
      }
      throw Exception('Error de conexión: $e');
    }
  }

  // Método para registro de cliente
  Future<User> registerClient({
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
      final error = jsonDecode(response.body)['message'] ?? 'Error desconocido';
      throw Exception(error);
    }
  }
}