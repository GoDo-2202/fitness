import 'package:fitness/core/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

extension LocalizationExt on BuildContext {
  AppLocalizations get localizations {
    return AppLocalizations.of(this) ?? _FakeLocalizations();
  }
}

class _FakeLocalizations implements AppLocalizations {
  @override
  noSuchMethod(Invocation invocation) {
    final memberName = invocation.memberName.toString();
    final key = memberName.replaceAll('Symbol("', '').replaceAll('")', '');
    return key;
  }
}

// flutter gen-l10n when add new item