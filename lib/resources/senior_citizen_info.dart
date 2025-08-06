import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../accessibility/font_size_provider.dart';
import '../widgets/draggable_tts_fab.dart';

class SeniorCitizenInfoScreen extends StatefulWidget {
  final FontSizeNotifier fontSizeNotifier;
  const SeniorCitizenInfoScreen({required this.fontSizeNotifier, super.key});

  @override
  State<SeniorCitizenInfoScreen> createState() => _SeniorCitizenInfoScreenState();
}

class _SeniorCitizenInfoScreenState extends State<SeniorCitizenInfoScreen> {
  late List<_GameCard> games;

  @override
  void initState() {
    super.initState();
    games = [
      _GameCard(
        icon: '♟️',
        title: 'Chess',
        subtitle: '♟️ Classic strategy game to boost thinking skills.',
        url: 'https://www.chess.com/',
      ),
      _GameCard(
        icon: '🔢',
        title: 'Sudoku',
        subtitle: '🔢 Number puzzle game for logical thinking.',
        url: 'https://sudoku.com/',
      ),
      _GameCard(
        icon: '🧠',
        title: 'Memory Training',
        subtitle: '🧠 Brain training games to improve memory.',
        url: 'https://www.helpfulgames.com/subjects/brain-training/memory.html',
      ),
      _GameCard(
        icon: '🧩',
        title: 'Jigsaw Puzzles',
        subtitle: '🧩 Relaxing puzzle games for focus and patience.',
        url: 'https://www.jigsawexplorer.com/',
      ),
      _GameCard(
        icon: '📝',
        title: 'Crossword Puzzles',
        subtitle: '📝 Word games to enhance vocabulary and recall.',
        url: 'https://www.boatloadpuzzles.com/playcrossword',
      ),
    ];
  }

  Future<void> _launchGame(String url) async {
    try {
      final uri = Uri.parse(url);
      
      if (await canLaunchUrl(uri)) {
        final result = await launchUrl(uri, mode: LaunchMode.externalApplication);
        
        if (!result && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Could not open game. Please try again.')),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Could not open game. Please check your internet connection.')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error opening game: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final fontSize = widget.fontSizeNotifier.value;
    // Collect all main visible text for TTS
    final ttsText = [
      'Memory-boosting Games for Senior Citizens.',
      'Fun games to keep your mind sharp and active.',
      ...games.map((g) => g.title + '. ' + g.subtitle)
    ].join(' ');
    
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Color(0xFFF7FAFC),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: Text('Memory-boosting Games', style: TextStyle(fontSize: fontSize + 2, color: Color(0xFF0057B8), fontWeight: FontWeight.bold)),
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
                      child: Text('🧠', style: TextStyle(fontSize: fontSize + 32)),
                    ),
                    SizedBox(height: 12),
                    Center(
                      child: Text(
                        'For Senior Citizens',
                        style: TextStyle(fontSize: fontSize + 4, fontWeight: FontWeight.w600, color: Color(0xFF0057B8)),
                      ),
                    ),
                    SizedBox(height: 8),
                    Center(
                      child: Text(
                        'Fun games to keep your mind sharp and active! Tap a game to play.',
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
                itemCount: games.length,
                itemBuilder: (context, index) {
                  final game = games[index];
                  return _GameCardWidget(
                    game: game,
                    fontSize: fontSize,
                    onTap: () => _launchGame(game.url),
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

class _GameCard {
  final String icon;
  final String title;
  final String subtitle;
  final String url;
  _GameCard({required this.icon, required this.title, required this.subtitle, required this.url});
}

class _GameCardWidget extends StatelessWidget {
  final _GameCard game;
  final double fontSize;
  final VoidCallback onTap;
  const _GameCardWidget({required this.game, required this.fontSize, required this.onTap});

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
                      game.icon,
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
                        game.title,
                        style: TextStyle(
                          fontSize: fontSize + 3,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF222B45),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        game.subtitle,
                        style: TextStyle(fontSize: fontSize, color: Color(0xFF444B54)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(Icons.play_arrow, color: Color(0xFF0057B8), size: fontSize + 8),
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