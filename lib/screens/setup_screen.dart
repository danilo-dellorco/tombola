import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/game_settings.dart';
import 'settings_screen.dart';

/// Schermata iniziale semplificata con solo icona, titolo, impostazioni e nuova partita
class SetupScreen extends StatefulWidget {
  final GameSettings settings;
  final Function(GameSettings settings) onStartGame;
  final Function(GameSettings settings) onSettingsChanged;

  const SetupScreen({
    super.key,
    required this.settings,
    required this.onStartGame,
    required this.onSettingsChanged,
  });

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  late GameSettings _currentSettings;

  @override
  void initState() {
    super.initState();
    _currentSettings = widget.settings;
  }

  @override
  void didUpdateWidget(SetupScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.settings != oldWidget.settings) {
      setState(() {
        _currentSettings = widget.settings;
      });
    }
  }

  void _openSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SettingsScreen(
          initialSettings: _currentSettings,
          onSettingsSaved: (newSettings) {
            setState(() {
              _currentSettings = newSettings;
            });
            widget.onSettingsChanged(newSettings);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1A1A2E), Color(0xFF16213E), Color(0xFF0F3460)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo/Icona
              _buildIcon(),

              const SizedBox(height: 24),

              // Titolo
              _buildTitle(),

              const SizedBox(height: 80),

              // Pulsanti
              _buildButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    return Text(
      _currentSettings.gameIcon,
      style: const TextStyle(fontSize: 120),
    )
        .animate()
        .fadeIn(duration: 600.ms)
        .scale(begin: const Offset(0.5, 0.5), curve: Curves.elasticOut);
  }

  Widget _buildTitle() {
    final title = _currentSettings.gameTitle;
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: title.length > 12 ? 36 : (title.length > 8 ? 48 : 64),
        fontWeight: FontWeight.w800,
        color: Colors.amber,
        letterSpacing: title.length > 10 ? 4 : 8,
        shadows: [
          Shadow(color: Colors.amber.withOpacity(0.5), blurRadius: 20),
        ],
      ),
      textAlign: TextAlign.center,
    )
        .animate()
        .fadeIn(delay: 200.ms, duration: 600.ms)
        .slideY(begin: -0.3, curve: Curves.easeOut);
  }

  Widget _buildButtons() {
    return Column(
      children: [
        // Pulsante Nuova Partita
        _buildMainButton(
          icon: Icons.play_arrow_rounded,
          label: 'NUOVA PARTITA',
          onTap: () => widget.onStartGame(_currentSettings),
        )
            .animate()
            .fadeIn(delay: 400.ms, duration: 400.ms)
            .slideY(begin: 0.3, curve: Curves.easeOut),

        const SizedBox(height: 24),

        // Pulsante Impostazioni
        _buildSecondaryButton(
          icon: Icons.settings,
          label: 'IMPOSTAZIONI',
          onTap: _openSettings,
        )
            .animate()
            .fadeIn(delay: 500.ms, duration: 400.ms)
            .slideY(begin: 0.3, curve: Curves.easeOut),
      ],
    );
  }

  Widget _buildMainButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
            ),
            borderRadius: BorderRadius.circular(50),
            boxShadow: [
              BoxShadow(
                color: Colors.amber.withOpacity(0.4),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.black, size: 32),
              const SizedBox(width: 12),
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSecondaryButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(50),
            border: Border.all(color: Colors.amber.withOpacity(0.5), width: 2),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.amber, size: 24),
              const SizedBox(width: 10),
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.amber,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
