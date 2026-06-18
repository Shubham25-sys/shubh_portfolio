import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import 'resume_download_button.dart';

class NavBar extends StatefulWidget {
  final Function(String) onNavTap;

  const NavBar({super.key, required this.onNavTap});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  bool _mobileMenuOpen = false;

  static const List<Map<String, String>> _navItems = [
    {'key': 'home', 'label': 'Home'},
    {'key': 'about', 'label': 'About'},
    {'key': 'skills', 'label': 'Skills'},
    {'key': 'experience', 'label': 'Experience'},
    {'key': 'projects', 'label': 'Projects'},
    {'key': 'education', 'label': 'Education'},
    {'key': 'contact', 'label': 'Contact'},
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isWide = width > 900;

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Column(
        children: [
          ClipRect(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.bgDeep.withValues(alpha: 0.92),
                border: const Border(
                  bottom: BorderSide(color: AppColors.borderColor, width: 1),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.4),
                    blurRadius: 24,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isWide ? 60 : 20,
                    vertical: 14,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Logo
                      GestureDetector(
                        onTap: () => widget.onNavTap('home'),
                        child: ShaderMask(
                          shaderCallback: (bounds) =>
                              AppColors.accentGradient.createShader(bounds),
                          child: Text(
                            'Shubham Wani',
                            style: GoogleFonts.inter(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ),
                      ),

                      if (isWide)
                        Row(
                          children: [
                            ..._navItems.map((item) => _NavItem(
                                  label: item['label']!,
                                  onTap: () => widget.onNavTap(item['key']!),
                                )),
                            const SizedBox(width: 12),
                            const ResumeDownloadButton(
                              style: ResumeButtonStyle.minimal,
                              fontSize: 13,
                            ),
                          ],
                        )
                      else
                        IconButton(
                          icon: Icon(
                            _mobileMenuOpen ? Icons.close_rounded : Icons.menu_rounded,
                            color: AppColors.accentTeal,
                            size: 26,
                          ),
                          onPressed: () =>
                              setState(() => _mobileMenuOpen = !_mobileMenuOpen),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Mobile menu
          if (_mobileMenuOpen && !isWide)
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.bgSurface.withValues(alpha: 0.98),
                border: const Border(
                  bottom: BorderSide(color: AppColors.borderColor),
                ),
              ),
              child: Column(
                children: _navItems
                    .map((item) => InkWell(
                          onTap: () {
                            setState(() => _mobileMenuOpen = false);
                            widget.onNavTap(item['key']!);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 14),
                            child: Row(
                              children: [
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: const BoxDecoration(
                                    color: AppColors.accentTeal,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  item['label']!,
                                  style: GoogleFonts.inter(
                                    fontSize: 15,
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ).animate().fadeIn(duration: 200.ms).slideY(begin: -0.05, end: 0),
        ],
      )
          .animate()
          .fadeIn(duration: 600.ms)
          .slideY(begin: -1, end: 0, duration: 600.ms, curve: Curves.easeOut),
    );
  }
}

class _NavItem extends StatefulWidget {
  final String label;
  final VoidCallback onTap;

  const _NavItem({required this.label, required this.onTap});

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> {
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
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.label,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: _hovered ? AppColors.accentTeal : AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 3),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 2,
                width: _hovered ? 20 : 0,
                decoration: BoxDecoration(
                  color: AppColors.accentTeal,
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
