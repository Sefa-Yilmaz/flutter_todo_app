// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class TranslationsHelper {
  TranslationsHelper._();

  static getDeviceLanguage(BuildContext context) {
    var _deviceLanguage = context.deviceLocale.countryCode!.toLowerCase();
    print(_deviceLanguage);
    switch (_deviceLanguage) {
      case 'tr':
        return LocaleType.tr;
      case 'en':
        return LocaleType.en;
    }
  }
}
