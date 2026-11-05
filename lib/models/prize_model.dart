/// Modello per i premi della tombola
class Prize {
  final int id;
  final String name;
  final String emoji;
  final int festivityLevel; // 1-6 per intensità suono festa
  bool isWon;

  Prize({
    required this.id,
    required this.name,
    required this.emoji,
    required this.festivityLevel,
    this.isWon = false,
  });

  /// Crea una copia del premio con i valori modificati
  Prize copyWith({
    int? id,
    String? name,
    String? emoji,
    int? festivityLevel,
    bool? isWon,
  }) {
    return Prize(
      id: id ?? this.id,
      name: name ?? this.name,
      emoji: emoji ?? this.emoji,
      festivityLevel: festivityLevel ?? this.festivityLevel,
      isWon: isWon ?? this.isWon,
    );
  }

  /// Lista dei premi predefiniti della tombola
  /// Se withTombolino è true, include il Tombolino dopo la Tombola (premio di consolazione)
  static List<Prize> defaultPrizes({bool withTombolino = false}) {
    if (withTombolino) {
      return [
        Prize(id: 1, name: 'AMBO', emoji: '🎯', festivityLevel: 1),
        Prize(id: 2, name: 'TERNA', emoji: '🎲', festivityLevel: 2),
        Prize(id: 3, name: 'QUATERNA', emoji: '🌟', festivityLevel: 3),
        Prize(id: 4, name: 'CINQUINA', emoji: '🏆', festivityLevel: 4),
        Prize(id: 5, name: 'TOMBOLA', emoji: '👑', festivityLevel: 5),
        Prize(id: 6, name: 'TOMBOLINO', emoji: '🎰', festivityLevel: 6),
      ];
    }
    return [
      Prize(id: 1, name: 'AMBO', emoji: '🎯', festivityLevel: 1),
      Prize(id: 2, name: 'TERNA', emoji: '🎲', festivityLevel: 2),
      Prize(id: 3, name: 'QUATERNA', emoji: '🌟', festivityLevel: 3),
      Prize(id: 4, name: 'CINQUINA', emoji: '🏆', festivityLevel: 4),
      Prize(id: 5, name: 'TOMBOLA', emoji: '👑', festivityLevel: 5),
    ];
  }

  @override
  String toString() => 'Prize(id: $id, name: $name, isWon: $isWon)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Prize && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
