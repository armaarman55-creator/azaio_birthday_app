import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:async';
import 'dart:math';

/// Memory Card Matching Game — flip cards to find matching show characters!
class MemoryGameScreen extends StatefulWidget {
  final Map<String, dynamic> theme;
  const MemoryGameScreen({super.key, required this.theme});

  @override
  State<MemoryGameScreen> createState() => _MemoryGameScreenState();
}

class _MemoryGameScreenState extends State<MemoryGameScreen> {
  late ConfettiController _confetti;

  // All card emojis — each appears twice
  final List<String> _cardEmojis = [
    '🐕', '🐷', '⭐', '🎂', '🎵', '🌟', '🎀', '🦋',
  ];

  late List<String> _cards;
  late List<bool> _flipped;
  late List<bool> _matched;
  List<int> _selected = [];
  bool _locked = false;
  int _moves = 0;
  int _pairs = 0;
  bool _gameWon = false;

  @override
  void initState() {
    super.initState();
    _confetti = ConfettiController(duration: const Duration(seconds: 4));
    _initGame();
  }

  void _initGame() {
    final doubled = [..._cardEmojis, ..._cardEmojis];
    doubled.shuffle(Random());
    setState(() {
      _cards = doubled;
      _flipped = List.filled(doubled.length, false);
      _matched = List.filled(doubled.length, false);
      _selected = [];
      _locked = false;
      _moves = 0;
      _pairs = 0;
      _gameWon = false;
    });
  }

  void _flipCard(int index) {
    if (_locked || _flipped[index] || _matched[index]) return;

    setState(() {
      _flipped[index] = true;
      _selected.add(index);
    });

    if (_selected.length == 2) {
      _locked = true;
      _moves++;

      final a = _selected[0];
      final b = _selected[1];

      if (_cards[a] == _cards[b]) {
        // Match!
        setState(() {
          _matched[a] = true;
          _matched[b] = true;
          _pairs++;
          _selected = [];
          _locked = false;
        });
        if (_pairs == _cardEmojis.length) {
          setState(() => _gameWon = true);
          _confetti.play();
        }
      } else {
        // No match — flip back
        Future.delayed(const Duration(milliseconds: 900), () {
          if (mounted) {
            setState(() {
              _flipped[a] = false;
              _flipped[b] = false;
              _selected = [];
              _locked = false;
            });
          }
        });
      }
    }
  }

  @override
  void dispose() {
    _confetti.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              widget.theme['color1'] as Color,
              widget.theme['color2'] as Color,
            ],
          ),
        ),
        child: Stack(
          children: [
            SafeArea(
              child: Column(
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            width: 44, height: 44,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Center(
                              child: Text('←', style: TextStyle(fontSize: 22, color: Colors.white)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          '🃏 Memory Game!',
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: _initGame,
                          child: Container(
                            width: 44, height: 44,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Center(
                              child: Text('🔄', style: TextStyle(fontSize: 20)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Score bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _scorePill('🎯 Moves', '$_moves'),
                        _scorePill('💚 Pairs', '$_pairs/${_cardEmojis.length}'),
                        _scorePill('🌟 Stars',
                          _moves <= 12 ? '⭐⭐⭐' : _moves <= 18 ? '⭐⭐' : '⭐'),
                      ],
                    ),
                  ),

                  if (_gameWon)
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          const Text('🎉 You Won! 🎉',
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.white)),
                          Text('$_moves moves — Amazing Azaio! 🌟',
                            style: const TextStyle(fontSize: 16, color: Colors.white)),
                          const SizedBox(height: 8),
                          GestureDetector(
                            onTap: _initGame,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                '🔄 Play Again',
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  color: widget.theme['color2'] as Color,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ).animate().scale(begin: const Offset(0.5, 0.5), curve: Curves.elasticOut, duration: 600.ms),

                  // Card grid
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                        ),
                        itemCount: _cards.length,
                        itemBuilder: (_, i) => _buildCard(i),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),

            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _confetti,
                blastDirectionality: BlastDirectionality.explosive,
                numberOfParticles: 40,
                colors: const [
                  Color(0xFF7DD3F0), Color(0xFFF472B6),
                  Color(0xFFA855F7), Color(0xFFFDE68A), Colors.white,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(int i) {
    final isFlipped = _flipped[i] || _matched[i];
    final isMatched = _matched[i];

    return GestureDetector(
      onTap: () => _flipCard(i),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: isMatched
              ? Colors.green.withOpacity(0.5)
              : isFlipped
                  ? Colors.white.withOpacity(0.4)
                  : Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isMatched
                ? Colors.greenAccent
                : isFlipped
                    ? Colors.white
                    : Colors.white.withOpacity(0.3),
            width: isFlipped ? 2.5 : 1.5,
          ),
          boxShadow: isMatched
              ? [BoxShadow(color: Colors.greenAccent.withOpacity(0.4), blurRadius: 12)]
              : [],
        ),
        child: Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: isFlipped
                ? Text(_cards[i], key: ValueKey('open_$i'), style: const TextStyle(fontSize: 36))
                : Text(
                    '❓',
                    key: ValueKey('closed_$i'),
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _scorePill(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Text(label, style: const TextStyle(fontSize: 10, color: Colors.white70, fontWeight: FontWeight.w700)),
          Text(value, style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }
}
