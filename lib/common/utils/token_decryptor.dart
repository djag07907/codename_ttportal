import 'package:jwt_decoder/jwt_decoder.dart';

class TokenDecryptor {
  static String? getUserId(String token) {
    try {
      final Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      return decodedToken['Id'];
    } catch (error) {
      return null;
    }
  }
}
