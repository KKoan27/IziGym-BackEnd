import 'dart:io';
import 'parser_extension.dart';

class Customenv {
  static Map<String, String> _map = {};

  static Future<Type> get<Type>({required String? key}) async {
    if (_map.isEmpty) await _load();

    return _map[key]!.toType(Type);
  }

  static Future<String> _readfile() async {
    return await File('.env').readAsString();
  }

  static Future<void> _load() async {
    List<String> linhas = (await _readfile()).split('\n');

    var linhasValidas = linhas.where((l) => l.isNotEmpty && l.contains('='));
    _map = {for (var l in linhasValidas) l.split('=')[0]: l.split('=')[1]};
    _map = {
      for (var l in linhasValidas)
        l.split('=')[0].trim(): l
            .split('=')[1]
            .trim(), // Use .trim() na chave e no valor
    };
  }
}
