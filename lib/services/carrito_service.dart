import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/carrito.dart';

class CarritoService {
  static const String baseUrl = 'http://192.168.0.6:8081/mrp';

  // Obtener el ID del usuario desde SharedPreferences
  Future<int?> _obtenerUsuarioId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId');
  }

  // Obtener el token de autenticación
  Future<String?> _obtenerToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Obtener carrito activo del usuario
  Future<Carrito> obtenerCarrito() async {
    try {
      final usuarioId = await _obtenerUsuarioId();
      final token = await _obtenerToken();

      if (usuarioId == null) {
        throw Exception('Usuario no autenticado');
      }

      if (token == null) {
        throw Exception('No hay token de autenticación');
      }

      print('CarritoService: Obteniendo carrito para usuario $usuarioId');
      
      final response = await http.get(
        Uri.parse('$baseUrl/api/carrito/$usuarioId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ).timeout(Duration(seconds: 15));

      print('CarritoService: Respuesta recibida');
      print('Status code: ${response.statusCode}');

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        print('Carrito obtenido: ${jsonResponse['data']}');
        return Carrito.fromJson(jsonResponse['data']);
      } else {
        print('CarritoService: Error en la respuesta - ${response.body}');
        throw Exception('Error al obtener el carrito');
      }
    } catch (e) {
      print('CarritoService: Error - $e');
      throw Exception('Error de conexión: $e');
    }
  }

  // Agregar producto al carrito
  Future<Carrito> agregarProducto(int productoId, int cantidad) async {
    try {
      final usuarioId = await _obtenerUsuarioId();
      final token = await _obtenerToken();

      if (usuarioId == null) {
        throw Exception('Usuario no autenticado');
      }

      if (token == null) {
        throw Exception('No hay token de autenticación');
      }

      print('CarritoService: Agregando producto $productoId, cantidad: $cantidad');
      print('CarritoService: Usuario ID: $usuarioId');

      // Construir URL con parámetros de forma más explícita
      final Map<String, String> queryParams = {
        'usuarioId': usuarioId.toString(),
        'productoId': productoId.toString(),
        'cantidad': cantidad.toString(),
      };

      final uri = Uri.parse('$baseUrl/api/carrito/agregar').replace(queryParameters: queryParams);
      print('CarritoService: URL completa: $uri');

      final response = await http.post(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ).timeout(Duration(seconds: 15));

      print('CarritoService: Respuesta recibida');
      print('Status code: ${response.statusCode}');

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        print('Producto agregado: ${jsonResponse['data']}');
        return Carrito.fromJson(jsonResponse['data']);
      } else {
        print('CarritoService: Error en la respuesta - ${response.body}');
        throw Exception('Error al agregar producto al carrito');
      }
    } catch (e) {
      print('CarritoService: Error - $e');
      throw Exception('Error de conexión: $e');
    }
  }

  // Actualizar cantidad de un producto en el carrito
  Future<Carrito> actualizarCantidad(int productoId, int cantidad) async {
    try {
      final usuarioId = await _obtenerUsuarioId();
      final token = await _obtenerToken();

      if (usuarioId == null) {
        throw Exception('Usuario no autenticado');
      }

      if (token == null) {
        throw Exception('No hay token de autenticación');
      }

      print('CarritoService: Actualizando cantidad producto $productoId, nueva cantidad: $cantidad');

      // Convertir a String explícitamente
      final usuarioIdStr = usuarioId.toString();
      final productoIdStr = productoId.toString();
      final cantidadStr = cantidad.toString();

      final response = await http.put(
        Uri.parse('$baseUrl/api/carrito/actualizar?usuarioId=$usuarioIdStr&productoId=$productoIdStr&cantidad=$cantidadStr'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ).timeout(Duration(seconds: 15));

      print('CarritoService: Respuesta recibida');
      print('Status code: ${response.statusCode}');

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        print('Cantidad actualizada: ${jsonResponse['data']}');
        return Carrito.fromJson(jsonResponse['data']);
      } else {
        print('CarritoService: Error en la respuesta - ${response.body}');
        throw Exception('Error al actualizar cantidad');
      }
    } catch (e) {
      print('CarritoService: Error - $e');
      throw Exception('Error de conexión: $e');
    }
  }

  // Eliminar producto del carrito
  Future<void> eliminarProducto(int productoId) async {
    try {
      final usuarioId = await _obtenerUsuarioId();
      final token = await _obtenerToken();

      if (usuarioId == null) {
        throw Exception('Usuario no autenticado');
      }

      if (token == null) {
        throw Exception('No hay token de autenticación');
      }

      print('CarritoService: Eliminando producto $productoId');

      // Convertir a String explícitamente
      final usuarioIdStr = usuarioId.toString();
      final productoIdStr = productoId.toString();

      final response = await http.delete(
        Uri.parse('$baseUrl/api/carrito/eliminar?usuarioId=$usuarioIdStr&productoId=$productoIdStr'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ).timeout(Duration(seconds: 15));

      print('CarritoService: Respuesta recibida');
      print('Status code: ${response.statusCode}');

      if (response.statusCode == 200) {
        print('Producto eliminado del carrito');
      } else {
        print('CarritoService: Error en la respuesta - ${response.body}');
        throw Exception('Error al eliminar producto del carrito');
      }
    } catch (e) {
      print('CarritoService: Error - $e');
      throw Exception('Error de conexión: $e');
    }
  }

  // Obtener total del carrito
  Future<double> obtenerTotal() async {
    try {
      final usuarioId = await _obtenerUsuarioId();
      final token = await _obtenerToken();

      if (usuarioId == null) {
        throw Exception('Usuario no autenticado');
      }

      if (token == null) {
        throw Exception('No hay token de autenticación');
      }

      print('CarritoService: Obteniendo total del carrito');

      final usuarioIdStr = usuarioId.toString();

      final response = await http.get(
        Uri.parse('$baseUrl/api/carrito/total?usuarioId=$usuarioIdStr'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ).timeout(Duration(seconds: 15));

      print('CarritoService: Respuesta recibida');
      print('Status code: ${response.statusCode}');

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final total = jsonResponse['data'].toDouble();
        print('Total del carrito: $total');
        return total;
      } else {
        print('CarritoService: Error en la respuesta - ${response.body}');
        throw Exception('Error al obtener total del carrito');
      }
    } catch (e) {
      print('CarritoService: Error - $e');
      throw Exception('Error de conexión: $e');
    }
  }

  // Comprar carrito (simulación con método de pago por defecto)
  Future<bool> comprarCarrito() async {
    try {
      final usuarioId = await _obtenerUsuarioId();
      final token = await _obtenerToken();

      if (usuarioId == null) {
        throw Exception('Usuario no autenticado');
      }

      if (token == null) {
        throw Exception('No hay token de autenticación');
      }

      // Método de pago simulado (ID: 1) - crear en BD o cambiar este valor
      const int metodoPagoId = 1;

      print('CarritoService: Comprando carrito');

      final usuarioIdStr = usuarioId.toString();
      final metodoPagoIdStr = metodoPagoId.toString();

      final response = await http.post(
        Uri.parse('$baseUrl/api/carrito/comprar?usuarioId=$usuarioIdStr&metodoPagoId=$metodoPagoIdStr'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ).timeout(Duration(seconds: 15));

      print('CarritoService: Respuesta recibida');
      print('Status code: ${response.statusCode}');

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        print('Pedido creado: ${jsonResponse['data']}');
        return true;
      } else {
        print('CarritoService: Error en la respuesta - ${response.body}');
        throw Exception('Error al procesar la compra');
      }
    } catch (e) {
      print('CarritoService: Error - $e');
      throw Exception('Error de conexión: $e');
    }
  }
} 