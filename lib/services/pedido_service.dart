import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/pedido.dart';

class PedidoService {
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

  // Obtener todos los pedidos del usuario autenticado
  Future<List<Pedido>> obtenerPedidosUsuario() async {
    try {
      final usuarioId = await _obtenerUsuarioId();
      final token = await _obtenerToken();

      if (usuarioId == null) {
        throw Exception('Usuario no autenticado');
      }

      if (token == null) {
        throw Exception('No hay token de autenticación');
      }

      print('PedidoService: Obteniendo pedidos para usuario $usuarioId');
      
      final response = await http.get(
        Uri.parse('$baseUrl/api/pedidos/usuario/$usuarioId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ).timeout(Duration(seconds: 15));

      print('PedidoService: Respuesta recibida');
      print('Status code: ${response.statusCode}');

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final List<dynamic> pedidosData = jsonResponse['data'] ?? jsonResponse;
        print('Pedidos obtenidos: ${pedidosData.length}');
        
        return pedidosData.map((pedidoJson) => Pedido.fromJson(pedidoJson)).toList();
      } else {
        print('PedidoService: Error en la respuesta - ${response.body}');
        throw Exception('Error al obtener los pedidos');
      }
    } catch (e) {
      print('PedidoService: Error - $e');
      throw Exception('Error de conexión: $e');
    }
  }

  // Obtener detalles de un pedido específico
  Future<Pedido> obtenerDetallePedido(int pedidoId) async {
    try {
      final token = await _obtenerToken();

      if (token == null) {
        throw Exception('No hay token de autenticación');
      }

      print('PedidoService: Obteniendo detalle del pedido $pedidoId');
      
      final response = await http.get(
        Uri.parse('$baseUrl/api/pedidos/$pedidoId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ).timeout(Duration(seconds: 15));

      print('PedidoService: Respuesta recibida');
      print('Status code: ${response.statusCode}');

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        print('Detalle del pedido obtenido');
        return Pedido.fromJson(jsonResponse['data'] ?? jsonResponse);
      } else {
        print('PedidoService: Error en la respuesta - ${response.body}');
        throw Exception('Error al obtener el detalle del pedido');
      }
    } catch (e) {
      print('PedidoService: Error - $e');
      throw Exception('Error de conexión: $e');
    }
  }
} 