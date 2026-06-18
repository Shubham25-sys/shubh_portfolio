import 'dart:math' show Random, sin, cos, pi;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_colors.dart';
import '../data/portfolio_data.dart';
import 'resume_download_button.dart';

class HeroSection extends StatefulWidget {
  final VoidCallback onContactTap;
  final VoidCallback onProjectsTap;

  const HeroSection({
    super.key,
    required this.onContactTap,
    required this.onProjectsTap,
  });

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection> with TickerProviderStateMixin {
  late AnimationController _particleController;
  late AnimationController _orb1Controller;
  late AnimationController _orb2Controller;

  @override
  void initState() {
    super.initState();
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
    _orb1Controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: true);
    _orb2Controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _particleController.dispose();
    _orb1Controller.dispose();
    _orb2Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWide = size.width > 768;

    return Container(
      width: double.infinity,
      height: size.height,
      decoration: const BoxDecoration(gradient: AppColors.heroBg),
      child: Stack(
        children: [
          // Animated particles
          AnimatedBuilder(
            animation: _particleController,
            builder: (context, child) => CustomPaint(
              size: Size(size.width, size.height),
              painter: _ParticlePainter(_particleController.value),
            ),
          ),

          // Glowing orb top-right
          AnimatedBuilder(
            animation: _orb1Controller,
            builder: (context, child) => Positioned(
              top: -120 + (_orb1Controller.value * 40),
              right: -120 + (_orb1Controller.value * 30),
              child: Container(
                width: 500,
                height: 500,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.accentTeal.withValues(alpha: 0.12),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Glowing orb bottom-left
          AnimatedBuilder(
            animation: _orb2Controller,
            builder: (context, child) => Positioned(
              bottom: -150 + (_orb2Controller.value * 40),
              left: -150 + (_orb2Controller.value * 20),
              child: Container(
                width: 450,
                height: 450,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.accentPurple.withValues(alpha: 0.12),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Grid overlay
          CustomPaint(
            size: Size(size.width, size.height),
            painter: _GridPainter(),
          ),

          // Main content
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  isWide ? 80 : 24,
                  100,
                  isWide ? 80 : 24,
                  60,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.accentTeal.withValues(alpha: 0.5)),
                        borderRadius: BorderRadius.circular(20),
                        color: AppColors.accentTeal.withValues(alpha: 0.08),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.accentTeal,
                              shape: BoxShape.circle,
                            ),
                          )
                              .animate(onPlay: (c) => c.repeat())
                              .scale(begin: const Offset(1, 1), end: const Offset(1.5, 1.5), duration: 800.ms)
                              .then()
                              .scale(begin: const Offset(1.5, 1.5), end: const Offset(1, 1), duration: 800.ms),
                          const SizedBox(width: 8),
                          Text(
                            'Available for opportunities',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: AppColors.accentTeal,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    )
                        .animate()
                        .fadeIn(delay: 200.ms, duration: 600.ms)
                        .slideX(begin: -0.2, end: 0),

                    const SizedBox(height: 24),

                    // Hi greeting
                    Text(
                      "Hi, I'm",
                      style: GoogleFonts.inter(
                        fontSize: isWide ? 22 : 17,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 1,
                      ),
                    )
                        .animate()
                        .fadeIn(delay: 400.ms, duration: 600.ms)
                        .slideX(begin: -0.2, end: 0),

                    const SizedBox(height: 8),

                    // Name with gradient
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [AppColors.accentTeal, AppColors.accentBlue, AppColors.accentPurple],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ).createShader(bounds),
                      child: Text(
                        PortfolioData.name,
                        style: GoogleFonts.inter(
                          fontSize: isWide ? 76 : 44,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          height: 1.05,
                          letterSpacing: -2,
                        ),
                      ),
                    )
                        .animate()
                        .fadeIn(delay: 500.ms, duration: 700.ms)
                        .slideX(begin: -0.15, end: 0),

                    const SizedBox(height: 20),

                    // Animated role
                    Row(
                      children: [
                        Text(
                          "I'm a ",
                          style: GoogleFonts.inter(
                            fontSize: isWide ? 26 : 19,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        AnimatedTextKit(
                          animatedTexts: PortfolioData.roles
                              .map(
                                (role) => TypewriterAnimatedText(
                                  role,
                                  textStyle: GoogleFonts.inter(
                                    fontSize: isWide ? 26 : 19,
                                    color: AppColors.accentTeal,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  speed: const Duration(milliseconds: 75),
                                ),
                              )
                              .toList(),
                          repeatForever: true,
                          pause: const Duration(milliseconds: 1800),
                        ),
                      ],
                    ).animate().fadeIn(delay: 700.ms, duration: 600.ms),

                    const SizedBox(height: 28),

                    // Summary
                    Container(
                      constraints: BoxConstraints(maxWidth: isWide ? 580 : double.infinity),
                      child: Text(
                        PortfolioData.summary,
                        style: GoogleFonts.inter(
                          fontSize: isWide ? 16 : 14,
                          color: AppColors.textSecondary,
                          height: 1.75,
                        ),
                      ),
                    ).animate().fadeIn(delay: 900.ms, duration: 600.ms),

                    const SizedBox(height: 44),

                    // CTA Buttons
                    Wrap(
                      spacing: 16,
                      runSpacing: 12,
                      children: [
                        _GradientButton(
                          label: 'Contact Me',
                          icon: Icons.send_rounded,
                          onTap: widget.onContactTap,
                          filled: true,
                        ),
                        _GradientButton(
                          label: 'View Projects',
                          icon: Icons.code_rounded,
                          onTap: widget.onProjectsTap,
                          filled: false,
                        ),
                        const ResumeDownloadButton(
                          style: ResumeButtonStyle.outlined,
                        ),
                      ],
                    )
                        .animate()
                        .fadeIn(delay: 1100.ms, duration: 600.ms)
                        .slideY(begin: 0.2, end: 0),

                    const SizedBox(height: 52),

                    // Social links
                    Row(
                      children: [
                        _SocialIcon(
                          icon: FontAwesomeIcons.linkedin,
                          url: PortfolioData.linkedin,
                          color: const Color(0xFF0A66C2),
                          tooltip: 'LinkedIn',
                        ),
                        const SizedBox(width: 16),
                        _SocialIcon(
                          icon: FontAwesomeIcons.envelope,
                          url: 'mailto:${PortfolioData.email}',
                          color: AppColors.accentTeal,
                          tooltip: 'Email',
                        ),
                        const SizedBox(width: 16),
                        _SocialIcon(
                          icon: FontAwesomeIcons.phone,
                          url: 'tel:${PortfolioData.phone}',
                          color: AppColors.accentPurple,
                          tooltip: 'Phone',
                        ),
                        const SizedBox(width: 16),
                        _SocialIcon(
                          icon: FontAwesomeIcons.locationDot,
                          url: '',
                          color: AppColors.accentBlue,
                          tooltip: PortfolioData.location,
                        ),
                      ],
                    ).animate().fadeIn(delay: 1300.ms, duration: 600.ms),
                  ],
                ),
              ),
            ),
          ),

          // Scroll arrow
          Positioned(
            bottom: 28,
            left: 0,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'scroll',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: AppColors.textMuted,
                    letterSpacing: 3,
                  ),
                ),
                const SizedBox(height: 6),
                const Icon(Icons.keyboard_arrow_down_rounded,
                    color: AppColors.accentTeal, size: 22)
                    .animate(onPlay: (c) => c.repeat())
                    .moveY(
                      begin: 0,
                      end: 8,
                      duration: 900.ms,
                      curve: Curves.easeInOut,
                    )
                    .then()
                    .moveY(
                      begin: 8,
                      end: 0,
                      duration: 900.ms,
                      curve: Curves.easeInOut,
                    ),
              ],
            ).animate().fadeIn(delay: 1500.ms),
          ),
        ],
      ),
    );
  }
}

