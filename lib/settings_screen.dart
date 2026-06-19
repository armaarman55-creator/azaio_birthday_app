import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// Key used in SharedPreferences to store the path of a custom photo
/// chosen by the user. If this is null/empty, the app falls back to the
/// bundled asset at assets/images/azaio.jpg.
const String kCustomPhotoPathKey = 'custom_photo_path';

class SettingsScreen extends StatefulWidget {
  final Map<String, dynamic> theme;
  const SettingsScreen({super.key, required this.theme});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String? _customPhotoPath;
  bool _loading = true;
  String _appVersion = '';

  @override
  void initState() {
    super.initState();
    _loadPhoto();
    _loadAppInfo();
  }

  Future<void> _loadPhoto() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _customPhotoPath = prefs.getString(kCustomPhotoPathKey);
      _loading = false;
    });
  }

  Future<void> _loadAppInfo() async {
    try {
      final info = await PackageInfo.fromPlatform();
      if (mounted) {
        setState(() => _appVersion = '${info.version} (build ${info.buildNumber})');
      }
    } catch (_) {
      // Package info isn't critical — fail silently if unavailable
      if (mounted) setState(() => _appVersion = '1.0.0');
    }
  }

  Future<void> _pickNewPhoto() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1000,
      imageQuality: 85,
    );
    if (picked == null) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(kCustomPhotoPathKey, picked.path);

    setState(() => _customPhotoPath = picked.path);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: widget.theme['color2'] as Color,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          behavior: SnackBarBehavior.floating,
          content: const Text(
            '📸 Photo updated!',
            style: TextStyle(fontWeight: FontWeight.w800, color: Colors.white),
          ),
        ),
      );
    }
  }

  Future<void> _resetPhoto() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(kCustomPhotoPathKey);
    setState(() => _customPhotoPath = null);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: widget.theme['color2'] as Color,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          behavior: SnackBarBehavior.floating,
          content: const Text(
            '↩️ Reset to default photo',
            style: TextStyle(fontWeight: FontWeight.w800, color: Colors.white),
          ),
        ),
      );
    }
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
                      onTap: () => Navigator.pop(context, _customPhotoPath),
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
                      '⚙️ Settings',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: _loading
                    ? const Center(child: CircularProgressIndicator(color: Colors.white))
                    : SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(
                          parent: ClampingScrollPhysics(),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        child: Column(
                          children: [
                            _buildPhotoSection(),
                            const SizedBox(height: 24),
                            _buildAboutSection(),
                            const SizedBox(height: 24),
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

  Widget _buildPhotoSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.18),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.35), width: 1.5),
      ),
      child: Column(
        children: [
          const Text(
            'Profile Photo',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white),
          ),
          const SizedBox(height: 16),

          // Current photo preview
          Container(
            width: 130,
            height: 130,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 4),
              boxShadow: [
                BoxShadow(
                  color: (widget.theme['accent'] as Color).withOpacity(0.5),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: ClipOval(
              child: _customPhotoPath != null
                  ? Image.file(
                      File(_customPhotoPath!),
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _defaultPhotoFallback(),
                    )
                  : Image.asset(
                      'assets/images/azaio.jpg',
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _defaultPhotoFallback(),
                    ),
            ),
          ).animate().scale(begin: const Offset(0.7, 0.7), duration: 400.ms, curve: Curves.elasticOut),

          const SizedBox(height: 20),

          GestureDetector(
            onTap: _pickNewPhoto,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('📷', style: TextStyle(fontSize: 18)),
                  const SizedBox(width: 8),
                  Text(
                    'Choose New Photo',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                      color: widget.theme['color2'] as Color,
                    ),
                  ),
                ],
              ),
            ),
          ),

          if (_customPhotoPath != null) ...[
            const SizedBox(height: 10),
            GestureDetector(
              onTap: _resetPhoto,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Colors.white.withOpacity(0.4)),
                ),
                child: const Center(
                  child: Text(
                    '↩️  Reset to Default Photo',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _defaultPhotoFallback() {
    return Container(
      color: Colors.white.withOpacity(0.25),
      child: const Center(child: Text('📸', style: TextStyle(fontSize: 40))),
    );
  }

  Widget _buildAboutSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.18),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.35), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'About This App',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white),
          ),
          const SizedBox(height: 16),
          _infoRow('🎂', 'App', "Azaio's Birthday World"),
          _infoRow('👶', 'Made for', 'Azaio Ihla Saige'),
          _infoRow('📅', 'Birthday', 'June 23, 2026 — turning 4'),
          _infoRow('🔢', 'Version', _appVersion.isEmpty ? '1.0.0' : _appVersion),
          const SizedBox(height: 16),
          const Divider(color: Colors.white38),
          const SizedBox(height: 12),
          const Text(
            'Built by',
            style: TextStyle(fontSize: 12, color: Colors.white60, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          const Text(
            'Diswayne Tech Systems Pty Ltd',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
          ),
          const Text(
            '© 2026',
            style: TextStyle(fontSize: 13, color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String emoji, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 10),
          Text(
            label,
            style: const TextStyle(fontSize: 13, color: Colors.white70, fontWeight: FontWeight.w600),
          ),
          const Spacer(),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }
}