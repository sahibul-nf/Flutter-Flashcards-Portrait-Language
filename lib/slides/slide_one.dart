import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flashcards_portrait/app_localizations.dart';
import 'package:flutter_flashcards_portrait/models/tags.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:styled_text/styled_text.dart';
import 'package:url_launcher/url_launcher.dart';

import '../screens/learn_more.dart';
import '../models/slide.dart';

class SlideOne extends ConsumerStatefulWidget {
  final Slide slide;
  final String categoryName;
  final int pages;
  final Function flip;
  final FlipCardController controller;
  const SlideOne({
    Key? key,
    required this.slide,
    required this.categoryName,
    required this.pages,
    required this.flip,
    required this.controller,
  }) : super(key: key);

  @override
  ConsumerState<SlideOne> createState() => _SlideOneState();
}

class _SlideOneState extends ConsumerState<SlideOne> {
  Map<String, StyledTextTagBase> tags = {};

  @override
  Widget build(BuildContext context) {
    updateTags();
    return Column(
      children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(
                left: 32.0, right: 32.0, top: 0.0, bottom: 0.0),
            color: Colors.transparent,
            child: FlipCard(
              controller: widget.controller,
              direction: FlipDirection.VERTICAL,
              speed: 1000,
              onFlip: () async {
                await Future.delayed(const Duration(milliseconds: 500));
                widget.flip();
              },
              onFlipDone: (status) {
                widget.flip(status: !status);
              },
              front: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                ),
                child: Center(
                    child: StyledText(
                  textAlign: TextAlign.center,
                  text: widget.slide.firstSide,
                  style: TextStyle(
                    fontFamily: "RobotoSerif",
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w400,
                    fontSize: (MediaQuery.of(context).size.longestSide /
                            MediaQuery.of(context).size.shortestSide) *
                        15,
                  ),
                  tags: tags,
                )),
              ),
              back: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                ),
                child: Center(
                  child: Column(
                    children: [
                      const Spacer(),
                      StyledText(
                        text: widget.slide.secondSide,
                        style: TextStyle(
                          fontFamily: "RobotoSerif",
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w400,
                          fontSize: 19,
                          height: 1.7,
                        ),
                        tags: tags,
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Row(
                          children: [
                            const Spacer(),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shadowColor: Colors.transparent,
                                backgroundColor: Colors.grey.shade100,
                                shape: RoundedRectangleBorder(
                                    side: const BorderSide(
                                        color: Colors.blue, width: 0.5),
                                    borderRadius: BorderRadius.circular(10.0)),
                                padding: const EdgeInsets.all(10.0),
                              ),
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LearnMore(
                                      categoryName: widget.categoryName,
                                      tags: tags,
                                      text: widget.slide.learnMore),
                                ),
                              ),
                              child: Text(
                                AppLocalizations.of(context)!
                                    .translate('learn_more')!,
                                style: GoogleFonts.robotoCondensed(
                                  textStyle: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: Colors.blue.shade500,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                            const Spacer(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void updateTags() {
    List<Tags> tagsList = AppLocalizations.of(context)!.getTags();
    tags.clear();
    for (var element in tagsList) {
      int color = int.parse("0xff" + element.color);
      int decorationColor = int.parse("0xff" + element.decorationColor);

      FontWeight fontWeight =
          element.fontWeight == "bold" ? FontWeight.bold : FontWeight.normal;

      TextStyle tagTextStyle = TextStyle(
          fontFamily: "RobotoSerif",
          fontWeight: fontWeight,
          decoration: element.isUnderLine ? TextDecoration.underline : null,
          decorationColor:
              (element.decorationColor != "") ? Color(decorationColor) : null,
          fontSize: (element.fontSize != 0) ? element.fontSize : null,
          color: (element.color != "") ? Color(color) : null);
      setState(() {
        tags.putIfAbsent(element.tag, () {
          if (element.tag == 'link') {
            return StyledTextActionTag(
              (String? text, Map<String?, String?> attrs) async {
                final String? link = attrs['href'];
                launchUrl(Uri.parse(link!));
              },
              style: tagTextStyle,
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
                    style: tagTextStyle,
                  )),
            );
          } else {
            return StyledTextTag(
              style: tagTextStyle,
            );
          }
        });
      });
    }
  }
}