// Floating particle painter
class _ParticlePainter extends CustomPainter {
  final double progress;
  static final _rng = Random(42);
  static final List<_Particle> _particles = List.unmodifiable(List.generate(
    60,
    (i) => _Particle(
      x: _rng.nextDouble(),
      y: _rng.nextDouble(),
      r: _rng.nextDouble() * 2.0 + 0.4,
      speed: _rng.nextDouble() * 0.4 + 0.2,
      phase: _rng.nextDouble() * 2 * pi,
      colorIdx: i % 3,
    ),
  ));

  static const _colors = [
    Color(0xFF64FFDA),
    Color(0xFF00B4D8),
    Color(0xFFBD93F9),
  ];

  _ParticlePainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    for (final p in _particles) {
      final offsetY = sin(progress * 2 * pi * p.speed + p.phase) * 18;
      final offsetX = cos(progress * 2 * pi * p.speed * 0.5 + p.phase) * 10;
      paint.color = _colors[p.colorIdx].withValues(alpha: 0.25 + 0.15 * sin(progress * 2 * pi + p.phase));
      canvas.drawCircle(
        Offset(p.x * size.width + offsetX, p.y * size.height + offsetY),
        p.r,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_ParticlePainter old) => old.progress != progress;
}

class _Particle {
  final double x, y, r, speed, phase;
  final int colorIdx;
  const _Particle({
    required this.x,
    required this.y,
    required this.r,
    required this.speed,
    required this.phase,
    required this.colorIdx,
  });
}

// Subtle grid painter
class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF1E3A5F).withValues(alpha: 0.25)
      ..strokeWidth = 0.5;

    const spacing = 60.0;
    for (double x = 0; x <= size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y <= size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_GridPainter old) => false;
}

