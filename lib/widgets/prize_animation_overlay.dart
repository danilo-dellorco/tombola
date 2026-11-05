import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/prize_model.dart';

/// Overlay fullscreen per animazione premio vinto
class PrizeAnimationOverlay extends StatefulWidget {
  /// Il premio vinto
  final Prize prize;

  /// Callback quando l'animazione è completata
  final void Function(String action)? onAction;

  /// Durata totale dell'animazione in millisecondi
  final int durationMs;

  const PrizeAnimationOverlay({
    super.key,
    required this.prize,
    this.onAction,
    this.durationMs = 3000,
  });

  @override
  State<PrizeAnimationOverlay> createState() => _PrizeAnimationOverlayState();
}

class _PrizeAnimationOverlayState extends State<PrizeAnimationOverlay> {
  bool _actionDone = false;
  @override
  void initState() {
    super.initState();
    // Se non è Tombola o Tombolino, chiudi dopo la durata
    if (!_isBloccante()) {
      Future.delayed(Duration(milliseconds: widget.durationMs), () {
        if (mounted && !_actionDone) {
          widget.onAction?.call('auto');
        }
      });
    }
  }

  bool _isBloccante() =>
      widget.prize.festivityLevel == 5 || widget.prize.name == 'TOMBOLINO';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final random = Random();

    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          // Sfondo semi-trasparente con fade in
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.5,
                colors: [
                  _getPrizeColor().withValues(alpha: 0.8),
                  Colors.black.withValues(alpha: 0.9),
                ],
              ),
            ),
          ).animate().fadeIn(duration: 300.ms),

          // Coriandoli che cadono
          ...List.generate(30, (index) {
            return _ConfettiParticle(
              index: index,
              screenSize: size,
              color: _getConfettiColor(index),
              durationMs: widget.durationMs,
            );
          }),

          // Fuochi d'artificio (solo per premi alti)
          if (widget.prize.festivityLevel >= 4)
            ...List.generate(8, (index) {
              return _FireworkBurst(
                index: index,
                screenSize: size,
                delay: 200 + (index * 150),
              );
            }),

          // Contenuto centrale
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Banner "PREMIO VINTO!"
                Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: _getPrizeColor().withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: _getPrizeColor().withValues(alpha: 0.5),
                            blurRadius: 30,
                            spreadRadius: 10,
                          ),
                        ],
                      ),
                      child: Text(
                        '🎉 PREMIO VINTO! 🎉',
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 2,
                        ),
                      ),
                    )
                    .animate()
                    .fadeIn(duration: 300.ms)
                    .slideY(
                      begin: -0.5,
                      end: 0,
                      duration: 400.ms,
                      curve: Curves.elasticOut,
                    ),

                const SizedBox(height: 30),

                // Emoji premio gigante
                Text(widget.prize.emoji, style: const TextStyle(fontSize: 120))
                    .animate()
                    .scale(
                      begin: const Offset(0, 0),
                      end: const Offset(1.2, 1.2),
                      duration: 500.ms,
                      curve: Curves.elasticOut,
                    )
                    .then()
                    .scale(
                      begin: const Offset(1.2, 1.2),
                      end: const Offset(1.0, 1.0),
                      duration: 200.ms,
                    )
                    .then()
                    .shake(hz: 2, rotation: 0.05, duration: 500.ms),

                const SizedBox(height: 20),

                // Nome premio
                Text(
                      widget.prize.name,
                      style: GoogleFonts.poppins(
                        fontSize: 72,
                        fontWeight: FontWeight.w900,
                        color: _getPrizeColor(),
                        shadows: [
                          Shadow(
                            color: Colors.black.withValues(alpha: 0.5),
                            offset: const Offset(4, 4),
                            blurRadius: 10,
                          ),
                          Shadow(
                            color: _getPrizeColor().withValues(alpha: 0.5),
                            offset: const Offset(0, 0),
                            blurRadius: 30,
                          ),
                        ],
                      ),
                    )
                    .animate()
                    .fadeIn(delay: 200.ms, duration: 300.ms)
                    .scale(
                      begin: const Offset(0.5, 0.5),
                      end: const Offset(1.0, 1.0),
                      delay: 200.ms,
                      duration: 400.ms,
                      curve: Curves.elasticOut,
                    ),

                const SizedBox(height: 40),

                // Messaggio in base al livello
                Text(
                  _getPrizeMessage(),
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(delay: 600.ms, duration: 400.ms),
                // Pulsanti per Tombola o Tombolino
                if (_isBloccante())
                  Padding(
                    padding: const EdgeInsets.only(top: 32.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber.shade700,
                            foregroundColor: Colors.black,
                            textStyle: GoogleFonts.poppins(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 16,
                            ),
                          ),
                          onPressed: () {
                            setState(() => _actionDone = true);
                            widget.onAction?.call('continua');
                          },
                          child: const Text('Continua'),
                        ),
                        const SizedBox(width: 24),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade700,
                            foregroundColor: Colors.white,
                            textStyle: GoogleFonts.poppins(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 16,
                            ),
                          ),
                          onPressed: () {
                            setState(() => _actionDone = true);
                            widget.onAction?.call('termina');
                          },
                          child: const Text('Termina'),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),

          // Stelle scintillanti agli angoli
          ...List.generate(6, (index) {
            final positions = [
              Offset(size.width * 0.1, size.height * 0.2),
              Offset(size.width * 0.9, size.height * 0.15),
              Offset(size.width * 0.15, size.height * 0.8),
              Offset(size.width * 0.85, size.height * 0.75),
              Offset(size.width * 0.5, size.height * 0.1),
              Offset(size.width * 0.5, size.height * 0.9),
            ];
            return Positioned(
              left: positions[index].dx,
              top: positions[index].dy,
              child:
                  Icon(
                        Icons.star,
                        size: 30 + random.nextDouble() * 20,
                        color: Colors.amber,
                      )
                      .animate(
                        onPlay: (controller) =>
                            controller.repeat(reverse: true),
                      )
                      .fadeIn(delay: (index * 100).ms)
                      .scale(
                        begin: const Offset(0.5, 0.5),
                        end: const Offset(1.2, 1.2),
                        duration: 600.ms,
                      )
                      .rotate(begin: 0, end: 0.1, duration: 800.ms),
            );
          }),
        ],
      ),
    );
  }

  /// Colore in base al livello del premio
  Color _getPrizeColor() {
    switch (widget.prize.festivityLevel) {
      case 1:
        return Colors.green;
      case 2:
        return Colors.teal;
      case 3:
        return Colors.blue;
      case 4:
        return Colors.purple;
      case 5:
        return Colors.orange;
      case 6:
        return const Color(0xFFFFD700); // Oro per Tombola
      default:
        return Colors.amber;
    }
  }

  /// Messaggio in base al premio
  String _getPrizeMessage() {
    switch (widget.prize.festivityLevel) {
      case 1:
        return 'Complimenti! Primo premio della serata!';
      case 2:
        return 'Ottimo! La fortuna è dalla tua parte!';
      case 3:
        return 'Fantastico! Continua così!';
      case 4:
        return 'Incredibile! Quasi al traguardo!';
      case 5:
        return '🏆 TOMBOLA! 🏆\nIl vincitore assoluto!';
      case 6:
        return 'TOMBOLINO! Ci sei andato vicino!';
      default:
        return 'Premio vinto!';
    }
  }

  /// Colore coriandolo
  Color _getConfettiColor(int index) {
    final colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.yellow,
      Colors.purple,
      Colors.orange,
      Colors.pink,
      Colors.cyan,
    ];
    return colors[index % colors.length];
  }
}

