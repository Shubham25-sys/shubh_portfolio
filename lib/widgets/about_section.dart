import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../data/portfolio_data.dart';
import 'section_title.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isWide = width > 900;
    final hPad = width > 1200 ? (width - 1200) / 2 + 40.0 : (width > 768 ? 80.0 : 24.0);

    return Container(
      width: double.infinity,
      color: AppColors.bgSurface,
      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(
            title: 'About Me',
            subtitle: 'A passionate developer building impactful digital experiences',
          ),
          if (isWide)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 2, child: _AvatarCard()),
                const SizedBox(width: 60),
                Expanded(flex: 3, child: _AboutContent()),
              ],
            )
          else
            Column(
              children: [
                _AvatarCard(),
                const SizedBox(height: 40),
                _AboutContent(),
              ],
            ),
        ],
      ),
    );
  }
}

class _AvatarCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Profile photo with animated gradient ring
        Stack(
          alignment: Alignment.center,
          children: [
            // Outer pulsing glow ring
            Container(
              width: 224,
              height: 224,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const SweepGradient(
                  colors: [
                    AppColors.accentTeal,
                    AppColors.accentBlue,
                    AppColors.accentPurple,
                    AppColors.accentTeal,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accentTeal.withValues(alpha: 0.35),
                    blurRadius: 40,
                    spreadRadius: 4,
                  ),
                ],
              ),
            )
                .animate(onPlay: (c) => c.repeat())
                .rotate(duration: 4000.ms, curve: Curves.linear),

            // Dark ring separator
            Container(
              width: 216,
              height: 216,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.bgSurface,
              ),
            ),

            // Photo
            Container(
              width: 208,
              height: 208,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/images/profile.jpg',
                  fit: BoxFit.cover,
                  width: 208,
                  height: 208,
                  errorBuilder: (ctx, obj, err) => Container(
                    width: 208,
                    height: 208,
                    color: AppColors.bgCard,
                    child: Center(
                      child: ShaderMask(
                        shaderCallback: (bounds) =>
                            AppColors.accentGradient.createShader(bounds),
                        child: Text(
                          'SW',
                          style: GoogleFonts.inter(
                            fontSize: 56,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Online badge
            Positioned(
              bottom: 12,
              right: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  gradient: AppColors.tealBlueGradient,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accentTeal.withValues(alpha: 0.5),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                        color: AppColors.bgDeep,
                        shape: BoxShape.circle,
                      ),
                    )
                        .animate(onPlay: (c) => c.repeat())
                        .scale(
                          begin: const Offset(1, 1),
                          end: const Offset(1.5, 1.5),
                          duration: 800.ms,
                        )
                        .then()
                        .scale(
                          begin: const Offset(1.5, 1.5),
                          end: const Offset(1, 1),
                          duration: 800.ms,
                        ),
                    const SizedBox(width: 5),
                    Text(
                      'Available',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AppColors.bgDeep,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        )
            .animate()
            .fadeIn(delay: 200.ms, duration: 700.ms)
            .scale(begin: const Offset(0.85, 0.85), end: const Offset(1, 1)),

        const SizedBox(height: 32),

        // Stats grid
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.5,
          physics: const NeverScrollableScrollPhysics(),
          children: PortfolioData.stats
              .asMap()
              .entries
              .map(
                (e) => _StatCard(
                  value: e.value['value'] as String,
                  label: e.value['label'] as String,
                  delay: (e.key * 100).ms,
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class _StatCard extends StatefulWidget {
  final String value, label;
  final Duration delay;

  const _StatCard({required this.value, required this.label, required this.delay});

  @override
  State<_StatCard> createState() => _StatCardState();
}

class _StatCardState extends State<_StatCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          gradient: _hovered
              ? const LinearGradient(
                  colors: [Color(0xFF142850), Color(0xFF0F2040)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : AppColors.cardGradient,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _hovered ? AppColors.accentTeal.withValues(alpha: 0.5) : AppColors.borderColor,
          ),
          boxShadow: _hovered
              ? [BoxShadow(color: AppColors.shadowTeal, blurRadius: 16)]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ShaderMask(
              shaderCallback: (bounds) =>
                  AppColors.accentGradient.createShader(bounds),
              child: Text(
                widget.value,
                style: GoogleFonts.inter(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              widget.label,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ).animate().fadeIn(delay: widget.delay + 400.ms, duration: 500.ms).scale(
            begin: const Offset(0.9, 0.9),
            end: const Offset(1, 1),
            delay: widget.delay + 400.ms,
          ),
    );
  }
}

class _AboutContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Passionate Flutter Developer crafting\nbeautiful cross-platform experiences',
          style: GoogleFonts.inter(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
            height: 1.4,
          ),
        ).animate().fadeIn(delay: 300.ms, duration: 600.ms).slideX(begin: 0.1, end: 0),

        const SizedBox(height: 20),

        Text(
          PortfolioData.summary,
          style: GoogleFonts.inter(
            fontSize: 15,
            color: AppColors.textSecondary,
            height: 1.8,
          ),
        ).animate().fadeIn(delay: 400.ms, duration: 600.ms),

        const SizedBox(height: 32),

        // Key highlights
        ..._highlights.asMap().entries.map(
              (e) => _HighlightRow(
                icon: e.value['icon'] as IconData,
                title: e.value['title'] as String,
                value: e.value['value'] as String,
                delay: (e.key * 80 + 500).ms,
              ),
            ),
      ],
    );
  }

  static const List<Map<String, dynamic>> _highlights = [
    {'icon': Icons.location_on_rounded, 'title': 'Location', 'value': PortfolioData.location},
    {'icon': Icons.email_rounded, 'title': 'Email', 'value': PortfolioData.email},
    {'icon': Icons.phone_rounded, 'title': 'Phone', 'value': PortfolioData.phone},
    {'icon': Icons.school_rounded, 'title': 'Education', 'value': 'MCA – BAMU, CGPA 8.0'},
    {'icon': Icons.work_rounded, 'title': 'Current Role', 'value': 'Associate Software Developer @ BinYuga'},
  ];
}

class _HighlightRow extends StatelessWidget {
  final IconData icon;
  final String title, value;
  final Duration delay;

  const _HighlightRow({
    required this.icon,
    required this.title,
    required this.value,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.accentTeal.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.accentTeal.withValues(alpha: 0.25)),
            ),
            child: Icon(icon, color: AppColors.accentTeal, size: 16),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppColors.textMuted,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: delay, duration: 500.ms).slideX(begin: 0.1, end: 0);
  }
}
