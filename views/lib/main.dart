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
import 'package:provider/provider.dart';
import 'controllers/main.controller.dart';
import 'utils/declarations/themes.dart';

SessionController session;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); await initDB();
  session = SessionController();
  session.getSession();
  runApp(ChangeNotifierProvider(create: (context) => session, child: MyApp()));
}




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

  Route onGeneratedRoute(RouteSettings route){
    switch (route.name) {
      case '/': return MaterialPageRoute(
        builder: (context){
          return HomeScreen();
        }
      );

      case '/products': return MaterialPageRoute(
        builder: (context){
          return ProductsScreen();
        }
      );

      case '/authentication': return MaterialPageRoute(
        builder: (context){
          return AuthenticationScreen();
        }
      );

      case '/welcome': return MaterialPageRoute(
        builder: (context){
          return WelcomeScreen();
        }
      );

      case '/costumers': return MaterialPageRoute(
        builder: (context){
          return CostumersScreen();
        }
      );

      case '/orders': return MaterialPageRoute(
        builder: (context){
          return OrdersScreen();
        }
      );

      case '/settings': return MaterialPageRoute(
        builder: (context){
          return SettingsScreen();
        }
      );

      case '/panel': return MaterialPageRoute(
        builder: (context){
          return OrdersPanelScreen();
        }
      );
        
      default: return MaterialPageRoute(
        builder: (context){
          return WelcomeScreen();
        }
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    themeSwitcher = switchTheme;
    return MaterialApp(
      title: 'Comies',
      theme: mainTheme(Brightness.light),
      darkTheme: mainTheme(Brightness.dark),
      themeMode: themeMode,
      initialRoute: Provider.of<SessionController>(context, listen: false).actualRoute,
      onGenerateRoute: onGeneratedRoute,
    );
  }
}
