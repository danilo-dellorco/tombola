import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegolamentoPremiScreen extends StatefulWidget {
  const RegolamentoPremiScreen({super.key});

  @override
  State<RegolamentoPremiScreen> createState() => _RegolamentoPremiScreenState();
}

class _RegolamentoPremiScreenState extends State<RegolamentoPremiScreen> {
  static const String _prefsKey = 'regolamento_premi';
  static const String _defaultRegolamento = '''
<b>Regolamento Premi Tombola</b>

- Ambo: 2 numeri sulla stessa fila
- Terna: 3 numeri sulla stessa fila
- Quaterna: 4 numeri sulla stessa fila
- Cinquina: 5 numeri sulla stessa fila
- Tombola: tutti i numeri di una cartella
- Tombolino: premio di consolazione dopo la Tombola (opzionale)

I premi vengono assegnati in ordine di estrazione. In caso di più vincitori, il premio viene diviso.
''';

  String _regolamento = _defaultRegolamento;
  bool _editing = false;
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadRegolamento();
  }

  Future<void> _loadRegolamento() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _regolamento = prefs.getString(_prefsKey) ?? _defaultRegolamento;
      _controller.text = _regolamento;
    });
  }

  Future<void> _saveRegolamento() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, _controller.text);
    setState(() {
      _regolamento = _controller.text;
      _editing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Regolamento premi'),
        backgroundColor: Colors.amber.shade700,
        actions: [
          if (!_editing)
            IconButton(
              icon: const Icon(Icons.edit),
              tooltip: 'Modifica',
              onPressed: () => setState(() => _editing = true),
            ),
          if (_editing)
            IconButton(
              icon: const Icon(Icons.save),
              tooltip: 'Salva',
              onPressed: _saveRegolamento,
            ),
        ],
      ),
      backgroundColor: const Color(0xFF1A1A2E),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 700),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.04),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: _editing
              ? TextField(
                  controller: _controller,
                  maxLines: 16,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    color: Colors.amber.shade900,
                  ),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Regolamento premi',
                  ),
                )
              : SingleChildScrollView(
                  child: SelectableText.rich(
                    TextSpan(
                      text: _regolamento,
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        color: Colors.amber.shade100,
                        height: 1.5,
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
