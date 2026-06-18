import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Reusable UI widgets shared across screens

// ── Glassy card container ──────────────────────────────────────────────────

class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final double opacity;
  final double radius;
  final bool hasBorder;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.opacity = 0.2,
    this.radius = 20,
    this.hasBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(opacity),
        borderRadius: BorderRadius.circular(radius),
        border: hasBorder
            ? Border.all(color: Colors.white.withOpacity(0.4), width: 1.5)
            : null,
      ),
      child: child,
    );
  }
}

// ── Bouncy back button ─────────────────────────────────────────────────────

class BackBtn extends StatelessWidget {
  const BackBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.3),
          borderRadius: BorderRadius.circular(15),
        ),
        child: const Center(
          child: Text('←', style: TextStyle(fontSize: 24, color: Colors.white)),
        ),
      ),
    );
  }
}

// ── Gradient background scaffold ───────────────────────────────────────────

class GradientScaffold extends StatelessWidget {
  final Color color1;
  final Color color2;
  final Widget child;

  const GradientScaffold({
    super.key,
    required this.color1,
    required this.color2,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [color1, color2],
          ),
        ),
        child: child,
      ),
    );
  }
}

// ── Big action button ──────────────────────────────────────────────────────

class BigButton extends StatelessWidget {
  final String label;
  final String emoji;
  final VoidCallback onTap;
  final Color? backgroundColor;
  final Color? textColor;

  const BigButton({
    super.key,
    required this.label,
    required this.emoji,
    required this.onTap,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: const [
            BoxShadow(color: Colors.black26, blurRadius: 12, offset: Offset(0, 4)),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 22)),
            const SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: textColor ?? const Color(0xFF7C3AED),
              ),
            ),
          ],
        ),
      ),
    ).animate().scale(
      begin: const Offset(0.95, 0.95),
      duration: 100.ms,
    );
  }
}

// ── Animated emoji float ───────────────────────────────────────────────────

class FloatingEmoji extends StatelessWidget {
  final String emoji;
  final double size;
  final Animation<double> animation;
  final double phase;

  const FloatingEmoji({
    super.key,
    required this.emoji,
    required this.size,
    required this.animation,
    this.phase = 0,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (_, __) {
        final offset = (animation.value + phase) % 1.0;
        return Transform.translate(
          offset: Offset(0, -offset * 8 + 4),
          child: Opacity(
            opacity: 0.25,
            child: Text(emoji, style: TextStyle(fontSize: size)),
          ),
        );
      },
    );
  }
}

// ── Show character badge ───────────────────────────────────────────────────

class ShowBadge extends StatelessWidget {
  final String emoji;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const ShowBadge({
    super.key,
    required this.emoji,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isActive
              ? Colors.white.withOpacity(0.4)
              : Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? Colors.white : Colors.transparent,
            width: 2.5,
          ),
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 32)),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: Colors.white.withOpacity(isActive ? 1 : 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
