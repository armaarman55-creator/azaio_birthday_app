import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:math';

/// Sticker Book — tap stickers to collect them! All Azaio's fave characters.
class StickerBookScreen extends StatefulWidget {
  final Map<String, dynamic> theme;
  const StickerBookScreen({super.key, required this.theme});

  @override
  State<StickerBookScreen> createState() => _StickerBookScreenState();
}

class _StickerBookScreenState extends State<StickerBookScreen> {
  // All available stickers to collect
  final List<Map<String, dynamic>> _allStickers = [
    // Bluey stickers
    {'emoji': '🐕', 'name': 'Bluey', 'show': 'bluey', 'unlocked': false},
    {'emoji': '🦴', 'name': 'Bone', 'show': 'bluey', 'unlocked': false},
    {'emoji': '🐾', 'name': 'Paw Print', 'show': 'bluey', 'unlocked': false},
    {'emoji': '🎈', 'name': 'Balloon', 'show': 'bluey', 'unlocked': false},
    {'emoji': '🏠', 'name': 'Heeler House', 'show': 'bluey', 'unlocked': false},
    // Peppa stickers
    {'emoji': '🐷', 'name': 'Peppa', 'show': 'peppa', 'unlocked': false},
    {'emoji': '💦', 'name': 'Muddy Puddle', 'show': 'peppa', 'unlocked': false},
    {'emoji': '🐽', 'name': 'Snout', 'show': 'peppa', 'unlocked': false},
    {'emoji': '🌈', 'name': 'Rainbow', 'show': 'peppa', 'unlocked': false},
    {'emoji': '🦕', 'name': 'Mr Dinosaur', 'show': 'peppa', 'unlocked': false},
    // Demon Hunters stickers
    {'emoji': '⭐', 'name': 'Star Power', 'show': 'demon', 'unlocked': false},
    {'emoji': '🎤', 'name': 'Microphone', 'show': 'demon', 'unlocked': false},
    {'emoji': '💫', 'name': 'Sparkle', 'show': 'demon', 'unlocked': false},
    {'emoji': '🎵', 'name': 'Music Note', 'show': 'demon', 'unlocked': false},
    {'emoji': '👑', 'name': 'Crown', 'show': 'demon', 'unlocked': false},
    // Birthday stickers
    {'emoji': '🎂', 'name': 'Birthday Cake', 'show': 'bday', 'unlocked': false},
    {'emoji': '🎁', 'name': 'Gift', 'show': 'bday', 'unlocked': false},
    {'emoji': '🎉', 'name': 'Party Popper', 'show': 'bday', 'unlocked': false},
    {'emoji': '🌟', 'name': 'Gold Star', 'show': 'bday', 'unlocked': false},
    {'emoji': '🦋', 'name': 'Butterfly', 'show': 'bday', 'unlocked': false},
  ];

  List<Map<String, dynamic>> get _unlockedStickers =>
      _allStickers.where((s) => s['unlocked'] == true).toList();

  int get _unlockedCount => _unlockedStickers.length;
  String _selectedFilter = 'all';

  List<Map<String, dynamic>> get _filteredStickers =>
      _selectedFilter == 'all'
          ? _allStickers
          : _allStickers.where((s) => s['show'] == _selectedFilter).toList();

  void _unlockSticker(int index) {
    final sticker = _filteredStickers[index];
    if (sticker['unlocked'] == true) return;
    final realIndex = _allStickers.indexOf(sticker);
    setState(() => _allStickers[realIndex] = {...sticker, 'unlocked': true});

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: widget.theme['color2'] as Color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        content: Text(
          '${sticker['emoji']} "${sticker['name']}" sticker collected!',
          style: const TextStyle(fontWeight: FontWeight.w800, color: Colors.white),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [widget.theme['color1'] as Color, widget.theme['color2'] as Color],
          ),
        ),
        child: SafeArea(
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
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('📚 Sticker Book',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white)),
                          Text(
                            '$_unlockedCount / ${_allStickers.length} collected!',
                            style: const TextStyle(fontSize: 13, color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Progress bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: _unlockedCount / _allStickers.length,
                        backgroundColor: Colors.white.withOpacity(0.2),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          widget.theme['accent'] as Color,
                        ),
                        minHeight: 10,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _unlockedCount == _allStickers.length
                          ? '🎉 All stickers collected! You\'re a champion!'
                          : 'Tap stickers to collect them all! ✨',
                      style: const TextStyle(fontSize: 12, color: Colors.white70),
                    ),
                  ],
                ),
              ),

              // Filter tabs
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _filterTab('all', '🌟 All'),
                      _filterTab('bluey', '🐕 Bluey'),
                      _filterTab('peppa', '🐷 Peppa'),
                      _filterTab('demon', '⭐ K-Pop'),
                      _filterTab('bday', '🎂 Birthday'),
                    ],
                  ),
                ),
              ),

              // Sticker grid
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                  ),
                  itemCount: _filteredStickers.length,
                  itemBuilder: (_, i) {
                    final sticker = _filteredStickers[i];
                    final unlocked = sticker['unlocked'] == true;
                    return GestureDetector(
                      onTap: () => _unlockSticker(i),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          color: unlocked
                              ? Colors.white.withOpacity(0.35)
                              : Colors.black.withOpacity(0.25),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: unlocked ? Colors.white : Colors.white.withOpacity(0.2),
                            width: unlocked ? 2.5 : 1,
                          ),
                          boxShadow: unlocked
                              ? [BoxShadow(
                                  color: (widget.theme['accent'] as Color).withOpacity(0.3),
                                  blurRadius: 12,
                                )]
                              : [],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            unlocked
                                ? Text(sticker['emoji'], style: const TextStyle(fontSize: 36))
                                    .animate(key: ValueKey('unlocked_$i'))
                                    .scale(begin: const Offset(0.3, 0.3), duration: 400.ms, curve: Curves.elasticOut)
                                : const Text('🔒', style: TextStyle(fontSize: 28)),
                            const SizedBox(height: 4),
                            Text(
                              unlocked ? sticker['name'] : '???',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                color: Colors.white.withOpacity(unlocked ? 0.9 : 0.4),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _filterTab(String id, String label) {
    final isActive = _selectedFilter == id;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? Colors.white.withOpacity(0.4) : Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? Colors.white : Colors.transparent,
            width: 2,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: Colors.white.withOpacity(isActive ? 1 : 0.7),
          ),
        ),
      ),
    );
  }
}
