import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:math';

/// Standalone "Make a Wish" screen with a starfield and animated candle
class WishScreen extends StatefulWidget {
  final Map<String, dynamic> theme;
  const WishScreen({super.key, required this.theme});

  @override
  State<WishScreen> createState() => _WishScreenState();
}

class _WishScreenState extends State<WishScreen> with TickerProviderStateMixin {
  late ConfettiController _confetti;
  late AnimationController _flameController;
  late AnimationController _starController;
  bool _wishMade = false;
  bool _candleLit = true;
  final TextEditingController _wishController = TextEditingController();
  String? _savedWish;

  @override
  void initState() {
    super.initState();
    _confetti = ConfettiController(duration: const Duration(seconds: 5));
    _flameController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    )..repeat(reverse: true);
    _starController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _confetti.dispose();
    _flameController.dispose();
    _starController.dispose();
    _wishController.dispose();
    super.dispose();
  }

  void _makeWish() {
    if (_wishController.text.trim().isEmpty && !_candleLit) return;
    setState(() {
      _savedWish = _wishController.text.trim().isEmpty
          ? 'A magical surprise! ✨'
          : _wishController.text.trim();
      _wishMade = true;
      _candleLit = false;
    });
    _confetti.play();
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
              const Color(0xFF1a0533),
              widget.theme['color2'] as Color,
            ],
          ),
        ),
        child: Stack(
          children: [
            // Animated starfield
            ..._buildStars(),

            SafeArea(
              child: Column(
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            width: 44, height: 44,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Center(
                              child: Text('←', style: TextStyle(fontSize: 22, color: Colors.white)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          '🌠 Birthday Wish',
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white),
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          const SizedBox(height: 20),

                          // Candle
                          _buildCandle(),

                          const SizedBox(height: 32),

                          if (!_wishMade) ...[
                            const Text(
                              'Type your secret wish\nand blow out the candle! 🕯️',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.white.withOpacity(0.3)),
                              ),
                              child: TextField(
                                controller: _wishController,
                                style: const TextStyle(color: Colors.white, fontSize: 16),
                                decoration: InputDecoration(
                                  hintText: 'I wish for... (optional)',
                                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.all(18),
                                  prefixIcon: const Text('💭', style: TextStyle(fontSize: 22)),
                                  prefixIconConstraints: const BoxConstraints(
                                    minWidth: 50, minHeight: 50,
                                  ),
                                ),
                                maxLines: 3,
                                maxLength: 100,
                                buildCounter: (_, {required currentLength, required isFocused, maxLength}) =>
                                    Text('$currentLength/$maxLength',
                                        style: const TextStyle(color: Colors.white54, fontSize: 11)),
                              ),
                            ),
                            const SizedBox(height: 24),
                            GestureDetector(
                              onTap: _makeWish,
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(vertical: 18),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      widget.theme['accent'] as Color,
                                      (widget.theme['color1'] as Color),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(24),
                                  boxShadow: [
                                    BoxShadow(
                                      color: (widget.theme['accent'] as Color).withOpacity(0.5),
                                      blurRadius: 20,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                ),
                                child: const Column(
                                  children: [
                                    Text('🕯️💨', style: TextStyle(fontSize: 36)),
                                    SizedBox(height: 6),
                                    Text(
                                      'Blow out the candle!',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ).animate().shimmer(duration: 2000.ms),
                          ] else ...[
                            // Wish made!
                            Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(color: Colors.white.withOpacity(0.4), width: 2),
                              ),
                              child: Column(
                                children: [
                                  const Text('✨🌟✨', style: TextStyle(fontSize: 40)),
                                  const SizedBox(height: 12),
                                  const Text(
                                    'Your wish has been sent\nto the stars!',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Text(
                                      '"$_savedWish"',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontStyle: FontStyle.italic,
                                        color: Colors.white,
                                        height: 1.5,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  const Text(
                                    '🌙 The universe heard you,\nAzaio Ihla Saige! 🌙',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 15, color: Colors.white70),
                                  ),
                                ],
                              ),
                            ).animate().scale(
                              begin: const Offset(0.5, 0.5),
                              duration: 600.ms,
                              curve: Curves.elasticOut,
                            ),
                            const SizedBox(height: 24),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _wishMade = false;
                                  _candleLit = true;
                                  _savedWish = null;
                                  _wishController.clear();
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: Colors.white.withOpacity(0.5)),
                                ),
                                child: const Text(
                                  '🕯️ Make Another Wish',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white),
                                ),
                              ),
                            ),
                          ],

                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Confetti
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _confetti,
                blastDirectionality: BlastDirectionality.explosive,
                numberOfParticles: 50,
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

  Widget _buildCandle() {
    return AnimatedBuilder(
      animation: _flameController,
      builder: (_, __) {
        return Column(
          children: [
            // Flame (or smoke when blown out)
            if (_candleLit)
              Transform.scale(
                scale: 1.0 + _flameController.value * 0.15,
                child: Transform.rotate(
                  angle: (_flameController.value - 0.5) * 0.2,
                  child: const Text('🔥', style: TextStyle(fontSize: 50)),
                ),
              )
            else
              const Text('💨', style: TextStyle(fontSize: 40))
                  .animate()
                  .fadeIn()
                  .slideY(begin: 0.3),

            // Candle body
            Container(
              width: 40,
              height: 120,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFfde68a), Color(0xFFf59e0b)],
                ),
                borderRadius: BorderRadius.circular(8),
                boxShadow: _candleLit
                    ? [BoxShadow(color: const Color(0xFFfde68a).withOpacity(0.7), blurRadius: 20, spreadRadius: 5)]
                    : [],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('🎂', style: TextStyle(fontSize: 20)),
                  const SizedBox(height: 4),
                  Text(
                    '4',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  List<Widget> _buildStars() {
    final rng = Random(99);
    return List.generate(20, (i) {
      final x = rng.nextDouble();
      final y = rng.nextDouble() * 0.7;
      final size = 8.0 + rng.nextDouble() * 16;
      final emojis = ['⭐', '✨', '💫', '🌟'];
      return Positioned(
        left: MediaQuery.of(context).size.width * x,
        top: MediaQuery.of(context).size.height * y,
        child: AnimatedBuilder(
          animation: _starController,
          builder: (_, __) {
            final t = (_starController.value + i / 20) % 1.0;
            return Opacity(
              opacity: (sin(t * pi * 2) * 0.5 + 0.5) * 0.6,
              child: Text(emojis[i % emojis.length], style: TextStyle(fontSize: size)),
            );
          },
        ),
      );
    });
  }
}
