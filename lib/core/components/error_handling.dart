import 'package:easy_localization/easy_localization.dart';

class ErrorHandling {
  static String translateErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'invalid-credential':
        return 'firebase_invalid_credential'.tr();
      case 'email-already-in-use':
        return 'firebase_email_already_in_use'.tr();
      case 'network-request-failed':
        return 'firebase_network_request_failed'.tr();
      default:
        return 'firebase_custom_error'.tr();
    }
  }
}
