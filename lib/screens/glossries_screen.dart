import 'package:auto_size_text/auto_size_text.dart';
import "package:flutter/material.dart";
import 'package:flutter_flashcards_portrait/app_localizations.dart';
import 'package:flutter_flashcards_portrait/models/category.dart';
import 'package:flutter_flashcards_portrait/models/tags.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:styled_text/styled_text.dart';
import 'package:url_launcher/url_launcher.dart';
import '../state_managment/dark_mode_state_manager.dart';

class GlossariesScreen extends ConsumerStatefulWidget {
  final Category category;
  const GlossariesScreen({Key? key, required this.category}) : super(key: key);

  @override
  ConsumerState<GlossariesScreen> createState() => _GlossariesScreenState();
}

class _GlossariesScreenState extends ConsumerState<GlossariesScreen> {
  late Map<String, StyledTextTagBase> tags = {};

  @override
  Widget build(BuildContext context) {
    updateTags();
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          iconTheme: IconThemeData(
            color: Theme.of(context).primaryColor, //change your color here
          ),
          shape: const Border(top: BorderSide(color: Colors.green, width: 3)),
          backgroundColor: Theme.of(context).cardColor,
          titleSpacing: 0,
          shadowColor: Theme.of(context).shadowColor,
          actions: [
            PopupMenuButton<String>(
              child: Icon(
                Icons.more_vert,
                color: Theme.of(context).primaryColor,
              ),
              onSelected: (String value) => ref
                  .read(darkModeStateManagerProvider.notifier)
                  .switchDarkMode(),
              itemBuilder: (BuildContext context) {
                return {
                  Theme.of(context).brightness == Brightness.light
                      ? 'Dark mode'
                      : 'Light mode'
                }.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            ),
            const SizedBox(width: 16),
          ],
        ),
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  child: Text(
                    AppLocalizations.of(context)!.translate('glossary')!,
                    style: GoogleFonts.oswald(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                        fontSize: 27,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: widget.category.glossries.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: ExpansionTile(
                            key: GlobalKey(),
                            tilePadding: const EdgeInsets.all(10),
                            title: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AutoSizeText(
                                    widget.category.glossries[index].title,
                                    maxLines: 1,
                                    style: GoogleFonts.robotoCondensed(
                                      textStyle: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            children: [
                              ...List<Widget>.generate(
                                  widget.category.glossries[index].questions
                                      .length, (i) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: StyledText(
                                    textAlign: TextAlign.left,
                                    text: widget
                                        .category.glossries[index].questions[i],
                                    style: GoogleFonts.robotoCondensed(
                                        textStyle: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 18,
                                    )),
                                    tags: tags,
                                  ),
                                );
                              }),
                            ],
                          ),
                        );
                      }),
                )
              ],
            )));
  }

  void updateTags() {
    List<Tags> tagsList = AppLocalizations.of(context)!.getTags();
    tags.clear();
    for (var element in tagsList) {
      int color = int.parse("0xff" + element.color);
      int decorationColor = int.parse("0xff" + element.decorationColor);

      FontWeight fontWeight =
          element.fontWeight == "bold" ? FontWeight.bold : FontWeight.normal;
      setState(() {
        tags.putIfAbsent(element.tag, () {
          if (element.tag == 'link') {
            return StyledTextActionTag(
              (String? text, Map<String?, String?> attrs) async {
                final String? link = attrs['href'];
                launch(link!);
              },
              style: GoogleFonts.robotoCondensed(
                  textStyle: TextStyle(
                      fontFamily: "RobotoSerif",
                      fontWeight: fontWeight,
                      decoration:
                          element.isUnderLine ? TextDecoration.underline : null,
                      decorationColor: (element.decorationColor != "")
                          ? Color(decorationColor)
                          : null,
                      fontSize:
                          (element.fontSize != 0) ? element.fontSize : null,
                      color: (element.color != "") ? Color(color) : null)),
            );
          } else if (element.tag == 'tooltip') {
            return StyledTextWidgetBuilderTag(
              (context, attributes) => Tooltip(
                  message: attributes['message'],
                  triggerMode: TooltipTriggerMode.tap,
                  textStyle: Theme.of(context).textTheme.bodyText2!.copyWith(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.black
                            : Colors.white,
                        fontSize: (element.messageFontSize != 0)
                            ? element.messageFontSize
                            : null,
                      ),
                  child: Text(
                    attributes['text']!,
                    style: TextStyle(
                        fontFamily: "RobotoSerif",
                        fontWeight: fontWeight,
                        decoration: element.isUnderLine
                            ? TextDecoration.underline
                            : null,
                        decorationColor: (element.decorationColor != "")
                            ? Color(decorationColor)
                            : null,
                        fontSize: (element.fontSize != 0)
                            ? element.fontSize
                            : (MediaQuery.of(context).size.longestSide /
                                    MediaQuery.of(context).size.shortestSide) *
                                15,
                        color: (element.color != "") ? Color(color) : null),
                  )),
            );
          } else {
            return StyledTextTag(
              style: GoogleFonts.robotoCondensed(
                  textStyle: TextStyle(
                      fontWeight: fontWeight,
                      decoration:
                          element.isUnderLine ? TextDecoration.underline : null,
                      decorationColor: (element.decorationColor != "")
                          ? Color(decorationColor)
                          : null,
                      fontSize: (element.fontSize != 0)
                          ? element.fontSize
                          : (MediaQuery.of(context).size.longestSide /
                                  MediaQuery.of(context).size.shortestSide) *
                              15,
                      color: (element.color != "") ? Color(color) : null)),
            );
          }
        });
      });
    }
  }
}
