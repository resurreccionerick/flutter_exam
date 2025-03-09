import 'package:flutter/material.dart';
import 'package:flutter_exam/models/SocialsModel.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialScreen extends StatelessWidget {
  final SocialsModel social;

  const SocialScreen({super.key, required this.social});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
      title: Text(social.name),
      backgroundColor: _getColor(social.name),
    ),
    body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Display
            if (social.imgUrl.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  social.imgUrl,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              )
            else
             const Center(
                child: Text(
                  "No image available.",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),

            const SizedBox(height: 16),

            // History Text
            if (social.history.isNotEmpty)
              Text(
                social.history,
                style: const TextStyle(fontSize: 16),
              )
            else
             const Text(
                "No history available.",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),

            const SizedBox(height: 16),

            // Visit Button   
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    final Uri url = Uri.parse(social.webUrl!);
                    print("URL WAS: $url");
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Could not launch ${social.webUrl}"),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _getColor(social.name),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(
                    "Visit ${social.name}",
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              )
          ],
        ),
      ),
    ),
  );
}

  // Function to get color based on social name
  Color _getColor(String name) {
    switch (name.toLowerCase()) {
      case "youtube":
        return Colors.red;
      case "spotify":
        return Colors.green;
      case "facebook":
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}
