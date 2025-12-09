// car_view_model.dart
import 'package:firebase_database/firebase_database.dart';
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
    distancia: 0,
  );

  CarViewModel() {
    _iniciarListenerDistancia();
  }

  Commands get command => _command;
  double get distancia => _command.distancia;

  // Joystick
  void updateJoystick(int x, int y) {
    final bool desligandoAutomatico = _command.modoAutomatico;

    _command = _command.copyWith(
      joystickX: x,
      joystickY: y,
      modoAutomatico: desligandoAutomatico ? false : null,
      destinoX: desligandoAutomatico ? 0 : null,
      destinoY: desligandoAutomatico ? 0 : null,
    );

    _service.atualizarJoystick(
      joystickX: x,
      joystickY: y,
      modoAutomatico: desligandoAutomatico ? false : null,
      destinoX: desligandoAutomatico ? 0.0 : null,
      destinoY: desligandoAutomatico ? 0.0 : null,
    );

    // Sem notifyListeners() por performance (como você já tinha feito)
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
    _command = _command.copyWith(
      modoAutomatico: true,
      destinoX: x,
      destinoY: y,
    );

    await _service.atualizarDestino(destinoX: x, destinoY: y);
    notifyListeners();
  }

  Future<void> setManualMode() async {
    _command = _command.copyWith(
      modoAutomatico: false,
      destinoX: 0,
      destinoY: 0
    );
    await _service.setManualMode();
    notifyListeners();
  }

  // Listener da distância no Firebase
  void _iniciarListenerDistancia() {
    FirebaseDatabase.instance.ref().child('distancia').onValue.listen((event) {
      final valor = event.snapshot.value;
      final doubleDistancia =
      (valor is num) ? valor.toDouble() : double.tryParse(valor?.toString() ?? '0') ?? 0.0;

      _command = _command.copyWith(distancia: doubleDistancia);
      notifyListeners();
    });
  }
}