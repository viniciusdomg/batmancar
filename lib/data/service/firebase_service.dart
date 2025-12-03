import 'package:firebase_database/firebase_database.dart';

class FirebaseService {
  final FirebaseDatabase _db = FirebaseDatabase.instance;

  // Getter necessário para usar _rootRef
  DatabaseReference get _rootRef => _db.ref();

  /// Atualiza um caminho direto no Firebase
  Future<void> atualizarEstado(String caminho, dynamic valor) async {
    try {
      await _rootRef.child(caminho).set(valor);
      print("Firebase atualizou: $caminho = $valor");
    } catch (e) {
      print("Erro ao atualizar Firebase: $e");
    }
  }

  /// Atualiza apenas um nó específico (mesma ideia da função acima)
  Future<void> updateState(String path, dynamic value) async {
    try {
      await _rootRef.child(path).set(value);
      print("Updated: $path -> $value");
    } catch (e) {
      print("Error updating state: $e");
    }
  }

  /// Atualiza o nó car_state sem sobrescrever os demais campos
  Future<void> updateCarState(Map<String, dynamic> data) async {
    try {
      await _rootRef.child("car_state").update(data);
      print("car_state atualizado -> $data");
    } catch (e) {
      print("Erro ao atualizar car_state: $e");
    }
  }
}
