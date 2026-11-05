import 'package:shared_preferences/shared_preferences.dart';

/// Impostazioni di gioco configurabili dall'utente
class GameSettings {
  /// Abilita il premio Tombolino
  final bool withTombolino;

  /// Durata animazione estrazione numero (in secondi)
  final double numberAnimationDuration;

  /// Durata animazione premio vinto (in secondi)
  final double prizeAnimationDuration;

  /// Icona/emoji del gioco
  final String gameIcon;

  /// Titolo del gioco
  final String gameTitle;

  const GameSettings({
    this.withTombolino = false,
    this.numberAnimationDuration = 2.0,
    this.prizeAnimationDuration = 3.0,
    this.gameIcon = '🎱',
    this.gameTitle = 'TOMBOLA',
  });

  /// Durata animazione numero in millisecondi
  int get numberAnimationMs => (numberAnimationDuration * 1000).round();

  /// Durata animazione premio in millisecondi
  int get prizeAnimationMs => (prizeAnimationDuration * 1000).round();

  /// Impostazioni predefinite
  static const GameSettings defaults = GameSettings();

  /// Valori minimi e massimi per le durate
  static const double minDuration = 0.5;
  static const double maxDuration = 10.0;

  /// Icone disponibili per la selezione
  static const List<String> availableIcons = [
    '🎱',
    '🎲',
    '🎯',
    '🏆',
    '🌟',
    '👑',
    '🎰',
    '🎉',
    '🎊',
    '🎁',
    '⭐',
    '🔥',
    '🍺',
  ];

  // Keys per SharedPreferences
  static const String _keyWithTombolino = 'settings_withTombolino';
  static const String _keyNumberAnimDuration = 'settings_numberAnimDuration';
  static const String _keyPrizeAnimDuration = 'settings_prizeAnimDuration';
  static const String _keyGameIcon = 'settings_gameIcon';
  static const String _keyGameTitle = 'settings_gameTitle';

  /// Salva le impostazioni in modo persistente
  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyWithTombolino, withTombolino);
    await prefs.setDouble(_keyNumberAnimDuration, numberAnimationDuration);
    await prefs.setDouble(_keyPrizeAnimDuration, prizeAnimationDuration);
    await prefs.setString(_keyGameIcon, gameIcon);
    await prefs.setString(_keyGameTitle, gameTitle);
  }

  /// Carica le impostazioni salvate
  static Future<GameSettings> load() async {
    final prefs = await SharedPreferences.getInstance();
    return GameSettings(
      withTombolino: prefs.getBool(_keyWithTombolino) ?? defaults.withTombolino,
      numberAnimationDuration:
          prefs.getDouble(_keyNumberAnimDuration) ??
          defaults.numberAnimationDuration,
      prizeAnimationDuration:
          prefs.getDouble(_keyPrizeAnimDuration) ??
          defaults.prizeAnimationDuration,
      gameIcon: prefs.getString(_keyGameIcon) ?? defaults.gameIcon,
      gameTitle: prefs.getString(_keyGameTitle) ?? defaults.gameTitle,
    );
  }

  /// Crea una copia con i valori modificati
  GameSettings copyWith({
    bool? withTombolino,
    double? numberAnimationDuration,
    double? prizeAnimationDuration,
    String? gameIcon,
    String? gameTitle,
  }) {
    return GameSettings(
      withTombolino: withTombolino ?? this.withTombolino,
      numberAnimationDuration:
          numberAnimationDuration ?? this.numberAnimationDuration,
      prizeAnimationDuration:
          prizeAnimationDuration ?? this.prizeAnimationDuration,
      gameIcon: gameIcon ?? this.gameIcon,
      gameTitle: gameTitle ?? this.gameTitle,
    );
  }

  @override
  String toString() =>
      'GameSettings(withTombolino: $withTombolino, numberAnim: ${numberAnimationDuration}s, prizeAnim: ${prizeAnimationDuration}s, icon: $gameIcon, title: $gameTitle)';
}
