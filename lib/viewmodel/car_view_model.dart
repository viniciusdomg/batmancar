// car_view_model.dart
import 'package:flutter/foundation.dart';
import '../data/model/commands.dart';
import '../data/service/firebase_service.dart';

class CarViewModel extends ChangeNotifier {
  final FirebaseService _service = FirebaseService.instance;

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

  // Joystick
  void updateJoystick(int x, int y) {
    _command = _command.copyWith(joystickX: x, joystickY: y);
    _service.atualizarJoystick(joystickX: x, joystickY: y);
    // sem notifyListeners() por performance
  }

  // Funções especiais
  Future<void> toggleLuz(bool value) async {
    _command = _command.copyWith(luz: value);
    await _service.atualizarLuzes(value);
    notifyListeners();
  }

  Future<void> toggleTurbo(bool value) async {
    _command = _command.copyWith(turbo: value);
    await _service.atualizarTurbo(value);
    notifyListeners();
  }

  Future<void> toggleStealth(bool value) async {
    _command = _command.copyWith(stealth: value);
    await _service.atualizarStealth(value);
    notifyListeners();
  }

  // Modo automático
  Future<void> setDestino(double x, double y) async {
    final int dx = x.toInt();
    final int dy = y.toInt();

    _command = _command.copyWith(
      modoAutomatico: true,
      destinoX: dx,
      destinoY: dy,
    );

    await _service.atualizarDestino(destinoX: dx, destinoY: dy);
    notifyListeners();
  }

  Future<void> setManualMode() async {
    _command = _command.copyWith(modoAutomatico: false);
    await _service.setManualMode();
    notifyListeners();
  }
}