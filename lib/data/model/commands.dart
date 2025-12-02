class Commands {
  final int joystickX;
  final int joystickY;
  final bool luz;
  final bool turbo;
  final bool stealth;
  final bool modoAutomatico;
  final int destinoX;
  final int destinoY;

  Commands({
    required this.joystickX,
    required this.joystickY,
    required this.luz,
    required this.turbo,
    required this.stealth,
    required this.modoAutomatico,
    required this.destinoX,
    required this.destinoY,
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
    };
  }

  factory Commands.fromMap(Map<String, dynamic> map) {

    return Commands(
      joystickX: map['joystick_x'] ?? 0,
      joystickY: map['joystick_y'] ?? 0,
      luz: map['luz'] ?? false,
      turbo: map['turbo'] ?? false,
      stealth: map['stealth'] ?? false,
      modoAutomatico: map['modo_automatico'] ?? false,
      destinoX: map['destino_x'] ?? 0,
      destinoY: map['destino_y'] ?? 0,
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
    int? destinoX,
    int? destinoY,
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
    );
  }

}




