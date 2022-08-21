import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_flashcards_portrait/app_localizations.dart';
import 'package:flutter_flashcards_portrait/screens/categories_screen.dart';
import 'package:flutter_flashcards_portrait/state_managment/localization_state_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/category.dart';
import '../slides/slide_zero.dart';
import '../state_managment/categories_state_manager.dart';
import '../state_managment/dark_mode_state_manager.dart';
import 'Impressum.dart';

class MainScreen extends ConsumerStatefulWidget {
  final int initPage;
  const MainScreen({Key? key, this.initPage = 0}) : super(key: key);

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  late int page;
  List<Widget> list = [];
  List<Category> categories = [];
  String title = "";
  String lesson = "";

  late PageController pageControllerH;

  void startLesson() {
    pageControllerH.nextPage(
        duration: const Duration(milliseconds: 3), curve: Curves.fastOutSlowIn);
  }

  Future<void> loadData() async {
    setState(() {
      categories = AppLocalizations.of(context)!.getCategories();
      title = AppLocalizations.of(context)!.translate('title')!;
      lesson = AppLocalizations.of(context)!.translate('lesson')!;
      list = [
        SlideZero(startLesson, title),
        CategoriesScreen(title: title, lesson: lesson),
      ];
    });
    ref.read(categoriesStateManagerProvider.notifier).init(categories);
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => loadData());

    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    setState(() {
      page = widget.initPage;
      list = [
        SlideZero(startLesson, title),
        CategoriesScreen(title: title, lesson: lesson),
      ];
    });
    pageControllerH = PageController(initialPage: page);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: const Border(top: BorderSide(color: Colors.green, width: 3)),
        backgroundColor: Theme.of(context).cardColor,
        centerTitle: false,
        titleSpacing: 0,
        shadowColor: Theme.of(context).shadowColor,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 30,
                      child: Image.asset('assets/images/LogoMaster.png'),
                    ),
                  ],
                ),
              ),
              Expanded(
                  flex: 2,
                  child: Center(
                    child: AutoSizeText(
                        page == 0 ? "Accelerated Learning" : "FlashDecks",
                        maxLines: 1,
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontFamily: "RobotoSerif",
                            fontSize: 20,
                            fontWeight: FontWeight.w300)),
                  )),
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    PopupMenuButton<String>(
                      child: Icon(
                        Icons.language,
                        color: Theme.of(context).primaryColor,
                      ),
                      onSelected: (String value) => ref
                          .read(localizationStateManagerProvider.notifier)
                          .switchLanguage(value),
                      itemBuilder: (BuildContext context) {
                        return {
                          "en",
                          "de",
                        }.map((String choice) {
                          bool isSelected =
                              Localizations.localeOf(context).languageCode ==
                                  choice;
                          return PopupMenuItem<String>(
                            value: choice,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(choice == "en" ? "English" : "German"),
                                if (isSelected)
                                  const Icon(
                                    Icons.check,
                                    color: Colors.black,
                                  )
                              ],
                            ),
                          );
                        }).toList();
                      },
                    ),
                    PopupMenuButton<String>(
                      child: Icon(
                        Icons.more_vert,
                        color: Theme.of(context).primaryColor,
                      ),
                      onSelected: (String value) => value == 'Impressum'
                          ? Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const ImpressumScreen()),
                            )
                          : ref
                              .read(darkModeStateManagerProvider.notifier)
                              .switchDarkMode(),
                      itemBuilder: (BuildContext context) {
                        return {
                          Theme.of(context).brightness == Brightness.light
                              ? 'Dark mode'
                              : 'Light mode',
                          'Impressum'
                        }.map((String choice) {
                          return PopupMenuItem<String>(
                            value: choice,
                            child: Text(choice),
                          );
                        }).toList();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView(
              onPageChanged: (int newpage) {
                setState(() {
                  page = newpage;
                });
              },
              scrollDirection: Axis.horizontal,
              controller: pageControllerH,
              scrollBehavior:
                  ScrollConfiguration.of(context).copyWith(dragDevices: {
                PointerDeviceKind.touch,
                PointerDeviceKind.mouse,
              }),
              children: list,
            ),
          ),
          Container(
            padding: const EdgeInsets.only(
              left: 20,
            ),
            color: Colors.blue,
            width: double.infinity,
            height: 45,
            child: Align(
              alignment: Alignment.centerLeft,
              child: AutoSizeText(title,
                  maxLines: 1,
                  style: GoogleFonts.robotoSlab(
                    textStyle: GoogleFonts.robotoSlab(
                        textStyle: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w500)),
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
