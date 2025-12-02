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

  void _sendDestination() {
    if (endPoint == null) return;

    final destinoX = endPoint!.dx.toInt();
    final destinoY = endPoint!.dy.toInt();

    print('Enviando destino: X=$destinoX, Y=$destinoY');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Destino enviado: ($destinoX, $destinoY)'),
        backgroundColor: const Color(0xFF2547F4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mapWidth = (maxX + 1) * cellSize;
    final mapHeight = (maxY + 1) * cellSize;

    return Scaffold(
      backgroundColor: const Color(0xFF101322),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Modo Automático"),
        actions: [
          IconButton(
            onPressed: reset,
            icon: const Icon(Icons.refresh),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
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

          /// BOTÃO ENVIAR
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2547F4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: _sendDestination,
                child: const Text(
                  "Enviar Destino",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),

          /// RODAPÉ / COORDENADAS
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.black,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Pontos Marcados",
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text("Início"),
                    Text("(0, 0)"),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Fim"),
                    Text(
                      endPoint == null
                          ? "(-, -)"
                          : "(${endPoint!.dx.toInt()}, ${endPoint!.dy.toInt()})",
                    ),
                  ],
                ),
                const SizedBox(height: 30),
              ],
            ),
          )
        ],
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
      ..color = Colors.grey.shade800
      ..strokeWidth = 1;

    final rows = (size.height / cellSize).floor();
    final cols = (size.width / cellSize).floor();

    /// LINHAS HORIZONTAIS
    for (int i = 0; i <= rows; i++) {
      canvas.drawLine(
        Offset(0, i * cellSize),
        Offset(size.width, i * cellSize),
        paintGrid,
      );
    }

    /// LINHAS VERTICAIS
    for (int i = 0; i <= cols; i++) {
      canvas.drawLine(
        Offset(i * cellSize, 0),
        Offset(i * cellSize, size.height),
        paintGrid,
      );
    }

    /// PONTO INICIAL
    final startPaint = Paint()..color = Colors.red;
    canvas.drawCircle(
      Offset(cellSize / 2, size.height - cellSize / 2),
      6,
      startPaint,
    );

    /// PONTO FINAL
    if (endPoint != null) {
      final endPaint = Paint()..color = Colors.blue;
      final dx = endPoint!.dx * cellSize + (cellSize / 2);
      final dy = size.height - (endPoint!.dy * cellSize + (cellSize / 2));

      canvas.drawCircle(Offset(dx, dy), 6, endPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}