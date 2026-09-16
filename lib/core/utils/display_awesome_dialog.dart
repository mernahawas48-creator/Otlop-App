import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

void displayAwesomeDialog(
  BuildContext context, {
  String? errorMessage,
  String? message,

  // Keeping this temporarily so old code
  // using the misspelled "meesage" does not break.
  String? meesage,

  String? title,
  String? buttonText,
  VoidCallback? onOk,
}) {
  final bool isError = errorMessage != null;

  AwesomeDialog(
    context: context,

    dialogType: isError ? DialogType.error : DialogType.success,

    animType: AnimType.scale,

    title: title ?? (isError ? 'Error' : 'Success'),

    desc: errorMessage ?? message ?? meesage ?? '',

    btnOkText: buttonText ?? 'Ok',

    btnOkColor: isError ? Colors.red : const Color(0xFF00CE78),

    btnOkOnPress: onOk,
  ).show();
}
