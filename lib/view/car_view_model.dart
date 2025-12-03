import 'package:batmancar/data/service/firebase_service.dart';
import 'package:flutter/foundation.dart';
import '../data/model/commands.dart';

class CarViewModel extends ChangeNotifier {

  final _service = FirebaseService();

  Commands _command = Commands(
    joystickX: 0,
    joystickY: 0,
    luz: false,
    turbo: false,
    stealth: false,
    modoAutomatico: false,
    destinoX: 0,
    destinoY: 0,
  );

  Commands get command => _command;

  void updateJoystick(int x, int y) {
    _command = _command.copyWith(joystickX: x, joystickY: y);
    _syncWithFirebase();
    // notifyListeners() removido propositalmente para performance do joystick
  }

  // 2. Funções Especiais
  void toggleLuz(bool value) {
    _command = _command.copyWith(luz: value);
    _syncWithFirebase();
    notifyListeners();
  }

  void toggleTurbo(bool value) {
    _command = _command.copyWith(turbo: value);
    _syncWithFirebase();
    notifyListeners();
  }

  void toggleStealth(bool value) {
    _command = _command.copyWith(stealth: value);

    // agora funcionando corretamente
    _service.updateState("car_state/modes/stealth", value);

    notifyListeners();
  }

  // 3. Modo Automático
  void setDestino(double x, double y) {
    _command = _command.copyWith(
      modoAutomatico: true,
      destinoX: x.toInt(),
      destinoY: y.toInt(),
    );
    _syncWithFirebase();
    notifyListeners();
  }

  void setManualMode() {
    _command = _command.copyWith(modoAutomatico: false);
    _syncWithFirebase();
    notifyListeners();
  }

  // --- COMUNICAÇÃO COM FIREBASE ---
  void _syncWithFirebase() {
    try {
      final data = _command.toJson();
      if (kDebugMode) {
        print('CarViewModel: atualizando car_state -> $data');
      }
      _service.updateCarState(data);
    } catch (e) {
      if (kDebugMode) {
        print("Erro ao enviar para Firebase: $e");
      }
    }
  }
}