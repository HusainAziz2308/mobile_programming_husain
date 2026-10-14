import 'package:flutter/material.dart';

void main() {
  runApp(const ProfileCardApp());
}

class ProfileCardApp extends StatelessWidget {
  const ProfileCardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kartu Profil',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4056D6),
        ),
        scaffoldBackgroundColor: const Color(0xFFF4F6FC),
      ),
      home: const ProfileCardPage(),
    );
  }
}

class ProfileCardPage extends StatelessWidget {
  const ProfileCardPage({super.key});

  static const Color navy = Color(0xFF172554);
  static const Color blue = Color(0xFF4056D6);
  static const Color muted = Color(0xFF64748B);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(

        child: LayoutBuilder(
          builder: (context, constraints) {
            final bool isWide = constraints.maxWidth > 600;

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: isWide ? 40 : 20,
                vertical: 28,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1000),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'KARTU PROFIL',
                                  style: TextStyle(
                                    color: blue,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 2,
                                  ),
                                ),
                                SizedBox(height: 7),
                                Text(
                                  'Kenali saya lebih dekat',
                                  style: TextStyle(
                                    color: navy,
                                    fontSize: 25,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (isWide)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 9,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                  color: const Color(0xFFE3E8F4),
                                ),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.person_outline_rounded,
                                    size: 17,
                                    color: blue,
                                  ),
                                  SizedBox(width: 7),
                                  Text(
                                    'PORTOFOLIO PRIBADI',
                                    style: TextStyle(
                                      color: navy,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(isWide ? 32 : 22),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(
                            color: const Color(0xFFE7EAF3),
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x0B172554),
                              blurRadius: 28,
                              offset: Offset(0, 12),
                            ),
                          ],
                        ),
                        child: isWide
                            ? const Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Center(child: _ProfileAvatar()),
                                  ),
                                  SizedBox(width: 30),
                                  Expanded(
                                    flex: 5,
                                    child: _ProfileIntroduction(
                                      isWide: true,
                                    ),
                                  ),
                                ],
                              )
                            : const Column(
                                children: [
                                  _ProfileAvatar(),
                                  SizedBox(height: 20),
                                  _ProfileIntroduction(isWide: false),
                                ],
                              ),
                      ),
                      const SizedBox(height: 20),

                      _InformationCard(
                        title: 'Kontak & Sosial',
                        subtitle: 'Temukan saya melalui',
                        child: const Row(
                          children: [
                            Expanded(
                              child: _ContactItem(
                                icon: Icons.alternate_email_rounded,
                                label: 'Email',
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: _ContactItem(
                                icon: Icons.phone_in_talk_outlined,
                                label: 'Telepon',
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: _ContactItem(
                                icon: Icons.code_rounded,
                                label: 'GitHub',
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      _InformationCard(
                        title: 'Keahlian',
                        subtitle: 'Teknologi yang sedang saya pelajari',
                        child: const Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            _SkillChip(label: 'Flutter & Dart'),
                            _SkillChip(label: 'Laravel'),
                            _SkillChip(label: 'UI/UX Design'),
                            _SkillChip(label: 'MySQL Database'),
                            _SkillChip(label: 'Conceping Aplication'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Center(
                        child: Text(
                          'Dibuat dengan Flutter  •  2026',
                          style: TextStyle(
                            color: muted,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 154,
      height: 154,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 5,
            top: 5,
            child: Container(
              width: 138,
              height: 138,
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Color(0xFF536DFE), Color(0xFF9AA8FF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: ClipOval(
                child: Image.network(
                  '',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: const Color(0xFFE9EDFF),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.person_rounded,
                        size: 76,
                        color: Color(0xFF4056D6),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          
          Positioned(
            right: -1,
            bottom: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
              decoration: BoxDecoration(
                color: const Color(0xFF14804A),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.white, width: 3),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x1A000000),
                    blurRadius: 8,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle, size: 13, color: Colors.white),
                  SizedBox(width: 5),
                  Text(
                    'Available',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileIntroduction extends StatelessWidget {
  const _ProfileIntroduction({required this.isWide});

  final bool isWide;

  @override
  Widget build(BuildContext context) {
    final TextAlign textAlign = isWide ? TextAlign.left : TextAlign.center;
    final CrossAxisAlignment crossAxisAlignment = isWide
        ? CrossAxisAlignment.start
        : CrossAxisAlignment.center;

    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        const Text(
          'HALO, SAYA',
          style: TextStyle(
            color: ProfileCardPage.blue,
            fontSize: 12,
            fontWeight: FontWeight.w800,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Husain Aziz Al Rosyid',
          textAlign: textAlign,
          style: TextStyle(
            color: ProfileCardPage.navy,
            fontSize: isWide ? 32 : 27,
            height: 1.15,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.6,
          ),
        ),
        const SizedBox(height: 13),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
          decoration: BoxDecoration(
            color: const Color(0xFFEEF1FF),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.school_outlined, color: ProfileCardPage.blue, size: 18),
              SizedBox(width: 8),
              Flexible(
                child: Text(
                  'Mahasiswa Sistem Informasi • Semester 5',
                  style: TextStyle(
                    color: ProfileCardPage.navy,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Halo Dunia',
          textAlign: textAlign,
          style: const TextStyle(
            color: ProfileCardPage.muted,
            fontSize: 14,
            height: 1.7,
          ),
        ),
      ],
    );
  }
}

class _InformationCard extends StatelessWidget {
  const _InformationCard({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE7EAF3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: ProfileCardPage.navy,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            subtitle,
            style: const TextStyle(
              color: ProfileCardPage.muted,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 18),
          child,
        ],
      ),
    );
  }
}

class _ContactItem extends StatelessWidget {
  const _ContactItem({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: const Color(0xFFEEF1FF),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Icon(icon, color: ProfileCardPage.blue, size: 23),
        ),
        const SizedBox(height: 9),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: ProfileCardPage.navy,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _SkillChip extends StatelessWidget {
  const _SkillChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: const Icon(
        Icons.check_rounded,
        size: 17,
        color: ProfileCardPage.blue,
      ),
      label: Text(label),
      labelStyle: const TextStyle(
        color: ProfileCardPage.navy,
        fontSize: 12,
        fontWeight: FontWeight.w700,
      ),
      backgroundColor: const Color(0xFFF4F5FF),
      side: const BorderSide(color: Color(0xFFE0E5FF)),
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}
