import 'package:url_launcher/url_launcher.dart';

class PricingRedirectService {
  static Future<void> call() async {
    final Uri url = Uri.parse('https://admin.jarvis.cx/pricing/overview');
    if (await canLaunchUrl(url)) {
      await launchUrl(
        url,
        mode: LaunchMode.platformDefault, // Opens in a web browser
      );
    }
  }
}
