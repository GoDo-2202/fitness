import 'package:fitness/core/l10n/localizations_extension.dart';
import 'package:fitness/core/widgets/custom_app_bar.dart';
import 'package:fitness/providers/locale_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LocalizationsSetting extends StatelessWidget {
  const LocalizationsSetting({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    final currentLocale = localeProvider.locale?.languageCode ?? 'system';

    return Scaffold(
      appBar: CustomAppBar(
        title: context.localizations.settings,
        showBackButton: true,
        showActions: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text('Select language', style: TextStyle(fontSize: 18)),
          const SizedBox(height: 10),
          RadioListTile<String>(
            title: const Text('English'),
            value: 'en',
            groupValue: currentLocale,
            onChanged: (value) {
              localeProvider.setLocale(const Locale('en'));
            },
          ),
          RadioListTile<String>(
            title: const Text('Vietnamese'),
            value: 'vi',
            groupValue: currentLocale,
            onChanged: (value) {
              localeProvider.setLocale(const Locale('vi'));
            },
          ),
          RadioListTile<String>(
            title: const Text('System'),
            value: 'system',
            groupValue: currentLocale,
            onChanged: (value) {
              localeProvider.clearLocale();
            },
          ),
        ],
      ),
    );
  }
}
