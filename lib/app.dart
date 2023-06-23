import 'package:flutter/material.dart';
import 'package:flutter_appwrite_starter/core/presentation/router/router.dart';
import 'core/presentation/providers/providers.dart';
import 'core/res/themes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppThemes.context = context;
    return Consumer(builder: (context, ref, child) {
      return MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: ref.watch(configProvider).appTitle,
        theme: AppThemes.defaultTheme.copyWith(useMaterial3: true),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: AppRoutes.router,
      );
    });
  }
}
