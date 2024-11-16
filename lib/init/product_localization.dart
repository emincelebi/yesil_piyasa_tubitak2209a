import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:yesil_piyasa/core/components/enums/locales.dart';

final class ProductLocalization extends EasyLocalization {
  ProductLocalization({required super.child, super.key})
      : super(
          supportedLocales: _supportedItems,
          path: _translationPath,
          useOnlyLangCode: true,
          fallbackLocale: Locales.tr.locale,
        );

  static final List<Locale> _supportedItems = [
    Locales.tr.locale,
    Locales.en.locale,
    Locales.de.locale
  ];

  static const String _translationPath = 'assets/translations';

  static Future<void> updateLanguage(
          {required BuildContext context, required Locales value}) =>
      context.setLocale(value.locale);
}
