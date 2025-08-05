import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../accessibility/font_size_provider.dart';
import '../accessibility/screen_reader_volume_notifier.dart';
import '../accessibility/language_provider.dart';


class AccessibilitySettings extends StatelessWidget {
  final FontSizeNotifier fontSizeNotifier;

  const AccessibilitySettings({super.key, required this.fontSizeNotifier});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Accessibility options',
          style: TextStyle(
            fontSize: fontSizeNotifier.value + 6,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF0057B8),
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        children: [
          // Removed App Language section and LanguageSelector
          // Divider(height: 32),
          Padding(
            padding: const EdgeInsets.only(left: 8, bottom: 8),
            child: Text(
              'Font Size',
              style: TextStyle(
                fontSize: fontSizeNotifier.value + 2,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.text_fields, color: Theme.of(context).primaryColor),
            title: Text('Adjust Font Size', style: TextStyle(fontSize: fontSizeNotifier.value, color: Colors.black)),
            subtitle: Text('${fontSizeNotifier.value.toStringAsFixed(0)} pt', style: TextStyle(fontSize: fontSizeNotifier.value - 2, color: Colors.black)),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: fontSizeNotifier.decrease,
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: fontSizeNotifier.increase,
                ),
              ],
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          ),
          Divider(height: 32),
          Padding(
            padding: const EdgeInsets.only(left: 8, bottom: 8),
            child: Text(
              'Screen Reader Volume',
              style: TextStyle(
                fontSize: fontSizeNotifier.value + 2,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.volume_up, color: Theme.of(context).primaryColor),
            title: Text('Adjust screen reader volume', style: TextStyle(fontSize: fontSizeNotifier.value, color: Colors.black)),
            subtitle: ValueListenableBuilder<double>(
              valueListenable: screenReaderVolumeNotifier,
              builder: (context, volume, _) => Slider(
                value: volume,
                min: 0.0,
                max: 1.0,
                divisions: 10,
                label: '${(volume * 100).toStringAsFixed(0)}%',
                onChanged: (val) => screenReaderVolumeNotifier.value = val,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          ),
        ],
      ),
    );
  }
}

class _LanguageSelector extends StatefulWidget {
  @override
  State<_LanguageSelector> createState() => _LanguageSelectorState();
}

class _LanguageSelectorState extends State<_LanguageSelector> {
  String? _selectedLang;

  @override
  Widget build(BuildContext context) {
    final langNotifier = Provider.of<LanguageNotifier>(context);
    final currentLang = langNotifier.value;
    _selectedLang ??= currentLang;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...supportedLanguages.map((lang) {
          return RadioListTile<String>(
            title: Text(lang['label']!),
            value: lang['code']!,
            groupValue: _selectedLang,
            onChanged: (newLang) {
              setState(() {
                _selectedLang = newLang;
              });
            },
            contentPadding: EdgeInsets.symmetric(horizontal: 8),
          );
        }).toList(),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerLeft,
          child: ElevatedButton.icon(
            icon: const Icon(Icons.save),
            label: Text('Settings'),
            onPressed: _selectedLang != null && _selectedLang != currentLang
                ? () {
                    langNotifier.setLanguage(_selectedLang!);
                  }
                : null,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }
}


