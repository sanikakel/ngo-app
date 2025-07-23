import 'package:flutter/material.dart';
import '../widgets/info_card.dart';
import '../accessibility/font_size_provider.dart';

class UnderprivilegedInfoScreen extends StatelessWidget {
  final FontSizeNotifier fontSizeNotifier;

  const UnderprivilegedInfoScreen({required this.fontSizeNotifier, super.key});

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
          // Health & Mental Wellness
          InfoCard(
            title: "Health Manual",
            description: "Comprehensive health guide for elderly care.",
            url: "https://main.mohfw.gov.in/sites/default/files/SeniorCitizenHealthCareManual.pdf",
            fontSizeNotifier: fontSizeNotifier,
          ),
          InfoCard(
            title: "Yoga for Seniors",
            description: "Safe yoga practices to stay active.",
            url: "https://youtu.be/RS3P6sfFh8A",
            fontSizeNotifier: fontSizeNotifier,
          ),
          InfoCard(
            title: "Mental Wellness Guide",
            description: "Support and care for mental well-being.",
            url: "https://nimhans.ac.in/wp-content/uploads/2022/10/Senior-Citizens-English.pdf",
            fontSizeNotifier: fontSizeNotifier,
          ),

          // Digital Literacy
          InfoCard(
            title: "Digital India Guide",
            description: "Learn smartphone basics and online tools.",
            url: "https://www.meity.gov.in/writereaddata/files/Initiative%20for%20senior%20citizens.pdf",
            fontSizeNotifier: fontSizeNotifier,
          ),
          InfoCard(
            title: "Smartphone Basics",
            description: "YouTube guide for using smartphones.",
            url: "https://youtu.be/fQFie73MRz0",
            fontSizeNotifier: fontSizeNotifier,
          ),

          // Brain Games
          InfoCard(
            title: "BrainCurls",
            description: "Fun brain games for seniors.",
            url: "https://www.braincurls.com/",
            fontSizeNotifier: fontSizeNotifier,
          ),
          InfoCard(
            title: "Games for the Brain",
            description: "Word and memory games.",
            url: "https://www.gamesforthebrain.com/",
            fontSizeNotifier: fontSizeNotifier,
          ),
          InfoCard(
            title: "Jigsaw Planet",
            description: "Play relaxing jigsaw puzzles online.",
            url: "https://www.jigsawplanet.com/",
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
import 'package:ngo_app/resources/specially_abled_info.dart';
import '../widgets/info_card.dart';

class UnderprivilegedInfoScreen extends StatelessWidget {
  final FontSizeNotifier fontSizeNotifier;

  UnderprivilegedInfoScreen({required this.fontSizeNotifier, super.key});
  
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        InfoCard(title: "Helpline Numbers", description: "Emergency support numbers for women.", fontSizeNotifier: fontSizeNotifier),
        InfoCard(title: "Skill-building Courses", description: "Links to free online courses.", fontSizeNotifier: fontSizeNotifier),
        InfoCard(title: "Safety Resources", description: "PDFs and videos on safety awareness.", fontSizeNotifier: fontSizeNotifier),
      ],
    );
  }
}
*/