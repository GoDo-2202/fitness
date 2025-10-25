import 'package:fitness/core/l10n/localizations_extension.dart';
import 'package:fitness/core/widgets/custom_app_bar.dart';
import 'package:fitness/pages/settings/widgets/localizations_setting.dart';
import 'package:flutter/material.dart';

class SettingPageBody extends StatelessWidget {
  const SettingPageBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: context.localizations.settings,
        showBackButton: false,
        showActions: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          GestureDetector(
            onTap: () {},
            child: const ListTile(
              leading: Icon(Icons.person),
              title: Text('Account'),
            ),
          ),
          const Divider(),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const LocalizationsSetting()));
            },
            child: const ListTile(
              leading: Icon(Icons.person),
              title: Text('Localizations'),
            ),
          ),
          const Divider(),
          GestureDetector(
            onTap: () {},
            child: const ListTile(
              leading: Icon(Icons.person),
              title: Text('Account'),
            ),
          ),
        ],
      ),
    );
  }
}
