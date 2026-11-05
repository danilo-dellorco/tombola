import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Widget che mostra il tabellone della tombola con griglia 9x10 (numeri 1-90)
class TombolaBoard extends StatelessWidget {
  /// Set dei numeri già estratti
  final Set<int> extractedNumbers;

  /// Callback quando un numero viene premuto
  final void Function(int number)? onNumberTapped;

  /// Se true, disabilita i click (es. durante animazione)
  final bool disabled;

  const TombolaBoard({
    super.key,
    required this.extractedNumbers,
    this.onNumberTapped,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calcola la dimensione ottimale delle celle mantenendo aspect ratio
        // Griglia 9 colonne x 10 righe
        const columns = 9;
        const rows = 10;
        const spacing = 4.0;
        const containerPadding = 8.0;
        const borderWidth = 2.0;

        // Sottrai padding, bordo e spacing
        final totalExtraWidth =
            (spacing * (columns - 1)) +
            (containerPadding * 2) +
            (borderWidth * 2);
        final totalExtraHeight =
            (spacing * (rows - 1)) + (containerPadding * 2) + (borderWidth * 2);

        final availableWidth = constraints.maxWidth - totalExtraWidth;
        final availableHeight = constraints.maxHeight - totalExtraHeight;

        final cellWidth = availableWidth / columns;
        final cellHeight = availableHeight / rows;

        // Usa la dimensione minore per mantenere celle quadrate
        final cellSize = (cellWidth < cellHeight ? cellWidth : cellHeight)
            .clamp(20.0, 80.0);

        // Calcola dimensione font in base alla cella
        final fontSize = cellSize * 0.45;

        return Center(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.amber.withValues(alpha: 0.3),
                width: borderWidth,
              ),
            ),
            padding: const EdgeInsets.all(containerPadding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(rows, (row) {
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: row < rows - 1 ? spacing : 0,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(columns, (col) {
                      final number = row * columns + col + 1;
                      final isExtracted = extractedNumbers.contains(number);

                      return Padding(
                        padding: EdgeInsets.only(
                          right: col < columns - 1 ? spacing : 0,
                        ),
                        child: _NumberCell(
                          number: number,
                          isExtracted: isExtracted,
                          size: cellSize,
                          fontSize: fontSize,
                          disabled: disabled,
                          onTap: () => onNumberTapped?.call(number),
                        ),
                      );
                    }),
                  ),
                );
              }),
            ),
          ),
        );
      },
    );
  }
}

/// Cella singola del tabellone con numero
class _NumberCell extends StatefulWidget {
  final int number;
  final bool isExtracted;
  final double size;
  final double fontSize;
  final bool disabled;
  final VoidCallback? onTap;

  const _NumberCell({
    required this.number,
    required this.isExtracted,
    required this.size,
    required this.fontSize,
    required this.disabled,
    this.onTap,
  });

  @override
  State<_NumberCell> createState() => _NumberCellState();
}

class _NumberCellState extends State<_NumberCell> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    // Colori in base allo stato
    final Color backgroundColor;
    final Color textColor;
    final Color borderColor;

    if (widget.isExtracted) {
      // Numero estratto - dorato brillante
      backgroundColor = const Color(0xFFFFD700); // Oro
      textColor = Colors.black;
      borderColor = const Color(0xFFB8860B); // Oro scuro
    } else if (_isHovered && !widget.disabled) {
      // Hover - evidenziato
      backgroundColor = Colors.amber.withValues(alpha: 0.3);
      textColor = Colors.white;
      borderColor = Colors.amber.withValues(alpha: 0.5);
    } else {
      // Non estratto - scuro
      backgroundColor = Colors.grey.withValues(alpha: 0.15);
      textColor = Colors.grey.shade500;
      borderColor = Colors.grey.withValues(alpha: 0.3);
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: widget.disabled
          ? SystemMouseCursors.basic
          : SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.disabled ? null : widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: borderColor,
              width: widget.isExtracted ? 2 : 1,
            ),
            boxShadow: widget.isExtracted
                ? [
                    BoxShadow(
                      color: Colors.amber.withValues(alpha: 0.5),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: Text(
              widget.number.toString(),
              style: GoogleFonts.poppins(
                fontSize: widget.fontSize,
                fontWeight: widget.isExtracted
                    ? FontWeight.w800
                    : FontWeight.w600,
                color: textColor,
                height: 1,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
