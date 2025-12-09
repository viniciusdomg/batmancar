import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../../data/service/firebase_service.dart';

class TelaFuncoesEspeciais extends StatefulWidget {
  const TelaFuncoesEspeciais({super.key});

  @override
  _TelaFuncoesEspeciaisState createState() => _TelaFuncoesEspeciaisState();
}

class _TelaFuncoesEspeciaisState extends State<TelaFuncoesEspeciais> {
  final _firebaseService = FirebaseService.instance;
  late final DatabaseReference _inputsRef;

  bool luzesAtivadas = false;
  bool turboAtivado = false;
  bool stealthAtivado = false;
  bool cabineAtivada = false;

  StreamSubscription<DatabaseEvent>? _listener;

  @override
  void initState() {
    super.initState();
    final rootRef = FirebaseDatabase.instance.ref();
    _inputsRef = rootRef.child('inputs');
    _carregarEstadoInicial();
    _ouvirMudancas();
  }

  @override
  void dispose() {
    _listener?.cancel();
    super.dispose();
  }

  Future<void> _carregarEstadoInicial() async {
    final snapshot = await _inputsRef.get();
    final data = snapshot.value as Map<dynamic, dynamic>?;

    if (data == null || !mounted) return;

    setState(() {
      luzesAtivadas = (data['luz'] ?? false) as bool;
      turboAtivado = (data['turbo'] ?? false) as bool;
      stealthAtivado = (data['stealth'] ?? false) as bool;
      cabineAtivada = (data['cabine'] ?? false) as bool;
    });
  }

  void _ouvirMudancas() {
    _listener = _inputsRef.onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;

      if (data == null || !mounted) return;

      setState(() {
        luzesAtivadas = (data['luz'] ?? false) as bool;
        turboAtivado = (data['turbo'] ?? false) as bool;
        stealthAtivado = (data['stealth'] ?? false) as bool;
        cabineAtivada = (data['cabine'] ?? false) as bool;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101322),
      appBar: AppBar(
        backgroundColor: const Color(0xFF101322),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          'Funções Especiais',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0).copyWith(top: 32),
              child: Column(
                children: [
                  _buildFunctionItem(
                    icon: Icons.lightbulb,
                    label: 'Luzes',
                    value: luzesAtivadas,
                    onChanged: (value) {
                      setState(() => luzesAtivadas = value);
                      _onFunctionToggle('Luzes', value);
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildFunctionItem(
                    icon: Icons.bolt,
                    label: 'Turbo',
                    value: turboAtivado,
                    onChanged: (value) {
                      setState(() => turboAtivado = value);
                      _onFunctionToggle('Turbo', value);
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildFunctionItem(
                    icon: Icons.airline_seat_recline_extra  ,
                    label: 'Cabine',
                    value: cabineAtivada,
                    onChanged: (value) {
                      setState(() => cabineAtivada = value);
                      _onFunctionToggle('Cabine', value);
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildFunctionItem(
                    icon: Icons.visibility_off,
                    label: 'Modo furtivo',
                    value: stealthAtivado,
                    onChanged: (value) {
                      setState(() => stealthAtivado = value);
                      _onFunctionToggle('Stealth', value);
                    },
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 32),
            child: Text(
              'Conectado',
              style: TextStyle(
                color: const Color(0xFF9CA1BA),
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFunctionItem({
    required IconData icon,
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1D2D),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFF282B39),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF2547F4),
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          _buildCustomSwitch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }

  Widget _buildCustomSwitch({
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 51,
        height: 31,
        decoration: BoxDecoration(
          color: value ? const Color(0xFF2547F4) : const Color(0xFF282B39),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(2),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 27,
            height: 27,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onFunctionToggle(String function, bool enabled) async {
    print('$function: ${enabled ? "Ativado" : "Desativado"}');

    try {
      switch (function) {
        case 'Luzes':
          await _firebaseService.atualizarLuzes(enabled);
          break;
        case 'Turbo':
          await _firebaseService.atualizarTurbo(enabled);
          break;
        case 'Cabine':
          await _firebaseService.atualizarCabine(enabled);
          break;
        case 'Stealth':
          await _firebaseService.atualizarStealth(enabled);
          break;
      }
    } catch (e) {
      debugPrint('Erro ao atualizar $function: $e');
    }
  }
}