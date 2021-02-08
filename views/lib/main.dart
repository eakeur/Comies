import 'package:comies/utils/declarations/session.dart';
import 'package:comies/utils/declarations/storage.dart';
import 'package:comies/views/authentication/authentication.screen.dart';
import 'package:comies/views/costumers/costumers.screen.dart';
import 'package:comies/views/orders/orders.screen.dart';
import 'package:comies/views/orders/panel.screen.dart';
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
  session = await new Session().loadSession();
  bool isSet = await session.isConfigured();
  if (isSet){
    session.isAuthenticated() ? initialPage = '/' : initialPage = '/authentication';
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

Session session;

class Application extends State<ApplicationLauncher> {
  ThemeMode themeMode = ThemeMode.system;

  switchTheme(ThemeMode mode) {
    setState(() => themeMode = mode);
  }

  @override
  Widget build(BuildContext context) {
    themeSwitcher = switchTheme;
    session.loadSession();
    return MaterialApp(
      title: 'Comies',
      theme: mainTheme(Brightness.light),
      darkTheme: mainTheme(Brightness.dark),
      themeMode: themeMode,
      initialRoute: initialPage,
      routes: {
        '/welcome': (context) => WelcomeScreen(),
        '/authentication': (context) => AuthenticationScreen(),
        '/': (context) => HomeScreen(),
        '/products': (context) => ProductsScreen(),
        '/costumers': (context) => CostumersScreen(),
        '/orders': (context) => OrdersScreen(),
        '/settings': (context) => SettingsScreen(),
        '/panel': (context) => OrdersPanelScreen(),
      },
    );
  }
}
