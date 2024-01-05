import 'dart:ui';

import 'package:air_quality_app/data/air_quality.dart';
import 'package:air_quality_app/painter.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  AirQuality airQuality;
  HomeScreen(this.airQuality, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
        title: const Text(
          'Air Quality Indicator',
          style: TextStyle(
            fontSize: 22,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/images/back.png'),
              )),
            ),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.black12,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: kTextTabBarHeight * 3),
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Stack(
                    children: [
                      CustomPaint(
                        size: Size(
                          MediaQuery.of(context).size.width,
                          MediaQuery.of(context).size.width,
                        ),
                        painter: AirQualityPainter(airQuality.aqi),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: SizedBox(
                          width: 400,
                          height: MediaQuery.of(context).size.height * 0.5,
                          child: Column(
                            children: [
                              Container(
                                width: 400,
                                height: MediaQuery.of(context).size.height * 0.25,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage('assets/images/${airQuality.emojiRef}'),
                                  )
                                ),
                              ),
                              Container(
                                width: 400,
                                height: MediaQuery.of(context).size.height * 0.15,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white70,
                                ),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Text(airQuality.message!, textAlign: TextAlign.center, style: const TextStyle(
                                      height: 1.5,
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                    ),),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
