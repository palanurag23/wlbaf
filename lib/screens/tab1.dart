import 'package:flutter/material.dart';
import 'package:wlbaf/models/modelClasses.dart';
import 'package:wlbaf/widgets/circle.dart';
import 'package:wlbaf/widgets/oneImage.dart';
import 'package:wlbaf/widgets/runningMan.dart';
import 'package:wlbaf/widgets/twoImages.dart';
import '../providers/providers.dart';
import 'package:provider/provider.dart';

class Tab1 extends StatefulWidget {
  @override
  _Tab1State createState() => _Tab1State();
}

class _Tab1State extends State<Tab1> {
  int lastPicindex;
  int currentjourneyId;
  List<WeightAndPic> weightAndPics;
  bool isInitialized = false;
  GlobalKey materialNavigatorKey;
  int firstPicindex;
  bool onlyOnePic;
  @override
  void didChangeDependencies() {
    if (!isInitialized) {
      materialNavigatorKey =
          Provider.of<MaterialNavigatorKey>(context, listen: false).get();
      setState(() {
        isInitialized = true;
      });
    }

    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    double ratio = MediaQuery.of(context).size.height / 896; //> 900 ? 1 : 0.7;
    currentjourneyId = Provider.of<CurrentJourney>(context).currentJourneyId;
    weightAndPics =
        Provider.of<WeightAndPicturesData>(context).weightAndPicList;
    firstPicindex = weightAndPics.indexWhere((element) => element.havePicture);
    lastPicindex =
        weightAndPics.lastIndexWhere((element) => element.havePicture);
    onlyOnePic = firstPicindex == lastPicindex;
    print('weightAndPics is empty =' +
        weightAndPics.isEmpty.toString() +
        ' onlyOnePic=' +
        onlyOnePic.toString());
    return SingleChildScrollView(
      child: currentjourneyId == 0
          ? Text('no journey selected')
          : weightAndPics.isEmpty
              ? Text('no data yet in journey $currentjourneyId')
              : Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      // color: Colors.blueGrey[50],
                      child: onlyOnePic
                          ? OneImage(
                              weightAndPics[firstPicindex].weight,
                            )
                          : TwoImages(
                              firstImageWeight:
                                  weightAndPics[firstPicindex].weight,
                            ),
                      //  color: Colors.blueGrey[100],
                    ),
                    CircleWidget(weightAndPics),
                    RunningMan(
                      currentWeight: weightAndPics.last.weight,
                      startingWeight: weightAndPics.first.weight,
                    )
                  ],
                ),
    );
  }

  String formatWeight(num weight) {}
}
