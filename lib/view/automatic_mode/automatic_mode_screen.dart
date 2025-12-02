import 'package:flutter/material.dart';

class TelaDirecaoAutomatica extends StatefulWidget {
  @override
  _TelaDirecaoAutomaticaState createState() => _TelaDirecaoAutomaticaState();
}

class _TelaDirecaoAutomaticaState extends State<TelaDirecaoAutomatica>
    with SingleTickerProviderStateMixin {
  double destinoX = 152.4;
  double destinoY = 88.9;
  Offset? markerPosition;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    
    // Posição inicial do marcador (45% do topo, 60% da esquerda)
    markerPosition = const Offset(0.6, 0.45);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

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
          'Modo Automático',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.15,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Mapa interativo
                  Expanded(
                    child: _buildInteractiveMap(),
                  ),
                  const SizedBox(height: 24),
                  // Coordenadas do destino
                  _buildCoordinatesDisplay(),
                  const SizedBox(height: 24),
                  // Botão enviar destino
                  _buildSendDestinationButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Mapa interativo com marcador animado
  Widget _buildInteractiveMap() {
    return GestureDetector(
      onTapDown: (details) {
        setState(() {
          // Captura posição relativa do toque
          final RenderBox box = context.findRenderObject() as RenderBox;
          final localPosition = details.localPosition;
          
          // Calcula posição relativa (0.0 a 1.0)
          markerPosition = Offset(
            localPosition.dx / box.size.width,
            localPosition.dy / box.size.height,
          );
          
          // Atualiza coordenadas
          destinoX = (markerPosition!.dx * 300).roundToDouble();
          destinoY = (markerPosition!.dy * 200).roundToDouble();
        });
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFF2547F4).withOpacity(0.3),
            width: 1,
          ),
          image: const DecorationImage(
            image: NetworkImage(
              'https://lh3.googleusercontent.com/aida-public/AB6AXuBdtksBcnKVclASRBDJEmqTTb4a3_SkynzzT5Q43UG1TY0cwfK1h0NqYZBwbdWgO5yHzDkfXI7HH4cxR4P-qJ4ig717kijZx246hcTazAaSAKIEqcMQDBjK8NqKfKpe6Lj2EZSlyUJoyvzii9m3k820vuWGI2B6eiWGVXnl-WHWSGO8GOf2KvPLLy6QMnFAoJ0NNQ2k5MWh3o5SgVza7YrosY7hrs-vD0v8k2FuHP0YGFprbH5SytHfEXcNUH7Qi7P5iWNGcFd2psE',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            // Gradiente overlay
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.transparent,
                    const Color(0xFF101322).withOpacity(0.8),
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
            // Marcador animado
            if (markerPosition != null)
              Positioned(
                left: markerPosition!.dx * MediaQuery.of(context).size.width - 20,
                top: markerPosition!.dy * 300 - 20,
                child: _buildAnimatedMarker(),
              ),
            // Texto de instrução
            Positioned(
              bottom: 16,
              left: 16,
              child: Text(
                'Toque no mapa para definir um destino',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Marcador com animação de pulso
  Widget _buildAnimatedMarker() {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Anel de pulso externo
            Transform.scale(
              scale: 1 + (_pulseController.value * 0.5),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF2547F4).withOpacity(
                      0.5 * (1 - _pulseController.value),
                    ),
                    width: 2,
                  ),
                ),
              ),
            ),
            // Ícone de localização
            const Icon(
              Icons.location_searching,
              color: Color(0xFF2547F4),
              size: 36,
            ),
          ],
        );
      },
    );
  }

  // Display de coordenadas
  Widget _buildCoordinatesDisplay() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Colors.white.withOpacity(0.1),
                  width: 1,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Destino X',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  destinoX.toStringAsFixed(1),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Colors.white.withOpacity(0.1),
                  width: 1,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Destino Y',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  destinoY.toStringAsFixed(1),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Botão de enviar destino
  Widget _buildSendDestinationButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: const Color(0xFF2547F4),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2547F4).withOpacity(0.5),
            blurRadius: 20,
            spreadRadius: 0,
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _sendDestination,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text(
          'Enviar Destino',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.15,
          ),
        ),
      ),
    );
  }

  // Enviar destino ao Arduino
  void _sendDestination() {
    print('Enviando destino: X=$destinoX, Y=$destinoY');
    // Aqui você adicionaria a lógica para enviar coordenadas via Bluetooth
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Destino enviado: ($destinoX, $destinoY)'),
        backgroundColor: const Color(0xFF2547F4),
      ),
    );
  }
}
