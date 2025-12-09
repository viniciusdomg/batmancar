import 'package:flutter/material.dart';

class BatmanStartButton extends StatefulWidget {
  final bool ignicao;
  final VoidCallback onTap;

  const BatmanStartButton({
    super.key,
    required this.ignicao,
    required this.onTap,
  });

  @override
  State<BatmanStartButton> createState() => _BatmanStartButtonState();
}

class _BatmanStartButtonState extends State<BatmanStartButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  // Cores do projeto
  final Color batmanBlue = const Color(0xFF2547F4);
  final Color activeRed = const Color(0xFFFF0000); // Vermelho vibrante

  @override
  void initState() {
    super.initState();
    // Configura a animação para durar 2 segundos e repetir
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void didUpdateWidget(BatmanStartButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Se ligou o carro, para de piscar (já chamou a atenção).
    // Se desligou, volta a piscar pedindo para ligar.
    if (widget.ignicao) {
      _controller.stop();
      _controller.reset();
    } else {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 150),
      child: GestureDetector(
        onTap: widget.onTap,
        child: SizedBox(
          width: 200,
          height: 200,
          child: Stack(
            alignment: Alignment.center,
            children: [
              //A ONDA (O EFEITO PISCANDO)
              if (!widget.ignicao) // Só mostra a onda se estiver desligado
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Container(
                      width: 150 + (_controller.value * 60), // Cresce de 150 a 210
                      height: 150 + (_controller.value * 60),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: batmanBlue.withValues(alpha: 1.0 - _controller.value), // Esmaece
                          width: 2,
                        ),
                      ),
                    );
                  },
                ),

              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.ignicao ? activeRed : batmanBlue,
                  boxShadow: [
                    BoxShadow(
                      color: widget.ignicao
                          ? activeRed.withValues(alpha: 0.6)
                          : Colors.black.withValues(alpha: 0.5),
                      blurRadius: widget.ignicao ? 25 : 15,
                      spreadRadius: widget.ignicao ? 2 : 0,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),

                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset(
                      'assets/icon/batman.png',
                      width: 120,
                      height: 120,
                      color: Colors.white,
                      fit: BoxFit.contain,
                    ),

                    Icon(
                      Icons.power_settings_new_rounded,
                      size: 20,
                      color: widget.ignicao ? activeRed : batmanBlue,

                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}