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
    ignicao: false,
    cabine: false,
    modoAutomatico: false,
    destinoX: 0,
    destinoY: 0,
    distancia: 0,
    teste1: 0,
    teste2: false,
  );

  CarViewModel() {
    _iniciarListenerDistancia();
    _iniciarListenerTeste();
  }

  Commands get command => _command;

  double get distancia => _command.distancia;
  bool get ignicao => _command.ignicao;
  int get teste1 => _command.teste1;
  bool get teste2 => _command.teste2;

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
  }

  Future<void> toggleIgnicao(bool value) async {
    _command = _command.copyWith(ignicao: value);
    await _service.atualizarIgnicao(value);

    // Se a ignição estiver sendo LIGADA, chama a função de teste
    if (value) {
      // Você pode alterar os valores de teste aqui como precisar
      await atualizarTeste(1, true);
    }

    notifyListeners();
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

  Future<void> toggleCabine(bool value) async {
    _command = _command.copyWith(cabine: value);
    await _service.atualizarCabine(value);
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
      destinoY: 0,
    );
    await _service.setManualMode();
    notifyListeners();
  }

  Future<void> atualizarTeste(int teste1, bool teste2) async {
    await _service.atualizarTeste(teste1, teste2);
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

  // Listener para os valores de teste no Firebase
  void _iniciarListenerTeste() {
    FirebaseDatabase.instance.ref().child('teste').onValue.listen((event) {
      final data = event.snapshot.value;
      if (data != null && data is Map) {
        final testeData = Map<String, dynamic>.from(data as Map);
        _command = _command.copyWith(
          teste1: testeData['teste1'] as int? ?? _command.teste1,
          teste2: testeData['teste2'] as bool? ?? _command.teste2,
        );
        notifyListeners();
      }
    });
  }
}