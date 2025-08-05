import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../accessibility/font_size_provider.dart';

class InfoCard extends StatelessWidget {
  final String title;
  final String description;
  final String? url;
  final FontSizeNotifier fontSizeNotifier;

  const InfoCard({
    required this.title, 
    required this.description,
    required this.fontSizeNotifier,
    this.url,
    super.key,
  });

  void _launchURL(String url, BuildContext context) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not open resource.')),
      );
    }
  }

  void_launchURL(BuildContext context) async {
    if (url != null && await canLaunchUrl(Uri.parse(url!))) {
      await launchUrl(Uri.parse(url!));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not open resource.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    void launchURL() async {
      if (url != null && await canLaunchUrl(Uri.parse(url!))) {
        await launchUrl(Uri.parse(url!));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not open resource.')),
        );
      }
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ListTile(
        title: Text(title, style: TextStyle(fontSize: fontSizeNotifier.value)),
        subtitle: Text(description, style: TextStyle(fontSize: fontSizeNotifier.value)),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: url != null 
          ? () => _launchURL(url!, context) 
          : null,
      ),
    );
  }
}