// Gradient CTA button
class _GradientButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool filled;

  const _GradientButton({
    required this.label,
    required this.icon,
    required this.onTap,
    required this.filled,
  });

  @override
  State<_GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<_GradientButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 15),
          decoration: BoxDecoration(
            gradient: widget.filled
                ? const LinearGradient(
                    colors: [AppColors.accentTeal, AppColors.accentBlue],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            border: widget.filled
                ? null
                : Border.all(
                    color: _hovered ? AppColors.accentTeal : AppColors.borderColor,
                    width: 1.5,
                  ),
            borderRadius: BorderRadius.circular(10),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                      color: widget.filled
                          ? AppColors.shadowTeal
                          : AppColors.borderColor.withValues(alpha: 0.4),
                      blurRadius: 24,
                      spreadRadius: 0,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
            color: widget.filled ? null : (_hovered ? AppColors.bgCard : Colors.transparent),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.icon,
                size: 16,
                color: widget.filled ? AppColors.bgDeep : AppColors.textPrimary,
              ),
              const SizedBox(width: 8),
              Text(
                widget.label,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: widget.filled ? AppColors.bgDeep : AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Social icon button
class _SocialIcon extends StatefulWidget {
  final IconData icon;
  final String url;
  final Color color;
  final String tooltip;

  const _SocialIcon({
    required this.icon,
    required this.url,
    required this.color,
    required this.tooltip,
  });

  @override
  State<_SocialIcon> createState() => _SocialIconState();
}

class _SocialIconState extends State<_SocialIcon> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.tooltip,
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () async {
            if (widget.url.isEmpty) return;
            final uri = Uri.parse(widget.url);
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri, mode: LaunchMode.externalApplication);
            }
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _hovered ? widget.color.withValues(alpha: 0.15) : Colors.transparent,
              border: Border.all(
                color: _hovered ? widget.color : AppColors.borderColor,
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(10),
              boxShadow: _hovered
                  ? [BoxShadow(color: widget.color.withValues(alpha: 0.25), blurRadius: 16)]
                  : null,
            ),
            child: FaIcon(
              widget.icon,
              size: 17,
              color: _hovered ? widget.color : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
