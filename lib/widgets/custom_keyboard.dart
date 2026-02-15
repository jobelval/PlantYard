import 'package:flutter/material.dart';

class CustomKeyboard extends StatelessWidget {
  final bool upper;
  final bool symbol;
  final bool email;
  final Function(String) onKey;
  final VoidCallback onBack;
  final VoidCallback onShift;
  final VoidCallback onSymbol;

  const CustomKeyboard({
    super.key,
    required this.upper,
    required this.symbol,
    required this.email,
    required this.onKey,
    required this.onBack,
    required this.onShift,
    required this.onSymbol,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade200,
      padding: const EdgeInsets.only(bottom: 16, top: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (symbol) ..._buildSymbols(),
          if (!symbol) ..._buildLetters(),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _btn(Icons.arrow_upward, onShift),
              const SizedBox(width: 5),
              _btnText('123', onSymbol),
              const SizedBox(width: 5),
              _btn(Icons.backspace, onBack),
              const SizedBox(width: 5),
              _btnText('Space', () => onKey(' ')),
              if (email) ...[
                const SizedBox(width: 5),
                _btnText('@', () => onKey('@')),
                const SizedBox(width: 5),
                _btnText('.com', () => onKey('.com')),
              ]
            ],
          )
        ],
      ),
    );
  }

  List<Widget> _buildLetters() {
    final List<List<String>> letters = const [
      ['q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p'],
      ['a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l'],
      ['z', 'x', 'c', 'v', 'b', 'n', 'm'],
    ];
    return letters.map((row) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: row.map((k) => _btnKey(upper ? k.toUpperCase() : k)).toList(),
      );
    }).toList();
  }

  List<Widget> _buildSymbols() {
    final List<List<String>> symbols = const [
      ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0'],
      ['@', '.', '_', '-', '+', '/', '*', '#', '%'],
    ];
    return symbols.map((row) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: row.map((k) => _btnKey(k)).toList(),
      );
    }).toList();
  }

  Widget _btnKey(String k) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
      child: ElevatedButton(
        onPressed: () => onKey(k),
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(40, 50),
          backgroundColor: const Color(0xFF2E7D32),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        child: Text(
          k,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _btn(IconData i, VoidCallback on) {
    return ElevatedButton(
      onPressed: on,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(60, 50),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
      ),
      child: Icon(i),
    );
  }

  Widget _btnText(String t, VoidCallback on) {
    return ElevatedButton(
      onPressed: on,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(60, 50),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
      ),
      child: Text(
        t,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
