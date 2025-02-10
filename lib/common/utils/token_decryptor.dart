import 'package:jwt_decoder/jwt_decoder.dart';

class TokenDecryptor {
  static String? getUserId(String token) {
    try {
      final Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      print("Decoded Token: $decodedToken");
      return decodedToken['Id'];
    } catch (error) {
      print("Error decoding token: $error");
      return null;
    }
  }
}
