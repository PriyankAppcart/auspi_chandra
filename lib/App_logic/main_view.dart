import 'dart:math';

import 'package:auspi_chandra_flutter/App_logic/app_logic_controller.dart';
import 'package:auspi_chandra_flutter/App_logic/sectetion_list.dart';
import 'package:auspi_chandra_flutter/RemoteServices/cust_text_center.dart';
import 'package:auspi_chandra_flutter/SizeConfig.dart';
import 'package:auspi_chandra_flutter/cust_text.dart';
import 'package:auspi_chandra_flutter/photosViewPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:url_launcher/url_launcher.dart';

class MainView extends StatelessWidget {
  MainView({Key? key}) : super(key: key);

  final app_logic_controller logicController = Get.put(app_logic_controller());

  bool isDataLoaded(app_logic_controller controller) {
    return controller.City.isNotEmpty &&
        controller.bharatiya_saur.isNotEmpty &&
        controller.CRashi.isNotEmpty &&
        controller.CNkh.isNotEmpty &&
        controller.MoonRise.isNotEmpty &&
        controller.MoonSet.isNotEmpty &&
        controller.current_Time.isNotEmpty &&
        controller.days.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<app_logic_controller>(
        init: app_logic_controller(),
        builder: (controller) => Container(
          decoration: BoxDecoration(
            color: !controller.internetConnection ||
                    !controller.enableDeviceLocation ||
                    !isDataLoaded(controller)
                ? Colors.white
                : null,
            gradient: controller.internetConnection &&
                    controller.enableDeviceLocation &&
                    isDataLoaded(controller)
                ? LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: controller.isDarkMode
                        ? [
                            Color(0xFF0D1117),
                            Color(0xFF161B22),
                            Color(0xFF0D1117),
                          ]
                        : [
                            Color(0xFFE3F2FD),
                            Color.fromARGB(255, 163, 206, 242),
                            Color.fromARGB(255, 169, 219, 255),
                          ],
                  )
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 12 * SizeConfig.heightMultiplier,
                width: 100 * SizeConfig.widthMultiplier,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: controller.isDarkMode
                        ? [Color(0xFF0B3D91), Color(0xFF1E88E5)]
                        : [Color(0xFF0095da), Color(0xFF29b1ef)],
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: controller.isDarkMode
                          ? Colors.black38
                          : Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                    top: 4 * SizeConfig.heightMultiplier,
                    left: 4 * SizeConfig.widthMultiplier,
                    right: 4 * SizeConfig.widthMultiplier,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustText(
                        name: "Auspi Chandra",
                        size: 2,
                        colors: Colors.white,
                        fontWeightName: FontWeight.w600,
                      ),
                      Row(
                        children: [
                          controller.enableDeviceLocation
                              ? Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 3 * SizeConfig.widthMultiplier,
                                    vertical: 0.5 * SizeConfig.heightMultiplier,
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(Icons.location_on,
                                          color: Colors.white, size: 16),
                                      SizedBox(
                                          width: 1 * SizeConfig.widthMultiplier),
                                      Text(
                                        "${controller.City}",
                                        style: TextStyle(
                                          fontSize:
                                              1.4 * SizeConfig.textMultiplier,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : SizedBox(),
                          SizedBox(width: 2 * SizeConfig.widthMultiplier),
                          _buildThemeToggle(controller),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              !controller.enableDeviceLocation
                  ? Center(
                      child: Container(
                        height: 80 * SizeConfig.heightMultiplier,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/splash.png',
                              height: 40 * SizeConfig.widthMultiplier,
                              width: 40 * SizeConfig.widthMultiplier,
                            ),
                            SizedBox(height: 3 * SizeConfig.heightMultiplier),
                            CustText(
                              name: "GPS Service",
                              size: 2,
                              colors: Colors.black,
                              fontWeightName: FontWeight.w700,
                            ),
                            SizedBox(height: 1 * SizeConfig.heightMultiplier),
                            Container(
                              width: 85 * SizeConfig.widthMultiplier,
                              child: CustTextCenter(
                                name:
                                    "GPS Service is not enabled, To get accurate AUSPICIOUS time at your location, please turn on your device's GPS location.",
                                size: 1.8,
                                colors: Colors.black,
                                fontWeightName: FontWeight.w400,
                              ),
                            ),
                            SizedBox(height: 2.5 * SizeConfig.heightMultiplier),
                            ElevatedButton(
                              onPressed: () {
                                controller.checkGps();
                              },
                              style: ElevatedButton.styleFrom(
                                elevation: 12.0,
                                textStyle: const TextStyle(color: Colors.white),
                              ),
                              child: const Text('Refresh'),
                            ),
                            SizedBox(height: 2.5 * SizeConfig.heightMultiplier),
                            Container(
                              width: 85 * SizeConfig.widthMultiplier,
                              child: CustTextCenter(
                                name: "To select preset location ",
                                size: 1.8,
                                colors: Colors.black,
                                fontWeightName: FontWeight.w400,
                              ),
                            ),
                            SizedBox(height: 1 * SizeConfig.heightMultiplier),
                            ElevatedButton(
                              onPressed: () {
                                showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (BuildContext context) =>
                                      sectetionList(
                                    dataList: controller.mapLatLong,
                                    onSelected: (city, lat, long) {
                                      print(
                                          "Selected city $city , $lat, $long");
                                      controller.getLocationPreset(lat, long);
                                    },
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                elevation: 12.0,
                                textStyle: const TextStyle(color: Colors.white),
                              ),
                              child: const Text('Click here'),
                            ),
                            SizedBox(height: 1 * SizeConfig.heightMultiplier),
                            ElevatedButton(
                              onPressed: () {
                                try {
                                  launch(
                                      "https://auspiwatch.com/auspiwatchprivacypolicy.html");
                                } catch (e) {}
                              },
                              style: ElevatedButton.styleFrom(
                                elevation: 12.0,
                                textStyle: const TextStyle(color: Colors.white),
                              ),
                              child: const Text('Privacy Policy'),
                            ),
                          ],
                        ),
                      ),
                    )
                  : !controller.internetConnection
                      ? Center(
                          child: Container(
                            height: 80 * SizeConfig.heightMultiplier,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/splash.png',
                                  height: 40 * SizeConfig.widthMultiplier,
                                  width: 40 * SizeConfig.widthMultiplier,
                                ),
                                SizedBox(
                                    height: 3 * SizeConfig.heightMultiplier),
                                CustText(
                                  name: "Internet Connection Not available.",
                                  size: 1.8,
                                  colors: Colors.black,
                                  fontWeightName: FontWeight.w600,
                                ),
                                SizedBox(
                                    height: 1 * SizeConfig.heightMultiplier),
                                Container(
                                  width: 85 * SizeConfig.widthMultiplier,
                                  child: CustTextCenter(
                                    name:
                                        "To get accurate AUSPICIOUS time please turn on your device's Internet Connection.",
                                    size: 1.8,
                                    colors: Colors.black,
                                    fontWeightName: FontWeight.w400,
                                  ),
                                ),
                                SizedBox(
                                    height: 2.5 * SizeConfig.heightMultiplier),
                                ElevatedButton(
                                  onPressed: () {
                                    controller.checkGps();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    elevation: 12.0,
                                    textStyle:
                                        const TextStyle(color: Colors.white),
                                  ),
                                  child: const Text('Refresh'),
                                ),
                                SizedBox(
                                    height: 1 * SizeConfig.heightMultiplier),
                                ElevatedButton(
                                  onPressed: () {
                                    try {
                                      launch(
                                          "https://auspiwatch.com/auspiwatchprivacypolicy.html");
                                    } catch (e) {}
                                  },
                                  style: ElevatedButton.styleFrom(
                                    elevation: 12.0,
                                    textStyle:
                                        const TextStyle(color: Colors.white),
                                  ),
                                  child: const Text('Privacy Policy'),
                                ),
                              ],
                            ),
                          ),
                        )
                      : !isDataLoaded(controller)
                          ? Center(
                              child: Container(
                                height: 80 * SizeConfig.heightMultiplier,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/splash.png',
                                      height: 40 * SizeConfig.widthMultiplier,
                                      width: 40 * SizeConfig.widthMultiplier,
                                    ),
                                    SizedBox(
                                        height:
                                            3 * SizeConfig.heightMultiplier),
                                    CustText(
                                      name: "Loading Data...",
                                      size: 1.8,
                                      colors: Colors.black,
                                      fontWeightName: FontWeight.w600,
                                    ),
                                    SizedBox(
                                        height:
                                            2 * SizeConfig.heightMultiplier),
                                    const CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Color(0xFF29b1ef)),
                                    ),
                                    SizedBox(
                                        height:
                                            2 * SizeConfig.heightMultiplier),
                                    Container(
                                      width: 85 * SizeConfig.widthMultiplier,
                                      child: CustTextCenter(
                                        name:
                                            "Please wait while we fetch the auspicious time data.",
                                        size: 1.8,
                                        colors: Colors.black,
                                        fontWeightName: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Container(
                              height: 88 * SizeConfig.heightMultiplier,
                              child: Padding(
                                padding: EdgeInsets.all(
                                    2 * SizeConfig.widthMultiplier),
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(
                                            3 * SizeConfig.widthMultiplier),
                                        decoration: BoxDecoration(
                                          color: controller.isDarkMode
                                              ? Colors.indigo.withOpacity(0.15)
                                              : Colors.indigo.withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          border: Border.all(
                                            color: controller.isDarkMode
                                                ? Colors.indigo.withOpacity(0.3)
                                                : Colors.indigo
                                                    .withOpacity(0.2),
                                            width: 1,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: controller.isDarkMode
                                                  ? Colors.black12
                                                  : Colors.indigo
                                                      .withOpacity(0.1),
                                              blurRadius: 8,
                                              offset: Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              padding: EdgeInsets.all(2 *
                                                  SizeConfig.widthMultiplier),
                                              decoration: BoxDecoration(
                                                color: controller.isDarkMode
                                                    ? Colors.indigo
                                                        .withOpacity(0.2)
                                                    : Colors.indigo
                                                        .withOpacity(0.1),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Icon(
                                                Icons.calendar_today,
                                                color: controller.isDarkMode
                                                    ? Colors.cyanAccent
                                                    : Colors.indigo,
                                                size: 6 *
                                                    SizeConfig.widthMultiplier,
                                              ),
                                            ),
                                            SizedBox(
                                                width: 3 *
                                                    SizeConfig.widthMultiplier),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Bharatiya Saur",
                                                    style: TextStyle(
                                                      fontSize: 1.8 *
                                                          SizeConfig
                                                              .textMultiplier,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: controller
                                                              .isDarkMode
                                                          ? Colors.cyanAccent
                                                          : Colors.indigo,
                                                      letterSpacing: 1.1,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                      height: 1 *
                                                          SizeConfig
                                                              .heightMultiplier),
                                                  Text(
                                                    "${controller.bharatiya_saur}",
                                                    style: TextStyle(
                                                      fontSize: 2 *
                                                          SizeConfig
                                                              .textMultiplier,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color:
                                                          controller.isDarkMode
                                                              ? Colors.white
                                                              : Colors.black87,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                      height: 0.5 *
                                                          SizeConfig
                                                              .heightMultiplier),
                                                  Text(
                                                    "${controller.days} ${controller.current_Time}",
                                                    style: TextStyle(
                                                      fontSize: 1.6 *
                                                          SizeConfig
                                                              .textMultiplier,
                                                      color:
                                                          controller.isDarkMode
                                                              ? Colors.white
                                                              : Colors.black54,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                          height:
                                              2 * SizeConfig.heightMultiplier),
                                      auspiSevenData(
                                        9,
                                        Color(0xFF0196da),
                                        "assets/moon_icon.png",
                                        "",
                                        "",
                                        "Moon-Rashi",
                                        "${controller.CRashi}",
                                        "Nakshatra",
                                        "${controller.CNkh} ${controller.Nakshatra_endtime}",
                                        "MoonRise",
                                        "${controller.MoonRise}",
                                        "Moonset",
                                        "${controller.MoonSet}",
                                        "Yog",
                                        "${controller.Yog_endtime}",
                                        "Moon Month",
                                        "${controller.Hindu_month}",
                                        "Moon Tithi",
                                        "${controller.MoonTithi} ${controller.Tithi_endtime}",
                                        "Tithi Karan",
                                        "${controller.KaranText} ${controller.Karan_endtime}",
                                        "Hora (${controller.Hora_duration} min)\n\n",
                                        "${controller.graha} \n(Starts:${controller.Hora_start}) \n(Ends:${controller.Hora_end})",
                                      ),
                                      SizedBox(
                                          height:
                                              1 * SizeConfig.heightMultiplier),
                                      Container(
                                        height:
                                            42 * SizeConfig.heightMultiplier,
                                        margin:
                                            EdgeInsets.symmetric(horizontal: 5),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                        ),
                                        child: PageView(
                                          controller: controller.controller,
                                          onPageChanged: (int page) {
                                            controller.indicator(page);
                                          },
                                          children: <Widget>[
                                            GestureDetector(
                                              onTap: () {
                                                List<String> imgList = [
                                                  "assets/chandra.png"
                                                ];
                                                Get.to(PhotosViewPage(imgList));
                                              },
                                              child: Center(
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                    left: 2 *
                                                        (MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            100),
                                                    right: 2 *
                                                        (MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            100),
                                                  ),
                                                  child: InteractiveViewer(
                                                    child: Container(
                                                      height: 60 *
                                                          SizeConfig
                                                              .heightMultiplier,
                                                      width: 39 *
                                                          SizeConfig
                                                              .heightMultiplier,
                                                      child: Stack(
                                                        children: [
                                                          Center(
                                                            child: Container(
                                                              child: Image.asset(
                                                                  "assets/chandra.png",
                                                                  fit:
                                                                      BoxFit.fill),
                                                            ),
                                                          ),
                                                          Transform.rotate(
                                                            angle:
                                                                (controller.hour_rotation *
                                                                        pi) /
                                                                    180,
                                                            child: Center(
                                                                child: Image.asset(
                                                                    "assets/hourhand.png",
                                                                    fit: BoxFit
                                                                        .fitHeight)),
                                                          ),
                                                          Transform.rotate(
                                                            angle: ((double.parse(
                                                                        "${controller.minutes_rotation}")) *
                                                                    pi) /
                                                                180,
                                                            child: Center(
                                                                child: Image.asset(
                                                                    "assets/minutehand.png",
                                                                    fit: BoxFit
                                                                        .fitHeight)),
                                                          ),
                                                          Transform.rotate(
                                                            angle: ((double.parse(
                                                                        "${controller.seconds_rotation}")) *
                                                                    pi) /
                                                                180,
                                                            child: Center(
                                                                child: Image.asset(
                                                                    "assets/sechand.png",
                                                                    fit: BoxFit
                                                                        .fitHeight,
                                                                    color: Colors
                                                                        .black)),
                                                          ),
                                                          Transform.rotate(
                                                            angle: ((double.parse(
                                                                        "${controller.cday}")) *
                                                                    pi) /
                                                                180,
                                                            child: Center(
                                                                child: Image.asset(
                                                                    "assets/moonh.png",
                                                                    fit: BoxFit
                                                                        .fitHeight)),
                                                          ),
                                                          Transform.rotate(
                                                            angle: (controller
                                                                        .Tithi_hand *
                                                                    pi) /
                                                                180,
                                                            child: Center(
                                                                child: Image.asset(
                                                                    "assets/tithi_hand.png",
                                                                    fit: BoxFit
                                                                        .fitHeight,
                                                                    color: Colors
                                                                        .amber)),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                controller
                                                    .scheduleDailyTenAMNotification();
                                                List<String> imgList = [
                                                  "assets/${controller.days.toLowerCase()}.png"
                                                ];
                                                Get.to(PhotosViewPage(imgList));
                                              },
                                              child: Center(
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                    left: 2 *
                                                        (MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            100),
                                                    right: 2 *
                                                        (MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            100),
                                                  ),
                                                  child: InteractiveViewer(
                                                    child: Container(
                                                      height: 39 *
                                                          SizeConfig
                                                              .heightMultiplier,
                                                      width: 39 *
                                                          SizeConfig
                                                              .heightMultiplier,
                                                      child: Stack(
                                                        children: [
                                                          Center(
                                                            child: Container(
                                                              child: Image.asset(
                                                                  "assets/${controller.days.toLowerCase()}.png",
                                                                  fit:
                                                                      BoxFit.fill),
                                                            ),
                                                          ),
                                                          Transform.rotate(
                                                            angle:
                                                                (controller.hour_rotation *
                                                                        pi) /
                                                                    180,
                                                            child: Center(
                                                                child: Image.asset(
                                                                    "assets/hourhand.png",
                                                                    fit: BoxFit
                                                                        .fitHeight)),
                                                          ),
                                                          Transform.rotate(
                                                            angle: ((double.parse(
                                                                        "${controller.minutes_rotation}")) *
                                                                    pi) /
                                                                180,
                                                            child: Center(
                                                                child: Image.asset(
                                                                    "assets/minutehand.png",
                                                                    fit: BoxFit
                                                                        .fitHeight)),
                                                          ),
                                                          Transform.rotate(
                                                            angle: ((double.parse(
                                                                        "${controller.seconds_rotation}")) *
                                                                    pi) /
                                                                180,
                                                            child: Center(
                                                                child: Image.asset(
                                                                    "assets/sechand.png",
                                                                    fit: BoxFit
                                                                        .fitHeight)),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                List<String> imgList = [
                                                  "assets/moon_help.png"
                                                ];
                                                Get.to(PhotosViewPage(imgList));
                                              },
                                              child: Center(
                                                child: Image.asset(
                                                  "assets/moon_help.png",
                                                  height: 42 *
                                                      SizeConfig
                                                          .heightMultiplier,
                                                  width: 100 *
                                                      SizeConfig
                                                          .widthMultiplier,
                                                  fit: BoxFit.fitHeight,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                          height:
                                              2 * SizeConfig.heightMultiplier),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            height:
                                                2 * SizeConfig.widthMultiplier,
                                            width:
                                                2 * SizeConfig.widthMultiplier,
                                            decoration: BoxDecoration(
                                              color:
                                                  controller.pageindicator == 0
                                                      ? const Color(0xFF29b1ef)
                                                      : controller.isDarkMode
                                                          ? Colors.white
                                                          : Colors.black12,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          SizedBox(
                                              width: 1 *
                                                  SizeConfig.widthMultiplier),
                                          Container(
                                            height:
                                                2 * SizeConfig.widthMultiplier,
                                            width:
                                                2 * SizeConfig.widthMultiplier,
                                            decoration: BoxDecoration(
                                              color:
                                                  controller.pageindicator == 1
                                                      ? const Color(0xFF29b1ef)
                                                      : controller.isDarkMode
                                                          ? Colors.white
                                                          : Colors.black12,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          SizedBox(
                                              width: 1 *
                                                  SizeConfig.widthMultiplier),
                                          Container(
                                            height:
                                                2 * SizeConfig.widthMultiplier,
                                            width:
                                                2 * SizeConfig.widthMultiplier,
                                            decoration: BoxDecoration(
                                              color:
                                                  controller.pageindicator == 2
                                                      ? const Color(0xFF29b1ef)
                                                      : controller.isDarkMode
                                                          ? Colors.white
                                                          : Colors.black12,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                          height:
                                              4 * SizeConfig.heightMultiplier),
                                    ],
                                  ),
                                ),
                              ),
                            ),
            ],
          ),
        ),
      ),
    );
  }

  Widget auspiSevenData(
      int boxHeight,
      Color colorName,
      String img,
      String title7,
      String butitle7,
      String title1,
      String butitle1,
      String title2,
      String butitle2,
      String title3,
      String butitle3,
      String title4,
      String butitle4,
      String title5,
      String butitle5,
      String title8,
      String butitle8,
      String title9,
      String butitle9,
      String title6,
      String butitle6,
      String title10,
      String butitle10) {
    return Padding(
      padding: EdgeInsets.all(1 * SizeConfig.widthMultiplier),
      child: Container(
        decoration: BoxDecoration(
          color: logicController.isDarkMode
              ? Colors.grey.shade900.withOpacity(0.7)
              : Colors.white,
          borderRadius:
              BorderRadius.all(Radius.circular(2 * SizeConfig.widthMultiplier)),
        ),
        child: IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 11 * SizeConfig.widthMultiplier,
                decoration: BoxDecoration(
                  color: colorName.withOpacity(0.2),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(2 * SizeConfig.widthMultiplier),
                    bottomLeft: Radius.circular(2 * SizeConfig.widthMultiplier),
                  ),
                ),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(1 * SizeConfig.widthMultiplier),
                    child: Image.asset(
                      img,
                      height: 8 * SizeConfig.widthMultiplier,
                      width: 8 * SizeConfig.widthMultiplier,
                      fit: BoxFit.fitWidth,
                      color: colorName,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 2 * SizeConfig.widthMultiplier,
                    vertical: 1 * SizeConfig.heightMultiplier,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      if (butitle7 != "") ...[
                        auspiSevenSubData(title7, butitle7),
                        SizedBox(height: SizeConfig.heightMultiplier),
                      ],
                      auspiSevenSubData(title1, butitle1),
                      SizedBox(height: SizeConfig.heightMultiplier),
                      auspiSevenSubData(title2, butitle2),
                      SizedBox(height: SizeConfig.heightMultiplier),
                      title3 == "Anandadi Yog"
                          ? auspiSevenSubYogData(title3, butitle3)
                          : auspiSevenSubData(title3, butitle3),
                      SizedBox(height: SizeConfig.heightMultiplier),
                      title4 == "Phal"
                          ? auspiSevenSubYogData(title4, butitle4)
                          : auspiSevenSubData(title4, butitle4),
                      if (butitle5 != "") ...[
                        SizedBox(height: SizeConfig.heightMultiplier),
                        auspiSevenSubData(title5, butitle5),
                      ],
                      if (butitle8 != "") ...[
                        SizedBox(height: SizeConfig.heightMultiplier),
                        auspiSevenSubData(title8, butitle8),
                      ],
                      if (butitle9 != "") ...[
                        SizedBox(height: SizeConfig.heightMultiplier),
                        auspiSevenSubData(title9, butitle9),
                      ],
                      if (butitle6 != "") ...[
                        SizedBox(height: SizeConfig.heightMultiplier),
                        auspiSevenSubData(title6, butitle6),
                      ],
                      if (logicController.graha != "") ...[
                        SizedBox(height: SizeConfig.heightMultiplier),
                        auspiSevenSubData(title10, butitle10),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget auspiSevenSubData(String title, String bubTitle) {
    return Container(
      width: 80 * SizeConfig.widthMultiplier,
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 1 * SizeConfig.heightMultiplier,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: CustText(
                name: title,
                size: 1.6,
                colors: logicController.isDarkMode
                    ? Colors.blue.shade300
                    : Colors.blue.shade700,
                fontWeightName: FontWeight.w700,
              ),
            ),
            Expanded(
              flex: 5,
              child: Align(
                alignment: Alignment.centerLeft,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: CustText(
                    name: bubTitle,
                    size: 1.6,
                    colors: logicController.isDarkMode
                        ? Colors.white
                        : Color(0xFF565656),
                    fontWeightName: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget auspiSevenSubYogData(String title, String bubTitle) {
    return Container(
      width: 80 * SizeConfig.widthMultiplier,
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 1 * SizeConfig.heightMultiplier,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: CustText(
                name: title,
                size: 1.6,
                colors: logicController.isDarkMode
                    ? Colors.blue.shade300
                    : Colors.blue.shade700,
                fontWeightName: FontWeight.w700,
              ),
            ),
            Expanded(
              flex: 5,
              child: Align(
                alignment: Alignment.centerLeft,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: CustText(
                    name: bubTitle,
                    size: 1.6,
                    colors: logicController.yoggood == "true"
                        ? Colors.green
                        : Colors.red,
                    fontWeightName: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeToggle(app_logic_controller controller) {
    return Container(
      height: 4 * SizeConfig.heightMultiplier,
      width: 4 * SizeConfig.heightMultiplier,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        shape: BoxShape.circle,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(4 * SizeConfig.heightMultiplier),
          onTap: () {
            controller.toggleTheme();
          },
          child: Center(
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return RotationTransition(
                  turns: animation,
                  child: ScaleTransition(
                    scale: animation,
                    child: child,
                  ),
                );
              },
              child: controller.isDarkMode
                  ? Icon(
                      Icons.light_mode,
                      key: ValueKey('light'),
                      color: Colors.amber,
                      size: 18,
                    )
                  : Icon(
                      Icons.dark_mode,
                      key: ValueKey('dark'),
                      color: Colors.white,
                      size: 18,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}


// import 'dart:math';

// import 'package:auspi_chandra_flutter/App_logic/app_logic_controller.dart';
// import 'package:auspi_chandra_flutter/App_logic/sectetion_list.dart';
// import 'package:auspi_chandra_flutter/RemoteServices/cust_text_center.dart';
// import 'package:auspi_chandra_flutter/SizeConfig.dart';
// import 'package:auspi_chandra_flutter/cust_text.dart';
// import 'package:auspi_chandra_flutter/photosViewPage.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:url_launcher/url_launcher.dart';

// // import 'package:praniti/customFields/cust_text.dart';
// // import 'package:praniti/subscription/subscription_controller.dart';
// // import 'package:praniti/util/SizeConfig.dart';

// class MainView extends StatelessWidget {
//   MainView({Key? key}) : super(key: key);

//   var logicController = Get.put(app_logic_controller());
//   @override
//   Widget build(BuildContext context) {

//     return Scaffold(
//       //backgroundColor: Color(0xFFFAFAFB),
//       body: GetBuilder<app_logic_controller>(
//         init: app_logic_controller(),
//         builder: (controller) => Container(
//           color:logicController.enableDeviceLocation || logicController.internetConnection?Colors.white:Color(0xFFFAFAFB),
//           child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 Container(
//                   height: 12 * SizeConfig.heightMultiplier,
//                   width: 100 * SizeConfig.widthMultiplier,
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomLeft,
//                       colors: [Color(0xFF0095da),Color(0xFF29b1ef)],
//                       tileMode: TileMode.repeated,
//                     ),
//                   ),
//                   child: Padding(
//                     padding: EdgeInsets.only(top: 4 * SizeConfig.heightMultiplier,left: 4 * SizeConfig.widthMultiplier),
//                     child: Row(
//                       children: [
//                         CustText(name: "Auspi Chandra ",size: 2,colors:Colors.white,fontWeightName:FontWeight.w600),
//                       ],
//                     ),
//                   ),
//                 ),
//                 logicController.enableDeviceLocation?logicController.internetConnection?
//                 Container(
//                   height: 88 * SizeConfig.heightMultiplier,
//                   child: Padding(
//                     padding: EdgeInsets.all(2 * SizeConfig.widthMultiplier),
//                     child: SingleChildScrollView(
//                       child: Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.start,
//                         children: [
//                           Row(
//                             children: [
//                               Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.start,
//                                 children: [
//                                   CustText(name: "Bharatiya Saur: \n",size: 1.8,colors:Colors.black,fontWeightName:FontWeight.w600),
//                                 ],
//                               ),


//                               Container(
//                                   width: 61* SizeConfig.widthMultiplier,
//                                   child: CustText(name: "${logicController.bharatiya_saur} \n${logicController.days} ${logicController.current_Time}",size: 1.8,colors:Colors.black,fontWeightName:FontWeight.w600)),


//                             ],
//                           ),
//                           SizedBox(height: 2 * SizeConfig.heightMultiplier),
//                           // auspiSevenData(4,Color(0xFFefc000),"assets/sun_icon.png","","","Sun-Rashi","${logicController.SunRashi}",
//                           //     "Nakshatra","${logicController.SunNksh}","Rutu","${logicController.SunRutu}","Ayan","${logicController.SunAyan}","","","","","","","",""),
//                           // SizedBox(height: 1 * SizeConfig.heightMultiplier),
//                           auspiSevenData(9,Color(0xFF0196da),"assets/moon_icon.png","","","Moon-Rashi","${logicController.CRashi}",
//                               "Nakshatra","${logicController.CNkh} ${logicController.Nakshatra_endtime}","MoonRise","${logicController.MoonRise}","Moonset","${logicController.MoonSet}","Yog","${logicController.Yog_endtime}","Moon Month","${logicController.Hindu_month}","Moon Tithi","${logicController.MoonTithi} ${logicController.Tithi_endtime}","Tithi Karan","${logicController.KaranText} ${logicController.Karan_endtime}","Hora (${logicController.Hora_duration} min)\n\n","${logicController.graha} \n(Starts:${logicController.Hora_start}) \n(Ends:${logicController.Hora_end})"),
//                           SizedBox(height: 1 * SizeConfig.heightMultiplier),
//                           // auspiSevenData(11,Color(0xFFa6ce38),"assets/time_icon.png","Location ","${logicController.City}, ${logicController.State}, ${logicController.Country}","Hora (${logicController.Hora_duration} min)\n\n","${logicController.graha} \n(Starts:${logicController.Hora_start}) \n(Ends:${logicController.Hora_end})",
//                           //     "Rahu Kaal","\n(Starts:${logicController.rahukaalstartTime}) \n(Ends:${logicController.rahukaalendTime})","Sun-Rise","${logicController.SunRise}","Sun Set","${logicController.SunSet}","Moon Tithi","${logicController.MoonTithi} ${logicController.Tithi_endtime}","Tithi Karan","${logicController.KaranText} ${logicController.Karan_endtime}","Agni","${logicController.AgniText}","Ghatika Pal ","${logicController.MoonIllumination}"),
//                           // SizedBox(height: 2 * SizeConfig.heightMultiplier),
//                           Container(
//                             height: 42 * SizeConfig.heightMultiplier,
//                             child: PageView(
//                               /// [PageView.scrollDirection] defaults to [Axis.horizontal].
//                               /// Use [Axis.vertical] to scroll vertically.
//                               controller: logicController.controller,
//                               onPageChanged: (int page){
//                                 logicController.indicator(page);
//                               },
//                               children: <Widget>[

//                                 GestureDetector(
//                                   onTap: (){
//                                     List<String> imgList = ["assets/chandra.png"];
//                                     Get.to(PhotosViewPage(imgList));
//                                   },
//                                   child: Center(
//                                       child:  Padding(
//                                         padding:  EdgeInsets.only(left:2*(MediaQuery.of(context).size.width/100),right:2*(MediaQuery.of(context).size.width/100)  ),
//                                         child: Container(
//                                           height: 39 * SizeConfig.heightMultiplier,
//                                           width:  39 * SizeConfig.heightMultiplier,
//                                           child: Stack(
//                                             children: [
//                                               Center(
//                                                 child: Container(
//                                                   //height: 480,
//                                                   // width: 480,
//                                                   child: Image.asset("assets/chandra.png",fit: BoxFit.fill),
//                                                 ),
//                                               ),

//                                               Transform.rotate(
//                                                 angle: (logicController.hour_rotation*pi)/180,
//                                                 child: Center(child: Image.asset("assets/hourhand.png",fit: BoxFit.fitHeight)),
//                                               ),
//                                               Transform.rotate(
//                                                 angle: ((double.parse("${logicController.minutes_rotation}"))*pi)/180,
//                                                 child: Center(child: Image.asset("assets/minutehand.png",fit: BoxFit.fitHeight)),
//                                               ),

//                                               Transform.rotate(
//                                                 angle: ((double.parse("${logicController.seconds_rotation}"))*pi)/180,
//                                                 child: Center(child: Image.asset("assets/sechand.png",fit: BoxFit.fitHeight,
//                                                     color:Colors.black)),
//                                               ),

                                             
//                                               Transform.rotate(
//                                                 angle: ((double.parse("${logicController.cday}"))*pi)/180,
//                                                 child: Center(child: Image.asset("assets/moonh.png",fit: BoxFit.fitHeight)),
//                                               ),
//                                               Transform.rotate(
//                                                 angle: (logicController.Tithi_hand*pi)/180,
//                                                 child: Center(child: Image.asset("assets/tithi_hand.png",fit: BoxFit.fitHeight,
//                                                     color:Colors.amber)),
//                                               ),

//                                             ],
//                                           ),
//                                         ),
//                                       )
//                                   ),
//                                 ),
//                                 GestureDetector(
//                                   onTap: (){
//                                     logicController.scheduleDailyTenAMNotification();
//                                     List<String> imgList = ["assets/${logicController.days.toLowerCase()}.png"];
//                                     Get.to(PhotosViewPage(imgList));
//                                   },
//                                   child: Center(
//                                       child:  Padding(
//                                         padding:  EdgeInsets.only(left:2*(MediaQuery.of(context).size.width/100),right:2*(MediaQuery.of(context).size.width/100)  ),
//                                         child: Container(
//                                           height: 39 * SizeConfig.heightMultiplier,
//                                           width:  39 * SizeConfig.heightMultiplier,

//                                           child: Stack(
//                                             children: [
//                                               Center(
//                                                 child: Container(
//                                                   //height: 480,
//                                                   // width: 480,
//                                                   child: Image.asset("assets/${logicController.days.toLowerCase()}.png",fit: BoxFit.fill),
//                                                 ),
//                                               ),
//                                               Transform.rotate(
//                                                 angle: (logicController.hour_rotation*pi)/180,
//                                                 child: Center(child: Image.asset("assets/hourhand.png",fit: BoxFit.fitHeight)),
//                                               ),
//                                               Transform.rotate(
//                                                 angle: ((double.parse("${logicController.minutes_rotation}"))*pi)/180,
//                                                 child: Center(child: Image.asset("assets/minutehand.png",fit: BoxFit.fitHeight)),
//                                               ),

//                                               Transform.rotate(
//                                                 angle: ((double.parse("${logicController.seconds_rotation}"))*pi)/180,
//                                                 child: Center(child: Image.asset("assets/sechand.png",fit: BoxFit.fitHeight)),
//                                               ),

//                                             ],
//                                           ),
//                                         ),
//                                       )
//                                   ),
//                                 ),
//                                 GestureDetector(
//                                   onTap: (){
//                                     List<String> imgList = ["assets/moon_help.png"];
//                                     Get.to(PhotosViewPage(imgList));
//                                   },
//                                   child: Center(
//                                     child: Image.asset("assets/moon_help.png",
//                                         height: 42 * SizeConfig.heightMultiplier,
//                                         width: 100 * SizeConfig.widthMultiplier,fit: BoxFit.fitHeight),
//                                   ),
//                                 ),
                               

//                               ],
//                             ),
//                           ),
//                           SizedBox(height: 2 * SizeConfig.heightMultiplier),
//                           Row(mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Container(
//                                 height: 2 * SizeConfig.widthMultiplier,
//                                 width: 2 * SizeConfig.widthMultiplier,
//                                 decoration: BoxDecoration(
//                                     color: logicController.pageindicator == 0?Color(0xFF29b1ef):Colors.black12,
//                                     shape: BoxShape.circle
//                                 ),
//                               ),
//                               SizedBox(width: 1 * SizeConfig.widthMultiplier),
//                               Container(
//                                 height: 2 * SizeConfig.widthMultiplier,
//                                 width: 2 * SizeConfig.widthMultiplier,
//                                 decoration: BoxDecoration(
//                                     color: logicController.pageindicator == 1?Color(0xFF29b1ef):Colors.black12,
//                                     shape: BoxShape.circle
//                                 ),
//                               ),
//                               SizedBox(width: 1 * SizeConfig.widthMultiplier),
//                               Container(
//                                 height: 2 * SizeConfig.widthMultiplier,
//                                 width: 2 * SizeConfig.widthMultiplier,
//                                 decoration: BoxDecoration(
//                                     color: logicController.pageindicator == 2?Color(0xFF29b1ef):Colors.black12,
//                                     shape: BoxShape.circle
//                                 ),
//                               ),

//                             ],
//                           ),
//                           SizedBox(height: 4 * SizeConfig.heightMultiplier),


//                         ],
//                       ),
//                     ),
//                   ),
//                 )
//                     :Center(
//                   child: Container(
//                     height: 80  * SizeConfig.heightMultiplier,
//                     child: Column(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         Image.asset('assets/splash.png',
//                           height: 40 * SizeConfig.widthMultiplier,
//                           width: 40 * SizeConfig.widthMultiplier,),
//                         SizedBox(height: 3 * SizeConfig.heightMultiplier,),
//                         CustText(name: "Internet Connection Not available.",size: 1.8,colors:Colors.black,fontWeightName:FontWeight.w600),
//                         SizedBox(height: 1 * SizeConfig.heightMultiplier,),
//                         Container(
//                           width: 85  * SizeConfig.widthMultiplier,
//                           child:CustTextCenter(name: "To get accurate AUSPICIOUS time please turn on your device's Internet Connection.",size: 1.8,colors:Colors.black,fontWeightName:FontWeight.w400),
//                         ),

//                         SizedBox(height: 2.5 * SizeConfig.heightMultiplier),
//                         ElevatedButton(
//                           onPressed: () {
//                             logicController.checkGps();
//                           },
//                           // style: ButtonStyle(elevation: MaterialStateProperty(12.0 )),

//                           style: ElevatedButton.styleFrom(
//                               elevation: 12.0,
//                               textStyle: const TextStyle(color: Colors.white)),
//                           child: const Text('Refresh'),
//                         ),
//                         SizedBox(height: 1 * SizeConfig.heightMultiplier),
//                         ElevatedButton(
//                           onPressed: () {

//                             try{
//                               launch("https://auspiwatch.com/auspiwatchprivacypolicy.html");
//                             }catch(e)
//                             {

//                             }
//                           },
//                           // style: ButtonStyle(elevation: MaterialStateProperty(12.0 )),

//                           style: ElevatedButton.styleFrom(
//                               elevation: 12.0,
//                               textStyle: const TextStyle(color: Colors.white)),
//                           child: const Text('Privacy Policy'),
//                         ),
//                         /* Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               CustButton(name: "Refresh",size: 80,
//                                   onSelected: (flag) async {
//                                     //    subscriptionController.getSubscriptionPlanList();
//                                   })
//                             ],
//                           ),*/

//                       ],),
//                   ),
//                 )
//                     :Center(
//                   child: Container(
//                     height: 80  * SizeConfig.heightMultiplier,
//                     child: Column(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         Image.asset('assets/splash.png',
//                           height: 40 * SizeConfig.widthMultiplier,
//                           width: 40 * SizeConfig.widthMultiplier,),
//                         SizedBox(height: 3 * SizeConfig.heightMultiplier,),
//                         CustText(name: "GPS Service",size: 2,colors:Colors.black,fontWeightName:FontWeight.w700),
//                         SizedBox(height: 1 * SizeConfig.heightMultiplier,),
//                         Container(
//                           width: 85  * SizeConfig.widthMultiplier,
//                           child:CustTextCenter(name: "GPS Service is not enabled, To get accurate AUSPICIOUS time at your location, please turn on your device's GPS location.",size: 1.8,colors:Colors.black,fontWeightName:FontWeight.w400),
//                         ),

//                         SizedBox(height: 2.5 * SizeConfig.heightMultiplier),
//                         ElevatedButton(
//                           onPressed: () {
//                             logicController.checkGps();
//                           },
//                           // style: ButtonStyle(elevation: MaterialStateProperty(12.0 )),

//                           style: ElevatedButton.styleFrom(
//                               elevation: 12.0,
//                               textStyle: const TextStyle(color: Colors.white)),
//                           child: const Text('Refresh'),
//                         ),
//                         SizedBox(height: 2.5 * SizeConfig.heightMultiplier,),
//                         Container(
//                           width: 85  * SizeConfig.widthMultiplier,
//                           child:CustTextCenter(name: "To select preset location ",size: 1.8,colors:Colors.black,fontWeightName:FontWeight.w400),
//                         ),

//                         SizedBox(height: 1 * SizeConfig.heightMultiplier),
//                         ElevatedButton(
//                           onPressed: () {
//                             showDialog(barrierDismissible: false,
//                                 context: context,
//                                 builder: (BuildContext context) =>
//                                     sectetionList(
//                                       dataList: logicController.mapLatLong,
//                                       onSelected: (city, lat,long) {
//                                         print("Selected city $city , $lat, $long");
//                                         logicController.getLocationPreset(lat,long);
//                                       },
//                                     ));

//                           },
//                           // style: ButtonStyle(elevation: MaterialStateProperty(12.0 )),

//                           style: ElevatedButton.styleFrom(
//                               elevation: 12.0,
//                               textStyle: const TextStyle(color: Colors.white)),
//                           child: const Text('Click here'),
//                         ),

//                         SizedBox(height: 1 * SizeConfig.heightMultiplier),
//                         ElevatedButton(
//                           onPressed: () {

//                             try{
//                               launch("https://auspiwatch.com/auspiwatchprivacypolicy.html");
//                             }catch(e)
//                             {

//                             }
//                           },
//                           // style: ButtonStyle(elevation: MaterialStateProperty(12.0 )),

//                           style: ElevatedButton.styleFrom(
//                               elevation: 12.0,
//                               textStyle: const TextStyle(color: Colors.white)),
//                           child: const Text('Privacy Policy'),
//                         ),
//                         /* Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               CustButton(name: "Refresh",size: 80,
//                                   onSelected: (flag) async {
//                                     //    subscriptionController.getSubscriptionPlanList();
//                                   })
//                             ],
//                           ),*/

//                       ],),
//                   ),
//                 ),

//               ]),
//         ),
//       ),
//     );
//   }

//   auspiSevenData(boxHeight,colorName,img,title7,butitle7,title1,butitle1,title2,butitle2,title3,butitle3,title4,butitle4, title5,butitle5,title8,butitle8,title9,butitle9,title6,butitle6,title10,butitle10,) {
//     return Padding(
//       padding: EdgeInsets.all(1 * SizeConfig.widthMultiplier),
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.all(Radius.circular(
//               2 * SizeConfig.widthMultiplier)),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey,
//               blurRadius: 2 * SizeConfig.widthMultiplier,
//             ),
//           ],
//         ),
//         child: Row(mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 Container(
//                   height: (4 * boxHeight) * SizeConfig.heightMultiplier,
//                   width:10 * SizeConfig.widthMultiplier,
//                   decoration: BoxDecoration(
//                     color: colorName,
//                     borderRadius: BorderRadius.only(topLeft: Radius.circular(
//                         2 * SizeConfig.widthMultiplier),bottomLeft: Radius.circular(
//                         2 * SizeConfig.widthMultiplier)),
//                   ),child: Padding(
//                   padding: EdgeInsets.all(1 * SizeConfig.widthMultiplier),
//                   child: Image.asset(img,
//                       height: 6 * SizeConfig.widthMultiplier,
//                       width: 6 * SizeConfig.widthMultiplier,fit: BoxFit.fitWidth),
//                 ),
//                 ),
//               ],
//             ),
//             Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 butitle7 !=""?auspiSevenSubData(title7,butitle7):Container(),
//                 auspiSevenSubData(title1,butitle1),
//                 //auspiSevenSubData(title7,butitle7),
//                 auspiSevenSubData(title2,butitle2),
//                 title3=="Anandadi Yog"?auspiSevenSubYogData(title3,butitle3):auspiSevenSubData(title3,butitle3),
//                 title4=="Phal"?auspiSevenSubYogData(title4,butitle4):auspiSevenSubData(title4,butitle4),
//                 butitle5 !=""?auspiSevenSubData(title5,butitle5):Container(),
//                 butitle8 !=""?auspiSevenSubData(title8,butitle8):Container(),
//                 butitle9 !=""?auspiSevenSubData(title9,butitle9):Container(),
//                 butitle6 !=""?auspiSevenSubData(title6,butitle6):Container(),
//                 logicController.graha !=""?auspiSevenSubData(title10,butitle10):Container(),


//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   auspiSevenSubData(title,bubTitle){
//     return Container(
//       width: 80 * SizeConfig.widthMultiplier,
//       child: Padding(
//         padding: EdgeInsets.all(1 * SizeConfig.widthMultiplier),
//         child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Expanded(flex: 3,
//                 child: Row(
//                   children: [
//                     CustText(name: title,size: 1.6,colors:Color(0xFF29b1ef),fontWeightName:FontWeight.w600),
//                   ],
//                 )),
//             Expanded(flex: 5,
//                 child: Wrap(
//                   children: [
//                     CustText(name: bubTitle,size: 1.6,colors:Color(0xFF565656),fontWeightName:FontWeight.w600),
//                   ],
//                 )),
//           ],
//         ),
//       ),
//     );
//   }
//   auspiSevenSubYogData(title,bubTitle){
//     return Container(
//       width: 80 * SizeConfig.widthMultiplier,
//       child: Padding(
//         padding: EdgeInsets.all(1 * SizeConfig.widthMultiplier),
//         child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Expanded(flex: 3,
//                 child: Row(
//                   children: [
//                     CustText(name: title,size: 1.6,colors:Color(0xFF29b1ef),fontWeightName:FontWeight.w600),
//                   ],
//                 )),
//             Expanded(flex: 5,
//                 child: Row(
//                   children: [
//                     CustText(name: bubTitle,size: 1.6,colors:logicController.yoggood=="true"?Colors.green:Colors.red,fontWeightName:FontWeight.w600),
//                   ],
//                 )),
//           ],
//         ),
//       ),
//     );
//   }

// }


