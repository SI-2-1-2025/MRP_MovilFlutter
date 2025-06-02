import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/producto.dart';
//import 'package:shared_preferences.dart';

class ProductoService {
  static const String baseUrl = 'http://192.168.0.6:8081/mrp';

  Future<List<Producto>> getProductos() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        throw Exception('No hay token de autenticación');
      }

      print('ProductoService: Obteniendo productos...');
      print('URL: $baseUrl/api/productos');

      final response = await http.get(
        Uri.parse('$baseUrl/api/productos'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('ProductoService: Respuesta recibida');
      print('Status code: ${response.statusCode}');

      if (response.statusCode == 200) {
        final List<dynamic> productosJson = jsonDecode(response.body);
        return productosJson.map((json) => Producto.fromJson(json)).toList();
      } else {
        print('ProductoService: Error en la respuesta - ${response.body}');
        throw Exception('Error al obtener los productos');
      }
    } catch (e) {
      print('ProductoService: Error - $e');
      throw Exception('Error de conexión: $e');
    }
  }
}
/*import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:mrp_aplicacion_movil_flutter/models/producto.dart';
//import 'models/producto.dart';

class ProductService {
  final String _baseUrl = 'http://192.168.0.6:8081/mrp/api';

  Future<List<Producto>> getProductos() async {
    final response = await http.get(Uri.parse('$_baseUrl/productos'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => Producto.fromJson(item)).toList();
    } else {
      throw Exception('Error al cargar productos');
    }
  }
}*/