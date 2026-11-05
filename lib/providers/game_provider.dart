import 'package:flutter/foundation.dart';
import '../models/game_state_model.dart';
import '../models/prize_model.dart';
import '../models/game_settings.dart';

/// Provider per la gestione dello stato del gioco della tombola
class GameProvider extends ChangeNotifier {
  int _tomboliniVinti = 0;
  int get tomboliniVinti => _tomboliniVinti;
  GameState _state = GameState.initial();
  GameSettings _settings = GameSettings.defaults;
  bool _gameStarted = false;
  bool _settingsLoaded = false;

  /// Impostazioni di gioco correnti
  GameSettings get settings => _settings;

  /// Se il tombolino è abilitato
  bool get withTombolino => _settings.withTombolino;

  /// Se la partita è iniziata
  bool get gameStarted => _gameStarted;

  /// Se le impostazioni sono state caricate
  bool get settingsLoaded => _settingsLoaded;

  /// Stato corrente del gioco
  GameState get state => _state;

  /// Carica le impostazioni salvate
  Future<void> loadSettings() async {
    if (_settingsLoaded) return;
    _settings = await GameSettings.load();
    _settingsLoaded = true;
    notifyListeners();
  }

  /// Aggiorna le impostazioni
  void updateSettings(GameSettings newSettings) {
    _settings = newSettings;
    notifyListeners();
  }

  // ==================== GETTERS ====================

  /// Verifica se un numero è stato estratto
  bool isNumberExtracted(int number) => _state.isNumberExtracted(number);

  /// Ultimi 5 numeri estratti (dal più recente)
  List<int> get lastFiveExtracted => _state.lastFiveNumbers;

  /// Premio corrente per cui si gioca
  Prize? get currentPrize => _state.currentPrize;

  /// Lista dei premi già vinti
  List<Prize> get wonPrizes => _state.wonPrizes;

  /// Lista dei premi ancora da vincere
  List<Prize> get remainingPrizes => _state.remainingPrizes;

  /// Set di tutti i numeri estratti
  Set<int> get extractedNumbers => _state.extractedNumbers;

  /// Numero totale di numeri estratti
  int get extractedCount => _state.extractedCount;

  /// Verifica se c'è un'animazione in corso
  bool get isAnimating => _state.isAnimating;

  /// Numero attualmente in animazione
  int? get animatingNumber => _state.animatingNumber;

  /// Verifica se il gioco è terminato
  bool get isGameOver => _state.isGameOver;

  // ==================== METODI ====================

  /// Estrae o rimuove un numero dal tabellone
  /// Ritorna true se il numero è stato aggiunto (nuovo), false se rimosso
  bool toggleNumber(int number) {
    if (number < 1 || number > 90) return false;

    final currentExtracted = Set<int>.from(_state.extractedNumbers);
    final currentLastFive = List<int>.from(_state.lastFiveNumbers);
    bool isNewNumber;

    if (currentExtracted.contains(number)) {
      // Rimuovi il numero
      currentExtracted.remove(number);
      currentLastFive.remove(number);
      isNewNumber = false;
    } else {
      // Aggiungi il numero
      currentExtracted.add(number);
      // Aggiungi all'inizio della lista ultimi estratti
      currentLastFive.insert(0, number);
      // Mantieni solo gli ultimi 5
      if (currentLastFive.length > 5) {
        currentLastFive.removeLast();
      }
      isNewNumber = true;
    }

    _state = _state.copyWith(
      extractedNumbers: currentExtracted,
      lastFiveNumbers: currentLastFive,
    );

    notifyListeners();
    return isNewNumber;
  }

  /// Imposta il numero in animazione
  void setAnimatingNumber(int? number) {
    if (number == null) {
      _state = _state.copyWith(clearAnimatingNumber: true);
    } else {
      _state = _state.copyWith(animatingNumber: number);
    }
    notifyListeners();
  }

  /// Passa al prossimo premio, marcando il corrente come vinto
  /// Ritorna il livello di festività del premio vinto (per il suono)
  int? nextPrize() {
    if (_state.currentPrize == null || _state.isGameOver) return null;

    final currentPrize = _state.currentPrize!;
    final festivityLevel = currentPrize.festivityLevel;

    // Marca il premio corrente come vinto
    final updatedPrizes = _state.allPrizes.map((prize) {
      if (prize.id == currentPrize.id) {
        return prize.copyWith(isWon: true);
      }
      return prize;
    }).toList();

    // Trova il prossimo premio non vinto
    Prize? nextPrize;
    for (final prize in updatedPrizes) {
      if (!prize.isWon) {
        nextPrize = prize;
        break;
      }
    }

    _state = _state.copyWith(allPrizes: updatedPrizes, currentPrize: nextPrize);

    notifyListeners();
    return festivityLevel;
  }

  /// Ottiene l'indice del premio corrente (0-based)
  /// Utile per calcolare l'intensità della festa
  int getCurrentPrizeIndex() {
    return _state.currentPrizeIndex;
  }

  /// Inizia una nuova partita con la configurazione specificata
  void startGame({required GameSettings settings}) {
    _settings = settings;
    _gameStarted = true;
    _state = GameState.initial(withTombolino: settings.withTombolino);
    _tomboliniVinti = 0;
    notifyListeners();
  }

  /// Chiamare quando viene vinto un Tombolino e si vuole continuare
  void nuovoTombolino() {
    _tomboliniVinti++;
    // Resetta solo il premio Tombolino
    final newPrizes = _state.allPrizes.map((prize) {
      if (prize.name == 'TOMBOLINO') {
        return prize.copyWith(isWon: false);
      }
      return prize;
    }).toList();
    _state = _state.copyWith(
      allPrizes: newPrizes,
      currentPrize: newPrizes.firstWhere((p) => p.name == 'TOMBOLINO'),
      extractedNumbers: {},
      lastFiveNumbers: [],
      clearAnimatingNumber: true,
    );
    notifyListeners();
  }

  /// Resetta completamente il gioco (torna alla schermata di configurazione)
  void resetGame() {
    _gameStarted = false;
    _state = GameState.initial(withTombolino: _settings.withTombolino);
    notifyListeners();
  }

  /// Resetta solo i numeri e premi mantenendo la configurazione
  void restartGame() {
    _state = GameState.initial(withTombolino: _settings.withTombolino);
    notifyListeners();
  }

  /// Resetta solo i numeri estratti (mantiene i premi)
  void resetNumbers() {
    _state = _state.copyWith(
      extractedNumbers: {},
      lastFiveNumbers: [],
      clearAnimatingNumber: true,
    );
    notifyListeners();
  }
}
