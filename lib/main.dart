import 'package:fitness/pages/main/main_page.dart';
import 'package:flutter/material.dart';
import 'providers/locale_provider.dart';
import 'services/init_app_service.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await InitAppService.instance.init();

  runApp(
    ChangeNotifierProvider(
      create: (_) => LocaleProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fitness App',
      home: const MainPage(),
      locale: localeProvider.locale,
      supportedLocales: InitAppService.instance.supportedLocales,
      localizationsDelegates: InitAppService.instance.localizationsDelegates,
    );
  }
}
