import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:math';
import 'package:confetti/confetti.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'wish_screen.dart';
import 'memory_game.dart';
import 'sticker_book.dart';
import 'sing_along.dart';
import 'package:flutter_tts/flutter_tts.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const AzaiosBirthdayApp());
}

class AzaiosBirthdayApp extends StatelessWidget {
  const AzaiosBirthdayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Azaio's Birthday World",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Nunito',
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF7DD3F0)),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

// ─── SPLASH SCREEN ───────────────────────────────────────────────────────────

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _starController;

  @override
  void initState() {
    super.initState();
    _starController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    _starController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF7DD3F0), // Bluey sky
              Color(0xFFF472B6), // Peppa pink
              Color(0xFFA855F7), // Demon Hunter purple
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Big star burst
              AnimatedBuilder(
                animation: _starController,
                builder: (_, __) => Transform.scale(
                  scale: 1.0 + _starController.value * 0.2,
                  child: const Text('🌟', style: TextStyle(fontSize: 80)),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Azaio\'s',
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  shadows: [
                    Shadow(color: Color(0xFFA855F7), blurRadius: 20, offset: Offset(0, 4))
                  ],
                ),
              ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.3),
              const Text(
                'Birthday World! 🎉',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ).animate().fadeIn(delay: 300.ms, duration: 600.ms),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── HOME SCREEN ─────────────────────────────────────────────────────────────

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late ConfettiController _confettiController;
  late AnimationController _cakeController;
  late AnimationController _floatController;
  final DateTime _birthday = DateTime(2026, 6, 23);
  late Timer _countdownTimer;
  Duration _timeLeft = const Duration();
  int _activeTheme = 0; // 0=bluey, 1=peppa, 2=demon
  int _tapsOnCake = 0;

  final List<Map<String, dynamic>> _themes = [
    {
      'name': 'Bluey',
      'emoji': '🐕',
      'color1': const Color(0xFF7DD3F0),
      'color2': const Color(0xFF3B82F6),
      'accent': const Color(0xFFFDE68A),
      'greeting': 'Wackadoo! Happy Birthday!',
      'character': '🐶',
      'activity': 'Keepy Uppy',
    },
    {
      'name': 'Peppa Pig',
      'emoji': '🐷',
      'color1': const Color(0xFFF9A8D4),
      'color2': const Color(0xFFEC4899),
      'accent': const Color(0xFFFF6B6B),
      'greeting': 'Oink! It\'s your birthday!',
      'character': '🐽',
      'activity': 'Muddy Puddles',
    },
    {
      'name': 'Demon Hunters',
      'emoji': '⭐',
      'color1': const Color(0xFFA855F7),
      'color2': const Color(0xFF7C3AED),
      'accent': const Color(0xFFFDE68A),
      'greeting': 'You\'re a STAR, Azaio!',
      'character': '💫',
      'activity': 'K-Pop Dance',
    },
  ];

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 4));
    _cakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _updateCountdown();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) _updateCountdown();
    });
  }

  void _updateCountdown() {
    final now = DateTime.now();
    final target = DateTime(_birthday.year, _birthday.month, _birthday.day);
    setState(() {
      _timeLeft = target.isAfter(now)
          ? target.difference(now)
          : const Duration();
    });
  }

  void _tapCake() {
    _tapsOnCake++;
    _cakeController.forward(from: 0);
    if (_tapsOnCake % 3 == 0) {
      _confettiController.play();
    }
    setState(() {
      _activeTheme = (_activeTheme + 1) % 3;
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _cakeController.dispose();
    _floatController.dispose();
    _countdownTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = _themes[_activeTheme];
    final isBirthday = _timeLeft == const Duration();

    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme['color1'] as Color,
              theme['color2'] as Color,
            ],
          ),
        ),
        child: Stack(
          children: [
            // Floating stars background
            ..._buildFloatingStars(),

            SafeArea(
              child: Column(
                children: [
                  // ── TOP BAR ──────────────────────────────────────
                  _buildTopBar(theme),

                  Expanded(
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(
                        parent: ClampingScrollPhysics(),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            const SizedBox(height: 10),

                            // ── BIG GREETING ─────────────────────────
                            _buildGreeting(theme, isBirthday),

                            const SizedBox(height: 16),

                            // ── MAGIC BIRTHDAY CAKE ──────────────────
                            _buildMagicCake(theme),

                            const SizedBox(height: 16),

                            // ── COUNTDOWN ────────────────────────────
                            _buildCountdown(isBirthday),

                            const SizedBox(height: 16),

                            // ── SHOW SELECTOR ────────────────────────
                            _buildShowSelector(),

                            const SizedBox(height: 16),

                            // ── ACTIVITY CARDS ───────────────────────
                            _buildActivityCards(),

                            const SizedBox(height: 16),

                            // ── WISH MAKER ───────────────────────────
                            _buildWishMaker(theme),

                            const SizedBox(height: 24),
                          ],
                        ),
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
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                numberOfParticles: 40,
                colors: const [
                  Color(0xFF7DD3F0),
                  Color(0xFFF472B6),
                  Color(0xFFA855F7),
                  Color(0xFFFDE68A),
                  Colors.white,
                ],
                shouldLoop: false,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── FLOATING STARS ────────────────────────────────────────────────────────

  List<Widget> _buildFloatingStars() {
    final rng = Random(42);
    return List.generate(12, (i) {
      final x = rng.nextDouble();
      final y = rng.nextDouble();
      final size = 10.0 + rng.nextDouble() * 20;
      final emojis = ['⭐', '✨', '💫', '🌟'];
      return Positioned(
        left: MediaQuery.of(context).size.width * x,
        top: MediaQuery.of(context).size.height * y * 0.9,
        child: AnimatedBuilder(
          animation: _floatController,
          builder: (_, __) => Transform.translate(
            offset: Offset(0, sin(_floatController.value * pi * 2 + i) * 8),
            child: Opacity(
              opacity: 0.3,
              child: Text(
                emojis[i % emojis.length],
                style: TextStyle(fontSize: size),
              ),
            ),
          ),
        ),
      );
    });
  }

  // ─── TOP BAR ───────────────────────────────────────────────────────────────

  Widget _buildTopBar(Map<String, dynamic> theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Menu button — custom paw shape
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const FunActivitiesScreen()),
            ),
            child: Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(child: Text('🐾', style: TextStyle(fontSize: 22))),
            ),
          ),
          const Text(
            'Azaio\'s World',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
          // Gift button
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const GalleryScreen()),
            ),
            child: Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(child: Text('🎁', style: TextStyle(fontSize: 22))),
            ),
          ),
        ],
      ),
    );
  }

  // ─── GREETING ──────────────────────────────────────────────────────────────

  // ─── PHOTO AVATAR ──────────────────────────────────────────────────────────

  Widget _buildPhotoAvatar(Map<String, dynamic> theme) {
    return Container(
      width: 110,
      height: 110,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 4),
        boxShadow: [
          BoxShadow(
            color: (theme['accent'] as Color).withValues(alpha: 0.6),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipOval(
        child: Image.asset(
          'assets/images/azaio.jpg',
          fit: BoxFit.cover,
          // Falls back to a friendly placeholder if the photo hasn't been
          // added yet, so the app never crashes — just shows this instead.
          errorBuilder: (context, error, stackTrace) => Container(
            color: Colors.white.withValues(alpha: 0.25),
            child: const Center(
              child: Text('📸', style: TextStyle(fontSize: 40)),
            ),
          ),
        ),
      ),
    ).animate().scale(
      begin: const Offset(0.5, 0.5),
      duration: 600.ms,
      curve: Curves.elasticOut,
    );
  }

  Widget _buildGreeting(Map<String, dynamic> theme, bool isBirthday) {
    return Column(
      children: [
        _buildPhotoAvatar(theme),
        const SizedBox(height: 16),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          child: Text(
            key: ValueKey(_activeTheme),
            isBirthday ? '🎂 HAPPY BIRTHDAY! 🎂' : theme['greeting'],
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              shadows: [
                Shadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 3))
              ],
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Azaio Ihla Saige turns 4! 🌟',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.white.withValues(alpha: 0.9),
          ),
        ),
      ],
    );
  }

  // ─── MAGIC CAKE ────────────────────────────────────────────────────────────

  Widget _buildMagicCake(Map<String, dynamic> theme) {
    return GestureDetector(
      onTap: _tapCake,
      child: AnimatedBuilder(
        animation: _cakeController,
        builder: (_, __) {
          final shake = sin(_cakeController.value * pi * 6) * 12;
          return Transform.translate(
            offset: Offset(shake, 0),
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.25),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: (theme['accent'] as Color).withValues(alpha: 0.5),
                    blurRadius: 30,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Text(
                      key: ValueKey(_activeTheme),
                      _activeTheme == 0
                          ? '🐕'
                          : _activeTheme == 1
                              ? '🐷'
                              : '⭐',
                      style: const TextStyle(fontSize: 60),
                    ),
                  ),
                  const Text('🎂', style: TextStyle(fontSize: 40)),
                  Text(
                    'Tap me! ($_tapsOnCake)',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    ).animate().scale(begin: const Offset(0.5, 0.5), duration: 700.ms, curve: Curves.elasticOut);
  }

  // ─── COUNTDOWN ─────────────────────────────────────────────────────────────

  Widget _buildCountdown(bool isBirthday) {
    if (isBirthday) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.25),
          borderRadius: BorderRadius.circular(24),
        ),
        child: const Text(
          '🎉 TODAY IS THE DAY! 🎉\nHAPPY 4th BIRTHDAY!',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
      );
    }

    final days = _timeLeft.inDays;
    final hours = _timeLeft.inHours % 24;
    final minutes = _timeLeft.inMinutes % 60;
    final seconds = _timeLeft.inSeconds % 60;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.4), width: 2),
      ),
      child: Column(
        children: [
          const Text(
            '⏰ Birthday Countdown!',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _countdownUnit(days.toString().padLeft(2, '0'), 'DAYS', '🌞'),
              _countdownUnit(hours.toString().padLeft(2, '0'), 'HRS', '⏰'),
              _countdownUnit(minutes.toString().padLeft(2, '0'), 'MINS', '⚡'),
              _countdownUnit(seconds.toString().padLeft(2, '0'), 'SECS', '💫'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _countdownUnit(String value, String label, String emoji) {
    return Column(
      children: [
        Container(
          width: 62,
          height: 62,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(emoji, style: const TextStyle(fontSize: 16)),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  // ─── SHOW SELECTOR ─────────────────────────────────────────────────────────

  Widget _buildShowSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4, bottom: 10),
          child: Text(
            'Pick your show! 📺',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
        ),
        Row(
          children: List.generate(3, (i) {
            final t = _themes[i];
            final isActive = _activeTheme == i;
            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _activeTheme = i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: isActive
                        ? Colors.white.withValues(alpha: 0.4)
                        : Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isActive ? Colors.white : Colors.transparent,
                      width: 2.5,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(t['emoji'], style: const TextStyle(fontSize: 32)),
                      const SizedBox(height: 4),
                      Text(
                        t['name'],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: Colors.white.withValues(alpha: isActive ? 1 : 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  // ─── ACTIVITY CARDS ────────────────────────────────────────────────────────

  Widget _buildActivityCards() {
    final activities = [
      {'emoji': '🎵', 'title': 'Dance\nParty', 'screen': 'dance'},
      {'emoji': '🎨', 'title': 'Draw &\nColour', 'screen': 'draw'},
      {'emoji': '🧠', 'title': 'Fun\nQuiz', 'screen': 'quiz'},
      {'emoji': '🃏', 'title': 'Memory\nGame', 'screen': 'memory'},
      {'emoji': '📚', 'title': 'Sticker\nBook', 'screen': 'stickers'},
      {'emoji': '🎤', 'title': 'Sing\nAlong', 'screen': 'singalong'},
      {'emoji': '🌠', 'title': 'Make a\nWish', 'screen': 'wish'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4, bottom: 10),
          child: Text(
            'Fun Activities! 🎯',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
        ),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 1.1,
          children: activities.map((a) {
            return GestureDetector(
              onTap: () {
                final screen = a['screen']!;
                if (screen == 'memory') {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (_) => MemoryGameScreen(theme: _themes[_activeTheme]),
                  ));
                } else if (screen == 'stickers') {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (_) => StickerBookScreen(theme: _themes[_activeTheme]),
                  ));
                } else if (screen == 'wish') {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (_) => WishScreen(theme: _themes[_activeTheme]),
                  ));
                } else if (screen == 'singalong') {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (_) => SingAlongScreen(theme: _themes[_activeTheme]),
                  ));
                } else {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (_) => ActivityScreen(
                      activity: a,
                      theme: _themes[_activeTheme],
                    ),
                  ));
                }
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(a['emoji']!, style: const TextStyle(fontSize: 30)),
                    const SizedBox(height: 6),
                    Text(
                      a['title']!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // ─── WISH MAKER ────────────────────────────────────────────────────────────

  Widget _buildWishMaker(Map<String, dynamic> theme) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => WishScreen(theme: _themes[_activeTheme])),
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white.withValues(alpha: 0.35),
              Colors.white.withValues(alpha: 0.15),
            ],
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: const Column(
          children: [
            Text('🌠', style: TextStyle(fontSize: 40)),
            SizedBox(height: 8),
            Text(
              'Make a Birthday Wish!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
            Text(
              'Tap to send your wish to the stars ✨',
              style: TextStyle(fontSize: 13, color: Colors.white),
            ),
          ],
        ),
      ),
    ).animate().shimmer(duration: 2000.ms, delay: 1000.ms);
  }
}

// ─── ACTIVITY SCREEN ─────────────────────────────────────────────────────────

class ActivityScreen extends StatefulWidget {
  final Map<String, String> activity;
  final Map<String, dynamic> theme;

  const ActivityScreen({
    super.key,
    required this.activity,
    required this.theme,
  });

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen>
    with TickerProviderStateMixin {
  late ConfettiController _confetti;
  int _score = 0;
  int _currentQuestion = 0;
  bool _showResult = false;
  String? _selectedAnswer;
  bool _danceActive = false;
  late AnimationController _danceController;

  final List<Map<String, dynamic>> _quizQuestions = [
    {
      'q': 'What does Bluey love to play? 🐕',
      'options': ['Keepy Uppy 🎈', 'Swimming 🏊', 'Cooking 🍳', 'Sleeping 😴'],
      'answer': 'Keepy Uppy 🎈',
    },
    {
      'q': 'What does Peppa Pig LOVE to jump in? 🐷',
      'options': ['Puddles of sand 🏖️', 'Muddy puddles 💦', 'Puddles of milk 🥛', 'Snow puddles ❄️'],
      'answer': 'Muddy puddles 💦',
    },
    {
      'q': 'How old is Azaio turning? 🎂',
      'options': ['3 🧡', '5 💙', '4 💜', '6 💛'],
      'answer': '4 💜',
    },
    {
      'q': 'Which color is Bluey? 🎨',
      'options': ['Pink 🌸', 'Blue 💙', 'Yellow 💛', 'Green 💚'],
      'answer': 'Blue 💙',
    },
    {
      'q': 'What kind of animals are in Peppa Pig? 🐾',
      'options': ['Dogs 🐕', 'Pigs 🐷', 'Cats 🐱', 'Bears 🐻'],
      'answer': 'Pigs 🐷',
    },
  ];

  final List<String> _danceEmojis = ['💃', '🕺', '🎵', '🌟', '⭐', '✨', '🎶', '🎤'];

  @override
  void initState() {
    super.initState();
    _confetti = ConfettiController(duration: const Duration(seconds: 3));
    _danceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _confetti.dispose();
    _danceController.dispose();
    super.dispose();
  }

  Widget _buildDanceParty() {
    final rng = Random();
    return Column(
      children: [
        const Text(
          '💃 Dance Party! 🕺',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Colors.white),
        ),
        const SizedBox(height: 20),
        AnimatedBuilder(
          animation: _danceController,
          builder: (_, __) => Transform.scale(
            scale: _danceActive ? (1.0 + _danceController.value * 0.3) : 1.0,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  _danceActive
                      ? _danceEmojis[rng.nextInt(_danceEmojis.length)]
                      : '🎵',
                  style: const TextStyle(fontSize: 80),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        GestureDetector(
          onTap: () {
            setState(() => _danceActive = !_danceActive);
            if (_danceActive) _confetti.play();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              _danceActive ? '⏹ Stop Dancing' : '▶ Start Dance Party!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: widget.theme['color2'] as Color,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        if (_danceActive) ...[
          const Text(
            'Move your body! Shake it! 🌟',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: _danceEmojis.map((e) => AnimatedBuilder(
              animation: _danceController,
              builder: (_, __) => Transform.rotate(
                angle: _danceController.value * pi / 4,
                child: Text(e, style: const TextStyle(fontSize: 36)),
              ),
            )).toList(),
          ),
        ],
      ],
    );
  }

  Widget _buildQuiz() {
    if (_showResult) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🎉', style: TextStyle(fontSize: 80)),
          const SizedBox(height: 16),
          Text(
            'You got $_score out of ${_quizQuestions.length}!',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _score >= 4 ? '⭐ Super Smart! ⭐' : _score >= 2 ? '💪 Great Job!' : '🤗 Keep Playing!',
            style: const TextStyle(fontSize: 22, color: Colors.white),
          ),
          const SizedBox(height: 30),
          GestureDetector(
            onTap: () => setState(() {
              _score = 0;
              _currentQuestion = 0;
              _showResult = false;
              _selectedAnswer = null;
            }),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Text(
                '🔄 Play Again!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: widget.theme['color2'] as Color,
                ),
              ),
            ),
          ),
        ],
      );
    }

    final q = _quizQuestions[_currentQuestion];
    return Column(
      children: [
        Text(
          'Question ${_currentQuestion + 1} of ${_quizQuestions.length}',
          style: const TextStyle(fontSize: 14, color: Colors.white70),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            q['q'],
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 16),
        ...((q['options'] as List<String>).map((opt) {
          final isSelected = _selectedAnswer == opt;
          final isCorrect = _selectedAnswer != null && opt == q['answer'];
          final isWrong = isSelected && opt != q['answer'];
          return GestureDetector(
            onTap: _selectedAnswer != null
                ? null
                : () {
                    setState(() => _selectedAnswer = opt);
                    if (opt == q['answer']) {
                      _score++;
                      _confetti.play();
                    }
                    Future.delayed(const Duration(seconds: 1), () {
                      if (mounted) {
                        setState(() {
                          _selectedAnswer = null;
                          if (_currentQuestion < _quizQuestions.length - 1) {
                            _currentQuestion++;
                          } else {
                            _showResult = true;
                          }
                        });
                      }
                    });
                  },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              decoration: BoxDecoration(
                color: isCorrect
                    ? Colors.green.withValues(alpha: 0.8)
                    : isWrong
                        ? Colors.red.withValues(alpha: 0.8)
                        : Colors.white.withValues(alpha: isSelected ? 0.5 : 0.25),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isCorrect || isWrong ? Colors.white : Colors.white30,
                  width: 2,
                ),
              ),
              child: Text(
                opt,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          );
        })),
      ],
    );
  }

  Widget _buildDraw() {
    return DrawScreen(theme: widget.theme);
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Center(child: Text('←', style: TextStyle(fontSize: 22, color: Colors.white))),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '${widget.activity['emoji']} ${widget.activity['title']}',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: widget.activity['screen'] == 'dance'
                          ? SingleChildScrollView(child: _buildDanceParty())
                          : widget.activity['screen'] == 'quiz'
                              ? SingleChildScrollView(child: _buildQuiz())
                              : _buildDraw(),
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _confetti,
                blastDirectionality: BlastDirectionality.explosive,
                numberOfParticles: 30,
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
}

// ─── DRAW SCREEN ─────────────────────────────────────────────────────────────

class DrawScreen extends StatefulWidget {
  final Map<String, dynamic> theme;
  const DrawScreen({super.key, required this.theme});

  @override
  State<DrawScreen> createState() => _DrawScreenState();
}

class _DrawScreenState extends State<DrawScreen> {
  final List<DrawPoint> _points = [];
  Color _selectedColor = const Color(0xFFF472B6);
  double _strokeWidth = 6.0;

  final List<Color> _colors = [
    const Color(0xFFF472B6), // pink
    const Color(0xFF7DD3F0), // blue
    const Color(0xFFA855F7), // purple
    const Color(0xFFFDE68A), // yellow
    const Color(0xFF4ADE80), // green
    const Color(0xFFFF6B6B), // red
    Colors.white,
    Colors.black,
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          '🎨 Draw & Create!',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.white),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: GestureDetector(
              onPanStart: (d) => setState(() => _points.add(
                DrawPoint(d.localPosition, _selectedColor, _strokeWidth),
              )),
              onPanUpdate: (d) => setState(() => _points.add(
                DrawPoint(d.localPosition, _selectedColor, _strokeWidth),
              )),
              onPanEnd: (_) => setState(() => _points.add(DrawPoint.separator())),
              child: Container(
                color: Colors.white.withValues(alpha: 0.9),
                child: CustomPaint(
                  painter: DrawPainter(_points),
                  size: Size.infinite,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Color palette
        SizedBox(
          height: 44,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: _colors.map((c) => GestureDetector(
              onTap: () => setState(() => _selectedColor = c),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: _selectedColor == c ? 38 : 30,
                height: _selectedColor == c ? 38 : 30,
                decoration: BoxDecoration(
                  color: c,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _selectedColor == c ? Colors.white : Colors.white54,
                    width: _selectedColor == c ? 3 : 1,
                  ),
                ),
              ),
            )).toList(),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () => setState(() => _strokeWidth = 4),
              child: _toolButton('🖊️', 'Thin', _strokeWidth == 4),
            ),
            GestureDetector(
              onTap: () => setState(() => _strokeWidth = 10),
              child: _toolButton('✏️', 'Medium', _strokeWidth == 10),
            ),
            GestureDetector(
              onTap: () => setState(() => _strokeWidth = 20),
              child: _toolButton('🖌️', 'Thick', _strokeWidth == 20),
            ),
            GestureDetector(
              onTap: () => setState(() => _points.clear()),
              child: _toolButton('🗑️', 'Clear', false),
            ),
          ],
        ),
      ],
    );
  }

  Widget _toolButton(String emoji, String label, bool active) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: active ? Colors.white.withValues(alpha: 0.4) : Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: active ? Colors.white : Colors.transparent,
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 18)),
          Text(label, style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class DrawPoint {
  final Offset? offset;
  final Color color;
  final double strokeWidth;
  final bool isSeparator;

  DrawPoint(this.offset, this.color, this.strokeWidth) : isSeparator = false;
  DrawPoint.separator()
      : offset = null,
        color = Colors.transparent,
        strokeWidth = 0,
        isSeparator = true;
}

class DrawPainter extends CustomPainter {
  final List<DrawPoint> points;
  DrawPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < points.length - 1; i++) {
      if (points[i].isSeparator || points[i + 1].isSeparator) continue;
      final paint = Paint()
        ..color = points[i].color
        ..strokeWidth = points[i].strokeWidth
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;
      canvas.drawLine(points[i].offset!, points[i + 1].offset!, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// ─── FUN ACTIVITIES SCREEN ───────────────────────────────────────────────────

class FunActivitiesScreen extends StatelessWidget {
  const FunActivitiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      {'emoji': '🐕', 'title': 'Bluey Facts', 'fact': 'Bluey is a Blue Heeler puppy who lives in Brisbane, Australia with her family!'},
      {'emoji': '🐷', 'title': 'Peppa Facts', 'fact': 'Peppa Pig LOVES jumping in muddy puddles! She lives with Mummy Pig, Daddy Pig, and her little brother George.'},
      {'emoji': '⭐', 'title': 'K-Pop Fun', 'fact': 'K-Pop Demon Hunters are three cool animated girls who sing, dance, AND fight demons with their music!'},
      {'emoji': '🎂', 'title': 'Azaio\'s Day', 'fact': 'Azaio Ihla Saige turns 4 on June 23rd, 2026! She loves amazing shows and is a superstar herself!'},
      {'emoji': '🎵', 'title': 'Sing Along', 'fact': 'Music makes everything better! Sing your favourite songs and dance around the room!'},
      {'emoji': '🌟', 'title': 'Birthday Magic', 'fact': 'Birthdays are magical! Every wish you make on your birthday candles has extra special power! ✨'},
    ];

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF7DD3F0), Color(0xFFA855F7)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 44, height: 44,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Center(child: Text('←', style: TextStyle(fontSize: 22, color: Colors.white))),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text('🐾 Fun Facts!', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white)),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  physics: const AlwaysScrollableScrollPhysics(parent: ClampingScrollPhysics()),
                  itemCount: items.length,
                  itemBuilder: (_, i) => Container(
                    margin: const EdgeInsets.only(bottom: 14),
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.4), width: 1.5),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(items[i]['emoji']!, style: const TextStyle(fontSize: 36)),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(items[i]['title']!, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white)),
                              const SizedBox(height: 4),
                              Text(items[i]['fact']!, style: TextStyle(fontSize: 13, color: Colors.white.withValues(alpha: 0.9))),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: (i * 100).ms).slideX(begin: 0.3),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── GALLERY SCREEN ──────────────────────────────────────────────────────────

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  late ConfettiController _confetti;
  late FlutterTts _tts;
  int _selectedCard = -1;
  int _speakingCard = -1;

  final List<Map<String, dynamic>> _birthdayMessages = [
    {
      'from': '🐕 Bluey',
      'message': 'Wackadoo, Azaio! You\'re the coolest 4-year-old ever! Let\'s play Keepy Uppy all day long!',
      'color': const Color(0xFF7DD3F0),
      'emoji': '🎈',
    },
    {
      'from': '🐷 Peppa',
      'message': 'Oink oink! Happy Birthday Azaio! I hope you get to jump in ALL the muddy puddles today!',
      'color': const Color(0xFFF472B6),
      'emoji': '💦',
    },
    {
      'from': '⭐ Demon Hunters',
      'message': 'You shine brighter than any star, Azaio Ihla Saige! Rock your 4th birthday like the superstar you are!',
      'color': const Color(0xFFA855F7),
      'emoji': '🎤',
    },
    {
      'from': '🌟 The Universe',
      'message': 'Four years ago, the world became a more magical place when Azaio was born. Here\'s to many more! 🌙',
      'color': const Color(0xFF6366F1),
      'emoji': '✨',
    },
  ];

  @override
  void initState() {
    super.initState();
    _confetti = ConfettiController(duration: const Duration(seconds: 3));
    _tts = FlutterTts();
    _tts.setSpeechRate(0.42); // slower, easier for a toddler to follow
    _tts.setPitch(1.15); // slightly higher, friendlier tone
    _tts.setCompletionHandler(() {
      if (mounted) setState(() => _speakingCard = -1);
    });
  }

  Future<void> _speakMessage(int index, String text) async {
    if (_speakingCard == index) {
      await _tts.stop();
      setState(() => _speakingCard = -1);
      return;
    }
    await _tts.stop();
    setState(() => _speakingCard = index);
    await _tts.speak(text);
  }

  @override
  void dispose() {
    _confetti.dispose();
    _tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF472B6), Color(0xFFA855F7)],
          ),
        ),
        child: Stack(
          children: [
            SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            width: 44, height: 44,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Center(child: Text('←', style: TextStyle(fontSize: 22, color: Colors.white))),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text('🎁 Birthday Messages!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white)),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Text(
                      'Tap a card to read your birthday message! 💌',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      physics: const AlwaysScrollableScrollPhysics(parent: ClampingScrollPhysics()),
                      itemCount: _birthdayMessages.length,
                      itemBuilder: (_, i) {
                        final msg = _birthdayMessages[i];
                        final isOpen = _selectedCard == i;
                        return GestureDetector(
                          onTap: () {
                            setState(() => _selectedCard = isOpen ? -1 : i);
                            if (!isOpen) _confetti.play();
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                            margin: const EdgeInsets.only(bottom: 14),
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: (msg['color'] as Color).withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: isOpen ? Colors.white : Colors.white.withValues(alpha: 0.3),
                                width: isOpen ? 3 : 1.5,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(msg['emoji']!, style: const TextStyle(fontSize: 32)),
                                    const SizedBox(width: 12),
                                    Text(
                                      'From: ${msg['from']}',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(isOpen ? '▲' : '▼', style: const TextStyle(color: Colors.white, fontSize: 16)),
                                  ],
                                ),
                                if (isOpen) ...[
                                  const SizedBox(height: 12),
                                  const Divider(color: Colors.white54),
                                  const SizedBox(height: 8),
                                  Text(
                                    msg['message']!,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      height: 1.5,
                                    ),
                                  ),
                                  const SizedBox(height: 14),
                                  GestureDetector(
                                    onTap: () => _speakMessage(i, msg['message']!),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(alpha: 0.25),
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            _speakingCard == i ? '⏹' : '🔊',
                                            style: const TextStyle(fontSize: 18),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            _speakingCard == i ? 'Stop' : 'Listen to this!',
                                            style: const TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w800,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ).animate().fadeIn(delay: (i * 100).ms).slideX(begin: -0.2),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _confetti,
                blastDirectionality: BlastDirectionality.explosive,
                numberOfParticles: 30,
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
}