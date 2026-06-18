import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:web/web.dart' as web;
import '../data/portfolio_data.dart';
import '../theme/app_colors.dart';

enum ResumeButtonStyle { filled, outlined, minimal }

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

class _ResumeDownloadButtonState extends State<ResumeDownloadButton> {
  bool _hovered = false;
  bool _downloading = false;

  Future<void> _download() async {
    if (_downloading) return;
    setState(() => _downloading = true);

    try {
      if (kIsWeb) {
        // Create a hidden anchor element and trigger download
        final anchor = web.document.createElement('a') as web.HTMLAnchorElement;
        anchor.href = PortfolioData.resumePath;
        anchor.download = 'Shubham_Wani_Resume.pdf';
        anchor.click();
      } else {
        final uri = Uri.parse(PortfolioData.resumePath);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      }
    } finally {
      await Future.delayed(1200.ms);
      if (mounted) setState(() => _downloading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: _download,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: EdgeInsets.symmetric(
            horizontal: widget.style == ResumeButtonStyle.minimal ? 14 : 22,
            vertical: widget.style == ResumeButtonStyle.minimal ? 9 : 13,
          ),
          decoration: _buildDecoration(),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildIcon(),
              const SizedBox(width: 8),
              _buildLabel(),
              if (!_downloading && widget.style != ResumeButtonStyle.minimal) ...[
                const SizedBox(width: 6),
                _buildArrow(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildDecoration() {
    switch (widget.style) {
      case ResumeButtonStyle.filled:
        return BoxDecoration(
          gradient: _hovered
              ? const LinearGradient(
                  colors: [AppColors.accentPurple, AppColors.accentBlue],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : const LinearGradient(
                  colors: [Color(0xFF7B2FBE), AppColors.accentBlue],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
          borderRadius: BorderRadius.circular(10),
          boxShadow: _hovered
              ? [BoxShadow(color: AppColors.shadowPurple, blurRadius: 20, offset: const Offset(0, 4))]
              : null,
        );
      case ResumeButtonStyle.outlined:
        return BoxDecoration(
          color: _hovered ? AppColors.accentPurple.withValues(alpha: 0.12) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: _hovered ? AppColors.accentPurple : AppColors.borderColor,
            width: 1.5,
          ),
          boxShadow: _hovered
              ? [BoxShadow(color: AppColors.shadowPurple, blurRadius: 16)]
              : null,
        );
      case ResumeButtonStyle.minimal:
        return BoxDecoration(
          color: _hovered ? AppColors.accentPurple.withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: _hovered
                ? AppColors.accentPurple.withValues(alpha: 0.5)
                : AppColors.borderColor,
          ),
        );
    }
  }

  Widget _buildIcon() {
    if (_downloading) {
      return SizedBox(
        width: 16,
        height: 16,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            widget.style == ResumeButtonStyle.filled ? AppColors.bgDeep : AppColors.accentPurple,
          ),
        ),
      );
    }
    return FaIcon(
      FontAwesomeIcons.fileArrowDown,
      size: 15,
      color: widget.style == ResumeButtonStyle.filled
          ? AppColors.bgDeep
          : _hovered
              ? AppColors.accentPurple
              : AppColors.textSecondary,
    );
  }

  Widget _buildLabel() {
    return Text(
      _downloading ? 'Downloading...' : 'Download Resume',
      style: GoogleFonts.inter(
        fontSize: widget.fontSize,
        fontWeight: FontWeight.w600,
        color: widget.style == ResumeButtonStyle.filled
            ? AppColors.bgDeep
            : _hovered
                ? AppColors.accentPurple
                : AppColors.textPrimary,
      ),
    );
  }

  Widget _buildArrow() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      transform: _hovered
          ? Matrix4.translationValues(3, 0, 0)
          : Matrix4.identity(),
      child: FaIcon(
        FontAwesomeIcons.arrowDown,
        size: 11,
        color: widget.style == ResumeButtonStyle.filled
            ? AppColors.bgDeep.withValues(alpha: 0.7)
            : _hovered
                ? AppColors.accentPurple.withValues(alpha: 0.7)
                : AppColors.textMuted,
      ),
    );
  }
}
