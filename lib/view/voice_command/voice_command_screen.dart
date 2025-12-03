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
              mainAxisAlignment: MainAxisAlignment.center, // antes era end
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

          // Microfone (um pouco mais pra cima)
          Expanded(
            flex: 2, // dá mais espaço pra esse bloco
            child: Align(
              alignment: const Alignment(0, -0.8), // sobe o botão
              child: _buildMicrophoneButton(),
            ),
          ),

          // Sugestões (mais perto do centro)
          Expanded(
            flex: 1,
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Sugestões de Comandos',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.15,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildCommandChips(),
                ],
              ),
            ),
          ),
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

  Widget _buildCommandChips() {
    final commands = [
      'Ligar luz',
      'Desligar luz',
      'Ativar modo furtivo',
      'Desativar modo furtivo',
      'Modo turbo',
      'Desativar turbo',
      'Frente',
      'Parar',
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        alignment: WrapAlignment.center,
        children:
        commands.map((command) => _buildCommandChip(command)).toList(),
      ),
    );
  }

  Widget _buildCommandChip(String label) {
    return GestureDetector(
      onTap: () => _executeCommand(label),
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1D2E),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _toggleListening() async {
    final vm = context.read<CarViewModel>();

    if (!isListening) {
      // iniciar
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
      // parar
      await _speech.stop();
      setState(() => isListening = false);
    }
  }

  void _executeCommand(String command) {
    print('Clique no chip: $command');
    final vm = context.read<CarViewModel>();
    _processVoiceCommand(command, vm);
    setState(() {
      _lastWords = command;
    });
  }

  void _processVoiceCommand(String text, CarViewModel vm) {
    final normalized = text.toLowerCase();
    print('Processando comando de voz: "$normalized"');

    // 1. Desligar / desativar primeiro
    if (normalized.contains('desligar luz')) {
      print('-> toggleLuz(false)');
      vm.toggleLuz(false);
    } else if (normalized.contains('desativar modo furtivo')) {
      print('-> toggleStealth(false)');
      vm.toggleStealth(false);
    } else if (normalized.contains('desativar turbo')) {
      print('-> toggleTurbo(false)');
      vm.toggleTurbo(false);

      // 2. Depois ligar / ativar
    } else if (normalized.contains('ligar luz')) {
      print('-> toggleLuz(true)');
      vm.toggleLuz(true);
    } else if (normalized.contains('ativar modo furtivo')) {
      print('-> toggleStealth(true)');
      vm.toggleStealth(true);
    } else if (normalized.contains('modo turbo') ||
        normalized.contains('ativar turbo')) {
      print('-> toggleTurbo(true)');
      vm.toggleTurbo(true);

      // 3. Movimento
    } else if (normalized.contains('frente')) {
      print('-> updateJoystick(0, 1)');
      vm.updateJoystick(0, 1);
    } else if (normalized.contains('parar')) {
      print('-> updateJoystick(0, 0)');
      vm.updateJoystick(0, 0);
    } else {
      print('Nenhum comando reconhecido para: "$normalized"');
    }
  }
}