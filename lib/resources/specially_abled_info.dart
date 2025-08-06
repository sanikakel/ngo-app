import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../accessibility/font_size_provider.dart';
import '../widgets/draggable_tts_fab.dart';

class SpeciallyAbledInfoScreen extends StatefulWidget {
  final FontSizeNotifier fontSizeNotifier;
  const SpeciallyAbledInfoScreen({required this.fontSizeNotifier, super.key});

  @override
  State<SpeciallyAbledInfoScreen> createState() => _SpeciallyAbledInfoScreenState();
}

class _SpeciallyAbledInfoScreenState extends State<SpeciallyAbledInfoScreen> {
  late List<_HelpfulLink> links;

  @override
  void initState() {
    super.initState();
    links = [
      _HelpfulLink(
        icon: '🎓',
        title: 'Skill India Digital',
        subtitle: '🎓 Free online courses and skill development programs.',
        url: 'https://www.skillindiadigital.gov.in/courses',
      ),
      _HelpfulLink(
        icon: '📚',
        title: 'Educational Resources',
        subtitle: '📚 Learning videos and educational content.',
        url: 'https://youtu.be/inpok4MKVLM',
      ),
      _HelpfulLink(
        icon: '💼',
        title: 'Career Guidance',
        subtitle: '💼 Professional development and career advice.',
        url: 'https://youtu.be/2MGMvEnoD6U',
      ),
      _HelpfulLink(
        icon: '🔧',
        title: 'Skill Development',
        subtitle: '🔧 Practical skills and vocational training.',
        url: 'https://youtu.be/DBxmADjQlI4',
      ),
      _HelpfulLink(
        icon: '🌟',
        title: 'Motivation & Success',
        subtitle: '🌟 Inspirational content and success stories.',
        url: 'https://youtu.be/1lD0HdR9zA8',
      ),
    ];
  }

  Future<void> _launchLink(String url) async {
    try {
      final uri = Uri.parse(url);
      
      if (await canLaunchUrl(uri)) {
        final result = await launchUrl(uri, mode: LaunchMode.externalApplication);
        
        if (!result && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Could not open link. Please try again.')),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Could not open link. Please check your internet connection.')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error opening link: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final fontSize = widget.fontSizeNotifier.value;
    // Collect all main visible text for TTS
    final ttsText = [
      'Helpful Links for Specially Abled Individuals.',
      'Resources and support for skill development and empowerment.',
      ...links.map((l) => l.title + '. ' + l.subtitle)
    ].join(' ');
    
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Color(0xFFF7FAFC),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: Text('Helpful Links', style: TextStyle(fontSize: fontSize + 2, color: Color(0xFF0057B8), fontWeight: FontWeight.bold)),
            leading: BackButton(color: Color(0xFF0057B8)),
            toolbarHeight: 80, // Increased height
            titleSpacing: 20, // Increased spacing
          ),
          body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text('🌟', style: TextStyle(fontSize: fontSize + 32)),
                    ),
                    SizedBox(height: 12),
                    Center(
                      child: Text(
                        'For Specially Abled Individuals',
                        style: TextStyle(fontSize: fontSize + 4, fontWeight: FontWeight.w600, color: Color(0xFF0057B8)),
                      ),
                    ),
                    SizedBox(height: 8),
                    Center(
                      child: Text(
                        'Resources and support for skill development and empowerment! Tap a link to explore.',
                        style: TextStyle(fontSize: fontSize, color: Colors.grey[700]),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 18),
                  ],
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                itemCount: links.length,
                itemBuilder: (context, index) {
                  final link = links[index];
                  return _HelpfulLinkWidget(
                    link: link,
                    fontSize: fontSize,
                    onTap: () => _launchLink(link.url),
                  );
                },
              ),
              SizedBox(height: 24),
            ],
          ),
        ),
        DraggableTTSFab(
          text: ttsText,
          fontSize: fontSize,
          volume: 1.0,
        ),
      ],
    );
  }
}

class _HelpfulLink {
  final String icon;
  final String title;
  final String subtitle;
  final String url;
  _HelpfulLink({required this.icon, required this.title, required this.subtitle, required this.url});
}

class _HelpfulLinkWidget extends StatelessWidget {
  final _HelpfulLink link;
  final double fontSize;
  final VoidCallback onTap;
  const _HelpfulLinkWidget({required this.link, required this.fontSize, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Color(0xFFE0E3E7), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: fontSize + 28,
                  height: fontSize + 28,
                  decoration: BoxDecoration(
                    color: Color(0xFFF2F4F8),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      link.icon,
                      style: TextStyle(fontSize: fontSize + 14),
                    ),
                  ),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        link.title,
                        style: TextStyle(
                          fontSize: fontSize + 3,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF222B45),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        link.subtitle,
                        style: TextStyle(fontSize: fontSize, color: Color(0xFF444B54)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(Icons.link, color: Color(0xFF0057B8), size: fontSize + 8),
                const SizedBox(width: 2),
                Icon(Icons.arrow_forward_ios, color: Colors.grey[350], size: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }
}