import 'package:cardiac_petct/app_controller.dart';
import 'package:cardiac_petct/features/showcase/showcase_page.dart';
import 'package:cardiac_petct/src/shared/themes/themes_schemes.dart';
import 'package:flutter/material.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: AppController.instance.themeSwitch,
        builder: (context, value, child) {
          return MaterialApp(
            title: 'Flutter Demo',
            debugShowCheckedModeBanner: false,
            theme: themeLight,
            darkTheme: themeDark,
            themeMode: value ? ThemeMode.light : ThemeMode.dark,
            home: const ShowcasePage(),
          );
        });
  }
}
