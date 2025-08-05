import 'package:flutter/material.dart';
import '../widgets/info_card.dart';
import '../accessibility/font_size_provider.dart';
import '../widgets/draggable_tts_fab.dart';

class UnderprivilegedInfoScreen extends StatefulWidget {
  final FontSizeNotifier fontSizeNotifier;
  const UnderprivilegedInfoScreen({required this.fontSizeNotifier, super.key});

  @override
  State<UnderprivilegedInfoScreen> createState() => _UnderprivilegedInfoScreenState();
}

class _UnderprivilegedInfoScreenState extends State<UnderprivilegedInfoScreen> {
  late List<_HealthTopic> topics;
  late List<bool> _bookmarked;

  @override
  void initState() {
    super.initState();
    topics = [
      _HealthTopic(
        icon: '✅',
        title: 'Daily Wellness Checklist',
        subtitle: '✔️ Track your daily habits with simple reminders.',
      ),
      _HealthTopic(
        icon: '🥗',
        title: 'Nutrition & Eating Right',
        subtitle: '🍎 Simple, affordable meals to stay strong and happy.',
      ),
      _HealthTopic(
        icon: '🧠',
        title: 'Mental Health & Self-Esteem',
        subtitle: '💬 Boost confidence and talk kindly to yourself.',
      ),
      _HealthTopic(
        icon: '🧼',
        title: 'Personal Hygiene',
        subtitle: '🛁 Clean habits for daily freshness and safety.',
      ),
      _HealthTopic(
        icon: '🏃‍♀️',
        title: 'Fitness & Movement',
        subtitle: '🕺 Easy daily movement ideas with no equipment needed.',
      ),
      _HealthTopic(
        icon: '🚨',
        title: "Safety and Saying 'No'",
        subtitle: '🙅‍♀️ Learn to protect yourself and speak up.',
      ),
      _HealthTopic(
        icon: '🌸',
        title: 'Menstrual Hygiene',
        subtitle: '🧼 Learn how to stay clean and healthy during your period.',
      ),
    ];
    _bookmarked = List.filled(topics.length, false);
  }

