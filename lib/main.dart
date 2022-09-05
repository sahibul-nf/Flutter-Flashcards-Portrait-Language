import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_flashcards_portrait/app_localizations.dart';
import 'package:flutter_flashcards_portrait/screens/splash_screen.dart';
import 'package:flutter_flashcards_portrait/state_managment/localization_state_manager.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'state_managment/dark_mode_state_manager.dart';
import 'screens/main_screen.dart';

void main() {
  runApp(
    const ProviderScope(child: MyApp()),
  );
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool darkMode = ref.watch(darkModeStateManagerProvider);
    Locale? _locale = ref.watch(localizationStateManagerProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Web for Slides',
      locale: _locale,
      supportedLocales: const [
        Locale('en', ''),
        Locale('de', ''),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale?.languageCode) {
            return supportedLocale;
          }
        }
        // If the locale of the device is not supported, use the first one
        // from the list (English, in this case).
        return supportedLocales.first;
      },
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: const Color(0xff333333),
        backgroundColor: Colors.white,
        shadowColor: const Color(0xff333333),
        cardColor: Colors.white,

        /* light theme settings */
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        backgroundColor: Colors.black,
        primaryColor: Colors.white,
        shadowColor: Colors.white24,
        cardColor: Colors.black45,

        /* dark theme settings */
      ),
      themeMode: darkMode ? ThemeMode.dark : ThemeMode.light,
      home: SplashView(
        image: Column(
          children: [
            Image.asset(
              "assets/images/view.png",
              height: 100,
            ),
            const SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: DefaultTextStyle(
                textAlign: TextAlign.center,
                style: GoogleFonts.robotoMono(
                  color: Colors.black,
                  textStyle: const TextStyle(
                    fontSize: 28,
                  ),
                ),
                child: AnimatedTextKit(
                  isRepeatingAnimation: false,
                  animatedTexts: [
                    TypewriterAnimatedText('Accelerated Learning',
                        textAlign: TextAlign.center,
                        speed: const Duration(milliseconds: 100),
                        cursor: ""),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 150,
            ),
            DefaultTextStyle(
              textAlign: TextAlign.center,
              style: GoogleFonts.oswald(
                color: Colors.red,
                textStyle:
                    const TextStyle(fontWeight: FontWeight.w400, fontSize: 48),
              ),
              child: AnimatedTextKit(
                isRepeatingAnimation: false,
                animatedTexts: [
                  TypewriterAnimatedText("",
                      speed: const Duration(milliseconds: 110), cursor: ""),
                  TypewriterAnimatedText('Flashcards',
                      textAlign: TextAlign.center,
                      speed: const Duration(milliseconds: 100),
                      cursor: ""),
                ],
              ),
            ),
            const SizedBox(
              height: 100,
            ),
          ],
        ),
        title: "",
        showLoading: false,
        backgroundImage: const AssetImage("assets/images/backLandscape.png"),
        backgroundImageFit: BoxFit.cover,
        backgroundImageColorFilter: ColorFilter.mode(
          Colors.white.withOpacity(1),
          BlendMode.darken,
        ),
        home: const MainScreen(),
        seconds: 4,
      ),
    );
  }
}
