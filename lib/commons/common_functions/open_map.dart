import 'package:url_launcher/url_launcher.dart';

import '../common_imports/common_libs.dart';
import '../common_widgets/show_toast.dart';

openMap({required double lat, required double lng}) async {
  var _googleMapsUrl = Uri.parse(
      "google.navigation:q=${lat},${lng}&mode=d");
  var _appleMapsUrl = Uri.parse(
      "maps://?q=${lat},${lng}");

  try {
    // Try to launch Google Maps first
    bool googleMapsLaunched = await launchUrl(_googleMapsUrl);
    if (!googleMapsLaunched) {
      // If Google Maps is not available, try Apple Maps
      bool appleMapsLaunched = await launchUrl(_appleMapsUrl);
      if (!appleMapsLaunched) {
        print('Could not launch any map app');
        throw Exception('Could not launch any map app');
      }
    }
  } catch (e) {
    print('Error launching URL: $e');
    throw Exception('Error launching URL: $e');
  }
}

Future<void> launchWebsiteUrl({required BuildContext context,required  String url}) async {
  if (url == '') {
    showSnackBar(context, 'website does not exist');
    return;
  }
  var _url = Uri.parse(url);
  if (!await launchUrl(_url)) {
    showSnackBar(context, 'website does not exist');
    // throw 'Could not launch $url';
  }
}