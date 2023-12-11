// api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl;

  ApiService({this.baseUrl = 'http://localhost:56258'}); // Replace with your actual backend URL

  Future<List<String>> getPrompts() async {
    final response = await http.get(Uri.parse('$baseUrl/get-prompts'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return List<String>.from(data.map((prompt) => prompt['text']));
    } else {
      return [];
    }
  }

  Future<void> submitResponse(String response) async {
    await http.post(
      Uri.parse('$baseUrl/submit-response'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'response': response}),
    );
  }

  Future<String> getFeedback(String response) async {
    final responseFromApi = await http.post(
      Uri.parse('$baseUrl/get-feedback'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'response': response}),
    );

    if (responseFromApi.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(responseFromApi.body);
      return data['feedback'];
    } else {
      throw Exception('Failed to get feedback');
    }
  }
}
