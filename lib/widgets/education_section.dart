import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:web/web.dart' as web;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_colors.dart';
import '../data/portfolio_data.dart';
import 'section_title.dart';

class EducationSection extends StatelessWidget {
  const EducationSection({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final hPad = width > 1200 ? (width - 1200) / 2 + 40.0 : (width > 768 ? 80.0 : 24.0);
    final isWide = width > 900;

    final featuredCert = PortfolioData.certificates.firstWhere(
      (c) => c['featured'] == true,
      orElse: () => PortfolioData.certificates.last,
    );
    final otherCerts = PortfolioData.certificates
        .where((c) => c['featured'] != true)
        .toList();

    return Container(
      width: double.infinity,
      color: AppColors.bgSurface,
      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(
            title: 'Education & Certifications',
            subtitle: 'Academic background and professional development',
          ),

          // Row 1: Education + ML cert
          if (isWide)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _EducationCard()),
                const SizedBox(width: 24),
                ...otherCerts.map(
                  (c) => Expanded(child: _SmallCertCard(data: c)),
                ),
              ],
            )
          else
            Column(
              children: [
                _EducationCard(),
                const SizedBox(height: 24),
                ...otherCerts.map((c) => Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: _SmallCertCard(data: c),
                    )),
              ],
            ),

          const SizedBox(height: 24),

          // Row 2: Featured AI certificate — full width
          _FeaturedCertCard(data: featuredCert, isWide: isWide),
        ],
      ),
    );
  }
}

// Education degree card
class _EducationCard extends StatefulWidget {
  @override
  State<_EducationCard> createState() => _EducationCardState();
}

