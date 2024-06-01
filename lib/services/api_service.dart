// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app_user/models/user.dart';

class ApiService {
  final String baseUrl = "https://reqres.in/api";

  Future<List<User>> fetchUsers() async {
    final response = await http.get(Uri.parse('$baseUrl/users'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = json.decode(response.body)['data'];
      return jsonResponse.map((user) => User.fromJson(user)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  Future<User> fetchUserById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/users/$id'));
    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body)['data']);
    } else {
      throw Exception('Failed to load user');
    }
  }

  Future<http.Response> createUser(String name, String email) async {
    print('Creating user with name: $name and email: $email');
    final response = await http.post(
      Uri.parse('$baseUrl/users'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'name': name,
        'email': email,
      }),
    );
    print('Response received');
    return response;
  }
}
