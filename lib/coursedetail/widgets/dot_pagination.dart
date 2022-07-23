import 'package:flutter/material.dart';
import 'package:he/coursedetail/coursedetail.dart';

@immutable
class DotPagination extends StatelessWidget {
  const DotPagination(
      {Key? key, required this.itemCount, required this.activeIndex})
      : assert(activeIndex >= 0),
        assert(activeIndex < itemCount),
        super(key: key);

  final int itemCount;
  final int activeIndex;

  @override
  Widget build(BuildContext context) {
    const inactiveDot = ColorDot();
    final activeDot = ColorDot(
      color: Theme.of(context).primaryColor,
    );

    final list = List<ColorDot>.generate(
      itemCount,
      (index) => (index == activeIndex) ? activeDot : inactiveDot,
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 20, top: 20, left: 5, right: 5),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: list,
      ),
    );
  }
}
