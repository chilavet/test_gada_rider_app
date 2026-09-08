import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

class NavigationLauncher {
  /// Opens real turn-by-turn navigation in Google Maps or Apple Maps
  static Future<bool> launchNavigation({
    required double latitude,
    required double longitude,
    required String label,
  }) async {
    final encodedLabel = Uri.encodeComponent(label);

    if (!kIsWeb && Platform.isIOS) {
      // 1. Try Apple Maps native turn-by-turn
      final appleMapsUrl = Uri.parse(
        'maps://?q=$encodedLabel&ll=$latitude,$longitude',
      );
      if (await canLaunchUrl(appleMapsUrl)) {
        return await launchUrl(appleMapsUrl, mode: LaunchMode.externalApplication);
      }
    }

    // 2. Try Google Maps app URL scheme
    final googleMapsAppUrl = Uri.parse(
      'google.navigation:q=$latitude,$longitude&mode=d',
    );
    if (await canLaunchUrl(googleMapsAppUrl)) {
      return await launchUrl(googleMapsAppUrl, mode: LaunchMode.externalApplication);
    }

    // 3. Fallback to Google Maps Web Directions
    final googleMapsWebUrl = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=$latitude,$longitude',
    );
    if (await canLaunchUrl(googleMapsWebUrl)) {
      return await launchUrl(googleMapsWebUrl, mode: LaunchMode.externalApplication);
    }

    return false;
  }

  /// Launch phone call to merchant or customer
  static Future<bool> launchCall(String phoneNumber) async {
    final cleaned = phoneNumber.replaceAll(' ', '').replaceAll('-', '');
    final uri = Uri.parse('tel:$cleaned');
    if (await canLaunchUrl(uri)) {
      return await launchUrl(uri);
    }
    return false;
  }
}
