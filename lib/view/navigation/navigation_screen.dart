import 'package:batmancar/view/automatic_mode/automatic_mode_screen.dart';
import 'package:batmancar/view/joystick_control/joystick_control_screen.dart';
import 'package:batmancar/view/especial_functions/especial_functions_screen.dart';
import 'package:batmancar/view/voice_command/voice_command_screen.dart';
import 'package:batmancar/viewmodel/car_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TelaInicialBatman extends StatelessWidget {
  const TelaInicialBatman({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CarViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFF101322),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const Icon(Icons.shield, color: Color(0xFF2547F4), size: 32),
        centerTitle: true,
        title: const Text(
          'Carro do Batman',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          // Grid de modos
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _GridCard(
                    icon: Icons.sports_esports,
                    title: 'Controle Manual',
                    subtitle: 'Assuma o controle total',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TelaControleManual(),
                        ),
                      );
                    },
                  ),
                  _GridCard(
                    icon: Icons.auto_awesome,
                    title: 'Funções Especiais',
                    subtitle: 'Ative os gadgets',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TelaFuncoesEspeciais(),
                        ),
                      );
                    },
                  ),
                  _GridCard(
                    icon: Icons.graphic_eq,
                    title: 'Comando por Voz',
                    subtitle: 'Dê ordens diretas',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TelaComandoVoz(),
                        ),
                      );
                    },
                  ),
                  _GridCard(
                    icon: Icons.mode_of_travel,
                    title: 'Direção Automática',
                    subtitle: 'Deixe o carro dirigir',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TelaDirecaoAutomatica(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          // Botão redondo de Ligar/Desligar
          Padding(
            padding: const EdgeInsets.only(bottom: 150),
            child: GestureDetector(
              onTap: () => vm.toggleIgnicao(!vm.ignicao),
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: vm.ignicao ? Colors.red : const Color(0xFF2547F4),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Image.asset(
                    'assets/icon/batman.png',
                    width: 180,
                    height: 180,
                    color: Colors.white, // opcional, se quiser “tintar” o ícone
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Widget personalizado para cada card do grid
class _GridCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _GridCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: Colors.grey.withOpacity(0.2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: const Color(0xFF2547F4), size: 32),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
