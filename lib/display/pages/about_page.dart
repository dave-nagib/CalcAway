import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:icons_plus/icons_plus.dart';
import '../widgets/drawer_navigator.dart';
import '../widgets/calcaway_app_bar.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  static const _divider = Divider(height: 0, color: Colors.white54);
  static const _devInfoTitleStyle = TextStyle(color: Colors.white, fontFamily: 'Saira', fontSize: 18.0, fontWeight: FontWeight.bold);
  static const _devInfoSubtitleStyle = TextStyle(color: Color(0xFFA8E8D4), fontFamily: 'REM', fontSize: 16.0);
  static const _iconColor = Colors.white70;
  static const _horizontalTitleGap = 8.0;

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  void _launchEmail(String email) {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
    );
    launchUrl(emailUri);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF131316),
      appBar: const CalcawayAppBar(),
      drawer: const DrawerNavigator(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            /// App Info Card
            Card(
              color: const Color(0xFF08090A),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
              elevation: 4,
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CalcAway',
                      style: TextStyle(color: Colors.white, fontFamily: 'Saira', fontSize: 26.0, fontWeight: FontWeight.bold),
                    ),
                    // SizedBox(height: 8),
                    Text(
                      'Version 2.0.0 · Released August 6, 2025',
                      style: TextStyle(color: Colors.white54, fontFamily: 'Saira', fontSize: 16.0, letterSpacing: 0.5),
                    ),
                    // SizedBox(height: 16),
                    Text(
                      'CalcAway is a simple monolithic (single device) POS application that helps you keep track of your item sales and receipts.',
                      style: TextStyle(color: Colors.white, fontFamily: 'Saira', fontSize: 18.0),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 7.0),

            /// Developer Contact Card
            Card(
              color: const Color(0xFF08090A),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 7.5, horizontal: 20.0),
                child: Column(
                  children: [
                    ListTile(
                      horizontalTitleGap: _horizontalTitleGap,
                      leading: const Icon(Icons.person, color: _iconColor),
                      title: const Text('Developer', style: _devInfoTitleStyle),
                      subtitle: Text('David Nagib', style: _devInfoSubtitleStyle.copyWith(color: Colors.white)),
                    ),
                    _divider,

                    ListTile(
                      horizontalTitleGap: _horizontalTitleGap,
                      leading: const Icon(Icons.email, color: _iconColor),
                      title: const Text('Email', style: _devInfoTitleStyle),
                      subtitle: const Text('davidnagib101@gmail.com', style: _devInfoSubtitleStyle),
                      onTap: () => _launchEmail('davidnagib101@gmail.com'),
                    ),
                    _divider,

                    ListTile(
                      horizontalTitleGap: _horizontalTitleGap,
                      leading: const Icon(Icons.facebook, color: _iconColor),
                      title: const Text('Facebook', style: _devInfoTitleStyle),
                      subtitle: const Text('David Michael', style: _devInfoSubtitleStyle),
                      onTap: () => _launchURL('https://www.facebook.com/profile.php?id=100001321243268'),
                    ),
                    _divider,

                    ListTile(
                      horizontalTitleGap: _horizontalTitleGap,
                      leading: const Icon(EvaIcons.linkedin, color: _iconColor),
                      title: const Text('LinkedIn', style: _devInfoTitleStyle),
                      subtitle: const Text('david-nagib', style: _devInfoSubtitleStyle),
                      onTap: () => _launchURL('https://www.linkedin.com/in/david-nagib'),
                    ),
                    _divider,

                    ListTile(
                      horizontalTitleGap: _horizontalTitleGap,
                      leading: const Icon(Bootstrap.github, color: _iconColor),
                      title: const Text('GitHub', style: _devInfoTitleStyle),
                      subtitle: const Text('dave-nagib', style: _devInfoSubtitleStyle),
                      onTap: () => _launchURL('https://github.com/dave-nagib'),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 18.0),

            /// Footer
            const Text(
              '© 2025 David Nagib. All rights reserved.',
              style: TextStyle(color: Colors.grey, fontFamily: 'Saira', fontSize: 18.0, letterSpacing: 0.5),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      )
    );
  }
}
