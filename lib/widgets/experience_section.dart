import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../data/portfolio_data.dart';
import 'section_title.dart';

class ExperienceSection extends StatelessWidget {
  const ExperienceSection({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final hPad = width > 1200 ? (width - 1200) / 2 + 40.0 : (width > 768 ? 80.0 : 24.0);

    return Container(
      width: double.infinity,
      color: AppColors.bgSurface,
      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(
            title: 'Experience',
            subtitle: 'My professional journey and contributions',
          ),
          ...PortfolioData.experience.asMap().entries.map(
                (e) => _TimelineItem(
                  data: e.value,
                  index: e.key,
                  isLast: e.key == PortfolioData.experience.length - 1,
                ),
              ),
        ],
      ),
    );
  }
}

class _TimelineItem extends StatefulWidget {
  final Map<String, dynamic> data;
  final int index;
  final bool isLast;

  const _TimelineItem({
    required this.data,
    required this.index,
    required this.isLast,
  });

  @override
  State<_TimelineItem> createState() => _TimelineItemState();
}

class _TimelineItemState extends State<_TimelineItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isCurrent = widget.data['current'] as bool;
    final delay = (widget.index * 150).ms;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline column
          SizedBox(
            width: 28,
            child: Column(
              children: [
                // Dot
                Container(
                  width: 20,
                  height: 20,
                  margin: const EdgeInsets.only(top: 24),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: isCurrent ? AppColors.tealBlueGradient : null,
                    color: isCurrent ? null : AppColors.bgCard,
                    border: isCurrent
                        ? null
                        : Border.all(color: AppColors.borderColor, width: 2),
                    boxShadow: isCurrent
                        ? [BoxShadow(color: AppColors.shadowTeal, blurRadius: 12)]
                        : null,
                  ),
                  child: isCurrent
                      ? null
                      : Center(
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.accentBlue,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                ),
                // Line
                if (!widget.isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.accentTeal.withValues(alpha: 0.5),
                            AppColors.borderColor.withValues(alpha: 0.3),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 24),

          // Content
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: widget.isLast ? 0 : 40),
              child: MouseRegion(
                onEnter: (_) => setState(() => _hovered = true),
                onExit: (_) => setState(() => _hovered = false),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    gradient: _hovered
                        ? LinearGradient(
                            colors: [
                              AppColors.accentTeal.withValues(alpha: 0.05),
                              AppColors.bgCard,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : AppColors.cardGradient,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _hovered
                          ? AppColors.accentTeal.withValues(alpha: 0.4)
                          : AppColors.borderColor,
                    ),
                    boxShadow: _hovered
                        ? [BoxShadow(color: AppColors.shadowTeal, blurRadius: 20)]
                        : null,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header row
                      Wrap(
                        spacing: 10,
                        runSpacing: 8,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                            widget.data['title'] as String,
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          if (isCurrent)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 3),
                              decoration: BoxDecoration(
                                gradient: AppColors.tealBlueGradient,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'Current',
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.bgDeep,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.business_rounded,
                              size: 14, color: AppColors.accentTeal),
                          const SizedBox(width: 6),
                          Text(
                            '${widget.data['company']}  •  ${widget.data['type']}',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: AppColors.accentTeal,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.calendar_month_rounded,
                              size: 14, color: AppColors.textMuted),
                          const SizedBox(width: 6),
                          Text(
                            widget.data['duration'] as String,
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Divider(color: AppColors.borderColor, height: 1),
                      const SizedBox(height: 16),
                      ...(widget.data['points'] as List<String>).map(
                        (point) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 7),
                                child: Container(
                                  width: 5,
                                  height: 5,
                                  decoration: BoxDecoration(
                                    color: AppColors.accentTeal.withValues(alpha: 0.8),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  point,
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    color: AppColors.textSecondary,
                                    height: 1.65,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(delay: delay + 200.ms, duration: 600.ms)
        .slideX(begin: -0.08, end: 0, curve: Curves.easeOut);
  }
}