class _EducationCardState extends State<_EducationCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final edu = PortfolioData.education.first;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        decoration: BoxDecoration(
          gradient: _hovered
              ? LinearGradient(colors: [
                  AppColors.accentTeal.withValues(alpha: 0.07),
                  AppColors.bgCard,
                ], begin: Alignment.topLeft, end: Alignment.bottomRight)
              : AppColors.cardGradient,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _hovered
                ? AppColors.accentTeal.withValues(alpha: 0.5)
                : AppColors.borderColor,
          ),
          boxShadow: _hovered
              ? [BoxShadow(color: AppColors.shadowTeal, blurRadius: 28)]
              : null,
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  AppColors.accentTeal.withValues(alpha: 0.12),
                  Colors.transparent,
                ], begin: Alignment.topLeft, end: Alignment.bottomRight),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      gradient: AppColors.tealBlueGradient,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [BoxShadow(color: AppColors.shadowTeal, blurRadius: 16)],
                    ),
                    child: const Icon(Icons.school_rounded, color: AppColors.bgDeep, size: 26),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'Education',
                    style: GoogleFonts.inter(
                        fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(edu['degree']!,
                      style: GoogleFonts.inter(
                          fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                  const SizedBox(height: 10),
                  _InfoRow(icon: Icons.account_balance_rounded, text: edu['university']!, color: AppColors.accentTeal),
                  const SizedBox(height: 8),
                  _InfoRow(icon: Icons.location_on_rounded, text: edu['location']!, color: AppColors.accentBlue),
                  const SizedBox(height: 8),
                  _InfoRow(icon: Icons.calendar_month_rounded, text: edu['duration']!, color: AppColors.textMuted),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                    decoration: BoxDecoration(
                      gradient: AppColors.tealBlueGradient,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star_rounded, color: AppColors.bgDeep, size: 16),
                        const SizedBox(width: 8),
                        Text(edu['grade']!,
                            style: GoogleFonts.inter(
                                fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.bgDeep)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(delay: 200.ms, duration: 600.ms)
        .slideX(begin: -0.1, end: 0, curve: Curves.easeOut);
  }
}

// Small cert card (ML cert) — with full Udemy details + View Certificate button
class _SmallCertCard extends StatefulWidget {
  final Map<String, dynamic> data;
  const _SmallCertCard({required this.data});

  @override
  State<_SmallCertCard> createState() => _SmallCertCardState();
}

class _SmallCertCardState extends State<_SmallCertCard> {
  bool _hovered = false;

  Color get _accent => Color(widget.data['accentColor'] as int);

  void _openCertificate() async {
    final pdfPath = widget.data['pdfPath'] as String;
    final certUrl = widget.data['certUrl'] as String;

    if (kIsWeb && pdfPath.isNotEmpty) {
      try {
        web.window.open(pdfPath, '_blank');
        return;
      } catch (_) {}
    }
    if (certUrl.isNotEmpty) {
      final uri = Uri.parse(certUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasCert = (widget.data['pdfPath'] as String).isNotEmpty ||
        (widget.data['certUrl'] as String).isNotEmpty;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        decoration: BoxDecoration(
          gradient: _hovered
              ? LinearGradient(
                  colors: [_accent.withValues(alpha: 0.07), AppColors.bgCard],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight)
              : AppColors.cardGradient,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _hovered ? _accent.withValues(alpha: 0.5) : AppColors.borderColor,
          ),
          boxShadow: _hovered
              ? [BoxShadow(color: _accent.withValues(alpha: 0.2), blurRadius: 24)]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with gradient top bar
            Container(
              height: 3,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [_accent, AppColors.accentBlue]),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Platform badge + icon row
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: _accent.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: _accent.withValues(alpha: 0.3)),
                        ),
                        child: Icon(Icons.workspace_premium_rounded, color: _accent, size: 18),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: _accent.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: _accent.withValues(alpha: 0.3)),
                              ),
                              child: Text(
                                widget.data['platform'] as String,
                                style: GoogleFonts.inter(
                                    fontSize: 11, fontWeight: FontWeight.w700, color: _accent),
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              'Certificate of Completion',
                              style: GoogleFonts.inter(
                                  fontSize: 11, color: AppColors.textMuted),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // Title
                  Text(
                    widget.data['title'] as String,
                    style: GoogleFonts.inter(
                        fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary, height: 1.4),
                  ),

                  const SizedBox(height: 10),

                  // Meta row: instructor, date, hours
                  if ((widget.data['instructors'] as String).isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: _MetaRow(
                        icon: FontAwesomeIcons.chalkboardUser,
                        text: widget.data['instructors'] as String,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  Row(
                    children: [
                      if ((widget.data['date'] as String).isNotEmpty) ...[
                        _MetaRow(
                          icon: FontAwesomeIcons.calendarDay,
                          text: widget.data['date'] as String,
                          color: AppColors.textMuted,
                        ),
                        const SizedBox(width: 16),
                      ],
                      if ((widget.data['hours'] as String).isNotEmpty)
                        _MetaRow(
                          icon: FontAwesomeIcons.clock,
                          text: widget.data['hours'] as String,
                          color: _accent,
                        ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Description
                  Text(
                    widget.data['description'] as String,
                    style: GoogleFonts.inter(
                        fontSize: 12, color: AppColors.textSecondary, height: 1.65),
                  ),

                  const SizedBox(height: 12),

                  // Topic chips
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: (widget.data['topics'] as List<dynamic>)
                        .map((t) => _TopicChip(label: t as String, color: _accent))
                        .toList(),
                  ),

                  if (hasCert) ...[
                    const SizedBox(height: 16),
                    _OpenCertButton(accent: _accent, onOpen: _openCertificate),
                  ],

                  // Cert number
                  if ((widget.data['certNo'] as String).isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(Icons.tag_rounded, size: 11, color: AppColors.textMuted),
                        const SizedBox(width: 5),
                        Flexible(
                          child: Text(
                            widget.data['certNo'] as String,
                            style: GoogleFonts.inter(fontSize: 10, color: AppColors.textMuted),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(delay: 350.ms, duration: 600.ms)
        .slideX(begin: 0.1, end: 0, curve: Curves.easeOut);
  }
}

// Featured AI certificate card — full width
class _FeaturedCertCard extends StatefulWidget {
  final Map<String, dynamic> data;
  final bool isWide;

  const _FeaturedCertCard({required this.data, required this.isWide});

  @override
  State<_FeaturedCertCard> createState() => _FeaturedCertCardState();
}

class _FeaturedCertCardState extends State<_FeaturedCertCard> {
  bool _hovered = false;

  Color get _accent => Color(widget.data['accentColor'] as int);

  void _openCertificate() async {
    final pdfPath = widget.data['pdfPath'] as String;
    final certUrl = widget.data['certUrl'] as String;

    // On web: open local PDF if available, else Udemy URL
    if (kIsWeb && pdfPath.isNotEmpty) {
      try {
        web.window.open(pdfPath, '_blank');
        return;
      } catch (_) {}
    }
    // Fallback: open Udemy certificate URL
    if (certUrl.isNotEmpty) {
      final uri = Uri.parse(certUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        decoration: BoxDecoration(
          gradient: AppColors.cardGradient,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _hovered ? _accent.withValues(alpha: 0.6) : AppColors.borderColor,
            width: _hovered ? 1.5 : 1,
          ),
          boxShadow: _hovered
              ? [BoxShadow(color: _accent.withValues(alpha: 0.2), blurRadius: 40, offset: const Offset(0, 8))]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gradient top bar
            Container(
              height: 4,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [_accent, AppColors.accentPurple, AppColors.accentBlue],
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(28),
              child: widget.isWide
                  ? _FeaturedWideLayout(data: widget.data, accent: _accent, onOpen: _openCertificate)
                  : _FeaturedNarrowLayout(data: widget.data, accent: _accent, onOpen: _openCertificate),
            ),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(delay: 400.ms, duration: 700.ms)
        .slideY(begin: 0.12, end: 0, curve: Curves.easeOut);
  }
}

class _FeaturedWideLayout extends StatelessWidget {
  final Map<String, dynamic> data;
  final Color accent;
  final VoidCallback onOpen;

  const _FeaturedWideLayout({required this.data, required this.accent, required this.onOpen});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left panel
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Udemy badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [accent, AppColors.accentPurple]),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [BoxShadow(color: accent.withValues(alpha: 0.4), blurRadius: 16)],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const FaIcon(FontAwesomeIcons.graduationCap, color: AppColors.bgDeep, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    data['platform'] as String,
                    style: GoogleFonts.inter(
                        fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.bgDeep),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _MetaRow(icon: FontAwesomeIcons.user, text: data['instructors'] as String, color: AppColors.textSecondary),
            const SizedBox(height: 10),
            _MetaRow(icon: FontAwesomeIcons.calendarDay, text: data['date'] as String, color: AppColors.textSecondary),
            const SizedBox(height: 10),
            _MetaRow(icon: FontAwesomeIcons.clock, text: data['hours'] as String, color: AppColors.accentTeal),
            const SizedBox(height: 24),
            _OpenCertButton(accent: accent, onOpen: onOpen),
          ],
        ),

        const SizedBox(width: 36),

        // Right panel
        Expanded(child: _CertContent(data: data, accent: accent)),
      ],
    );
  }
}

class _FeaturedNarrowLayout extends StatelessWidget {
  final Map<String, dynamic> data;
  final Color accent;
  final VoidCallback onOpen;

  const _FeaturedNarrowLayout({required this.data, required this.accent, required this.onOpen});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [accent, AppColors.accentPurple]),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const FaIcon(FontAwesomeIcons.graduationCap, color: AppColors.bgDeep, size: 14),
                  const SizedBox(width: 7),
                  Text(data['platform'] as String,
                      style: GoogleFonts.inter(
                          fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.bgDeep)),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _CertContent(data: data, accent: accent),
        const SizedBox(height: 20),
        Row(
          children: [
            _MetaRow(icon: FontAwesomeIcons.calendarDay, text: data['date'] as String, color: AppColors.textSecondary),
            const SizedBox(width: 20),
            _MetaRow(icon: FontAwesomeIcons.clock, text: data['hours'] as String, color: AppColors.accentTeal),
          ],
        ),
        const SizedBox(height: 20),
        _OpenCertButton(accent: accent, onOpen: onOpen),
      ],
    );
  }
}

class _CertContent extends StatelessWidget {
  final Map<String, dynamic> data;
  final Color accent;

  const _CertContent({required this.data, required this.accent});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: accent.withValues(alpha: 0.4)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.verified_rounded, size: 13, color: accent),
                  const SizedBox(width: 5),
                  Text('Certificate of Completion',
                      style: GoogleFonts.inter(
                          fontSize: 11, fontWeight: FontWeight.w600, color: accent)),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          data['title'] as String,
          style: GoogleFonts.inter(
              fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.textPrimary, height: 1.3),
        ),
        const SizedBox(height: 12),
        Text(
          data['description'] as String,
          style: GoogleFonts.inter(
              fontSize: 14, color: AppColors.textSecondary, height: 1.75),
        ),
        const SizedBox(height: 20),
        // Topics section
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: accent.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: accent.withValues(alpha: 0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.menu_book_rounded, size: 15, color: accent),
                  const SizedBox(width: 8),
                  Text('Topics Covered',
                      style: GoogleFonts.inter(
                          fontSize: 13, fontWeight: FontWeight.w700, color: accent, letterSpacing: 0.3)),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: (data['topics'] as List<dynamic>)
                    .map((t) => _TopicChip(label: t as String, color: accent))
                    .toList(),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Certificate number
        if ((data['certNo'] as String).isNotEmpty)
          Row(
            children: [
              Icon(Icons.tag_rounded, size: 13, color: AppColors.textMuted),
              const SizedBox(width: 6),
              Text(
                'Cert: ${data['certNo']}',
                style: GoogleFonts.inter(fontSize: 11, color: AppColors.textMuted),
              ),
            ],
          ),
      ],
    );
  }
}

