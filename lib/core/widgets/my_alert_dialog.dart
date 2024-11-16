import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MyAlertDialog extends StatefulWidget {
  MyAlertDialog(
      {super.key,
      required this.title,
      this.content,
      required this.contentText,
      this.actions});
  String title;
  Widget? content;
  String contentText;
  Widget? actions;

  @override
  State<MyAlertDialog> createState() => _MyAlertDialogState();
}

class _MyAlertDialogState extends State<MyAlertDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: widget.content ?? Text(widget.contentText),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: widget.actions ??
              Text(
                'exit'.tr(),
                style: const TextStyle(color: Colors.red),
              ),
        ),
      ],
    );
  }
}
