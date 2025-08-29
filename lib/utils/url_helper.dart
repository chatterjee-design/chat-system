import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:html/parser.dart' as html;
import 'package:url_launcher/url_launcher.dart' as url_launcher;

class WebHelper {
  static final Dio _dio = Dio();

  static String normalizeUrl(String text) {
    final urlRegex = RegExp(
      r'((https?:\/\/)?[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}(\S*)?)',
      caseSensitive: false,
    );

    final match = urlRegex.firstMatch(text);
    if (match != null) {
      var url = match.group(0)!.trim();
      if (!url.startsWith("http://") && !url.startsWith("https://")) {
        url = "https://$url";
      }
      return url;
    }

    // fallback
    return "";
  }

  static Future<void> openUrl({required String url}) async {
    try {
      final Uri uri = Uri.parse(normalizeUrl(url));

      final bool launched = await url_launcher.launchUrl(
        uri,
        mode: url_launcher.LaunchMode.externalApplication,
      );

      if (!launched) throw 'Could not launch $url';
    } catch (e) {
      debugPrint('Error launching URL: $e');
    }
  }

  static Future<String?> getFavicon(String url) async {
    try {
      url = normalizeUrl(url);
      Uri uri = Uri.parse(url);
      final domain = "${uri.scheme}://${uri.host}";

      final faviconUrl = "$domain/favicon.ico";

      final response = await _dio.head(faviconUrl);
      if (response.statusCode == 200) {
        return faviconUrl;
      }
    } catch (e) {
      debugPrint("Error fetching favicon for $url: $e");
    }
    return null;
  }

  static Future<String?> getTitle(String url) async {
    try {
      url = normalizeUrl(url);
      final response = await _dio.get(url);
      if (response.statusCode == 200) {
        final document = html.parse(response.data);
        return document.querySelector("title")?.text.trim();
      }
    } catch (e) {
      debugPrint("Error fetching title: $e");
    }
    return null;
  }
}
