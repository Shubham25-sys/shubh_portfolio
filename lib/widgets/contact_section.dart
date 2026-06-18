import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_colors.dart';
import '../data/portfolio_data.dart';
import 'section_title.dart';
import 'resume_download_button.dart';

class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final hPad = width > 1200 ? (width - 1200) / 2 + 40.0 : (width > 768 ? 80.0 : 24.0);
    final isWide = width > 800;

    return Container(
      width: double.infinity,
      color: AppColors.bgDeep,
      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(
            title: "Let's Connect",
            subtitle: "Open to new opportunities and collaborations",
          ),

          // CTA banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(40),
            margin: const EdgeInsets.only(bottom: 48),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.accentTeal.withValues(alpha: 0.08),
                  AppColors.accentPurple.withValues(alpha: 0.08),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.borderColor),
            ),
            child: isWide
                ? Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ShaderMask(
                              shaderCallback: (b) =>
                                  AppColors.accentGradient.createShader(b),
                              child: Text(
                                "Ready to build something amazing?",
                                style: GoogleFonts.inter(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "I'm currently open to full-time roles and freelance projects. Let's create something impactful together.",
                              style: GoogleFonts.inter(
                                fontSize: 15,
                                color: AppColors.textSecondary,
                                height: 1.6,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 32),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _ContactCTA(),
                          const SizedBox(height: 12),
                          const ResumeDownloadButton(
                            style: ResumeButtonStyle.outlined,
                          ),
                        ],
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShaderMask(
                        shaderCallback: (b) =>
                            AppColors.accentGradient.createShader(b),
                        child: Text(
                          "Ready to build something amazing?",
                          style: GoogleFonts.inter(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "I'm currently open to full-time roles and freelance projects.",
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 24),
                      _ContactCTA(),
                      const SizedBox(height: 12),
                      const ResumeDownloadButton(
                        style: ResumeButtonStyle.outlined,
                      ),
                    ],
                  ),
          ).animate().fadeIn(delay: 200.ms, duration: 600.ms).slideY(begin: 0.1, end: 0),

          // Contact cards grid
          GridView.count(
            crossAxisCount: isWide ? 4 : 2,
            shrinkWrap: true,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: isWide ? 1.0 : 0.95,
            physics: const NeverScrollableScrollPhysics(),
            children: _contactItems.asMap().entries.map((e) => _ContactCard(
              icon: e.value['icon'] as IconData,
              isFa: e.value['isFa'] as bool,
              label: e.value['label'] as String,
              value: e.value['value'] as String,
              url: e.value['url'] as String,
              color: e.value['color'] as Color,
              delay: (e.key * 100).ms,
            )).toList(),
          ),
        ],
      ),
    );
  }

  static final List<Map<String, dynamic>> _contactItems = [
    {
      'icon': FontAwesomeIcons.envelope,
      'isFa': true,
      'label': 'Email',
      'value': PortfolioData.email,
      'url': 'mailto:${PortfolioData.email}',
      'color': AppColors.accentTeal,
    },
    {
      'icon': FontAwesomeIcons.phone,
      'isFa': true,
      'label': 'Phone',
      'value': PortfolioData.phone,
      'url': 'tel:${PortfolioData.phone}',
      'color': AppColors.accentPurple,
    },
    {
      'icon': FontAwesomeIcons.locationDot,
      'isFa': true,
      'label': 'Location',
      'value': PortfolioData.location,
      'url': '',
      'color': AppColors.accentBlue,
    },
    {
      'icon': FontAwesomeIcons.linkedin,
      'isFa': true,
      'label': 'LinkedIn',
      'value': 'shubham-wani',
      'url': PortfolioData.linkedin,
      'color': const Color(0xFF0A66C2),
    },
  ];
}

class _ContactCTA extends StatefulWidget {
  @override
  State<_ContactCTA> createState() => _ContactCTAState();
}

class _ContactCTAState extends State<_ContactCTA> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () async {
          final uri = Uri.parse('mailto:${PortfolioData.email}');
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 15),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.accentTeal, AppColors.accentBlue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: _hovered
                ? [BoxShadow(color: AppColors.shadowTeal, blurRadius: 24)]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.send_rounded, color: AppColors.bgDeep, size: 18),
              const SizedBox(width: 10),
              Text(
                "Say Hello",
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.bgDeep,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ContactCard extends StatefulWidget {
  final IconData icon;
  final bool isFa;
  final String label, value, url;
  final Color color;
  final Duration delay;

  const _ContactCard({
    required this.icon,
    required this.isFa,
    required this.label,
    required this.value,
    required this.url,
    required this.color,
    required this.delay,
  });

  @override
  State<_ContactCard> createState() => _ContactCardState();
}

class _ContactCardState extends State<_ContactCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: widget.url.isNotEmpty ? SystemMouseCursors.click : MouseCursor.defer,
      child: GestureDetector(
        onTap: () async {
          if (widget.url.isEmpty) return;
          final uri = Uri.parse(widget.url);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: _hovered
                ? LinearGradient(
                    colors: [
                      widget.color.withValues(alpha: 0.1),
                      AppColors.bgCard,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : AppColors.cardGradient,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _hovered
                  ? widget.color.withValues(alpha: 0.5)
                  : AppColors.borderColor,
            ),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                      color: widget.color.withValues(alpha: 0.2),
                      blurRadius: 20,
                    ),
                  ]
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: _hovered
                      ? widget.color.withValues(alpha: 0.2)
                      : widget.color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: widget.color.withValues(alpha: 0.3),
                  ),
                  boxShadow: _hovered
                      ? [BoxShadow(color: widget.color.withValues(alpha: 0.3), blurRadius: 12)]
                      : null,
                ),
                child: FaIcon(widget.icon, color: widget.color, size: 20),
              ),
              const SizedBox(height: 12),
              Text(
                widget.label,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textMuted,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                widget.value,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: _hovered ? widget.color : AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(delay: widget.delay + 400.ms, duration: 500.ms)
        .scale(
          begin: const Offset(0.9, 0.9),
          end: const Offset(1, 1),
          delay: widget.delay + 400.ms,
          curve: Curves.easeOut,
        );
  }
}
