import 'dart:math' show pi, cos, sin;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:web/web.dart' as web;
import '../data/portfolio_data.dart';
import '../theme/app_colors.dart';

enum ResumeButtonStyle { filled, outlined, minimal }

enum _DlState { idle, downloading, success }

class ResumeDownloadButton extends StatefulWidget {
  final ResumeButtonStyle style;
  final double fontSize;

  const ResumeDownloadButton({
    super.key,
    this.style = ResumeButtonStyle.filled,
    this.fontSize = 15,
  });

  @override
  State<ResumeDownloadButton> createState() => _ResumeDownloadButtonState();
}

class _ResumeDownloadButtonState extends State<ResumeDownloadButton>
    with TickerProviderStateMixin {
  bool _hovered = false;
  _DlState _dlState = _DlState.idle;

  // Always running
  late final AnimationController _borderCtrl;
  late final AnimationController _glowCtrl;

  // Triggered on interaction
  late final AnimationController _shimmerCtrl;
  late final AnimationController _scaleCtrl;
  late final AnimationController _progressCtrl;
  late final AnimationController _successCtrl;

  @override
  void initState() {
    super.initState();
    _borderCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
    _glowCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat(reverse: true);
    _shimmerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 750),
    );
    _scaleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _progressCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );
    _successCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
  }

  @override
  void dispose() {
    _borderCtrl.dispose();
    _glowCtrl.dispose();
    _shimmerCtrl.dispose();
    _scaleCtrl.dispose();
    _progressCtrl.dispose();
    _successCtrl.dispose();
    super.dispose();
  }

  void _onEnter(_) {
    setState(() => _hovered = true);
    _scaleCtrl.forward();
    _shimmerCtrl.forward(from: 0);
  }

  void _onExit(_) {
    setState(() => _hovered = false);
    _scaleCtrl.reverse();
  }

  Future<void> _onTap() async {
    if (_dlState != _DlState.idle) return;
    setState(() => _dlState = _DlState.downloading);
    _progressCtrl.forward(from: 0);
    try {
      if (kIsWeb) {
        final a = web.document.createElement('a') as web.HTMLAnchorElement;
        a.href = PortfolioData.resumePath;
        a.download = 'Shubham_Wani_Resume.pdf';
        a.click();
      } else {
        final uri = Uri.parse(PortfolioData.resumePath);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      }
    } catch (_) {
      // download errors are non-fatal
    }

    await Future.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    setState(() => _dlState = _DlState.success);
    _successCtrl.forward(from: 0);
    await Future.delayed(const Duration(milliseconds: 1800));
    if (!mounted) return;
    setState(() => _dlState = _DlState.idle);
    _progressCtrl.reset();
    _successCtrl.reset();
  }

  @override
  Widget build(BuildContext context) {
    final isFilled = widget.style == ResumeButtonStyle.filled;
    final isMinimal = widget.style == ResumeButtonStyle.minimal;

    return MouseRegion(
      onEnter: _onEnter,
      onExit: _onExit,
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: _onTap,
        child: AnimatedBuilder(
          animation: Listenable.merge([
            _borderCtrl,
            _glowCtrl,
            _shimmerCtrl,
            _scaleCtrl,
            _progressCtrl,
            _successCtrl,
          ]),
          builder: (context, _) {
            final scale = 1.0 +
                CurvedAnimation(parent: _scaleCtrl, curve: Curves.easeOut).value *
                    0.045;
            return Transform.scale(
              scale: scale,
              child: _buildBody(isFilled, isMinimal),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBody(bool isFilled, bool isMinimal) {
    final glowColor = _dlState == _DlState.success
        ? AppColors.accentTeal
        : isFilled
            ? AppColors.accentPurple
            : AppColors.accentBlue;
    final glowAlpha = (_hovered ? 0.30 : 0.12) + _glowCtrl.value * 0.15;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Breathing glow behind button
        if (!isMinimal)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: glowColor.withValues(alpha: glowAlpha),
                    blurRadius: 28,
                    spreadRadius: 3,
                  ),
                ],
              ),
            ),
          ),

        // Rotating gradient border
        if (!isMinimal)
          Positioned.fill(
            child: CustomPaint(
              painter: _BorderPainter(
                progress: _borderCtrl.value,
                active: _hovered || _dlState != _DlState.idle,
              ),
            ),
          ),

        // Button body
        Container(
          margin: isMinimal ? EdgeInsets.zero : const EdgeInsets.all(1.5),
          clipBehavior: Clip.antiAlias,
          decoration: _buildDecoration(isFilled, isMinimal),
          child: Stack(
            children: [
              // Download progress fill
              if (_dlState == _DlState.downloading)
                Positioned.fill(
                  child: FractionallySizedBox(
                    widthFactor: CurvedAnimation(
                      parent: _progressCtrl,
                      curve: Curves.easeInOut,
                    ).value,
                    alignment: Alignment.centerLeft,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.accentTeal.withValues(alpha: 0.28),
                            AppColors.accentBlue.withValues(alpha: 0.12),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

              // Shimmer sweep on hover
              if (_hovered && _dlState == _DlState.idle)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Colors.white.withValues(alpha: 0),
                          Colors.white.withValues(alpha: 0),
                          Colors.white.withValues(alpha: isFilled ? 0.22 : 0.10),
                          Colors.white.withValues(alpha: 0),
                          Colors.white.withValues(alpha: 0),
                        ],
                        stops: [
                          0.0,
                          (_shimmerCtrl.value * 1.25 - 0.14).clamp(0.0, 1.0),
                          (_shimmerCtrl.value * 1.25).clamp(0.0, 1.0),
                          (_shimmerCtrl.value * 1.25 + 0.14).clamp(0.0, 1.0),
                          1.0,
                        ],
                      ),
                    ),
                  ),
                ),

              // Content
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isMinimal ? 14 : 22,
                  vertical: isMinimal ? 9 : 13,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildIcon(isFilled),
                    const SizedBox(width: 8),
                    _buildLabel(isFilled),
                    if (_dlState == _DlState.idle && !isMinimal) ...[
                      const SizedBox(width: 6),
                      _buildArrow(isFilled),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  BoxDecoration _buildDecoration(bool isFilled, bool isMinimal) {
    final radius = BorderRadius.circular(isMinimal ? 8 : 9);

    if (_dlState == _DlState.success) {
      return BoxDecoration(
        color: AppColors.accentTeal.withValues(alpha: 0.15),
        borderRadius: radius,
        border: Border.all(
          color: AppColors.accentTeal.withValues(alpha: 0.7),
          width: 1.5,
        ),
      );
    }

    if (isFilled) {
      return BoxDecoration(
        gradient: LinearGradient(
          colors: _hovered || _dlState == _DlState.downloading
              ? [AppColors.accentPurple, AppColors.accentBlue]
              : [const Color(0xFF7B2FBE), AppColors.accentBlue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: radius,
      );
    }

    if (isMinimal) {
      return BoxDecoration(
        color: _hovered
            ? AppColors.accentPurple.withValues(alpha: 0.1)
            : Colors.transparent,
        borderRadius: radius,
        border: Border.all(
          color: _hovered
              ? AppColors.accentPurple.withValues(alpha: 0.5)
              : AppColors.borderColor,
        ),
      );
    }

    // outlined
    return BoxDecoration(
      color: _hovered
          ? AppColors.accentPurple.withValues(alpha: 0.12)
          : Colors.transparent,
      borderRadius: radius,
      border: Border.all(
        color: _hovered ? AppColors.accentPurple : AppColors.borderColor,
        width: 1.5,
      ),
    );
  }

  Widget _buildIcon(bool isFilled) {
    if (_dlState == _DlState.success) {
      return ScaleTransition(
        scale: CurvedAnimation(
          parent: _successCtrl,
          curve: Curves.elasticOut,
        ),
        child: const FaIcon(
          FontAwesomeIcons.circleCheck,
          size: 15,
          color: AppColors.accentTeal,
        ),
      );
    }
    if (_dlState == _DlState.downloading) {
      return SizedBox(
        width: 15,
        height: 15,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            isFilled ? AppColors.bgDeep : AppColors.accentPurple,
          ),
        ),
      );
    }
    // Idle — icon nudges down on hover
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      transform: _hovered
          ? Matrix4.translationValues(0, 2, 0)
          : Matrix4.identity(),
      child: FaIcon(
        FontAwesomeIcons.fileArrowDown,
        size: 15,
        color: isFilled
            ? AppColors.bgDeep
            : _hovered
                ? AppColors.accentPurple
                : AppColors.textSecondary,
      ),
    );
  }

  Widget _buildLabel(bool isFilled) {
    final String text;
    final Color color;

    switch (_dlState) {
      case _DlState.downloading:
        text = 'Downloading...';
        color = isFilled ? AppColors.bgDeep : AppColors.accentPurple;
      case _DlState.success:
        text = 'Downloaded!';
        color = AppColors.accentTeal;
      case _DlState.idle:
        text = 'Download Resume';
        color = isFilled
            ? AppColors.bgDeep
            : _hovered
                ? AppColors.accentPurple
                : AppColors.textPrimary;
    }

    return AnimatedDefaultTextStyle(
      duration: const Duration(milliseconds: 200),
      style: GoogleFonts.inter(
        fontSize: widget.fontSize,
        fontWeight: FontWeight.w600,
        color: color,
      ),
      child: Text(text),
    );
  }

  Widget _buildArrow(bool isFilled) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      transform: _hovered
          ? Matrix4.translationValues(3, 0, 0)
          : Matrix4.identity(),
      child: FaIcon(
        FontAwesomeIcons.arrowDown,
        size: 11,
        color: isFilled
            ? AppColors.bgDeep.withValues(alpha: 0.7)
            : _hovered
                ? AppColors.accentPurple.withValues(alpha: 0.7)
                : AppColors.textMuted,
      ),
    );
  }
}

// Rotating tri-color gradient border
class _BorderPainter extends CustomPainter {
  final double progress;
  final bool active;

  const _BorderPainter({required this.progress, required this.active});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(10.5));
    final angle = progress * 2 * pi;
    final a = active ? 1.0 : 0.35;

    canvas.drawRRect(
      rrect,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..shader = LinearGradient(
          colors: [
            AppColors.accentTeal.withValues(alpha: a),
            AppColors.accentBlue.withValues(alpha: a * 0.75),
            AppColors.accentPurple.withValues(alpha: a * 0.55),
            AppColors.accentTeal.withValues(alpha: 0),
          ],
          stops: const [0.0, 0.33, 0.66, 1.0],
          begin: Alignment(cos(angle), sin(angle)),
          end: Alignment(-cos(angle), -sin(angle)),
        ).createShader(rect),
    );
  }

  @override
  bool shouldRepaint(_BorderPainter old) =>
      old.progress != progress || old.active != active;
}
