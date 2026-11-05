import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io' show Platform;
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../providers/game_provider.dart';
import '../utils/audio_service.dart';
import '../widgets/info_panel.dart';
import '../widgets/number_animation_overlay.dart';
import '../widgets/prize_animation_overlay.dart';
import '../widgets/tombola_board.dart';
import '../utils/app_theme.dart';
import '../models/prize_model.dart';
import 'setup_screen.dart';

/// Schermata principale dell'applicazione Tombola
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AudioService _audioService = AudioService();
  bool _showAnimation = false;
  int? _animatingNumber;

  @override
  void initState() {
    super.initState();
    _audioService.init();
  }

  @override
  void dispose() {
    _audioService.dispose();
    super.dispose();
  }

  /// Header con titolo
  Widget _buildHeader() {
    final settings = context.read<GameProvider>().settings;

    return Row(
      children: [
        // Centro: icona + titolo
        Expanded(
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: settings.gameIcon == 'lottery.png'
                      ? Image.asset(
                          'assets/icons/lottery.png',
                          width: 56,
                          height: 56,
                        )
                      : Text(
                          settings.gameIcon,
                          style: const TextStyle(fontSize: 40),
                        ),
                ),
                const SizedBox(width: 18),
                Text(
                  settings.gameTitle,
                  style: GoogleFonts.poppins(
                    fontSize: settings.gameTitle.length > 10 ? 32 : 44,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFFFFD700),
                    letterSpacing: 2.5,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.25),
                        offset: const Offset(2, 2),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),

        // Pulsanti a destra
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () => Navigator.of(context).pushNamed('/regolamento'),
              icon: const Icon(Icons.rule, color: Colors.amber),
              tooltip: 'Regolamento premi',
            ),
            IconButton(
              onPressed: () {
                setState(() => _audioService.isMuted = !_audioService.isMuted);
              },
              icon: Icon(
                _audioService.isMuted ? Icons.volume_off : Icons.volume_up,
                color: _audioService.isMuted ? Colors.grey : Colors.amber,
              ),
              tooltip: _audioService.isMuted
                  ? 'Attiva audio'
                  : 'Disattiva audio',
            ),
            IconButton(
              onPressed: _toggleFullscreen,
              icon: const Icon(Icons.fullscreen, color: Colors.amber),
              tooltip: 'Schermo intero',
            ),
          ],
        ),
      ],
    );
  }

  /// Contenuto principale con tabellone e info panel
  Widget _buildMainContent() {
    return Consumer<GameProvider>(
      builder: (context, gameProvider, child) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 900;
            if (isWide) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 8,
                    child: TombolaBoard(
                      extractedNumbers: gameProvider.extractedNumbers,
                      onNumberTapped: _onNumberTapped,
                      disabled: _showAnimation,
                    ),
                  ),
                  const SizedBox(width: 16),
                  SizedBox(
                    width: 360,
                    child: InfoPanel(
                      lastFiveNumbers: gameProvider.lastFiveExtracted,
                      currentPrize: gameProvider.currentPrize,
                      wonPrizes: gameProvider.wonPrizes,
                      extractedCount: gameProvider.extractedCount,
                      isGameOver: gameProvider.isGameOver,
                      tomboliniVinti: gameProvider.tomboliniVinti,
                      onNextPrize: _onNextPrize,
                      onReset: _showResetDialog,
                    ),
                  ),
                ],
              );
            } else {
              return Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: TombolaBoard(
                      extractedNumbers: gameProvider.extractedNumbers,
                      onNumberTapped: _onNumberTapped,
                      disabled: _showAnimation,
                    ),
                  ),
                  SizedBox(
                    width: 360,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppTheme.darkTheme.scaffoldBackgroundColor,
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                      ),
                      child: InfoPanel(
                        lastFiveNumbers: gameProvider.lastFiveExtracted,
                        currentPrize: gameProvider.currentPrize,
                        wonPrizes: gameProvider.wonPrizes,
                        extractedCount: gameProvider.extractedCount,
                        isGameOver: gameProvider.isGameOver,
                        tomboliniVinti: gameProvider.tomboliniVinti,
                        onNextPrize: _onNextPrize,
                        onReset: _showResetDialog,
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        );
      },
    );
  }

  // Variabili per animazione premio
  bool _showPrizeAnimation = false;
  Prize? _wonPrize;

  /// Gestisce il tap su un numero del tabellone
  void _onNumberTapped(int number) {
    if (_showAnimation) return; // Ignora durante animazione

    final gameProvider = context.read<GameProvider>();
    final isNewNumber = gameProvider.toggleNumber(number);

    if (isNewNumber) {
      // Numero nuovo estratto - mostra animazione e suono
      setState(() {
        _showAnimation = true;
        _animatingNumber = number;
      });
      _audioService.playNumberSound();
    }
  }

  /// Callback quando l'animazione è completata
  void _onAnimationComplete() {
    setState(() {
      _showAnimation = false;
      _animatingNumber = null;
    });
  }

  /// Passa al prossimo premio
  void _onNextPrize() {
    final gameProvider = context.read<GameProvider>();
    final currentPrize = gameProvider.currentPrize;
    if (currentPrize == null) return;
    final wonPrize = currentPrize;
    final festivityLevel = gameProvider.nextPrize();
    if (festivityLevel != null) {
      setState(() {
        _showPrizeAnimation = true;
        _wonPrize = wonPrize;
      });
      _audioService.playPrizeWonSound(festivityLevel);
    }
  }

  /// Callback quando l'animazione premio è completata
  void _onPrizeAnimationComplete() {
    setState(() {
      _showPrizeAnimation = false;
      _wonPrize = null;
    });
  }

  /// Mostra dialog di conferma reset
  void _showResetDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey.shade900,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Opzioni Partita',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Cosa vuoi fare?',
          style: GoogleFonts.poppins(color: Colors.grey.shade300),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Annulla',
              style: GoogleFonts.poppins(color: Colors.grey),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<GameProvider>().restartGame();
            },
            child: Text(
              'Ricomincia',
              style: GoogleFonts.poppins(color: Colors.amber.shade300),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<GameProvider>().resetGame();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,
              foregroundColor: Colors.black,
            ),
            child: Text(
              'Nuova Partita',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final gameProvider = context.watch<GameProvider>();

    // Attendi caricamento impostazioni
    if (!gameProvider.settingsLoaded) {
      return const Scaffold(
        backgroundColor: Color(0xFF1A1A2E),
        body: Center(child: CircularProgressIndicator(color: Colors.amber)),
      );
    }

    // Mostra schermata di configurazione se la partita non è iniziata
    if (!gameProvider.gameStarted) {
      return SetupScreen(
        settings: gameProvider.settings,
        onStartGame: (settings) {
          context.read<GameProvider>().startGame(settings: settings);
        },
        onSettingsChanged: (settings) {
          context.read<GameProvider>().updateSettings(settings);
        },
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      body: KeyboardListener(
        focusNode: FocusNode()..requestFocus(),
        onKeyEvent: _handleKeyEvent,
        child: Stack(
          children: [
            // Sfondo con gradiente
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF1A1A2E),
                    Color(0xFF16213E),
                    Color(0xFF0F3460),
                  ],
                ),
              ),
            ),

            // Contenuto principale
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Header con titolo
                    _buildHeader(),

                    const SizedBox(height: 12),

                    // Contenuto principale: Tabellone + Info Panel
                    Expanded(child: _buildMainContent()),
                  ],
                ),
              ),
            ),

            // Overlay animazione numero
            if (_showAnimation && _animatingNumber != null)
              NumberAnimationOverlay(
                number: _animatingNumber!,
                onAnimationComplete: _onAnimationComplete,
                durationMs: gameProvider.settings.numberAnimationMs,
              ),

            // Overlay animazione premio vinto
            if (_showPrizeAnimation && _wonPrize != null)
              PrizeAnimationOverlay(
                prize: _wonPrize!,
                onAction: (action) async {
                  final gameProvider = context.read<GameProvider>();
                  // Blocca la schermata finché non si preme un pulsante
                  if (_wonPrize!.festivityLevel == 5) {
                    // Tombola: azione da utente
                    await _audioService.stopPrizeSound();
                    if (action == 'continua') {
                      // Passa a Tombolino (se abilitato)
                      gameProvider.nuovoTombolino();
                    } else if (action == 'termina') {
                      // Termina partita
                      gameProvider.resetGame();
                    }
                  } else if (_wonPrize!.name == 'TOMBOLINO') {
                    // Dopo ogni Tombolino, chiedi se continuare o terminare
                    await _audioService.stopPrizeSound();
                    if (action == 'continua') {
                      gameProvider.nuovoTombolino();
                    } else if (action == 'termina') {
                      gameProvider.resetGame();
                    }
                  }
                  _onPrizeAnimationComplete();
                },
                durationMs: gameProvider.settings.prizeAnimationMs,
              ),
          ],
        ),
      ),
    );
  }

  /// Gestisce gli eventi tastiera
  void _handleKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent) return;

    // Spazio per prossimo premio
    if (event.logicalKey == LogicalKeyboardKey.space) {
      _onNextPrize();
      return;
    }

    // F11 per fullscreen
    if (event.logicalKey == LogicalKeyboardKey.f11) {
      _toggleFullscreen();
      return;
    }

    // ESC per uscire da fullscreen
    if (event.logicalKey == LogicalKeyboardKey.escape) {
      // Gestito dal sistema
      return;
    }

    // R per reset
    if (event.logicalKey == LogicalKeyboardKey.keyR &&
        HardwareKeyboard.instance.isControlPressed) {
      _showResetDialog();
      return;
    }
  }

  /// Toggle fullscreen mode
  void _toggleFullscreen() async {
    if (Platform.isWindows) {
      // Usa un MethodChannel per richiedere fullscreen nativo su Windows
      const channel = MethodChannel('tombola/fullscreen');
      try {
        await channel.invokeMethod('toggleFullscreen');
      } catch (e) {
        debugPrint('Errore fullscreen Windows: $e');
      }
    } else {
      // Su mobile/web usa SystemChrome
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    }
  }
}
