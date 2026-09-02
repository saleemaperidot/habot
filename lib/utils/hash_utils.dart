import 'dart:convert';
import 'package:crypto/crypto.dart';


class HashUtils {
  const HashUtils._();

  static String sha256Hex(String input) {
    final bytes = utf8.encode(input);
    return sha256.convert(bytes).toString();
  }
}
