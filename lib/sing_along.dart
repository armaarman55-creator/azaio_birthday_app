import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:math';

/// Sing Along screen — plays a downloaded song file with a simple,
/// toddler-friendly player: big play button, progress bar, restart.
///
/// HOW TO ADD THE SONG:
/// 1. Download/save your chosen song as an MP3
/// 2. Rename it to: singalong.mp3
/// 3. Place it in: assets/audio/singalong.mp3
/// 4. Run `flutter pub get` and restart the app
///
/// Until that file exists, this screen shows a friendly "no song yet"
/// state instead of crashing.
class SingAlongScreen extends StatefulWidget {
  final Map<String, dynamic> theme;
  const SingAlongScreen({super.key, required this.theme});

  @override
  State<SingAlongScreen> createState() => _SingAlongScreenState();
}

class _SingAlongScreenState extends State<SingAlongScreen>
    with SingleTickerProviderStateMixin {
  final AudioPlayer _player = AudioPlayer();
  late AnimationController _spinController;

  bool _isPlaying = false;
  bool _songMissing = false;
  bool _loading = true;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  static const String _songAsset = 'audio/singalong.mp3';

  @override
  void initState() {
    super.initState();
    _spinController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();

    _player.onDurationChanged.listen((d) {
      if (mounted) setState(() => _duration = d);
    });
    _player.onPositionChanged.listen((p) {
      if (mounted) setState(() => _position = p);
    });
    _player.onPlayerComplete.listen((_) {
      if (mounted) {
        setState(() {
          _isPlaying = false;
          _position = Duration.zero;
        });
      }
    });

    _checkSongExists();
  }

  Future<void> _checkSongExists() async {
    try {
      // Try a silent "set source" to see if the asset resolves.
      await _player.setSource(AssetSource(_songAsset));
      setState(() => _loading = false);
    } catch (e) {
      setState(() {
        _songMissing = true;
        _loading = false;
      });
    }
  }

  Future<void> _togglePlay() async {
    if (_songMissing) return;
    if (_isPlaying) {
      await _player.pause();
    } else {
      await _player.play(AssetSource(_songAsset));
    }
    setState(() => _isPlaying = !_isPlaying);
  }

  Future<void> _restart() async {
    if (_songMissing) return;
    await _player.seek(Duration.zero);
    if (!_isPlaying) {
      await _player.play(AssetSource(_songAsset));
      setState(() => _isPlaying = true);
    }
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.toString().padLeft(2, '0');
    final seconds = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    _player.dispose();
    _spinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [theme['color1'] as Color, theme['color2'] as Color],
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
                    const Text(
                      '🎤 Sing Along!',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: _loading
                    ? const Center(child: CircularProgressIndicator(color: Colors.white))
                    : _songMissing
                        ? _buildMissingSongState()
                        : _buildPlayer(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMissingSongState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('🎵', style: TextStyle(fontSize: 70)),
            const SizedBox(height: 20),
            const Text(
              'No song yet!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.white),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Text(
                'Add a song to enable this screen:\n\n'
                '1. Save your MP3 file\n'
                '2. Rename it to "singalong.mp3"\n'
                '3. Put it in: assets/audio/\n'
                '4. Run "flutter pub get"\n'
                '5. Restart the app',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.white, height: 1.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayer() {
    final progress = _duration.inMilliseconds == 0
        ? 0.0
        : _position.inMilliseconds / _duration.inMilliseconds;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Spinning music disc
          AnimatedBuilder(
            animation: _spinController,
            builder: (_, __) => Transform.rotate(
              angle: _isPlaying ? _spinController.value * 2 * pi : 0,
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.2),
                  border: Border.all(color: Colors.white, width: 4),
                  boxShadow: [
                    BoxShadow(
                      color: (widget.theme['accent'] as Color).withOpacity(0.5),
                      blurRadius: 30,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                child: const Center(child: Text('🎵', style: TextStyle(fontSize: 60))),
              ),
            ),
          ),

          const SizedBox(height: 36),

          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              backgroundColor: Colors.white.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation<Color>(widget.theme['accent'] as Color),
              minHeight: 10,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(_formatDuration(_position), style: const TextStyle(color: Colors.white70, fontSize: 12)),
              Text(_formatDuration(_duration), style: const TextStyle(color: Colors.white70, fontSize: 12)),
            ],
          ),

          const SizedBox(height: 32),

          // Controls
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: _restart,
                child: Container(
                  width: 56, height: 56,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.25),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(child: Text('🔁', style: TextStyle(fontSize: 24))),
                ),
              ),
              const SizedBox(width: 24),
              GestureDetector(
                onTap: _togglePlay,
                child: Container(
                  width: 86, height: 86,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: (widget.theme['accent'] as Color).withOpacity(0.6),
                        blurRadius: 20,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      _isPlaying ? '⏸' : '▶️',
                      style: const TextStyle(fontSize: 36),
                    ),
                  ),
                ),
              ).animate(target: _isPlaying ? 1 : 0).scale(
                begin: const Offset(1, 1),
                end: const Offset(1.08, 1.08),
                duration: 400.ms,
              ),
            ],
          ),

          const SizedBox(height: 28),
          Text(
            _isPlaying ? 'Sing along, Azaio! 🎶' : 'Tap play to start singing!',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
          ),
        ],
      ),
    );
  }
}