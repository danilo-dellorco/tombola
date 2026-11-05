import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

/// Servizio singleton per la gestione dell'audio
class AudioService {
  /// Ferma il suono premio
  Future<void> stopPrizeSound() async {
    try {
      await _prizePlayer.stop();
    } catch (e) {
      debugPrint('Errore stop suono premio: $e');
    }
  }

  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  final AudioPlayer _numberPlayer = AudioPlayer();
  final AudioPlayer _prizePlayer = AudioPlayer();

  bool _isInitialized = false;
  bool _isMuted = false;

  /// Inizializza il servizio audio
  Future<void> init() async {
    if (_isInitialized) return;

    try {
      // Configura i player
      await _numberPlayer.setReleaseMode(ReleaseMode.stop);
      await _prizePlayer.setReleaseMode(ReleaseMode.stop);

      // Volume predefinito
      await _numberPlayer.setVolume(0.7);
      await _prizePlayer.setVolume(1.0);

      // Su web, imposta il player mode
      if (kIsWeb) {
        await _numberPlayer.setPlayerMode(PlayerMode.lowLatency);
        await _prizePlayer.setPlayerMode(PlayerMode.lowLatency);
      }

      _isInitialized = true;
      debugPrint('AudioService inizializzato');
    } catch (e) {
      debugPrint('Errore inizializzazione AudioService: $e');
    }
  }

  /// Attiva/disattiva il muto
  bool get isMuted => _isMuted;
  set isMuted(bool value) {
    _isMuted = value;
    if (_isMuted) {
      _numberPlayer.stop();
      _prizePlayer.stop();
    }
  }

  /// Riproduce il suono di estrazione numero
  Future<void> playNumberSound() async {
    if (_isMuted) return;

    try {
      await _numberPlayer.stop();
      // Ordine preferito: Web (OGG), Windows (MP3), altri (OGG, WAV, MP3)
      List<String> audioFiles;
      if (kIsWeb) {
        audioFiles = [
          'audio/number_click.ogg',
          'audio/number_click.mp3',
          'audio/number_click.wav',
        ];
      } else if (defaultTargetPlatform == TargetPlatform.windows) {
        audioFiles = [
          'audio/number_click.mp3',
          'audio/number_click.ogg',
          'audio/number_click.wav',
        ];
      } else {
        audioFiles = [
          'audio/number_click.ogg',
          'audio/number_click.mp3',
          'audio/number_click.wav',
        ];
      }

      for (final file in audioFiles) {
        try {
          await _numberPlayer.play(AssetSource(file));
          return; // Successo, esci
        } catch (e) {
          continue; // Prova il prossimo
        }
      }
      debugPrint('Audio number_click non trovato');
    } catch (e) {
      debugPrint('Errore riproduzione suono numero: $e');
    }
  }

  /// Riproduce il suono di vittoria premio
  /// [level] va da 1 (Ambo - applauso breve) a 6 (Tombola - fanfara completa)
  Future<void> playPrizeWonSound(int level) async {
    if (_isMuted) return;

    // Limita il livello tra 1 e 6
    final safeLevel = level.clamp(1, 6);

    try {
      await _prizePlayer.stop();

      List<String> audioFiles;
      if (kIsWeb) {
        audioFiles = [
          'audio/prize_$safeLevel.ogg',
          'audio/prize_$safeLevel.mp3',
          'audio/prize_$safeLevel.wav',
          'audio/prize_win.ogg',
          'audio/prize_win.mp3',
          'audio/prize_win.wav',
          'audio/celebration.ogg',
          'audio/celebration.mp3',
          'audio/celebration.wav',
        ];
      } else if (defaultTargetPlatform == TargetPlatform.windows) {
        audioFiles = [
          'audio/prize_$safeLevel.mp3',
          'audio/prize_$safeLevel.ogg',
          'audio/prize_$safeLevel.wav',
          'audio/prize_win.mp3',
          'audio/prize_win.ogg',
          'audio/prize_win.wav',
          'audio/celebration.mp3',
          'audio/celebration.ogg',
          'audio/celebration.wav',
        ];
      } else {
        audioFiles = [
          'audio/prize_$safeLevel.ogg',
          'audio/prize_$safeLevel.mp3',
          'audio/prize_$safeLevel.wav',
          'audio/prize_win.ogg',
          'audio/prize_win.mp3',
          'audio/prize_win.wav',
          'audio/celebration.ogg',
          'audio/celebration.mp3',
          'audio/celebration.wav',
        ];
      }

      bool played = false;
      for (final file in audioFiles) {
        try {
          await _prizePlayer.play(AssetSource(file));
          played = true;
          debugPrint('Riprodotto: $file');
          break;
        } catch (e) {
          continue;
        }
      }

      if (!played) {
        debugPrint('Nessun file audio premio trovato per level $safeLevel');
      }
    } catch (e) {
      debugPrint('Errore riproduzione suono premio: $e');
    }
  }

  /// Ferma tutti i suoni in riproduzione
  Future<void> stopAll() async {
    try {
      await _numberPlayer.stop();
      await _prizePlayer.stop();
    } catch (e) {
      debugPrint('Errore stop audio: $e');
    }
  }

  /// Rilascia le risorse audio
  Future<void> dispose() async {
    try {
      await _numberPlayer.dispose();
      await _prizePlayer.dispose();
      _isInitialized = false;
      debugPrint('AudioService disposed');
    } catch (e) {
      debugPrint('Errore dispose AudioService: $e');
    }
  }
}
