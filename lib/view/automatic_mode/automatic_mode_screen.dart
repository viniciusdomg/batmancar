import 'package:batmancar/viewmodel/car_view_model.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class TelaDirecaoAutomatica extends StatefulWidget {
  const TelaDirecaoAutomatica({super.key});

  @override
  State<TelaDirecaoAutomatica> createState() => _TelaDirecaoAutomaticaState();
}

class _TelaDirecaoAutomaticaState extends State<TelaDirecaoAutomatica> {
  double? _lastLat;
  double? _lastLng;
  bool _sending = false;

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
          'Direção Automática',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          // Mapa fictício + info + botão
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16).copyWith(top: 24),
              child: Column(
                children: [
                  // MAPA ILUSTRATIVO
                  Container(
                    height: 260,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1D2D),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFF2547F4).withOpacity(0.4),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: CustomPaint(
                        painter: _FakeMapPainter(),
                        child: Stack(
                          children: [
                            Positioned(
                              left: 16,
                              top: 16,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text(
                                  'Mapa ilustrativo',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            const Center(
                              child: Icon(
                                Icons.location_on,
                                color: Color(0xFF2547F4),
                                size: 36,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // INFO DESTINO ATUAL
                  Row(
                    children: [
                      _buildInfoBox(
                        title: 'Destino atual',
                        value: (_lastLat == null || _lastLng == null)
                            ? 'Nenhum destino definido'
                            : '${_lastLat!.toStringAsFixed(5)}, ${_lastLng!.toStringAsFixed(5)}',
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // BOTÃO
                  _buildSendButton(context),
                ],
              ),
            ),
          ),

          // STATUS
          Padding(
            padding: const EdgeInsets.only(bottom: 24),
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

  Widget _buildInfoBox({required String title, required String value}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1D2D),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white.withOpacity(0.08),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSendButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _sending ? null : () => _sendDestination(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2547F4),
          shadowColor: const Color(0xFF2547F4).withOpacity(0.5),
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: _sending
            ? const SizedBox(
          width: 22,
          height: 22,
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            strokeWidth: 2.5,
          ),
        )
            : const Text(
          'Iniciar Condução',
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

  Future<void> _sendDestination(BuildContext context) async {
    setState(() => _sending = true);

    try {
      // 1. Verificar / pedir permissão de localização
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Permita acesso à localização para usar a direção automática',
                ),
              ),
            );
          }
          return;
        }
      }

      // 2. Obter posição atual do celular
      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      final double lat = pos.latitude;
      final double lng = pos.longitude;

      // 3. Enviar para o Firebase via ViewModel
      final carViewModel = context.read<CarViewModel>();
      await carViewModel.setDestino(lat, lng); // destino_x / destino_y como double

      setState(() {
        _lastLat = lat;
        _lastLng = lng;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Destino enviado: (${lat.toStringAsFixed(5)}, ${lng.toStringAsFixed(5)})',
            ),
            backgroundColor: const Color(0xFF2547F4),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao obter/enviar localização: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _sending = false);
      }
    }
  }
}

// Desenho do mapa fictício
class _FakeMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = Colors.white.withOpacity(0.07)
      ..strokeWidth = 1;

    const cell = 32.0;
    final rows = (size.height / cell).floor();
    final cols = (size.width / cell).floor();

    // Grade
    for (int i = 0; i <= rows; i++) {
      canvas.drawLine(
        Offset(0, i * cell),
        Offset(size.width, i * cell),
        gridPaint,
      );
    }
    for (int j = 0; j <= cols; j++) {
      canvas.drawLine(
        Offset(j * cell, 0),
        Offset(j * cell, size.height),
        gridPaint,
      );
    }

    // Rota
    final routePaint = Paint()
      ..color = const Color(0xFF2547F4)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..moveTo(size.width * 0.15, size.height * 0.8)
      ..quadraticBezierTo(
        size.width * 0.30,
        size.height * 0.5,
        size.width * 0.5,
        size.height * 0.6,
      )
      ..quadraticBezierTo(
        size.width * 0.75,
        size.height * 0.7,
        size.width * 0.85,
        size.height * 0.3,
      );

    canvas.drawPath(path, routePaint);

    // Ponto de partida
    final startPaint = Paint()..color = Colors.greenAccent;
    canvas.drawCircle(
      Offset(size.width * 0.15, size.height * 0.8),
      5,
      startPaint,
    );

    // Destino
    final endPaint = Paint()..color = Colors.redAccent;
    canvas.drawCircle(
      Offset(size.width * 0.85, size.height * 0.3),
      6,
      endPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}