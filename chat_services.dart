import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatService {
  final String baseUrl = 'http://192.168.30.37:5000';

  Future<String> getResponse(String prompt) async {
    final response = await http.post(

      Uri.parse('$baseUrl/generate'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'prompt': prompt}),

    );
    print('Request: ${jsonEncode({'country': prompt})}');

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['response'];
    } else {
      print(jsonDecode(response.body));
      throw Exception('Failed to load response');
    }
  }
}
