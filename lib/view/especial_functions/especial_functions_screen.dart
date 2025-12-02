import 'package:flutter/material.dart';

class TelaFuncoesEspeciais extends StatefulWidget {
  @override
  _TelaFuncoesEspeciaisState createState() => _TelaFuncoesEspeciaisState();
}

class _TelaFuncoesEspeciaisState extends State<TelaFuncoesEspeciais> {
  bool luzAtivada = false;
  bool turboAtivado = true; // Iniciado como ligado (checked no HTML)
  bool stealthAtivado = false;

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
          'Funções Especiais',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0).copyWith(top: 32),
              child: Column(
                children: [
                  _buildFunctionItem(
                    icon: Icons.lightbulb,
                    label: 'Luz',
                    value: luzAtivada,
                    onChanged: (value) {
                      setState(() => luzAtivada = value);
                      _onFunctionToggle('Luz', value);
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildFunctionItem(
                    icon: Icons.bolt,
                    label: 'Turbo',
                    value: turboAtivado,
                    onChanged: (value) {
                      setState(() => turboAtivado = value);
                      _onFunctionToggle('Turbo', value);
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildFunctionItem(
                    icon: Icons.visibility_off,
                    label: 'Stealth',
                    value: stealthAtivado,
                    onChanged: (value) {
                      setState(() => stealthAtivado = value);
                      _onFunctionToggle('Stealth', value);
                    },
                  ),
                ],
              ),
            ),
          ),
          // Footer com status de conexão
          Padding(
            padding: const EdgeInsets.only(bottom: 32),
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

  // Widget de item de função com switch
  Widget _buildFunctionItem({
    required IconData icon,
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1D2D),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // Ícone à esquerda
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFF282B39),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF2547F4),
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          // Label
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          // Switch customizado
          _buildCustomSwitch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }

  // Switch customizado para corresponder ao design
  Widget _buildCustomSwitch({
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 51,
        height: 31,
        decoration: BoxDecoration(
          color: value ? const Color(0xFF2547F4) : const Color(0xFF282B39),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(2),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 27,
            height: 27,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Callback quando função é ativada/desativada
  void _onFunctionToggle(String function, bool enabled) {
    print('$function: ${enabled ? "Ativado" : "Desativado"}');
    // Aqui você pode adicionar lógica para enviar comandos ao Arduino/ESP
  }
}