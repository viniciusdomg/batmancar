import 'package:flutter/material.dart';

class TelaDirecaoAutomatica extends StatefulWidget {
  @override
  _TelaDirecaoAutomaticaState createState() => _TelaDirecaoAutomaticaState();
}

class _TelaDirecaoAutomaticaState extends State<TelaDirecaoAutomatica> {
  static const double cellSize = 20;
  static const int maxX = 10;
  static const int maxY = 24;

  Offset? endPoint;

  void reset() {
    setState(() {
      endPoint = null;
    });
  }

  void onTapDown(TapDownDetails details, Size size) {
    final local = details.localPosition;

    final x = (local.dx / cellSize).floor();
    final y = ((size.height - local.dy) / cellSize).floor();

    if (x < 0 || x > maxX || y < 0 || y > maxY) return;

    setState(() {
      endPoint = Offset(x.toDouble(), y.toDouble());
    });
  }

  @override
  Widget build(BuildContext context) {
    final mapWidth = (maxX + 1) * cellSize;
    final mapHeight = (maxY + 1) * cellSize;

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
          'Modo Automático',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: reset,
            icon: const Icon(Icons.refresh, color: Colors.white),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16).copyWith(top: 24),
              child: Column(
                children: [
                  /// MAPA
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1D2D),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFF2547F4).withOpacity(0.4),
                      ),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Center(
                      child: GestureDetector(
                        onTapDown: (details) {
                          onTapDown(
                            details,
                            Size(mapWidth, mapHeight),
                          );
                        },
                        child: CustomPaint(
                          size: Size(mapWidth, mapHeight),
                          painter: GridPainter(endPoint: endPoint),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  /// COORDENADAS
                  Row(
                    children: [
                      _buildCoordinateBox(
                        title: "Início",
                        value: "(0 , 0)",
                      ),
                      const SizedBox(width: 12),
                      _buildCoordinateBox(
                        title: "Fim",
                        value: endPoint == null
                            ? "(- , -)"
                            : "(${endPoint!.dx.toInt()} , ${endPoint!.dy.toInt()})",
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  /// BOTÃO
                  _buildSendButton(),
                ],
              ),
            ),
          ),

          /// STATUS
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

  Widget _buildCoordinateBox({required String title, required String value}) {
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
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSendButton() {
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

  void _sendDestination() {
    if (endPoint == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Defina um ponto no mapa primeiro'),
          backgroundColor: Color(0xFF2547F4),
        ),
      );
      return;
    }

    final x = endPoint!.dx.toInt();
    final y = endPoint!.dy.toInt();

    print('Enviando destino: X=$x, Y=$y');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Destino enviado: ($x, $y)'),
        backgroundColor: const Color(0xFF2547F4),
      ),
    );
  }
}

class GridPainter extends CustomPainter {
  static const double cellSize = 20;
  final Offset? endPoint;

  GridPainter({this.endPoint});

  @override
  void paint(Canvas canvas, Size size) {
    final paintGrid = Paint()
      ..color = Colors.white.withOpacity(0.15)
      ..strokeWidth = 1;

    final rows = (size.height / cellSize).floor();
    final cols = (size.width / cellSize).floor();

    for (int i = 0; i <= rows; i++) {
      canvas.drawLine(
        Offset(0, i * cellSize),
        Offset(size.width, i * cellSize),
        paintGrid,
      );
    }

    for (int i = 0; i <= cols; i++) {
      canvas.drawLine(
        Offset(i * cellSize, 0),
        Offset(i * cellSize, size.height),
        paintGrid,
      );
    }

    final startPaint = Paint()..color = Colors.red;
    canvas.drawCircle(
      Offset(cellSize / 2, size.height - cellSize / 2),
      6,
      startPaint,
    );

    if (endPoint != null) {
      final endPaint = Paint()..color = const Color(0xFF2547F4);
      final dx = endPoint!.dx * cellSize + (cellSize / 2);
      final dy = size.height - (endPoint!.dy * cellSize + (cellSize / 2));

      canvas.drawCircle(Offset(dx, dy), 6, endPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}