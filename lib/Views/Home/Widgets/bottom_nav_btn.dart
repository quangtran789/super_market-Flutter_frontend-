import 'package:app_supermarket/utils/size_config.dart';
import 'package:flutter/material.dart';

class BottomNavBtn extends StatelessWidget {
  final IconData icon;
  final int index;
  final int currentIndex;
  final Function(int) onPressed;
  const BottomNavBtn({
    super.key,
    required this.icon,
    required this.index,
    required this.currentIndex,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    AppSizes().initSizes(context);
    return InkWell(
      onTap: () {
        onPressed(index);
      },
      child: Container(
          height: AppSizes.blockSizeHorizontal * 13,
          width: AppSizes.blockSizeHorizontal * 17,
          color: Colors.transparent,
          child: AnimatedOpacity(
            opacity: (currentIndex == index)? 1 : .02,
            duration: Duration(microseconds: 300),
            child: Icon(
              icon,
              color: Color(0xff0FD5AF),
              size: AppSizes.blockSizeHorizontal * 8,
            ),
          )),
    );
  }
}
