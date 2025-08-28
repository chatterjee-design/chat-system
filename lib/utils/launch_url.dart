import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

Future<void> openUrl({required String url}) async {
  try {
    final Uri uri = Uri.parse(
      url.trim().startsWith("http") ? url.trim() : "https://${url.trim()}",
    );

    final bool launched = await url_launcher.launchUrl(
      uri,
      mode: url_launcher.LaunchMode.externalApplication,
    );

    if (!launched) {
      throw 'Could not launch $url';
    }
  } catch (e) {
    debugPrint('Error launching URL: $e');
  }
}
