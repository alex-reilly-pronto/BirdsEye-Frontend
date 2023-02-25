import 'package:flutter/material.dart';

class ShiftingFit extends LayoutBuilder {
  ShiftingFit(Widget a, Widget b, {super.key, bool ignoreBasline = false})
      : super(builder: (BuildContext context, BoxConstraints constraints) {
          if (constraints.maxWidth < 300) {
            return Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [a, Flexible(fit: FlexFit.loose, child: b)]));
          } else {
            return Row(
              crossAxisAlignment: ignoreBasline
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Expanded(child: Align(alignment: Alignment.topLeft, child: a)),
                Align(
                    alignment: Alignment.topRight,
                    child: LimitedBox(
                        maxWidth: constraints.maxWidth / 1.75, child: b))
              ],
            );
          }
        });
}

const double lineBaseline = 12;
