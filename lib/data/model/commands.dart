class Commands {
  final int joystickX;
  final int joystickY;
  final bool luz;
  final bool turbo;
  final bool stealth;
  final bool modoAutomatico;
  final double destinoX;
  final double destinoY;
  final double distancia;

  Commands({
    required this.joystickX,
    required this.joystickY,
    required this.luz,
    required this.turbo,
    required this.stealth,
    required this.modoAutomatico,
    required this.destinoX,
    required this.destinoY,
    required this.distancia,
  });

  Map<String, dynamic> toJson() {
    return {
      'joystick_x': joystickX,
      'joystick_y': joystickY,
      'luz': luz,
      'turbo': turbo,
      'stealth': stealth,
      'modo_automatico': modoAutomatico,
      'destino_x': destinoX,
      'destino_y': destinoY,
      'distancia': distancia,
    };
  }

  factory Commands.fromMap(Map<String, dynamic> map) {

    final inputs = map['inputs'] != null
        ? Map<dynamic, dynamic>.from(map['inputs'] as Map)
        : {};

    return Commands(
      joystickX: inputs['joystick_x'] ?? 0,
      joystickY: inputs['joystick_y'] ?? 0,
      luz: inputs['luz'] ?? false,
      turbo: inputs['turbo'] ?? false,
      stealth: inputs['stealth'] ?? false,
      modoAutomatico: inputs['modo_automatico'] ?? false,

      destinoX: (inputs['destino_x'] is int)
          ? (inputs['destino_x'] as int).toDouble()
          : (inputs['destino_x'] ?? 0.0),

      destinoY: (inputs['destino_y'] is int)
          ? (inputs['destino_y'] as int).toDouble()
          : (inputs['destino_y'] ?? 0.0),

      distancia: (map['distancia'] is int)
          ? (map['distancia'] as int).toDouble()
          : (map['distancia'] ?? 0.0),
    );
  }

  // Permite atualizar só um campo mantendo os outros
  Commands copyWith({
    int? joystickX,
    int? joystickY,
    bool? luz,
    bool? turbo,
    bool? stealth,
    bool? modoAutomatico,
    double? destinoX,
    double? destinoY,
    double? distancia,
  }) {
    return Commands(
      joystickX: joystickX ?? this.joystickX,
      joystickY: joystickY ?? this.joystickY,
      luz: luz ?? this.luz,
      turbo: turbo ?? this.turbo,
      stealth: stealth ?? this.stealth,
      modoAutomatico: modoAutomatico ?? this.modoAutomatico,
      destinoX: destinoX ?? this.destinoX,
      destinoY: destinoY ?? this.destinoY,
      distancia: distancia ?? this.distancia,
    );
  }

}