class _OpenCertButton extends StatefulWidget {
  final Color accent;
  final VoidCallback onOpen;

  const _OpenCertButton({required this.accent, required this.onOpen});

  @override
  State<_OpenCertButton> createState() => _OpenCertButtonState();
}

class _OpenCertButtonState extends State<_OpenCertButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onOpen,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 13),
          decoration: BoxDecoration(
            gradient: _hovered
                ? LinearGradient(
                    colors: [widget.accent, widget.accent.withValues(alpha: 0.7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: _hovered ? null : widget.accent.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _hovered ? widget.accent : widget.accent.withValues(alpha: 0.4),
            ),
            boxShadow: _hovered
                ? [BoxShadow(color: widget.accent.withValues(alpha: 0.35), blurRadius: 20)]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              FaIcon(
                FontAwesomeIcons.filePdf,
                size: 15,
                color: _hovered ? AppColors.bgDeep : widget.accent,
              ),
              const SizedBox(width: 9),
              Text(
                'View Certificate',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: _hovered ? AppColors.bgDeep : widget.accent,
                ),
              ),
              const SizedBox(width: 8),
              FaIcon(
                FontAwesomeIcons.upRightFromSquare,
                size: 11,
                color: _hovered ? AppColors.bgDeep : widget.accent.withValues(alpha: 0.7),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Shared helpers
class _TopicChip extends StatelessWidget {
  final String label;
  final Color color;

  const _TopicChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(fontSize: 12, color: color, fontWeight: FontWeight.w500),
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;

  const _MetaRow({required this.icon, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        FaIcon(icon, size: 13, color: color),
        const SizedBox(width: 8),
        Text(text,
            style: GoogleFonts.inter(fontSize: 13, color: color, fontWeight: FontWeight.w500)),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;

  const _InfoRow({required this.icon, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 8),
        Expanded(
          child: Text(text,
              style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary)),
        ),
      ],
    );
  }
}
