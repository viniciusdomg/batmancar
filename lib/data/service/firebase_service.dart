import 'package:firebase_database/firebase_database.dart';
import '../model/commands.dart';

class FirebaseService {
  FirebaseService._();
  static final instance = FirebaseService._();

  final FirebaseDatabase _db = FirebaseDatabase.instance;

  // Referência para a raiz do Realtime Database
  DatabaseReference get _rootRef => _db.ref();

  // --- Atualizações pontuais ---

  Future<void> atualizarLuzes(bool ligado) async {
    print('FirebaseService.atualizarLuzes: $ligado');
    await _rootRef.child('inputs').update({'luz': ligado});
  }

  Future<void> atualizarTurbo(bool ativado) async {
    print('FirebaseService.atualizarTurbo: $ativado');
    await _rootRef.child('inputs').update({'turbo': ativado});
  }

  Future<void> atualizarStealth(bool ativado) async {
    print('FirebaseService.atualizarStealth: $ativado');
    await _rootRef.child('inputs').update({'stealth': ativado});
  }

  Future<void> atualizarJoystick({
    required int joystickX,
    required int joystickY,
  }) async {
    print('FirebaseService.atualizarJoystick: x=$joystickX, y=$joystickY');
    await _rootRef.child('inputs').update({
      'joystick_x': joystickX,
      'joystick_y': joystickY,
    });
  }

  Future<void> atualizarDestino({
    required double destinoX,
    required double destinoY,
  }) async {
    await _rootRef.child('inputs').update({
      'modo_automatico': true,
      'destino_x': destinoX,
      'destino_y': destinoY,
    });
  }

  Future<void> setManualMode() async {
    print('FirebaseService.setManualMode');
    await _rootRef.child('inputs').update({'modo_automatico': false});
  }

  Future<void> atualizarDistancia(int distancia) async {
    print('FirebaseService.atualizarDistancia: $distancia');
    await _rootRef.update({'distancia': distancia});
  }

  // --- Atualizar tudo de uma vez (opcional) ---

  // Future<void> salvarCommands(Commands command) async {
  //   final json = command.toJson();
  //   await _rootRef.set(json);
  // }
}