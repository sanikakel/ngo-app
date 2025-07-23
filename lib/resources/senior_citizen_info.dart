import 'package:flutter/material.dart';
import '../widgets/info_card.dart';
import '../accessibility/font_size_provider.dart';

class SeniorCitizenInfoScreen extends StatelessWidget {
  final FontSizeNotifier fontSizeNotifier;

  const SeniorCitizenInfoScreen({required this.fontSizeNotifier, super.key});

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
          InfoCard(
            title: "Senior Citizen Health Manual",
            description: "Tap to open resource.",
            url: "https://main.mohfw.gov.in/sites/default/files/SeniorCitizenHealthCareManual.pdf",
            fontSizeNotifier: fontSizeNotifier,
          ),
          InfoCard(
            title: "Yoga for Seniors",
            description: "Tap to open resource.",
            url: "https://youtu.be/RS3P6sfFh8A",
            fontSizeNotifier: fontSizeNotifier,
          ),
          InfoCard(
            title: "Mental Wellness Guide (NIMHANS)",
            description: "Tap to open resource.",
            url: "https://nimhans.ac.in/wp-content/uploads/2022/10/Senior-Citizens-English.pdf",
            fontSizeNotifier: fontSizeNotifier,
          ),
          InfoCard(
            title: "Digital India for Seniors",
            description: "Tap to open guide.",
            url: "https://www.meity.gov.in/writereaddata/files/Initiative%20for%20senior%20citizens.pdf",
            fontSizeNotifier: fontSizeNotifier,
          ),
          InfoCard(
            title: "Smartphone Basics (YouTube)",
            description: "Tap to learn.",
            url: "https://youtu.be/fQFie73MRz0",
            fontSizeNotifier: fontSizeNotifier,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Text(
              "🧠 Brain Games for Seniors",
              style: TextStyle(fontSize: fontSizeNotifier.value + 2, fontWeight: FontWeight.bold),
            ),
          ),
          InfoCard(
            title: "BrainCurls",
            description: "Senior-friendly brain games",
            url: "https://www.braincurls.com/",
            fontSizeNotifier: fontSizeNotifier,
          ),
          InfoCard(
            title: "Games for the Brain",
            description: "Boost memory & logic",
            url: "https://www.gamesforthebrain.com/",
            fontSizeNotifier: fontSizeNotifier,
          ),
          InfoCard(
            title: "Arkadium Word Games",
            description: "Fun and interactive games",
            url: "https://www.arkadium.com/free-online-games/",
            fontSizeNotifier: fontSizeNotifier,
          ),
          InfoCard(
            title: "Helpful Memory Game",
            description: "Train your memory",
            url: "https://www.helpfulgames.com/subjects/brain-training/memory.html",
            fontSizeNotifier: fontSizeNotifier,
          ),
        ],
      ),
    );
  }
}



/*
import 'package:flutter/material.dart';
import '../widgets/info_card.dart';
import '../accessibility/font_size_provider.dart';

class SeniorCitizenInfoScreen extends StatelessWidget {
  final FontSizeNotifier fontSizeNotifier;

  SeniorCitizenInfoScreen({required this.fontSizeNotifier, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Senior Citizen Resources", style: TextStyle(fontSize: fontSizeNotifier.value)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          InfoCard(
            title: "Memory Games", 
            description: "Fun games to boost your brain.",
            fontSizeNotifier: fontSizeNotifier,
          ),
          InfoCard(
            title: "Exercise Videos", 
            description: "Gentle daily movement guides.",
            fontSizeNotifier: fontSizeNotifier,
          ),
          InfoCard(
            title: "Wellness Tips", 
            description: "Tips for a healthier lifestyle.",
            fontSizeNotifier: fontSizeNotifier),
        ]
      ),
    );
  }
}
*/
/*
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        InfoCard(
          title: "Memory Games", 
          description: "Fun games to boost your brain.",
          fontSizeNotifier: fontSizeNotifier,
          ),
        InfoCard(
          title: "Exercise Videos", 
          description: "Gentle daily movement guides.",
          fontSizeNotifier: fontSizeNotifier,
          ),
        InfoCard(
          title: "Wellness Tips", 
          description: "Tips for a healthier lifestyle.",
          fontSizeNotifier: fontSizeNotifier),
      ],
    );
  }
}
*/