import 'package:app_supermarket/Views/homepage.dart';
import 'package:app_supermarket/utils/themeNotifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:app_supermarket/utils/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_supermarket/Views/Login/Screens/login_screens.dart';
import 'package:app_supermarket/Views/Home/Screens/home.dart';
import 'package:app_supermarket/Views/Admin/Screens/admin_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized(); 
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? email = prefs.getString('email'); 
  String? role = prefs.getString('role');
  String? languageCode = prefs.getString('languageCode') ?? 'vi';

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(), // Initialize ThemeProvider
      child: MainApp(isLoggedIn: email != null, role: role, languageCode: languageCode),
    ),
  );
}

class MainApp extends StatelessWidget {
  final bool isLoggedIn;
  final String? role;
  final String languageCode;

  const MainApp({super.key, required this.isLoggedIn, this.role, required this.languageCode});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          locale: Locale(languageCode),
          supportedLocales: const [
            Locale('en', ''),
            Locale('vi', ''),
            Locale('th', ''),
            Locale('ja', ''),
            Locale('zh', ''),
            Locale('pt', ''),
            Locale('ko', ''),
            Locale('fr', ''),
          ],
          localizationsDelegates: [
            AppLocalizationsDelegate(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          theme: themeProvider.isDarkMode ? ThemeData.dark() : ThemeData.light(),
          home: isLoggedIn
              ? (role == 'admin'
                  ? const AdminScreen()
                  : const Homepage())
              : const LoginScreens(),
        );
      },
    );
  }
}
