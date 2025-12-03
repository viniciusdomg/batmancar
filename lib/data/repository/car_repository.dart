import '../service/firebase_service.dart';

class CarRepository {
  final FirebaseService _service;

  CarRepository(this._service);

  Future<void> setStealth(bool value) async {
    await _service.updateState("car_state/modes/stealth", value);
  }

  Future<void> setTurbo(bool value) async {
    await _service.updateCarState({'modoTurbo': value});
  }

  Future<void> abrirCabine(bool value) async {
    await _service.updateCarState({'abrirCabine': value});
  }
}
