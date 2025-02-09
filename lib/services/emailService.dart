import 'package:http/http.dart' as http;
import 'dart:convert';

Future<void> sendEmail(String to, String subject, String message) async {
  final url = Uri.parse("http://localhost:3000/send-email");

  final response = await http.post(
    url,
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({"to": to, "subject": subject, "message": message}),
  );

  if (response.statusCode == 200) {
    print("Email sent successfully!");
  } else {
    print("Failed to send email: ${response.body}");
  }
}
