import 'package:firebase_database/firebase_database.dart';

class FirebaseService {
  final FirebaseDatabase _db = FirebaseDatabase.instance;

  DatabaseReference get _rootRef => _db.ref();

  Future<void> updateData( Map<String, dynamic> data) async {
    try {
      await _rootRef.update(data);
      print("Salvou valor");
    } catch (e) {
      print('Erro no Service ao atualizar dados: $e');
    }
  }

  Future<void> setVal( dynamic value) async {
    try {
      await _rootRef.set(value);
      print("Salvou valor");
    } catch (e) {
      print('Erro no Service ao setar valor: $e');

    }
  }
}