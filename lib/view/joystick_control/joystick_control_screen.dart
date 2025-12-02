import 'package:flutter/material.dart';

class TelaControleManual extends StatefulWidget {
  @override
  _TelaControleManualState createState() => _TelaControleManualState();
}

class _TelaControleManualState extends State<TelaControleManual> {
  double joystickX = 0.00;
  double joystickY = 0.00;

  @override
  Widget build(BuildContext context) {
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
          // Área central com controle direcional
          Expanded(
            child: Center(
              child: _buildDirectionalControl(),
            ),
          ),
          // Indicadores de Joystick na parte inferior
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: _buildJoystickIndicator(
                    'Joystick X',
                    joystickX,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildJoystickIndicator(
                    'Joystick Y',
                    joystickY,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget do controle direcional 3x3
  Widget _buildDirectionalControl() {
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
              () => _onDirectionPressed('UP'),
            ),
          ),
          // Botão ESQUERDA (posição left center)
          Positioned(
            top: 93.33,
            left: 0,
            child: _buildDirectionButton(
              Icons.keyboard_arrow_left,
              () => _onDirectionPressed('LEFT'),
            ),
          ),
          // Botão DIREITA (posição right center)
          Positioned(
            top: 93.33,
            right: 0,
            child: _buildDirectionButton(
              Icons.keyboard_arrow_right,
              () => _onDirectionPressed('RIGHT'),
            ),
          ),
          // Botão BAIXO (posição bottom center)
          Positioned(
            bottom: 0,
            left: 93.33,
            child: _buildDirectionButton(
              Icons.keyboard_arrow_down,
              () => _onDirectionPressed('DOWN'),
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
                  color: const Color(0xFF2547F4).withOpacity(0.3),
                  width: 2,
                  style: BorderStyle.solid,
                ),
              ),
              child: Icon(
                Icons.navigation,
                color: const Color(0xFF2547F4).withOpacity(0.5),
                size: 48,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Botão direcional individual
  Widget _buildDirectionButton(IconData icon, VoidCallback onPressed) {
    return GestureDetector(
      onTapDown: (_) => onPressed(),
      onTapUp: (_) => _onDirectionReleased(),
      child: Container(
        width: 93.33,
        height: 93.33,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFF2547F4).withOpacity(0.5),
            width: 2,
          ),
          color: const Color(0xFF2547F4).withOpacity(0.2),
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 48,
        ),
      ),
    );
  }

  // Card de indicador de Joystick
  Widget _buildJoystickIndicator(String label, double value) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.black.withOpacity(0.3),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value.toStringAsFixed(2),
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
  void _onDirectionPressed(String direction) {
    setState(() {
      switch (direction) {
        case 'UP':
          joystickY = 1.00;
          break;
        case 'DOWN':
          joystickY = -1.00;
          break;
        case 'LEFT':
          joystickX = -1.00;
          break;
        case 'RIGHT':
          joystickX = 1.00;
          break;
      }
    });
    // Aqui você pode adicionar lógica para enviar comandos ao Arduino/ESP
    print('Direção: $direction | X: $joystickX | Y: $joystickY');
  }

  // Callback quando botão direcional é solto
  void _onDirectionReleased() {
    setState(() {
      joystickX = 0.00;
      joystickY = 0.00;
    });
  }
}
