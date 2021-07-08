import 'package:flutter/material.dart';
import 'package:wlbaf/models/modelClasses.dart';
import 'package:wlbaf/my_flutter_app_icons.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import '../providers/providers.dart';

class RunningMan extends StatelessWidget {
  num currentWeight;
  Journey journey;
  num startingWeight;
  RunningMan(
      {@required this.currentWeight,
      @required this.journey,
      @required this.startingWeight});
  @override
  Widget build(BuildContext context) {
    double percentage;
    double percentCalculator() {
      // Journey journey =
      //     Provider.of<JourneysData>(context, listen: false).journey;
      print(journey.weightLoss);
      num targetWeight = journey.targetWeight;
      bool weightLoss = startingWeight >= targetWeight; //journey.weightLoss;
      if (weightLoss) {
        print('if weightLoss $weightLoss');
        percentage =
            (startingWeight - currentWeight) / (startingWeight - targetWeight);
        print(percentage);
        return percentage > 0.1
            ? percentage < 1
                ? percentage
                : 1
            : 0.1;
      } else {
        print('else weightLoss $weightLoss');

        percentage =
            (currentWeight - startingWeight) / (targetWeight - startingWeight);
        print(percentage);

        return percentage > 0.1
            ? percentage < 1
                ? percentage
                : 1
            : 0.1;
      }
    }

    double percent = percentCalculator();
    double ratio = MediaQuery.of(context).size.height / 896;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.9,
          // color: Colors.grey,
          height: 35 * ratio,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  Container(
                    // color: Colors.amberAccent,
                    height: 35 * ratio,
                    width: MediaQuery.of(context).size.width * 0.9,
                  ),
                  Positioned(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 00.0 * ratio),
                      child: Icon(
                        MyFlutterApp.start_line,
                        color: Colors.blueGrey,
                        size: 35 * ratio,
                      ),
                    ),
                    left: 0,
                    bottom: 0,
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 0.0 * ratio),
                      child: Icon(
                        MyFlutterApp.finish,
                        color: Colors.blueGrey[900],
                        size: 35 * ratio,
                      ),
                    ),
                  ),
                  Positioned(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 0.0 * ratio),
                      child: Stack(
                        children: [
                          Container(
//color: Colors.black,
                            height: 40 * ratio,
                            width: MediaQuery.of(context).size.width * 0.9 -
                                (2 * (35 * ratio)),
                          ),
                          Positioned(
                            bottom: 0,
                            right: (MediaQuery.of(context).size.width * 0.9 -
                                    (2 * (35 * ratio))) *
                                (1 - percent),
                            child: Icon(
                              MyFlutterApp.runer_silhouette_running_fast,
                              size: 40 * ratio,
                              color: Colors.blueGrey,
                            ),
                          )
                        ],
                      ),
                    ),
                    bottom: 0, left: 35 * ratio,
                    //left: MediaQuery.of(context).size.width * 0.9 * 0.01,
                  ),
                ],
              ),
            ],
          ),
        ),

        // Container(
        //   margin: EdgeInsets.only(bottom: 50 * ratio),
        //   color: Colors.amber,
        //   height: 12 * ratio,
        //   width: MediaQuery.of(context).size.width * 0.8,
        // ),

        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 50 * ratio),
              child: LinearPercentIndicator(
                padding: EdgeInsets.all(0),
                backgroundColor: Colors.blueGrey[200],
                width: MediaQuery.of(context).size.width * 0.9,
                animation: true,
                lineHeight: 12.0 * ratio,
                animationDuration: 333,
                percent: percent,
                // center: Text("90.0%"),
                linearStrokeCap: LinearStrokeCap.roundAll,
                progressColor: Colors.blueGrey[900],
              ),
            ),
          ],
        )
      ],
    );
  }
}
/*return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          // color: Colors.grey,
          height: 40 * ratio,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 10.0 * ratio),
                child: Icon(
                  MyFlutterApp.start_line,
                  size: 35 * ratio,
                ),
              ),
              Stack(
                children: [Positioned(child: )
                  Container(
                    //color: Colors.amberAccent,
                    height: 42 * ratio,
                    width: MediaQuery.of(context).size.width * 0.7,
                  ),
                  Positioned(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 10.0 * ratio),
                      child: Icon(
                        MyFlutterApp.runer_silhouette_running_fast, //ning,
                        size: 40 * ratio,
                      ),
                    ),
                    left: MediaQuery.of(context).size.width * 0.7 * 0.4,
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 10.0 * ratio),
                child: Icon(
                  MyFlutterApp.finish,
                  size: 35 * ratio,
                ),
              ),
            ],
          ),
        ),

        // Container(
        //   margin: EdgeInsets.only(bottom: 50 * ratio),
        //   color: Colors.amber,
        //   height: 12 * ratio,
        //   width: MediaQuery.of(context).size.width * 0.8,
        // ),

        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 50 * ratio),
              child: LinearPercentIndicator(
                backgroundColor: Colors.blueGrey[400],
                width: MediaQuery.of(context).size.width * 0.9,
                animation: true,
                lineHeight: 10.0 * ratio,
                animationDuration: 333,
                percent: 0.4,
                // center: Text("90.0%"),
                linearStrokeCap: LinearStrokeCap.roundAll,
                progressColor: Colors.blueGrey[900],
              ),
            ),
          ],
        )
      ],
    );
  }
}
 */
