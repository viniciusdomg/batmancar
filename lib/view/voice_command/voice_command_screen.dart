import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:provider/provider.dart';
import 'package:batmancar/viewmodel/car_view_model.dart';

class TelaComandoVoz extends StatefulWidget {
  @override
  _TelaComandoVozState createState() => _TelaComandoVozState();
}

class _TelaComandoVozState extends State<TelaComandoVoz> {
  bool isListening = false;
  late stt.SpeechToText _speech;
  String _lastWords = '';

  final List<String> _commands = [
    'Ligar luz',
    'Desligar luz',
    'Ativar modo furtivo',
    'Desativar modo furtivo',
    'Modo turbo',
    'Desativar turbo',
    'Frente',
    'Parar',
  ];

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101322),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white.withOpacity(0.8),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          'Comando por Voz',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          // Texto
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Fale um comando...',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                if (_lastWords.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      _lastWords,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                const SizedBox(height: 12),
              ],
            ),
          ),

          // Microfone
          Expanded(
            flex: 2,
            child: Align(
              alignment: const Alignment(0, -0.8),
              child: _buildMicrophoneButton(),
            ),
          ),

          // Caixa de sugestões (menor, com divisores)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Container(
              height: 200, // ajusta se quiser mais/menos alto
              decoration: BoxDecoration(
                color: const Color(0xFF1A1D2E),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Sugestões de Comandos',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Expanded(
                    child: ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      itemCount: _commands.length,
                      itemBuilder: (context, index) {
                        final label = _commands[index];
                        return GestureDetector(
                          onTap: () => _executeCommand(label),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Text(
                              label,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 19,
                              ),
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => Divider(
                        color: Colors.white.withOpacity(0.15),
                        height: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 60),
        ],
      ),
    );
  }

  Widget _buildMicrophoneButton() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 256,
          height: 256,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF2547F4).withOpacity(0.1),
          ),
        ),
        Container(
          width: 192,
          height: 192,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF2547F4).withOpacity(0.2),
          ),
        ),
        GestureDetector(
          onTap: _toggleListening,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 128,
            height: 128,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isListening ? Colors.red : const Color(0xFF2547F4),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF2547F4).withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: const Icon(
              Icons.mic,
              color: Colors.white,
              size: 48,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _toggleListening() async {
    final vm = context.read<CarViewModel>();

    if (!isListening) {
      final available = await _speech.initialize(
        onStatus: (status) {
          if (status == 'notListening') {
            setState(() => isListening = false);
          }
        },
        onError: (error) {
          setState(() => isListening = false);
          debugPrint('Erro STT: $error');
        },
      );

      if (available) {
        setState(() => isListening = true);
        _speech.listen(
          onResult: (result) {
            setState(() {
              _lastWords = result.recognizedWords;
            });
            if (result.finalResult) {
              _processVoiceCommand(_lastWords, vm);
            }
          },
          listenFor: const Duration(seconds: 8),
          pauseFor: const Duration(seconds: 4),
          localeId: 'pt_BR',
        );
      }
    } else {
      await _speech.stop();
      setState(() => isListening = false);
    }
  }

  void _executeCommand(String command) {
    final vm = context.read<CarViewModel>();
    _processVoiceCommand(command, vm);
    setState(() {
      _lastWords = command;
    });
  }

  void _processVoiceCommand(String text, CarViewModel vm) {
    final normalized = text.toLowerCase();

    if (normalized.contains('desligar luz')) {
      vm.toggleLuz(false);
    } else if (normalized.contains('desativar modo furtivo')) {
      vm.toggleStealth(false);
    } else if (normalized.contains('desativar turbo')) {
      vm.toggleTurbo(false);
    } else if (normalized.contains('ligar luz')) {
      vm.toggleLuz(true);
    } else if (normalized.contains('ativar modo furtivo')) {
      vm.toggleStealth(true);
    } else if (normalized.contains('modo turbo') ||
        normalized.contains('ativar turbo')) {
      vm.toggleTurbo(true);
    } else if (normalized.contains('frente')) {
      vm.updateJoystick(0, 1);
    } else if (normalized.contains('parar')) {
      vm.updateJoystick(0, 0);
    }
  }
}