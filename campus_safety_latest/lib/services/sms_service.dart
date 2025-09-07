import 'package:url_launcher/url_launcher.dart';

class SmsService {
  /// Sends SMS message to the specified phone numbers
  /// Returns true if SMS app was launched successfully, false otherwise
  static Future<bool> sendSms({
    required String message,
    required List<String> recipients,
  }) async {
    // Create SMS URI with recipients and message
    final Uri smsUri = Uri(
      scheme: 'sms',
      path: recipients.join(','),
      queryParameters: {'body': message},
    );

    // Launch SMS app
    if (await canLaunchUrl(smsUri)) {
      return await launchUrl(smsUri);
    } else {
      // Fallback to a basic SMS URI without query parameters
      final Uri simpleSmsUri = Uri(
        scheme: 'sms',
        path: recipients.join(','),
      );
      
      if (await canLaunchUrl(simpleSmsUri)) {
        return await launchUrl(simpleSmsUri);
      }
      return false;
    }
  }
}
