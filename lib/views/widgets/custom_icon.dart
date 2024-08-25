import 'package:flutter/material.dart';
import 'package:tiktok_clone/services/constants/colors.dart';

class CustomIcon extends StatelessWidget {
  const CustomIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 45,
      height: 30,
      child: Stack(
        children: [
          Align(
            alignment: Alignment(-1.2, 0),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: CustomColors.pinkColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(4),
                  bottomLeft: Radius.circular(4),
                ),
              ),
              child: SizedBox(width: 10, height: 40),
            ),
          ),
          Align(
            alignment: Alignment(1.2, 0),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: CustomColors.blueColor,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(4),
                  bottomRight: Radius.circular(4),
                ),
              ),
              child: SizedBox(width: 10, height: 40),
            ),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(6)),
            ),
            child: SizedBox(
              width: 45,
              height: 40,
              child: Icon(
                Icons.add,
                size: 20,
                color: CustomColors.backgroundColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
