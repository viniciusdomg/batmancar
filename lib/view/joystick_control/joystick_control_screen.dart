import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:batmancar/viewmodel/car_view_model.dart';

class TelaControleManual extends StatefulWidget {
  const TelaControleManual({super.key});

  @override
  _TelaControleManualState createState() => _TelaControleManualState();
}

class _TelaControleManualState extends State<TelaControleManual> {
  int joystickX = 0;
  int joystickY = 0;

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<CarViewModel>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF101322),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          'Controle Manual',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 50),
          // Joystick com menos altura e sem Center extra
          Expanded(
            flex: 0,
            child: Padding(
              padding: const EdgeInsets.only(top: 16),
              child: _buildDirectionalControl(vm),
            ),
          ),

          const SizedBox(height: 80),

          // Bloco de cards logo abaixo
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildInfoCard(
                  'Sensor de Obstáculo (cm)',
                  vm.distancia,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoCard(
                        'Joystick X',
                        joystickX,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildInfoCard(
                        'Joystick Y',
                        joystickY,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget do controle direcional 3x3
  Widget _buildDirectionalControl(CarViewModel vm) {
    return SizedBox(
      width: 280,
      height: 280,
      child: Stack(
        children: [
          // Botão CIMA (posição top center)
          Positioned(
            top: 0,
            left: 93.33,
            child: _buildDirectionButton(
              Icons.keyboard_arrow_up,
                  () => _onDirectionPressed('UP', vm),
              vm,
            ),
          ),
          // Botão ESQUERDA (posição left center)
          Positioned(
            top: 93.33,
            left: 0,
            child: _buildDirectionButton(
              Icons.keyboard_arrow_left,
                  () => _onDirectionPressed('LEFT', vm),
              vm,
            ),
          ),
          // Botão DIREITA (posição right center)
          Positioned(
            top: 93.33,
            right: 0,
            child: _buildDirectionButton(
              Icons.keyboard_arrow_right,
                  () => _onDirectionPressed('RIGHT', vm),
              vm,
            ),
          ),
          // Botão BAIXO (posição bottom center)
          Positioned(
            bottom: 0,
            left: 93.33,
            child: _buildDirectionButton(
              Icons.keyboard_arrow_down,
                  () => _onDirectionPressed('DOWN', vm),
              vm,
            ),
          ),
          // Círculo central com ícone de navegação
          Center(
            child: Container(
              width: 93.33,
              height: 93.33,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF2547F4).withValues(alpha: 0.3),
                  width: 2,
                  style: BorderStyle.solid,
                ),
              ),
              child: Icon(
                Icons.navigation,
                color: const Color(0xFF2547F4).withValues(alpha: 0.5),
                size: 48,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Botão direcional individual
  Widget _buildDirectionButton(
      IconData icon,
      VoidCallback onPressed,
      CarViewModel vm,
      ) {
    return GestureDetector(
      onTapDown: (_) => onPressed(),
      onTapUp: (_) => _onDirectionReleased(vm),
      child: Container(
        width: 93.33,
        height: 93.33,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFF2547F4).withValues(alpha: 0.5),
            width: 2,
          ),
          color: const Color(0xFF2547F4).withValues(alpha: 0.2),
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 48,
        ),
      ),
    );
  }

  // Card genérico (usado para distância e joystick)
  Widget _buildInfoCard(String label, int value) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.black.withValues(alpha: 0.3),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }

  // Callback quando botão direcional é pressionado
  void _onDirectionPressed(String direction, CarViewModel vm) {
    int x = 0;
    int y = 0;

    switch (direction) {
      case 'UP':
        y = 1;
        break;
      case 'DOWN':
        y = -1;
        break;
      case 'LEFT':
        x = -1;
        break;
      case 'RIGHT':
        x = 1;
        break;
    }

    setState(() {
      joystickX = x;
      joystickY = y;
    });

    vm.updateJoystick(x, y);
  }

  // Callback quando botão direcional é solto
  void _onDirectionReleased(CarViewModel vm) {
    setState(() {
      joystickX = 0;
      joystickY = 0;
    });

    vm.updateJoystick(0, 0);
  }
}