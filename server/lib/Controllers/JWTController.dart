import 'dart:convert';

import 'package:dart_jsonwebtoken/src/keys.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:shelf/shelf.dart';

class JWTController {
  static String signer(Map<String, dynamic> payload, String key) {
    try {
      JWT jwt = JWT(payload);

      return jwt.sign(SecretKey(key));
    } on JWTException catch (e) {
      rethrow;
    }
  }
}