  void _toggleBookmark(int index) {
    setState(() {
      _bookmarked[index] = !_bookmarked[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    final fontSize = widget.fontSizeNotifier.value;
    // Collect all main visible text for TTS
    final ttsText = [
      'Health and Wellness. For Underprivileged Girls.',
      'Explore tips for a healthy, happy life! Tap a topic to learn more.',
      ...topics.map((t) => t.title + '. ' + t.subtitle)
    ].join(' ');
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Color(0xFFF7FAFC),
      appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: Text('Health & Wellness', style: TextStyle(fontSize: fontSize + 2, color: Color(0xFF0057B8), fontWeight: FontWeight.bold)),
            leading: BackButton(color: Color(0xFF0057B8)),
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
                      child: Text('🩺', style: TextStyle(fontSize: fontSize + 32)),
                    ),
                    SizedBox(height: 12),
                    Center(
                      child: Text(
                        'For Underprivileged Girls',
                        style: TextStyle(fontSize: fontSize + 4, fontWeight: FontWeight.w600, color: Color(0xFF0057B8)),
                      ),
                    ),
                    SizedBox(height: 8),
                    Center(
                      child: Text(
                        'Explore tips for a healthy, happy life! Tap a topic to learn more.',
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
                itemCount: topics.length,
                itemBuilder: (context, index) {
                  final topic = topics[index];
                  return _HealthTopicCard(
                    topic: topic,
                    fontSize: fontSize,
                    bookmarked: _bookmarked[index],
                    onBookmark: () => _toggleBookmark(index),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => _HealthTopicDetailScreen(
                            topic: topic,
                            fontSize: fontSize,
                          ),
                        ),
                      );
                    },
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

class _HealthTopic {
  final String icon;
  final String title;
  final String subtitle;
  _HealthTopic({required this.icon, required this.title, required this.subtitle});
}

class _HealthTopicCard extends StatelessWidget {
  final _HealthTopic topic;
  final double fontSize;
  final bool bookmarked;
  final VoidCallback onBookmark;
  final VoidCallback onTap;
  const _HealthTopicCard({required this.topic, required this.fontSize, required this.bookmarked, required this.onBookmark, required this.onTap});

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
                      topic.icon,
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
                        topic.title,
                        style: TextStyle(
                          fontSize: fontSize + 3,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF222B45),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        topic.subtitle,
                        style: TextStyle(fontSize: fontSize, color: Color(0xFF444B54)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    onBookmark();
                  },
                  child: Icon(
                    bookmarked ? Icons.bookmark : Icons.bookmark_border,
                    color: bookmarked ? Color(0xFF0057B8) : Color(0xFFB0B6C3),
                    size: fontSize + 8,
                  ),
                ),
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

class _HealthTopicDetailScreen extends StatelessWidget {
  final _HealthTopic topic;
  final double fontSize;
  const _HealthTopicDetailScreen({required this.topic, required this.fontSize});

  @override
  Widget build(BuildContext context) {
    Widget content;
    List<String> ttsBullets = [];
    switch (topic.title) {
      case 'Nutrition & Eating Right':
        ttsBullets = [
          'Nutrition during adolescence directly affects growth, immunity, and future reproductive health. Undernutrition and micronutrient deficiencies are especially common in underprivileged communities.',
          'A balanced diet should include carbohydrates (rice, chapati), proteins (dal, legumes, eggs), vegetables, fruits, and dairy where available.',
          'Iron-rich foods such as green leafy vegetables (e.g., spinach), jaggery, ragi, and groundnuts help prevent anaemia.',
          'Girls should consume 6–8 glasses of clean, safe water daily.',
          'Excessive consumption of processed foods, sugary snacks, and carbonated drinks should be avoided.',
        ];
        content = _BulletList(fontSize: fontSize, items: ttsBullets);
        break;
      case 'Mental Health & Self-Esteem':
        ttsBullets = [
          'Mental health is a vital component of overall health. Adolescents may experience emotional stress due to academic, social, or familial pressures.',
          'It is essential to identify and express emotions in a healthy manner.',
          'Seeking help is not a sign of weakness; talking to a trusted adult, teacher, or counsellor should be encouraged.',
          'Supportive environments that promote confidence, self-esteem, and non-judgmental communication are necessary.',
          'Engagement in creative activities, journaling, and group discussions can help build emotional resilience.',
        ];
        content = _BulletList(fontSize: fontSize, items: ttsBullets);
        break;
      case 'Personal Hygiene':
        ttsBullets = [
          'Maintaining personal hygiene is fundamental in preventing disease and ensuring social acceptance and self-respect.',
          'Daily bathing with clean water and mild soap is essential.',
          'Clothes, especially undergarments, should be washed and changed daily.',
          'Oral hygiene (brushing teeth twice a day) and regular nail trimming are also necessary.',
          'Hair should be kept clean and lice-free through regular washing and combing.',
        ];
        content = _BulletList(fontSize: fontSize, items: ttsBullets);
        break;
      case 'Fitness & Movement':
        ttsBullets = [
          'Regular physical activity is essential for healthy growth and development.',
          'A minimum of 30 minutes of physical movement per day is recommended — this can include walking, yoga, dancing, or outdoor games.',
          'Exercise improves cardiovascular health, strengthens muscles and bones, and enhances mental wellbeing.',
          'Stretching and good posture should be maintained to prevent body aches and improve concentration.',
        ];
        content = _BulletList(fontSize: fontSize, items: ttsBullets);
        break;
      case "Safety and Saying 'No'":
        ttsBullets = [
          'Safety education is a critical component of a girl\'s development and autonomy.',
          'Every girl has the right to personal space, safety, and dignity.',
          'Unwanted physical contact or inappropriate behavior must be immediately reported to a trusted authority (teacher, parent, or NGO representative).',
          'Girls should be taught to trust their instincts and say “NO” assertively when uncomfortable.',
          'It is important to be aware of local helpline numbers and safe spaces in case of emergencies.',
        ];
        content = _BulletList(fontSize: fontSize, items: ttsBullets);
        break;
      case 'Menstrual Hygiene':
        ttsBullets = [
          'Menstruation is a normal biological process and an essential indicator of reproductive health. Proper menstrual hygiene is crucial to prevent infections and promote dignity and confidence.',
          'Sanitary napkins or clean reusable cloth pads should be changed every 4–6 hours.',
          'Genital hygiene must be maintained by washing with clean water; the use of harsh soaps or intimate washes is discouraged.',
          'Used sanitary materials must be disposed of properly — ideally wrapped and discarded in a covered bin. They must not be flushed.',
          'Girls should be educated about the menstrual cycle to reduce stigma and ensure that discomfort or irregularities are reported to a healthcare provider.',
        ];
        content = _BulletList(fontSize: fontSize, items: ttsBullets);
        break;
      case 'Daily Wellness Checklist':
        ttsBullets = [
          'Daily Wellness Routine (Suggested).',
          'Eat three balanced meals. Nutritional health.',
          'Drink 6–8 glasses of water. Hydration and digestion.',
          'Bathe and wear clean clothes. Hygiene and confidence.',
          'Engage in 30 mins of physical activity. Fitness and mental clarity.',
          'Sleep 7–9 hours at night. Rest and brain development.',
          'Express thoughts or talk to someone. Emotional regulation.',
          'Practice self-affirmation. Build confidence and self-worth.',
        ];
        content = _DailyChecklist(fontSize: fontSize);
        break;
      default:
        content = Center(
          child: Text(
            'Content coming soon!',
            style: TextStyle(fontSize: fontSize + 2, color: Colors.grey[700]),
            textAlign: TextAlign.center,
          ),
        );
    }
    final ttsText = topic.title + '. ' + ttsBullets.join(' ');
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: Text(topic.title, style: TextStyle(fontSize: fontSize + 2, color: Color(0xFF0057B8), fontWeight: FontWeight.bold)),
            iconTheme: IconThemeData(color: Color(0xFF0057B8)),
          ),
          body: Padding(
            padding: const EdgeInsets.all(28.0),
            child: content,
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

class _BulletList extends StatelessWidget {
  final double fontSize;
  final List<String> items;
  const _BulletList({required this.fontSize, required this.items});
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: items.length,
      separatorBuilder: (context, i) => SizedBox(height: 12),
      itemBuilder: (context, i) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2.0),
            child: Text('•', style: TextStyle(fontSize: fontSize + 3, color: Color(0xFF0057B8), height: 1.3)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              items[i],
              style: TextStyle(fontSize: fontSize + 1.5, color: Color(0xFF222B45), height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}

class _DailyChecklist extends StatefulWidget {
  final double fontSize;
  const _DailyChecklist({required this.fontSize});
  @override
  State<_DailyChecklist> createState() => _DailyChecklistState();
}

class _DailyChecklistState extends State<_DailyChecklist> {
  final List<_ChecklistItem> _items = [
    _ChecklistItem('Eat three balanced meals', 'Nutritional health'),
    _ChecklistItem('Drink 6–8 glasses of water', 'Hydration and digestion'),
    _ChecklistItem('Bathe and wear clean clothes', 'Hygiene and confidence'),
    _ChecklistItem('Engage in 30 mins of physical activity', 'Fitness and mental clarity'),
    _ChecklistItem('Sleep 7–9 hours at night', 'Rest and brain development'),
    _ChecklistItem('Express thoughts or talk to someone', 'Emotional regulation'),
    _ChecklistItem('Practice self-affirmation', 'Build confidence and self-worth'),
  ];
  late List<bool> _checked;

  @override
  void initState() {
    super.initState();
    _checked = List.filled(_items.length, false);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Daily Wellness Routine (Suggested)', style: TextStyle(fontSize: widget.fontSize + 3, fontWeight: FontWeight.bold, color: Color(0xFF0057B8))),
        SizedBox(height: 18),
        ...List.generate(_items.length, (i) => CheckboxListTile(
              value: _checked[i],
              onChanged: (val) {
                setState(() => _checked[i] = val ?? false);
              },
              title: Text(_items[i].title, style: TextStyle(fontSize: widget.fontSize + 1.5, fontWeight: FontWeight.w600)),
              subtitle: Text(_items[i].subtitle, style: TextStyle(fontSize: widget.fontSize, color: Colors.grey[700])),
              controlAffinity: ListTileControlAffinity.leading,
              activeColor: Color(0xFF0057B8),
              contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            )),
        SizedBox(height: 18),
        Text('You can check off these habits every day to track your wellness!', style: TextStyle(fontSize: widget.fontSize, color: Colors.grey[700])),
      ],
    );
  }
}

class _ChecklistItem {
  final String title;
  final String subtitle;
  _ChecklistItem(this.title, this.subtitle);
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