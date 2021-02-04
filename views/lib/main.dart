import 'package:comies/services/settings.service.dart';
import 'package:comies/utils/declarations/environment.dart';
import 'package:comies/utils/declarations/storage.dart';
import 'package:comies/views/authentication/authentication.screen.dart';
import 'package:comies/views/costumers/costumers.screen.dart';
import 'package:comies/views/products/edit.screen.dart';
import 'package:comies/views/products/form.comp.dart';
import 'package:comies/views/products/products.screen.dart';
import 'package:comies/views/settings/settings.screen.dart';
import 'package:comies/views/home/home.screen.dart';
import 'package:comies/utils/declarations/themes.dart';
import 'package:comies/views/startup/welcome.screen.dart';
import 'package:flutter/material.dart';
import 'utils/declarations/themes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDB();
  SettingsService s = new SettingsService();
  dynamic allSet = await s.getSetting<bool>('allSet');
  if (allSet != null && allSet is bool) {
    if (allSet) {
      initialPage = "/";
      if (!(await s.getSetting<bool>('cloud'))) {
        URL = await s.getSetting('url');
      }
      if ((await s.getSetting<String>('access')) == null) {
        initialPage = "/authentication";
      }
    }
  }
  runApp(MyApp());
}

String initialPage = "/welcome";

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ApplicationLauncher();
  }
}

class ApplicationLauncher extends StatefulWidget {
  @override
  Application createState() => Application();
}

Function(ThemeMode) themeSwitcher;

class Application extends State<ApplicationLauncher> {
  ThemeMode themeMode = ThemeMode.system;

  switchTheme(ThemeMode mode) {
    setState(() => themeMode = mode);
  }

  @override
  Widget build(BuildContext context) {
    themeSwitcher = switchTheme;
    return MaterialApp(
      title: 'Comies',
      theme: mainTheme(Brightness.light),
      darkTheme: mainTheme(Brightness.dark),
      themeMode: themeMode,
      initialRoute: initialPage,
      routes: {
        '/': (context) => HomeScreen(),
        '/products': (context) => ProductsScreen(),
        '/authentication': (context) => AuthenticationScreen(),
        '/costumers': (context) => CostumersScreen(),
        '/welcome': (context) => WelcomeScreen(),
        '/settings': (context) => SettingsScreen()
      },
    );
  }
}
