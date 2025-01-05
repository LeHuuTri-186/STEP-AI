import 'package:url_launcher/url_launcher.dart';

import '../../config/constants.dart';

class PricingRedirectService {
  static Future<void> call() async {
    final Uri url = Uri.parse(Constant.pricing);
    if (await canLaunchUrl(url)) {
      await launchUrl(
        url,
        mode: LaunchMode.platformDefault, // Opens in a web browser
      );
    }
  }
}
