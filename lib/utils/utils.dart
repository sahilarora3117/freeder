import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_share/flutter_share.dart';

void launchInBrowser(url) async {
  if (!await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication)) {
    throw 'Could not launch';
  }
}

Future<void> shareURL(title, url) async {
  await Share.share(
    url,
    subject: title,
  );
}
