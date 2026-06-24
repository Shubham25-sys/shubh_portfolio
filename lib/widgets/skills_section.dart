import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../data/portfolio_data.dart';
import 'section_title.dart';

class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key});

  static const List<Color> _categoryColors = [
    AppColors.accentTeal,
    AppColors.accentPink,
    AppColors.accentBlue,
    AppColors.accentPurple,
    AppColors.accentTeal,
  ];

  // Power levels per category (anime DBZ style)
  static const List<int> _powerLevels = [95, 88, 80, 87, 83];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final hPad = width > 1200 ? (width - 1200) / 2 + 40.0 : (width > 768 ? 80.0 : 24.0);
    final isWide = width > 700;
    final categories = PortfolioData.skills.entries.toList();

    return Container(
      width: double.infinity,
      color: AppColors.bgDeep,
      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(
            title: 'Skills',
            subtitle: 'Technologies and tools I work with',
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isWide ? 3 : 1,
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
              childAspectRatio: isWide ? 1.05 : 1.7,
            ),
            itemCount: categories.length,
            itemBuilder: (context, i) => _SkillCard(
              title: categories[i].key,
              skills: categories[i].value,
              accentColor: _categoryColors[i % _categoryColors.length],
              delay: (i * 100).ms,
              powerLevel: _powerLevels[i % _powerLevels.length],
            ),
          ),
        ],
      ),
    );
  }
}

class _SkillCard extends StatefulWidget {
  final String title;
  final List<String> skills;
  final Color accentColor;
  final Duration delay;
  final int powerLevel;

  const _SkillCard({
    required this.title,
    required this.skills,
    required this.accentColor,
    required this.delay,
    required this.powerLevel,
  });

  @override
  State<_SkillCard> createState() => _SkillCardState();
}

class _SkillCardState extends State<_SkillCard>
    with SingleTickerProviderStateMixin {
  bool _hovered = false;
  late final AnimationController _powerCtrl;
  late final Animation<double> _powerAnim;

  @override
  void initState() {
    super.initState();
    _powerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );
    _powerAnim = CurvedAnimation(
      parent: _powerCtrl,
      curve: Curves.elasticOut,
    );
    // Trigger after card entrance delay
    Future.delayed(widget.delay + const Duration(milliseconds: 700), () {
      if (mounted) _powerCtrl.forward();
    });
  }

  @override
  void dispose() {
    _powerCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: _hovered
              ? LinearGradient(
                  colors: [
                    widget.accentColor.withValues(alpha: 0.08),
                    AppColors.bgCard,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : AppColors.cardGradient,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _hovered
                ? widget.accentColor.withValues(alpha: 0.5)
                : AppColors.borderColor,
            width: 1.5,
          ),
          boxShadow: _hovered
              ? [
                  BoxShadow(
                    color: widget.accentColor.withValues(alpha: 0.15),
                    blurRadius: 24,
                  ),
                ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category title row
            Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: widget.accentColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: widget.accentColor.withValues(alpha: 0.5),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  widget.title,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Skill chips
            Expanded(
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: widget.skills
                    .asMap()
                    .entries
                    .map(
                      (e) => _SkillChip(
                        label: e.value,
                        color: widget.accentColor,
                        delay: widget.delay + (e.key * 50).ms,
                      ),
                    )
                    .toList(),
              ),
            ),

            // ── Anime power bar ──────────────────────────────────────
            const SizedBox(height: 10),
            AnimatedBuilder(
              animation: _powerAnim,
              builder: (context, child) {
                final fill = (_powerAnim.value * widget.powerLevel / 100)
                    .clamp(0.0, 1.0);
                final displayLevel =
                    (_powerAnim.value * widget.powerLevel).clamp(0.0, widget.powerLevel.toDouble()).round();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'POWER LV.',
                          style: GoogleFonts.inter(
                            fontSize: 8,
                            color: widget.accentColor.withValues(alpha: 0.65),
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.8,
                          ),
                        ),
                        Text(
                          '$displayLevel%',
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            color: widget.accentColor,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Container(
                      height: 3,
                      decoration: BoxDecoration(
                        color: widget.accentColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: FractionallySizedBox(
                        widthFactor: fill,
                        alignment: Alignment.centerLeft,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                widget.accentColor,
                                widget.accentColor.withValues(alpha: 0.65),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(2),
                            boxShadow: [
                              BoxShadow(
                                color: widget.accentColor.withValues(alpha: 0.75),
                                blurRadius: 6,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(delay: widget.delay + 200.ms, duration: 600.ms)
        .slideY(begin: 0.15, end: 0, curve: Curves.easeOut);
  }
}

class _SkillChip extends StatefulWidget {
  final String label;
  final Color color;
  final Duration delay;

  const _SkillChip({required this.label, required this.color, required this.delay});

  @override
  State<_SkillChip> createState() => _SkillChipState();
}

class _SkillChipState extends State<_SkillChip> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: _hovered
              ? widget.color.withValues(alpha: 0.2)
              : widget.color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _hovered
                ? widget.color.withValues(alpha: 0.7)
                : widget.color.withValues(alpha: 0.25),
          ),
        ),
        child: Text(
          widget.label,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: _hovered ? widget.color : AppColors.textSecondary,
          ),
        ),
      ),
    ).animate().fadeIn(delay: widget.delay, duration: 400.ms).scale(
          begin: const Offset(0.8, 0.8),
          end: const Offset(1, 1),
          delay: widget.delay,
        );
  }
}
