import 'package:flutter/material.dart';
import '../widgets/info_card.dart';
import '../accessibility/font_size_provider.dart';

class SpeciallyAbledInfoScreen extends StatelessWidget {
  final FontSizeNotifier fontSizeNotifier;

  const SpeciallyAbledInfoScreen({required this.fontSizeNotifier, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Resources", style: TextStyle(fontSize: fontSizeNotifier.value)),
        leading: BackButton(),
      ),
      body: ListView(
        padding: const EdgeInsets.all(12.0),
        children: [
          const SizedBox(height: 8),
          InfoCard(
            title: "NCERT Audiobooks",
            description: "Textbooks in audio format for visually impaired students.",
            url: "https://ncert.nic.in/audio-books.php",
            fontSizeNotifier: fontSizeNotifier,
          ),
          InfoCard(
            title: "Enable India YouTube Channel",
            description: "Training and job readiness for persons with disabilities.",
            url: "https://www.youtube.com/@EnableIndia",
            fontSizeNotifier: fontSizeNotifier,
          ),
          InfoCard(
            title: "WHO Assistive Tech PDF",
            description: "Global guidelines for assistive technologies.",
            url: "https://www.who.int/publications/i/item/9789241516853",
            fontSizeNotifier: fontSizeNotifier,
          ),
          InfoCard(
            title: "Indian Sign Language Basics",
            description: "Learn Indian Sign Language (ISLRTC official playlist).",
            url: "https://www.youtube.com/playlist?list=PL97A6C90727C01DB7",
            fontSizeNotifier: fontSizeNotifier,
          ),
          InfoCard(
            title: "Rights of Persons with Disabilities Act",
            description: "Detailed PDF of the RPwD Act in India.",
            url: "https://legislative.gov.in/sites/default/files/A2016-49_1.pdf",
            fontSizeNotifier: fontSizeNotifier,
          ),
          InfoCard(
            title: "Malvika Iyer TED Talk",
            description: "Disability is not Inability - inspirational TEDx talk.",
            url: "https://youtu.be/j8d6RNuW-Mg",
            fontSizeNotifier: fontSizeNotifier,
          ),
        ],
      ),
    );
  }
}



/*
import 'package:flutter/material.dart';
import 'package:ngo_app/accessibility/font_size_provider.dart';
import '../widgets/info_card.dart';

class SpeciallyAbledInfoScreen extends StatelessWidget {
  final FontSizeNotifier fontSizeNotifier;

  SpeciallyAbledInfoScreen({required this.fontSizeNotifier, super.key});
  
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        InfoCard(title: "Disability Rights Info", description: "Know your rights and support services.", fontSizeNotifier: fontSizeNotifier),
        InfoCard(title: "Learning Tools", description: "Apps and sites for differently-abled education.", fontSizeNotifier: fontSizeNotifier),
        InfoCard(title: "Assistive Tech", description: "Resources for visually/audibly impaired users.", fontSizeNotifier: fontSizeNotifier),
      ],
    );
  }
}
*/