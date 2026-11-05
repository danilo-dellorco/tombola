import 'prize_model.dart';

/// Modello per lo stato completo del gioco della tombola
class GameState {
  /// Numeri estratti (1-90)
  final Set<int> extractedNumbers;

  /// Ultimi 5 numeri estratti (in ordine dal più recente)
  final List<int> lastFiveNumbers;

  /// Premio corrente per cui si gioca
  final Prize? currentPrize;

  /// Lista di tutti i premi
  final List<Prize> allPrizes;

  /// Numero attualmente in animazione (null se nessuna animazione)
  final int? animatingNumber;

  GameState({
    Set<int>? extractedNumbers,
    List<int>? lastFiveNumbers,
    this.currentPrize,
    List<Prize>? allPrizes,
    this.animatingNumber,
  }) : extractedNumbers = extractedNumbers ?? {},
       lastFiveNumbers = lastFiveNumbers ?? [],
       allPrizes = allPrizes ?? Prize.defaultPrizes();

  /// Stato iniziale del gioco
  /// Se withTombolino è true, include il Tombolino tra i premi
  factory GameState.initial({bool withTombolino = false}) {
    final prizes = Prize.defaultPrizes(withTombolino: withTombolino);
    return GameState(
      extractedNumbers: {},
      lastFiveNumbers: [],
      currentPrize: prizes.first,
      allPrizes: prizes,
      animatingNumber: null,
    );
  }

  /// Crea una copia dello stato con i valori modificati
  GameState copyWith({
    Set<int>? extractedNumbers,
    List<int>? lastFiveNumbers,
    Prize? currentPrize,
    List<Prize>? allPrizes,
    int? animatingNumber,
    bool clearAnimatingNumber = false,
  }) {
    return GameState(
      extractedNumbers: extractedNumbers ?? this.extractedNumbers,
      lastFiveNumbers: lastFiveNumbers ?? this.lastFiveNumbers,
      currentPrize: currentPrize ?? this.currentPrize,
      allPrizes: allPrizes ?? this.allPrizes,
      animatingNumber: clearAnimatingNumber
          ? null
          : (animatingNumber ?? this.animatingNumber),
    );
  }

  /// Verifica se un numero è stato estratto
  bool isNumberExtracted(int number) => extractedNumbers.contains(number);

  /// Premi già vinti
  List<Prize> get wonPrizes => allPrizes.where((prize) => prize.isWon).toList();

  /// Premi ancora da vincere
  List<Prize> get remainingPrizes =>
      allPrizes.where((prize) => !prize.isWon).toList();

  /// Indice del premio corrente (utile per calcolare intensità festa)
  int get currentPrizeIndex {
    if (currentPrize == null) return -1;
    return allPrizes.indexWhere((p) => p.id == currentPrize!.id);
  }

  /// Verifica se il gioco è terminato (Tombola vinta)
  bool get isGameOver =>
      allPrizes.isNotEmpty && allPrizes.every((prize) => prize.isWon);

  /// Numero totale di numeri estratti
  int get extractedCount => extractedNumbers.length;

  /// Verifica se c'è un'animazione in corso
  bool get isAnimating => animatingNumber != null;

  @override
  String toString() =>
      'GameState(extracted: ${extractedNumbers.length}, currentPrize: ${currentPrize?.name})';
}
