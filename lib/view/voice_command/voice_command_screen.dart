import 'package:flutter/material.dart';

class TelaComandoVoz extends StatefulWidget {
  @override
  _TelaComandoVozState createState() => _TelaComandoVozState();
}

class _TelaComandoVozState extends State<TelaComandoVoz> {
  bool isListening = false;

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
          // Área superior com texto
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
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
                const SizedBox(height: 20),
              ],
            ),
          ),
          // Área central com botão de microfone
          Expanded(
            flex: 1,
            child: Center(
              child: _buildMicrophoneButton(),
            ),
          ),
          // Área inferior com sugestões de comandos
          Expanded(
            flex: 1,
            child: Column(
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
                const SizedBox(height: 12),
                _buildCommandChips(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Botão de microfone com círculos concêntricos
  Widget _buildMicrophoneButton() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Círculo externo maior (background)
        Container(
          width: 256,
          height: 256,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF2547F4).withOpacity(0.1),
          ),
        ),
        // Círculo médio
        Container(
          width: 192,
          height: 192,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF2547F4).withOpacity(0.2),
          ),
        ),
        // Botão principal de microfone
        GestureDetector(
          onTap: _toggleListening,
          child: Container(
            width: 128,
            height: 128,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF2547F4),
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

  // Chips de sugestões de comandos
  Widget _buildCommandChips() {
    final commands = [
      'Ligar luz',
      'Ativar stealth',
      'Modo turbo',
      'Frente',
      'Parar',
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        alignment: WrapAlignment.center,
        children: commands
            .map((command) => _buildCommandChip(command))
            .toList(),
      ),
    );
  }

  // Chip individual de comando
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

  // Toggle de escuta de voz
  void _toggleListening() {
    setState(() {
      isListening = !isListening;
    });
    
    if (isListening) {
      _startListening();
    } else {
      _stopListening();
    }
  }

  // Iniciar reconhecimento de voz
  void _startListening() {
    print('Iniciando reconhecimento de voz...');
    // Aqui você integraria o pacote speech_to_text
    // Exemplo:
    // await speech.listen(onResult: (result) {
    //   _processVoiceCommand(result.recognizedWords);
    // });
  }

  // Parar reconhecimento de voz
  void _stopListening() {
    print('Parando reconhecimento de voz...');
    // await speech.stop();
  }

  // Executar comando selecionado
  void _executeCommand(String command) {
    print('Executando comando: $command');
    // Aqui você adicionaria a lógica para cada comando
    // Exemplo: enviar comando via Bluetooth para o Arduino
  }
}