import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:yesil_piyasa/core/components/error_handling.dart';

class ErrorDisplay {
  static void showTopError(BuildContext context, String englishErrorCode) {
    final translatedMessage =
        ErrorHandling.translateErrorMessage(englishErrorCode);
    Flushbar(
      messageText: Text(
        translatedMessage,
        style: const TextStyle(
            color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
      ),
      icon: const Icon(
        Icons.error_outline,
        size: 28.0,
        color: Colors.white,
      ),
      backgroundColor: Colors.redAccent,
      borderRadius: BorderRadius.circular(12),
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      duration: const Duration(seconds: 4),
      leftBarIndicatorColor: Colors.blueAccent,
      flushbarPosition: FlushbarPosition.TOP,
      animationDuration: const Duration(milliseconds: 500),
      isDismissible: true,
    ).show(context);
  }

  static void showBottomWarning(BuildContext context, String englishErrorCode) {
    final translatedMessage =
        ErrorHandling.translateErrorMessage(englishErrorCode);
    Flushbar(
      messageText: Text(
        translatedMessage,
        style: const TextStyle(
            color: Colors.black87, fontSize: 16, fontWeight: FontWeight.w600),
      ),
      icon: const Icon(
        Icons.warning_amber_rounded,
        size: 28.0,
        color: Colors.orange,
      ),
      backgroundColor: Colors.orange[100]!,
      borderRadius: BorderRadius.circular(12),
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      duration: const Duration(seconds: 4),
      leftBarIndicatorColor: Colors.orangeAccent,
      flushbarPosition: FlushbarPosition.BOTTOM,
      animationDuration: const Duration(milliseconds: 500),
      isDismissible: true,
    ).show(context);
  }

  static void showDialogError(BuildContext context, String englishErrorCode) {
    final translatedMessage =
        ErrorHandling.translateErrorMessage(englishErrorCode);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error, color: Colors.redAccent, size: 40),
                const SizedBox(height: 10),
                const Text(
                  "Hata",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent),
                ),
                const SizedBox(height: 10),
                Text(
                  translatedMessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, color: Colors.black54),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.redAccent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text("Tamam"),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