/// Particella coriandolo
class _ConfettiParticle extends StatelessWidget {
  final int index;
  final Size screenSize;
  final Color color;
  final int durationMs;

  const _ConfettiParticle({
    required this.index,
    required this.screenSize,
    required this.color,
    required this.durationMs,
  });

  @override
  Widget build(BuildContext context) {
    final random = Random(index);
    final startX = random.nextDouble() * screenSize.width;
    final size = 8.0 + random.nextDouble() * 12;
    final delay = random.nextInt(500);
    final duration = 1500 + random.nextInt(1000);

    return Positioned(
      left: startX,
      top: -50,
      child:
          Container(
                width: size,
                height: size * 0.6,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(2),
                ),
              )
              .animate(delay: delay.ms)
              .moveY(
                begin: 0,
                end: screenSize.height + 100,
                duration: duration.ms,
                curve: Curves.easeIn,
              )
              .rotate(
                begin: 0,
                end: random.nextDouble() * 4 - 2,
                duration: duration.ms,
              )
              .moveX(
                begin: 0,
                end: (random.nextDouble() - 0.5) * 200,
                duration: duration.ms,
              )
              .fadeOut(delay: (duration - 300).ms, duration: 300.ms),
    );
  }
}

/// Esplosione fuochi d'artificio
class _FireworkBurst extends StatelessWidget {
  final int index;
  final Size screenSize;
  final int delay;

  const _FireworkBurst({
    required this.index,
    required this.screenSize,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    final random = Random(index + 100);
    final centerX = screenSize.width * (0.2 + random.nextDouble() * 0.6);
    final centerY = screenSize.height * (0.2 + random.nextDouble() * 0.4);

    final colors = [
      Colors.amber,
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.purple,
    ];
    final color = colors[random.nextInt(colors.length)];

    return Stack(
      children: List.generate(12, (sparkIndex) {
        final angle = (sparkIndex / 12) * 2 * pi;
        final distance = 80 + random.nextDouble() * 60;

        return Positioned(
          left: centerX,
          top: centerY,
          child:
              Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: color,
                      boxShadow: [
                        BoxShadow(
                          color: color.withValues(alpha: 0.8),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  )
                  .animate(delay: delay.ms)
                  .scale(
                    begin: const Offset(0, 0),
                    end: const Offset(1, 1),
                    duration: 100.ms,
                  )
                  .moveX(
                    begin: 0,
                    end: cos(angle) * distance,
                    duration: 400.ms,
                    curve: Curves.easeOut,
                  )
                  .moveY(
                    begin: 0,
                    end: sin(angle) * distance,
                    duration: 400.ms,
                    curve: Curves.easeOut,
                  )
                  .fadeOut(delay: 300.ms, duration: 200.ms),
        );
      }),
    );
  }
}
