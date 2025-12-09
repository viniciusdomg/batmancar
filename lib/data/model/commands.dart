class Commands {
  final int joystickX;
  final int joystickY;
  final bool luz;
  final bool turbo;
  final bool stealth;
  final bool ignicao;
  final bool cabine;
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
    required this.ignicao,
    required this.cabine,
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
      'ignicao': ignicao,
      'cabine': cabine,
      'modo_automatico': modoAutomatico,
      'destino/x': destinoX,
      'destino/y': destinoY,
      'distancia': distancia,
    };
  }

  factory Commands.fromMap(Map<String, dynamic> map) {

    final inputs = map['inputs'] != null
        ? Map<dynamic, dynamic>.from(map['inputs'] as Map)
        : {};

    final destino = inputs['destino'] != null
        ? Map<dynamic, dynamic>.from(inputs['destino'] as Map)
        : {};

    return Commands(
      joystickX: inputs['joystick_x'] ?? 0,
      joystickY: inputs['joystick_y'] ?? 0,
      luz: inputs['luz'] ?? false,
      turbo: inputs['turbo'] ?? false,
      stealth: inputs['stealth'] ?? false,
      ignicao: inputs['ignicao'] ?? false,
      cabine: inputs['cabine'] ?? false,
      modoAutomatico: inputs['modo_automatico'] ?? false,

      destinoX: (destino['x'] is int)
          ? (destino['x'] as int).toDouble()
          : (destino['x']?.toDouble() ?? 0.0),

      destinoY: (destino['y'] is int)
          ? (destino['y'] as int).toDouble()
          : (destino['y']?.toDouble() ?? 0.0),

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
    bool? ignicao,
    bool? cabine,
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
      ignicao: ignicao ?? this.ignicao,
      cabine: cabine ?? this.cabine,
      modoAutomatico: modoAutomatico ?? this.modoAutomatico,
      destinoX: destinoX ?? this.destinoX,
      destinoY: destinoY ?? this.destinoY,
      distancia: distancia ?? this.distancia,
    );
  }

}




