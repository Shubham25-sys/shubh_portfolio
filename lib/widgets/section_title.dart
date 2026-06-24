import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';

class SectionTitle extends StatefulWidget {
  final String title;
  final String subtitle;

  const SectionTitle({super.key, required this.title, required this.subtitle});

  @override
  State<SectionTitle> createState() => _SectionTitleState();
}

class _SectionTitleState extends State<SectionTitle>
    with SingleTickerProviderStateMixin {
  late final AnimationController _sparkCtrl;

  @override
  void initState() {
    super.initState();
    _sparkCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _sparkCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Animated spark bar
            SizedBox(
              width: 4,
              height: 44,
              child: AnimatedBuilder(
                animation: _sparkCtrl,
                builder: (ctx, s) => CustomPaint(
                  painter: _SparkBarPainter(
                    CurvedAnimation(
                      parent: _sparkCtrl,
                      curve: Curves.easeInOut,
                    ).value,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            ShaderMask(
              shaderCallback: (bounds) =>
                  AppColors.accentGradient.createShader(bounds),
              child: Text(
                widget.title,
                style: GoogleFonts.inter(
                  fontSize: 36,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: -1,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Text(
            widget.subtitle,
            style: GoogleFonts.inter(
              fontSize: 16,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ),
        const SizedBox(height: 52),
      ],
    )
        .animate()
        .fadeIn(duration: 600.ms, delay: 100.ms)
        .slideY(begin: 0.15, end: 0, duration: 600.ms, curve: Curves.easeOut);
  }
}

class _SparkBarPainter extends CustomPainter {
  final double t; // 0 → 1 (easeInOut)

  const _SparkBarPainter(this.t);

  @override
  void paint(Canvas canvas, Size size) {
    // Base gradient bar
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        const Radius.circular(2),
      ),
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.accentTeal, AppColors.accentBlue, AppColors.accentPurple],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height)),
    );

    // Travelling spark particle
    final sparkY = t * size.height;
    final cx = size.width / 2;

    // Outer glow
    canvas.drawCircle(
      Offset(cx, sparkY),
      5.5,
      Paint()
        ..color = AppColors.accentTeal.withValues(alpha: 0.35)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
    );

    // Bright core
    canvas.drawCircle(
      Offset(cx, sparkY),
      2.5,
      Paint()..color = Colors.white.withValues(alpha: 0.95),
    );

    // Trail above spark
    if (sparkY > 4) {
      canvas.drawLine(
        Offset(cx, sparkY - 4),
        Offset(cx, sparkY),
        Paint()
          ..color = Colors.white.withValues(alpha: 0.4)
          ..strokeWidth = 1.5
          ..strokeCap = StrokeCap.round,
      );
    }
  }

  @override
  bool shouldRepaint(_SparkBarPainter old) => old.t != t;
}
