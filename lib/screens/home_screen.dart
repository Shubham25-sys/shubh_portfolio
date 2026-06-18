import 'package:flutter/material.dart';
import '../widgets/nav_bar.dart';
import '../widgets/hero_section.dart';
import '../widgets/about_section.dart';
import '../widgets/skills_section.dart';
import '../widgets/experience_section.dart';
import '../widgets/projects_section.dart';
import '../widgets/education_section.dart';
import '../widgets/contact_section.dart';
import '../widgets/footer_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scrollController = ScrollController();

  final _heroKey = GlobalKey();
  final _aboutKey = GlobalKey();
  final _skillsKey = GlobalKey();
  final _experienceKey = GlobalKey();
  final _projectsKey = GlobalKey();
  final _educationKey = GlobalKey();
  final _contactKey = GlobalKey();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollTo(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOutCubic,
        alignment: 0.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050B18),
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                HeroSection(
                  key: _heroKey,
                  onContactTap: () => _scrollTo(_contactKey),
                  onProjectsTap: () => _scrollTo(_projectsKey),
                ),
                AboutSection(key: _aboutKey),
                SkillsSection(key: _skillsKey),
                ExperienceSection(key: _experienceKey),
                ProjectsSection(key: _projectsKey),
                EducationSection(key: _educationKey),
                ContactSection(key: _contactKey),
                const FooterWidget(),
              ],
            ),
          ),
          NavBar(
            onNavTap: (section) {
              switch (section) {
                case 'home':
                  _scrollTo(_heroKey);
                case 'about':
                  _scrollTo(_aboutKey);
                case 'skills':
                  _scrollTo(_skillsKey);
                case 'experience':
                  _scrollTo(_experienceKey);
                case 'projects':
                  _scrollTo(_projectsKey);
                case 'education':
                  _scrollTo(_educationKey);
                case 'contact':
                  _scrollTo(_contactKey);
                default:
                  break;
              }
            },
          ),
        ],
      ),
    );
  }
}
