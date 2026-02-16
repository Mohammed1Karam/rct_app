import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:url_launcher/url_launcher.dart';

void openGoogleMaps(double latitude, double longitude, {String? label}) async {
  String url = '';

  // For Android & iOS
  if (label != null) {
    url = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude&query_place_id=$label';
  } else {
    url = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
  }

  // Alternative format (direct navigation)
  // String url = 'https://www.google.com/maps/dir/?api=1&destination=$latitude,$longitude';

  if (await canLaunchUrl(Uri.parse(url))) {
    await launchUrl(Uri.parse(url));
  } else {
    throw 'Could not launch $url';
  }
}