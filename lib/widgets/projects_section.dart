import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_colors.dart';
import '../data/portfolio_data.dart';
import 'section_title.dart';

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final hPad = width > 1200 ? (width - 1200) / 2 + 40.0 : (width > 768 ? 80.0 : 24.0);
    final isWide = width > 800;

    final featured = PortfolioData.projects.where((p) => p['featured'] == true).toList();
    final regular = PortfolioData.projects.where((p) => p['featured'] != true).toList();

    return Container(
      width: double.infinity,
      color: AppColors.bgDeep,
      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(
            title: 'Projects',
            subtitle: 'Production apps & AI solutions shipped with real-world impact',
          ),

          // Featured project(s) — full width
          ...featured.asMap().entries.map(
            (e) => Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: _ProjectCard(
                data: e.value,
                delay: (e.key * 150).ms,
                featured: true,
                isWide: isWide,
              ),
            ),
          ),

          // Regular projects — side by side on desktop
          if (isWide && regular.length > 1)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: regular.asMap().entries.map((e) {
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: e.key > 0 ? 12 : 0,
                      right: e.key < regular.length - 1 ? 12 : 0,
                    ),
                    child: _ProjectCard(
                      data: e.value,
                      delay: ((e.key + featured.length) * 150).ms,
                      featured: false,
                      isWide: isWide,
                    ),
                  ),
                );
              }).toList(),
            )
          else
            Column(
              children: regular.asMap().entries.map((e) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: _ProjectCard(
                    data: e.value,
                    delay: ((e.key + featured.length) * 150).ms,
                    featured: false,
                    isWide: isWide,
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}

class _ProjectCard extends StatefulWidget {
  final Map<String, dynamic> data;
  final Duration delay;
  final bool featured;
  final bool isWide;

  const _ProjectCard({
    required this.data,
    required this.delay,
    required this.featured,
    required this.isWide,
  });

  @override
  State<_ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<_ProjectCard> {
  bool _hovered = false;

  Color get _accent => Color(widget.data['accentColor'] as int);
  List<Color> get _gradients =>
      (widget.data['gradientColors'] as List<int>).map((c) => Color(c)).toList();
  String get _url => widget.data['url'] as String? ?? '';

  IconData get _icon {
    switch (widget.data['name'] as String) {
      case 'CognitoSphere AI':
        return Icons.psychology_rounded;
      case 'ProHealth Management':
        return Icons.local_hospital_rounded;
      default:
        return Icons.build_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        transform: _hovered
            ? Matrix4.translationValues(0.0, -6.0, 0.0)
            : Matrix4.identity(),
        decoration: BoxDecoration(
          gradient: AppColors.cardGradient,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _hovered ? _accent.withValues(alpha: 0.6) : AppColors.borderColor,
            width: _hovered ? 1.5 : 1,
          ),
          boxShadow: _hovered
              ? [
                  BoxShadow(
                    color: _accent.withValues(alpha: 0.2),
                    blurRadius: 40,
                    spreadRadius: 0,
                    offset: const Offset(0, 8),
                  ),
                ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top gradient bar
            Container(
              height: 4,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: _gradients),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(28),
              child: widget.featured && widget.isWide
                  ? _FeaturedLayout(
                      data: widget.data,
                      accent: _accent,
                      gradients: _gradients,
                      icon: _icon,
                      url: _url,
                      hovered: _hovered,
                    )
                  : _StandardLayout(
                      data: widget.data,
                      accent: _accent,
                      gradients: _gradients,
                      icon: _icon,
                      url: _url,
                      hovered: _hovered,
                    ),
            ),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(delay: widget.delay + 200.ms, duration: 600.ms)
        .slideY(begin: 0.12, end: 0, curve: Curves.easeOut);
  }
}

// Wide featured layout (horizontal split)
class _FeaturedLayout extends StatelessWidget {
  final Map<String, dynamic> data;
  final Color accent;
  final List<Color> gradients;
  final IconData icon;
  final String url;
  final bool hovered;

  const _FeaturedLayout({
    required this.data,
    required this.accent,
    required this.gradients,
    required this.icon,
    required this.url,
    required this.hovered,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left: icon + title + url
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: gradients),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: accent.withValues(alpha: 0.4),
                    blurRadius: 20,
                  ),
                ],
              ),
              child: Icon(icon, color: AppColors.bgDeep, size: 28),
            ),
            const SizedBox(height: 20),
            // Featured badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: gradients),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.star_rounded, color: AppColors.bgDeep, size: 12),
                  const SizedBox(width: 5),
                  Text(
                    'Featured',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.bgDeep,
                    ),
                  ),
                ],
              ),
            ),
            if (url.isNotEmpty) ...[
              const SizedBox(height: 16),
              _LiveButton(url: url, accent: accent),
            ],
          ],
        ),

        const SizedBox(width: 36),

        // Right: full content
        Expanded(
          child: _ProjectContent(
            data: data,
            accent: accent,
            gradients: gradients,
            url: url,
            showLiveButton: false,
          ),
        ),
      ],
    );
  }
}

