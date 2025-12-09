import 'package:firebase_database/firebase_database.dart';
import '../model/commands.dart';

class FirebaseService {
  FirebaseService._();
  static final instance = FirebaseService._();

  final FirebaseDatabase _db = FirebaseDatabase.instance;

  // raiz e nó "inputs"
  DatabaseReference get _rootRef => _db.ref();
  DatabaseReference get _inputsRef => _rootRef.child('inputs');

  // --- Atualizações pontuais ---

  Future<void> atualizarLuzes(bool ligado) async {
    print('FirebaseService.atualizarLuzes: $ligado');
    await _inputsRef.update({'luz': ligado});
  }

  Future<void> atualizarTurbo(bool ativado) async {
    print('FirebaseService.atualizarTurbo: $ativado');
    await _inputsRef.update({'turbo': ativado});
  }

  Future<void> atualizarStealth(bool ativado) async {
    print('FirebaseService.atualizarStealth: $ativado');
    await _inputsRef.update({'stealth': ativado});
  }

  Future<void> atualizarJoystick({
    required int joystickX,
    required int joystickY,
    bool? modoAutomatico,
    double? destinoX,
    double? destinoY,
  }) async {
    final Map<String, dynamic> updateMap = {
      'joystick_x': joystickX,
      'joystick_y': joystickY,
    };


    if (modoAutomatico != null) updateMap['modo_automatico'] = modoAutomatico;
    if (destinoX != null) updateMap['destino/x'] = destinoX;
    if (destinoY != null) updateMap['destino/y'] = destinoY;

    print('FirebaseService.atualizarJoystick: $updateMap');
    await _inputsRef.update(updateMap);
  }

  Future<void> atualizarDestino({
    required double destinoX,
    required double destinoY,
  }) async {
    await _inputsRef.update({
      'modo_automatico': true,
      'destino/x': destinoX,
      'destino/y': destinoY,
    });
  }

  Future<void> setManualMode() async {
    print('FirebaseService.setManualMode');
    await _inputsRef.update({
      'modo_automatico': false,
      'destino/x': 0,
      'destino/y': 0,
    });
  }

  // distancia continua na raiz
  Future<void> atualizarDistancia(double distancia) async {
    print('FirebaseService.atualizarDistancia: $distancia');
    await _rootRef.update({'distancia': distancia});
  }

  // --- Atualizar tudo de uma vez
  Future<void> salvarCommands(Commands command) async {
    final json = command.toJson();
    print('FirebaseService.salvarCommands: $json');

    final inputsJson = Map<String, dynamic>.from(json)..remove('distancia');
    final distancia = json['distancia'];

    await _rootRef.update({
      'inputs': inputsJson,
      if (distancia != null) 'distancia': distancia,
    });
  }

  Future<void> atualizarIgnicao(bool ligado) async {
    await _inputsRef.update({'ignicao': ligado});
  }

  Future<void> atualizarCabine(bool ativado) async {
    await _inputsRef.update({'cabine': ativado});
  }
}