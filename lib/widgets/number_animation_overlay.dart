import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

/// Overlay fullscreen per animazione numero estratto
class NumberAnimationOverlay extends StatefulWidget {
  /// Il numero da mostrare nell'animazione
  final int number;

  /// Callback quando l'animazione è completata
  final VoidCallback? onAnimationComplete;

  /// Durata totale dell'animazione in millisecondi
  final int durationMs;

  const NumberAnimationOverlay({
    super.key,
    required this.number,
    this.onAnimationComplete,
    this.durationMs = 5000,
  });

  @override
  State<NumberAnimationOverlay> createState() => _NumberAnimationOverlayState();
}

class _NumberAnimationOverlayState extends State<NumberAnimationOverlay> {
  @override
  void initState() {
    super.initState();
    // Chiama il callback dopo la durata dell'animazione
    Future.delayed(Duration(milliseconds: widget.durationMs), () {
      if (mounted) {
        widget.onAnimationComplete?.call();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // Calcola quando iniziare il fade out (500ms prima della fine)
    final fadeOutDelay = (widget.durationMs - 500).clamp(
      500,
      widget.durationMs - 300,
    );

    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          // Sfondo semi-trasparente con fade in e fade out alla fine
          Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.black.withValues(alpha: 0.85),
              )
              .animate()
              .fadeIn(duration: 200.ms)
              .then(delay: Duration(milliseconds: fadeOutDelay - 200))
              .fadeOut(duration: 400.ms),

          // Particelle decorative
          ...List.generate(12, (index) {
            return _StarParticle(
              index: index,
              screenSize: size,
              durationMs: widget.durationMs,
            );
          }),

          // Numero centrale gigante con glow
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Glow effect dietro il numero
                Container(
                      width: 300,
                      height: 300,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.amber.withValues(alpha: 0.4),
                            blurRadius: 100,
                            spreadRadius: 50,
                          ),
                        ],
                      ),
                    )
                    .animate()
                    .scale(
                      begin: const Offset(0, 0),
                      end: const Offset(1, 1),
                      duration: 400.ms,
                      curve: Curves.easeOut,
                    )
                    .fadeIn(duration: 300.ms)
                    .then(delay: Duration(milliseconds: fadeOutDelay - 400))
                    .fadeOut(duration: 400.ms),

                // Il numero
                Text(
                      widget.number.toString(),
                      style: GoogleFonts.poppins(
                        fontSize: 220,
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFFFFD700),
                        shadows: [
                          Shadow(
                            color: Colors.black.withValues(alpha: 0.5),
                            offset: const Offset(4, 4),
                            blurRadius: 10,
                          ),
                          const Shadow(
                            color: Color(0xFFB8860B),
                            offset: Offset(2, 2),
                            blurRadius: 0,
                          ),
                        ],
                      ),
                    )
                    .animate()
                    // Scale bounce: 0 -> 1.2 -> 1.0
                    .scale(
                      begin: const Offset(0, 0),
                      end: const Offset(1.2, 1.2),
                      duration: 400.ms,
                      curve: Curves.easeOut,
                    )
                    .then()
                    .scale(
                      begin: const Offset(1.2, 1.2),
                      end: const Offset(1.0, 1.0),
                      duration: 200.ms,
                      curve: Curves.easeInOut,
                    )
                    // Leggero shake
                    .then(delay: 100.ms)
                    .shake(hz: 3, rotation: 0.02, duration: 300.ms)
                    // Fade out proprio alla fine dell'animazione
                    .then(delay: Duration(milliseconds: fadeOutDelay - 1000))
                    .fadeOut(duration: 400.ms),
              ],
            ),
          ),

          // Anelli decorativi che si espandono
          Center(child: _ExpandingRing(delay: 0)),
          Center(child: _ExpandingRing(delay: 150)),
          Center(child: _ExpandingRing(delay: 300)),
        ],
      ),
    );
  }
}

/// Particella stella decorativa
class _StarParticle extends StatelessWidget {
  final int index;
  final Size screenSize;
  final int durationMs;

  const _StarParticle({
    required this.index,
    required this.screenSize,
    required this.durationMs,
  });

  @override
  Widget build(BuildContext context) {
    final random = Random(index);
    final startX = screenSize.width / 2;
    final startY = screenSize.height / 2;

    // Direzione casuale
    final angle = (index / 12) * 2 * pi + random.nextDouble() * 0.5;
    final distance = 200 + random.nextDouble() * 300;
    final endX = startX + cos(angle) * distance;
    final endY = startY + sin(angle) * distance;

    // Dimensione casuale
    final size = 10.0 + random.nextDouble() * 20;

    // Delay casuale
    final delay = 200 + random.nextInt(300);

    return Positioned(
      left: startX - size / 2,
      top: startY - size / 2,
      child:
          Icon(
                Icons.star,
                size: size,
                color: Colors.amber.withValues(alpha: 0.8),
              )
              .animate(delay: delay.ms)
              .fadeIn(duration: 100.ms)
              .scale(
                begin: const Offset(0, 0),
                end: const Offset(1, 1),
                duration: 200.ms,
              )
              .moveX(
                begin: 0,
                end: endX - startX,
                duration: 800.ms,
                curve: Curves.easeOut,
              )
              .moveY(
                begin: 0,
                end: endY - startY,
                duration: 800.ms,
                curve: Curves.easeOut,
              )
              .fadeOut(delay: 400.ms, duration: 400.ms),
    );
  }
}

/// Anello che si espande dal centro
class _ExpandingRing extends StatelessWidget {
  final int delay;

  const _ExpandingRing({required this.delay});

  @override
  Widget build(BuildContext context) {
    return Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.amber.withValues(alpha: 0.6),
              width: 3,
            ),
          ),
        )
        .animate(delay: delay.ms)
        .scale(
          begin: const Offset(0.5, 0.5),
          end: const Offset(4, 4),
          duration: 800.ms,
          curve: Curves.easeOut,
        )
        .fadeOut(duration: 800.ms, curve: Curves.easeIn);
  }
}
