import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import '../core/l10n/app_localizations.dart';
import '../providers/locale_provider.dart';

class InitAppService {
  InitAppService._privateConstructor();

  static final InitAppService instance = InitAppService._privateConstructor();

  /// Các localizations delegates
  final localizationsDelegates = const [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];

  /// Các ngôn ngữ được hỗ trợ
  final supportedLocales = const [
    Locale('en'),
    Locale('vi'),
  ];

  /// Hàm gọi để khởi tạo app
  Future<void> init() async {
    // Có thể load config, token, db, theme, language từ SharedPreferences...
    // Nhưng locale giờ lấy từ LocaleProvider
  }

  /// Build MaterialApp dựa vào LocaleProvider
  Widget buildApp({required Widget home}) {
    return Builder(
      builder: (context) {
        final localeProvider = Provider.of<LocaleProvider>(context);

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Fitness App',
          home: home,
          locale: localeProvider.locale,
          supportedLocales: supportedLocales,
          localizationsDelegates: localizationsDelegates,
        );
      },
    );
  }
}
