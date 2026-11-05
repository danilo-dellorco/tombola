import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/game_settings.dart';

/// Schermata delle impostazioni
class SettingsScreen extends StatefulWidget {
  final GameSettings initialSettings;
  final Function(GameSettings) onSettingsSaved;

  const SettingsScreen({
    super.key,
    required this.initialSettings,
    required this.onSettingsSaved,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late bool _withTombolino;
  late double _numberAnimationDuration;
  late double _prizeAnimationDuration;
  late String _gameIcon;
  late String _gameTitle;
  late TextEditingController _titleController;

  @override
  void initState() {
    super.initState();
    _withTombolino = widget.initialSettings.withTombolino;
    _numberAnimationDuration = widget.initialSettings.numberAnimationDuration;
    _prizeAnimationDuration = widget.initialSettings.prizeAnimationDuration;
    _gameIcon = widget.initialSettings.gameIcon;
    _gameTitle = widget.initialSettings.gameTitle;
    _titleController = TextEditingController(text: _gameTitle);
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _saveSettings() async {
    final settings = GameSettings(
      withTombolino: _withTombolino,
      numberAnimationDuration: _numberAnimationDuration,
      prizeAnimationDuration: _prizeAnimationDuration,
      gameIcon: _gameIcon,
      gameTitle: _gameTitle.isEmpty ? 'TOMBOLA' : _gameTitle,
    );
    await settings.save();
    widget.onSettingsSaved(settings);
    if (mounted) {
      Navigator.pop(context);
    }
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
        child: SafeArea(
          child: Column(
            children: [
              // Header
              _buildHeader(),

              // Contenuto scrollabile
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      _buildPersonalizationCard(),
                      const SizedBox(height: 24),
                      _buildGameOptionsCard(),
                      const SizedBox(height: 24),
                      _buildAnimationCard(),
                      const SizedBox(height: 32),
                      _buildSaveButton(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: Colors.amber),
          ),
          const SizedBox(width: 8),
          Text(
            'Impostazioni',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalizationCard() {
    return _buildCard(
      title: 'Personalizzazione',
      icon: Icons.brush_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Selezione icona
          Text(
            'Icona',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey.shade300,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: GameSettings.availableIcons.map((icon) {
              final isSelected = icon == _gameIcon;
              return GestureDetector(
                onTap: () => setState(() => _gameIcon = icon),
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.amber.withOpacity(0.3)
                        : Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? Colors.amber : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Text(icon, style: const TextStyle(fontSize: 24)),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 24),

          // Campo titolo
          Text(
            'Titolo',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey.shade300,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _titleController,
            onChanged: (value) => setState(() => _gameTitle = value),
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
            decoration: InputDecoration(
              hintText: 'TOMBOLA',
              hintStyle: GoogleFonts.poppins(color: Colors.grey.shade600),
              filled: true,
              fillColor: Colors.grey.withOpacity(0.2),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.amber, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
            textCapitalization: TextCapitalization.characters,
          ),
        ],
      ),
    );
  }

  Widget _buildGameOptionsCard() {
    return _buildCard(
      title: 'Opzioni di Gioco',
      icon: Icons.gamepad_outlined,
      child: Column(
        children: [
          // Switch Tombolino
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _withTombolino
                  ? Colors.amber.withOpacity(0.1)
                  : Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _withTombolino
                    ? Colors.amber.withOpacity(0.5)
                    : Colors.grey.withOpacity(0.3),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Text('🎰', style: TextStyle(fontSize: 22)),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tombolino',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Premio di consolazione per il secondo',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: _withTombolino,
                  onChanged: (value) => setState(() => _withTombolino = value),
                  activeColor: Colors.amber,
                  activeTrackColor: Colors.amber.withOpacity(0.3),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Info premi
          _buildPrizesInfo(),
        ],
      ),
    );
  }

  Widget _buildPrizesInfo() {
    final prizes = _withTombolino
        ? [
            '🎯 Ambo',
            '🎲 Terna',
            '🌟 Quaterna',
            '🏆 Cinquina',
            '👑 Tombola',
            '🎰 Tombolino',
          ]
        : ['🎯 Ambo', '🎲 Terna', '🌟 Quaterna', '🏆 Cinquina', '👑 Tombola'];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Premi in gioco:',
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: prizes.map((prize) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  prize,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.amber.shade200,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimationCard() {
    return _buildCard(
      title: 'Durata Animazioni',
      icon: Icons.animation,
      child: Column(
        children: [
          _buildDurationSlider(
            label: 'Estrazione Numero',
            icon: '🔢',
            value: _numberAnimationDuration,
            onChanged: (value) =>
                setState(() => _numberAnimationDuration = value),
          ),
          const SizedBox(height: 20),
          _buildDurationSlider(
            label: 'Premio Vinto',
            icon: '🏆',
            value: _prizeAnimationDuration,
            onChanged: (value) =>
                setState(() => _prizeAnimationDuration = value),
          ),
        ],
      ),
    );
  }

  Widget _buildDurationSlider({
    required String label,
    required String icon,
    required double value,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 10),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey.shade300,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${value.toStringAsFixed(1)}s',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.amber,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: Colors.amber,
            inactiveTrackColor: Colors.grey.withOpacity(0.3),
            thumbColor: Colors.amber,
            overlayColor: Colors.amber.withOpacity(0.2),
            trackHeight: 6,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
          ),
          child: Slider(
            value: value,
            min: GameSettings.minDuration,
            max: GameSettings.maxDuration,
            divisions: 19,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.amber.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.amber, size: 24),
              const SizedBox(width: 12),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _saveSettings,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.amber,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.save, size: 24),
            const SizedBox(width: 12),
            Text(
              'SALVA IMPOSTAZIONI',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
