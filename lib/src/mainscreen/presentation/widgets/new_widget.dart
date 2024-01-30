import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:storyways/core/extensions/context.dart';
import 'package:storyways/src/mainscreen/domain/entities/book.dart';

class NewWidget extends StatelessWidget {
  const NewWidget({
    super.key,
    this.showInSearchBar = false,
    required this.book,
  });

  final bool showInSearchBar;
  final Book book;

  @override
  Widget build(BuildContext context) {
    final heightRatio = context.heightRatio;
    final widthRatio = context.widthRatio;
    return Padding(
      padding: EdgeInsets.only(
        left: widthRatio * 21,
        right: widthRatio * 16,
      ),
      child: InkWell(
        onTap: () {
          HapticFeedback.vibrate;
          FocusScope.of(context).unfocus();
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: showInSearchBar ? 60 * widthRatio : 75 * widthRatio,
              height: showInSearchBar ? 85 * heightRatio : 100 * heightRatio,
              decoration: ShapeDecoration(
                image: const DecorationImage(
                  image: NetworkImage(
                    "https://picsum.photos/150/200",
                  ),
                  fit: BoxFit.fill,
                ),
                color: const Color(0xFF263D36),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: widthRatio * 14,
              ),
              child: SizedBox(
                width: widthRatio * 180,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book.name,
                      overflow: TextOverflow.clip,
                      maxLines: 1,
                      style: const TextStyle(
                        color: Color(0xFF171918),
                        fontSize: 14,
                        fontFamily: 'Rubik',
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Opacity(
                      opacity: 0.5,
                      child: Text(
                        book.author,
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                          color: Color(0xFF171918),
                          fontSize: 12,
                          fontFamily: 'Rubik',
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                    ),
                    if (!showInSearchBar) ...[
                      SizedBox(
                        height: heightRatio * 14,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            height: widthRatio * 16,
                            width: widthRatio * 16,
                            child: SvgPicture.asset(
                              'assets/images/Calendar.svg',
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              left: widthRatio * 8,
                            ),
                            child: Text(
                              DateFormat('dd MMM y').format(book.releaseDate),
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Color(0xFF263D36),
                                fontSize: 12,
                                fontFamily: 'Rubik',
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
            if (!showInSearchBar) ...[
              const Spacer(),
              Container(
                alignment: Alignment.centerRight,
                width: widthRatio * 40,
                height: widthRatio * 40,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(width: 1, color: Color(0xFFD9E5E2)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                    left: widthRatio * 11,
                    right: widthRatio * 9,
                    top: heightRatio * 10,
                    bottom: heightRatio * 10,
                  ),
                  child: SvgPicture.asset(
                    'assets/images/bell.svg',
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
