import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:storyways/core/extensions/context.dart';
import 'package:storyways/src/mainscreen/domain/entities/book.dart';

class ContinueWidget extends StatelessWidget {
  const ContinueWidget({
    super.key,
    required this.book,
  });

  final Book book;

  @override
  Widget build(BuildContext context) {
    final heightRatio = context.heightRatio;
    final widthRatio = context.widthRatio;
    return Padding(
      padding: EdgeInsets.only(left: widthRatio * 12, right: widthRatio * 12),
      child: InkWell(
        onTap: () {
          HapticFeedback.vibrate;
          FocusScope.of(context).unfocus();
        },
        child: SizedBox(
          height: heightRatio * 100,
          width: widthRatio * 100,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: widthRatio * 50,
                    backgroundImage:
                        const NetworkImage("https://picsum.photos/150"),
                  ),
                  Positioned(
                    top: heightRatio * 68,
                    left: widthRatio * 60,
                    child: Container(
                      width: 40 * widthRatio,
                      height: 40 * heightRatio,
                      decoration: const ShapeDecoration(
                        color: Color(0xFF5C5EA6),
                        shape: OvalBorder(),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: widthRatio * 7,
                          bottom: widthRatio * 7.86,
                          left: heightRatio * 9,
                          right: heightRatio * 9,
                        ),
                        child: SvgPicture.asset(
                          'assets/images/Play.svg',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: heightRatio * 9,
              ),
              Text(
                book.name,
                maxLines: 1,
                overflow: TextOverflow.clip,
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
                  maxLines: 1,
                  style: const TextStyle(
                    color: Color(0xFF171918),
                    fontSize: 12,
                    fontFamily: 'Rubik',
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.normal,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