// Standard (non-featured) card layout
class _StandardLayout extends StatelessWidget {
  final Map<String, dynamic> data;
  final Color accent;
  final List<Color> gradients;
  final IconData icon;
  final String url;
  final bool hovered;

  const _StandardLayout({
    required this.data,
    required this.accent,
    required this.gradients,
    required this.icon,
    required this.url,
    required this.hovered,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: gradients),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: accent.withValues(alpha: 0.3),
                    blurRadius: 12,
                  ),
                ],
              ),
              child: Icon(icon, color: AppColors.bgDeep, size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data['name'] as String,
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.calendar_today_rounded,
                          size: 12, color: AppColors.textMuted),
                      const SizedBox(width: 5),
                      Text(
                        data['duration'] as String,
                        style: GoogleFonts.inter(
                            fontSize: 12, color: AppColors.textMuted),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        _ProjectContent(
          data: data,
          accent: accent,
          gradients: gradients,
          url: url,
          showLiveButton: url.isNotEmpty,
        ),
      ],
    );
  }
}

// Shared content block (description + security + tags + live button)
class _ProjectContent extends StatelessWidget {
  final Map<String, dynamic> data;
  final Color accent;
  final List<Color> gradients;
  final String url;
  final bool showLiveButton;

  const _ProjectContent({
    required this.data,
    required this.accent,
    required this.gradients,
    required this.url,
    required this.showLiveButton,
  });

  @override
  Widget build(BuildContext context) {
    final isFeatured = data['featured'] == true;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isFeatured) ...[
          // Project name + duration for featured layout
          Text(
            data['name'] as String,
            style: GoogleFonts.inter(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(Icons.calendar_today_rounded, size: 13, color: AppColors.textMuted),
              const SizedBox(width: 6),
              Text(
                data['duration'] as String,
                style: GoogleFonts.inter(fontSize: 13, color: AppColors.textMuted),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],

        Text(
          data['description'] as String,
          style: GoogleFonts.inter(
            fontSize: 14,
            color: AppColors.textSecondary,
            height: 1.75,
          ),
        ),

        // Security highlights for AI project
        if (isFeatured) ...[
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: accent.withValues(alpha: 0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.security_rounded, color: accent, size: 15),
                    const SizedBox(width: 8),
                    Text(
                      'Security Features',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: accent,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: const [
                    'JWT Auth',
                    'Bcrypt Hashing',
                    'Server-side API Keys',
                    'Rate Limiting',
                    'Prompt Injection Guard',
                    'HTTPS/SSL',
                    'Session Management',
                    'Input Sanitization',
                  ].map((s) => _SecurityChip(label: s, color: accent)).toList(),
                ),
              ],
            ),
          ),
        ],

        const SizedBox(height: 20),

        // Tags
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: (data['tags'] as List<String>)
              .map(
                (tag) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: accent.withValues(alpha: 0.3)),
                  ),
                  child: Text(
                    tag,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: accent,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              )
              .toList(),
        ),

        if (showLiveButton && url.isNotEmpty) ...[
          const SizedBox(height: 20),
          _LiveButton(url: url, accent: accent),
        ],
      ],
    );
  }
}

class _SecurityChip extends StatelessWidget {
  final String label;
  final Color color;

  const _SecurityChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle_rounded, size: 11, color: color),
          const SizedBox(width: 5),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _LiveButton extends StatefulWidget {
  final String url;
  final Color accent;

  const _LiveButton({required this.url, required this.accent});

  @override
  State<_LiveButton> createState() => _LiveButtonState();
}

class _LiveButtonState extends State<_LiveButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () async {
          final uri = Uri.parse(widget.url);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          decoration: BoxDecoration(
            gradient: _hovered
                ? LinearGradient(
                    colors: [widget.accent, widget.accent.withValues(alpha: 0.7)],
                  )
                : null,
            color: _hovered ? null : widget.accent.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: _hovered
                  ? widget.accent
                  : widget.accent.withValues(alpha: 0.4),
            ),
            boxShadow: _hovered
                ? [BoxShadow(color: widget.accent.withValues(alpha: 0.3), blurRadius: 16)]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 7,
                height: 7,
                decoration: BoxDecoration(
                  color: _hovered ? AppColors.bgDeep : widget.accent,
                  shape: BoxShape.circle,
                ),
              )
                  .animate(onPlay: (c) => c.repeat())
                  .scale(
                    begin: const Offset(1, 1),
                    end: const Offset(1.5, 1.5),
                    duration: 700.ms,
                  )
                  .then()
                  .scale(
                    begin: const Offset(1.5, 1.5),
                    end: const Offset(1, 1),
                    duration: 700.ms,
                  ),
              const SizedBox(width: 8),
              FaIcon(
                FontAwesomeIcons.upRightFromSquare,
                size: 12,
                color: _hovered ? AppColors.bgDeep : widget.accent,
              ),
              const SizedBox(width: 6),
              Text(
                'Live Demo',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: _hovered ? AppColors.bgDeep : widget.accent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
