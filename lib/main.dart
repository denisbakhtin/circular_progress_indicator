import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Custom Circular Indicator"),
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                //first indicator with a scale background image
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: CircularIndicatorWidget(percent: 100),
                ),
                //second indicator with solid blue color and reduced duration
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: CircularIndicatorWidget(
                    percent: 70,
                    isFlat: true,
                    duration: Duration(seconds: 3),
                  ),
                ),
                //third indicator with transparent red color and reduced duration
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: CircularIndicatorWidget(
                    percent: 30,
                    isFlat: true,
                    color: Colors.redAccent.withOpacity(0.7),
                    duration: Duration(seconds: 1),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//Simple animated circular indicator, for more advanced usage consider implementing an AnimationController
class CircularIndicatorWidget extends StatelessWidget {
  final double percent;
  final bool isFlat;
  final Color color;
  final Duration duration;
  const CircularIndicatorWidget({
    Key key,
    @required this.percent,
    this.isFlat = false,
    this.color = Colors.blue,
    this.duration = const Duration(seconds: 4),
  }) : super(key: key);

  final size = 200.0;
  @override
  Widget build(BuildContext context) {
    assert(percent <= 100, 'Percent value must be less or equal than 100');
    return TweenAnimationBuilder(
        tween: Tween(begin: 0.0, end: percent / 100),
        duration: duration,
        builder: (context, value, child) {
          int percentage = (value * 100).ceil();
          return Container(
            width: size,
            height: size,
            child: Stack(
              children: [
                ShaderMask(
                  shaderCallback: (rect) => SweepGradient(
                    center: Alignment.center,
                    //first color is blue by default, second is transparent
                    colors: [color, Colors.transparent],
                    //first value is from 0 to $value sector color, second is from $value to the 360 degree color
                    stops: [value, value],
                  ).createShader(rect),
                  child: Container(
                    width: size,
                    height: size,
                    //you can use any transparent image, where white translates into 0 opacity
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: isFlat
                          ? null
                          : DecorationImage(
                              image: AssetImage("assets/radial_scale.png")),
                      //or don't use any image at all
                      color: isFlat ? Colors.white : null,
                    ),
                  ),
                ),
                Center(
                  //inner circle with text
                  child: Container(
                    //40 is the width of indicator band
                    width: size - 40,
                    height: size - 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      //keep it white or set to scaffold background color for smoothness
                      color: Colors.white,
                    ),
                    child: Center(
                      child: Text(
                        percentage.toString(),
                        style: TextStyle(fontSize: 40),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
