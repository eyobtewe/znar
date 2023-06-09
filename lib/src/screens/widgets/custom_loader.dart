import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

import '../../core/core.dart';

class CustomLoader extends StatelessWidget {
  final bool isPlayer;

  const CustomLoader({Key key, this.isPlayer = false}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 30,
        height: 30,
        child: SleekCircularSlider(
          appearance: CircularSliderAppearance(
            spinnerMode: true,
            customColors: CustomSliderColors(
              progressBarColors: [
                Colors.red,
                Colors.orange,
                // cPrimaryColor,
              ],
              trackColor: isPlayer
                  ? Theme.of(context).scaffoldBackgroundColor
                  : cPrimaryColor,
              dotColor:
                  isPlayer ? Theme.of(context).scaffoldBackgroundColor : cGray,
            ),
            customWidths: CustomSliderWidths(
              progressBarWidth: isPlayer ? 15 : 1,
              trackWidth: isPlayer ? 15 : 1,
            ),
          ),
        ),
      ),
    );
  }
}
