import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/prize_model.dart';

/// Pannello laterale con informazioni sul gioco
class InfoPanel extends StatelessWidget {
  /// Ultimi 5 numeri estratti (dal più recente)
  final List<int> lastFiveNumbers;

  /// Premio corrente per cui si gioca
  final Prize? currentPrize;

  /// Lista dei premi già vinti
  final List<Prize> wonPrizes;

  /// Numero totale di numeri estratti
  final int extractedCount;

  /// Se il gioco è terminato (Tombola vinta)
  final bool isGameOver;

  /// Callback per passare al prossimo premio
  final VoidCallback? onNextPrize;

  /// Callback per resettare il gioco
  final VoidCallback? onReset;

  final int tomboliniVinti;

  const InfoPanel({
    super.key,
    required this.lastFiveNumbers,
    required this.currentPrize,
    required this.wonPrizes,
    required this.extractedCount,
    required this.isGameOver,
    required this.tomboliniVinti,
    this.onNextPrize,
    this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade900.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.amber.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Contatore numeri estratti
          _buildExtractedCounter(),

          const SizedBox(height: 20),

          // Sezione ULTIMI ESTRATTI
          _buildLastExtractedSection(),

          const SizedBox(height: 24),

          // Sezione SI GIOCA PER
          _buildCurrentPrizeSection(),

          const SizedBox(height: 24),

          // Sezione PREMI VINTI
          _buildWonPrizesSection(),

          const Spacer(),

          // Bottone PROSSIMO PREMIO
          _buildNextPrizeButton(),

          const SizedBox(height: 12),

          // Bottone RESET (piccolo)
          _buildResetButton(),
        ],
      ),
    );
  }

  /// Contatore numeri estratti
  Widget _buildExtractedCounter() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.tag, color: Colors.amber.shade300, size: 20),
          const SizedBox(width: 8),
          Text(
            'Estratti: ',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey.shade400,
            ),
          ),
          Text(
            '$extractedCount',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.amber,
            ),
          ),
          Text(
            ' / 90',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  /// Sezione ultimi 5 numeri estratti
  Widget _buildLastExtractedSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Titolo sezione
        Row(
          children: [
            Icon(Icons.history, color: Colors.amber.shade300, size: 18),
            const SizedBox(width: 8),
            Text(
              'ULTIMI ESTRATTI',
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade400,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // 5 cerchi con numeri
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(5, (index) {
            final hasNumber = index < lastFiveNumbers.length;
            final number = hasNumber ? lastFiveNumbers[index] : null;

            return _LastExtractedCircle(number: number, isFirst: index == 0);
          }),
        ),
      ],
    );
  }

  /// Sezione premio corrente
  Widget _buildCurrentPrizeSection() {
    if (isGameOver) {
      return _buildGameOverCard();
    }

    if (currentPrize == null) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.amber.shade800.withValues(alpha: 0.4),
            Colors.orange.shade900.withValues(alpha: 0.3),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.amber.withValues(alpha: 0.5),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.amber.withValues(alpha: 0.2),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          // Label
          Text(
            'SI GIOCA PER',
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.amber.shade200,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 8),

          // Emoji premio
          Text(currentPrize!.emoji, style: const TextStyle(fontSize: 40)),
          const SizedBox(height: 4),

          // Nome premio
          Text(
            currentPrize!.name,
            style: GoogleFonts.poppins(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: const Color(0xFFFFD700),
              shadows: [
                Shadow(
                  color: Colors.black.withValues(alpha: 0.5),
                  offset: const Offset(2, 2),
                  blurRadius: 4,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Card per game over
  Widget _buildGameOverCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.green.shade800.withValues(alpha: 0.4),
            Colors.teal.shade900.withValues(alpha: 0.3),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.green.withValues(alpha: 0.5),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          const Text('🎉', style: TextStyle(fontSize: 50)),
          const SizedBox(height: 8),
          Text(
            'PARTITA TERMINATA!',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Colors.green.shade300,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Sezione premi vinti
  Widget _buildWonPrizesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Titolo sezione
        Row(
          children: [
            Icon(Icons.emoji_events, color: Colors.amber.shade300, size: 18),
            const SizedBox(width: 8),
            Text(
              'PREMI VINTI',
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade400,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Contatore tombolini vinti
        if (tomboliniVinti > 0)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              children: [
                Icon(Icons.casino, color: Colors.purple.shade200, size: 18),
                const SizedBox(width: 6),
                Text(
                  'Tombolini vinti: $tomboliniVinti',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.purple.shade100,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        // Lista premi
        if (wonPrizes.isEmpty)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                'Nessun premio vinto',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          )
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: wonPrizes.map((prize) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.green.withValues(alpha: 0.5),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: Colors.green.shade400,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      prize.name,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.green.shade300,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
      ],
    );
  }

  /// Bottone prossimo premio
  Widget _buildNextPrizeButton() {
    final isDisabled = isGameOver || currentPrize == null;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      child: ElevatedButton(
        onPressed: isDisabled ? null : onNextPrize,
        style: ElevatedButton.styleFrom(
          backgroundColor: isDisabled
              ? Colors.grey.shade800
              : Colors.amber.shade700,
          foregroundColor: isDisabled ? Colors.grey.shade600 : Colors.black,
          disabledBackgroundColor: Colors.grey.shade800,
          disabledForegroundColor: Colors.grey.shade600,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: isDisabled ? 0 : 4,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(isDisabled ? Icons.block : Icons.celebration, size: 24),
            const SizedBox(width: 10),
            Text(
              isGameOver ? 'PARTITA TERMINATA' : 'PROSSIMO PREMIO',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Bottone reset piccolo
  Widget _buildResetButton() {
    return TextButton.icon(
      onPressed: onReset,
      icon: Icon(Icons.refresh, size: 18, color: Colors.grey.shade500),
      label: Text(
        'Nuova Partita',
        style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey.shade500),
      ),
    );
  }
}

/// Cerchio per numero estratto
class _LastExtractedCircle extends StatelessWidget {
  final int? number;
  final bool isFirst;

  const _LastExtractedCircle({required this.number, required this.isFirst});

  @override
  Widget build(BuildContext context) {
    final hasNumber = number != null;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: isFirst && hasNumber ? 70 : 60, // più grande
      height: isFirst && hasNumber ? 70 : 60,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: hasNumber
            ? (isFirst ? const Color(0xFFFFD700) : Colors.amber.shade600)
            : Colors.grey.shade800,
        border: Border.all(
          color: hasNumber
              ? (isFirst ? Colors.amber.shade300 : Colors.amber.shade700)
              : Colors.grey.shade700,
          width: isFirst && hasNumber ? 4 : 3, // bordo più spesso
        ),
        boxShadow: isFirst && hasNumber
            ? [
                BoxShadow(
                  color: Colors.amber.withValues(alpha: 0.5),
                  blurRadius: 18,
                  spreadRadius: 4,
                ),
              ]
            : null,
      ),
      child: Center(
        child: hasNumber
            ? Text(
                number.toString(),
                style: GoogleFonts.poppins(
                  fontSize: isFirst ? 32 : 28, // font più grande
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                ),
              )
            : Icon(Icons.remove, color: Colors.grey.shade600, size: 28),
      ),
    );
  }
}
