import 'package:auspi_chandra_flutter/App_logic/app_logic_controller.dart';
import 'package:auspi_chandra_flutter/SizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'dart:math';

class PhotosViewPage extends StatelessWidget {
  final List<String> imgList;

  PhotosViewPage(this.imgList);

  @override
  Widget build(BuildContext context) {
    // Get the app_logic_controller instance
    final app_logic_controller controller = Get.find<app_logic_controller>();

    // Define dial and hand sizes using SizeConfig for responsiveness
    final double dialSize = 80 * SizeConfig.heightMultiplier; // Dial size (80% of screen height)
    final double handSize = dialSize * 0.48; // Hand size (48% of dial size, decreased by 20%)

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Text(
          'Back',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 2 * SizeConfig.textMultiplier,
            fontFamily: 'Abel',
          ),
        ),
        backgroundColor: Color(0xFF29b1ef),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      body: GetBuilder<app_logic_controller>(
        builder: (controller) => Column(
          children: [
            Container(
              color: Colors.white,
              height: 100 * SizeConfig.heightMultiplier,
              width: 100 * SizeConfig.widthMultiplier,
              child: PageView.builder(
                itemCount: imgList.length,
                itemBuilder: (context, index) {
                  return InteractiveViewer(
                    child: Center(
                      child: ClipOval( // Clip to ensure hands don't overflow dial
                        child: Container(
                          height: dialSize,
                          width: dialSize,
                          child: Stack(
                            alignment: Alignment.center, // Center all children
                            children: [
                              // Base dial image
                              Image.asset(
                                imgList[index],
                                fit: BoxFit.contain,
                                height: dialSize,
                                width: dialSize,
                              ),
                              // Hour hand
                              Transform.rotate(
                                angle: (controller.hour_rotation * pi) / 180,
                                child: Image.asset(
                                  "assets/hourhand.png",
                                  fit: BoxFit.contain,
                                  height: handSize * 0.96, // Decreased by 20% (1.2 * 0.8)
                                  width: handSize * 0.96,
                                ),
                              ),
                              // Minute hand
                              Transform.rotate(
                                angle: (double.parse("${controller.minutes_rotation}") * pi) / 180,
                                child: Image.asset(
                                  "assets/minutehand.png",
                                  fit: BoxFit.contain,
                                  height: handSize * 1.2, // Decreased by 20% (1.5 * 0.8)
                                  width: handSize * 1.2,
                                ),
                              ),
                              // Second hand
                              Transform.rotate(
                                angle: (double.parse("${controller.seconds_rotation}") * pi) / 180,
                                child: Image.asset(
                                  "assets/sechand.png",
                                  fit: BoxFit.contain,
                                  height: handSize * 1.2, // Decreased by 20% (1.5 * 0.8)
                                  width: handSize * 1.2,
                                  color:imgList[index] == "assets/chandra.png"? Colors.black:Colors.red,
                                ),
                              ),
                              // Moon hand (for chandra.png)
                              if (imgList[index] == "assets/chandra.png")
                                Transform.rotate(
                                  angle: (double.parse("${controller.cday}") * pi) / 180,
                                  child: Image.asset(
                                    "assets/moonh.png",
                                    fit: BoxFit.contain,
                                    height: handSize * 0.84, // Decreased by 20% (1.05 * 0.8)
                                    width: handSize * 0.84,
                                  ),
                                ),
                              // Tithi hand (for chandra.png)
                              if (imgList[index] == "assets/chandra.png")
                                Transform.rotate(
                                  angle: (controller.Tithi_hand * pi) / 180,
                                  child: Image.asset(
                                    "assets/tithi_hand.png",
                                    fit: BoxFit.contain,
                                    height: handSize * 0.84, // Decreased by 20% (1.05 * 0.8)
                                    width: handSize * 0.84,
                                    color: Colors.amber,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}