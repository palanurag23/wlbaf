import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wlbaf/providers/providers.dart';
import 'package:wlbaf/screens/photo_gallery.dart';
import '../models/modelClasses.dart';
import 'package:intl/intl.dart';

class Tab2 extends StatefulWidget {
  @override
  _Tab2State createState() => _Tab2State();
}

class _Tab2State extends State<Tab2> {
  bool initialized = false;
  TextEditingController _noteController;
  SharedPreferences _sharedPreferences;
  String note = '';
  @override
  void initState() {
    super.initState();
    _noteController = TextEditingController.fromValue(
      TextEditingValue(
        text: note,
      ),
    );
  }

  List<WeightAndPic> weightAndPics;
  int currentjourneyId;

  Journey journey;
  @override
  void didChangeDependencies() {
    if (!initialized) {
      weightAndPics = Provider.of<WeightAndPicturesData>(context, listen: false)
          .weightAndPics;
      journey = Provider.of<JourneysData>(context, listen: false).journey;
      _sharedPreferences =
          Provider.of<SharedPreferencesData>(context, listen: false).prefs;
      print(_sharedPreferences.containsKey('note'));
      print(_sharedPreferences.getString('note'));
      _noteController = TextEditingController.fromValue(TextEditingValue(
        text: _sharedPreferences.containsKey('note')
            ? _sharedPreferences.getString('note')
            : '',
      ));
      // note = _sharedPreferences.containsKey('note')
      //     ? _sharedPreferences.getString('note')
      //     : '';

      setState(() {
        initialized = true;
      });
    }
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future _save() async {
    setState(() {
      note = _noteController.text;
    });
    // widget.taskOpj.note = _noteController.text;
    // await Tasks.updateTask(widget.taskOpj);
    // widget.notifyParent();
    // Navigator.pop(context);
  }

  num percentage;
  num percentCalculator(num startingWeight, num currentWeight) {
    num targetWeight = journey.targetWeight;
    bool weightLoss = startingWeight >= targetWeight; //journey.weightLoss;

    if (weightLoss) {
      print('1weightLoss $weightLoss');
      percentage =
          (startingWeight - currentWeight) / (startingWeight - targetWeight);
      print(percentage);
      return 100 *
          (percentage >= 0
              ? percentage <= 1
                  ? percentage
                  : 1
              : 0);
    } else {
      print('2weightLoss $weightLoss');

      percentage =
          (currentWeight - startingWeight) / (targetWeight - startingWeight);
      print(percentage);

      return 100 *
          (percentage >= 0
              ? percentage <= 1
                  ? percentage
                  : 1
              : 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    String units = Provider.of<UnitsData>(context).units;

    currentjourneyId = Provider.of<CurrentJourney>(context).currentJourneyId;
    weightAndPics = Provider.of<WeightAndPicturesData>(context).weightAndPics;
    percentage = percentCalculator(
        weightAndPics.first.weight, weightAndPics.last.weight);
    int length = weightAndPics.length;
    double ratio = MediaQuery.of(context).size.height / 896;
    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        //height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: EdgeInsets.all(22),
              //color: Colors.grey[100],
              child: CircularPercentIndicator(
                animation: true,
                startAngle: 180,
                radius: 180.0 * ratio,
                circularStrokeCap: CircularStrokeCap.round,
                lineWidth: 15.0 * ratio,
                percent: percentage / 100,
                center: new RichText(
                  text: TextSpan(
                      text: NumberFormat("##").format(percentage),
                      style: TextStyle(
                          color: Colors.blueGrey[900],
                          fontStyle: FontStyle.italic,
                          fontSize: 30 * ratio,
                          fontWeight: FontWeight.w900),
                      children: <TextSpan>[
                        TextSpan(
                            text: '%',
                            style: TextStyle(
                                color: Colors.blueGrey[900],
                                fontStyle: FontStyle.italic,
                                fontSize: 20 * ratio,
                                fontWeight: FontWeight.bold))
                      ]),
                ),
                progressColor: Colors.cyan,
              ),
            ),
            // SizedBox(
            //   height: 50,
            // ),
            // Container(
            //   child: Row(
            //     mainAxisSize: MainAxisSize.max,
            //     mainAxisAlignment: MainAxisAlignment.spaceAround,
            //     children: [
            //       Container(
            //         child: Text('Started from',
            //             style: TextStyle(
            //                 color: Colors.blueGrey[400],
            //                 fontStyle: FontStyle.italic,
            //                 fontSize: 20,
            //                 fontWeight: FontWeight.bold)),
            //       ),
            //       Container(
            //         child: Text('Now',
            //             style: TextStyle(
            //                 color: Colors.blueGrey[400],
            //                 fontStyle: FontStyle.italic,
            //                 fontSize: 20,
            //                 fontWeight: FontWeight.bold)),
            //       ),
            //       Container(
            //         child: Text('Goal',
            //             style: TextStyle(
            //                 color: Colors.blueGrey[400],
            //                 fontStyle: FontStyle.italic,
            //                 fontSize: 20,
            //                 fontWeight: FontWeight.bold)),
            //       )
            //     ],
            //   ),
            // ),
            Container(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  //  if (length > 1)
                  Container(
                    child: Column(
                      children: [
                        Text('Started from',
                            style: TextStyle(
                                color: Colors.blueGrey[400],
                                fontStyle: FontStyle.italic,
                                fontSize: 10,
                                fontWeight: FontWeight.bold)),
                        RichText(
                          text: TextSpan(
                              text: NumberFormat("###.#")
                                  .format(weightAndPics.first.weight),
                              style: TextStyle(
                                  color: Colors.blueGrey[400],
                                  fontStyle: FontStyle.italic,
                                  fontSize: 20, //* ratio,
                                  fontWeight: FontWeight.w900),
                              children: <TextSpan>[
                                TextSpan(
                                    text: units,
                                    style: TextStyle(
                                        color: Colors.blueGrey[400],
                                        fontStyle: FontStyle.italic,
                                        fontSize: 10 * ratio,
                                        fontWeight: FontWeight.bold))
                              ]),
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      children: [
                        Text('Now',
                            style: TextStyle(
                                color: Colors.blueGrey[400],
                                fontStyle: FontStyle.italic,
                                fontSize: 20 * ratio,
                                fontWeight: FontWeight.bold)),
                        RichText(
                          text: TextSpan(
                              text: NumberFormat("###.#")
                                  .format(weightAndPics.last.weight),
                              style: TextStyle(
                                  color: Colors.cyan, //Colors.blueGrey[900],
                                  fontStyle: FontStyle.italic,
                                  fontSize: 40 * ratio,
                                  fontWeight: FontWeight.w900),
                              children: <TextSpan>[
                                TextSpan(
                                    text: units,
                                    style: TextStyle(
                                        color:
                                            Colors.cyan, //Colors.blueGrey[400],
                                        fontStyle: FontStyle.italic,
                                        fontSize: 10 * ratio,
                                        fontWeight: FontWeight.bold))
                              ]),
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text('    Goal ',
                                style: TextStyle(
                                    color: Colors.blueGrey[400],
                                    fontStyle: FontStyle.italic,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold)),
                            Icon(
                              Icons.lock,
                              color: Colors.blueGrey[500],
                              size: 15,
                            ),
                            Text('   ',
                                style: TextStyle(
                                    color: Colors.blueGrey[500],
                                    fontStyle: FontStyle.italic,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold))
                          ],
                        ),
                        RichText(
                          text: TextSpan(
                              text: NumberFormat("###.#")
                                  .format(journey.targetWeight),
                              style: TextStyle(
                                  color: Colors.blueGrey[500],
                                  fontStyle: FontStyle.italic,
                                  fontSize: 20, //* ratio,
                                  fontWeight: FontWeight.w900),
                              children: <TextSpan>[
                                TextSpan(
                                    text: units,
                                    style: TextStyle(
                                        color: Colors.blueGrey[500],
                                        fontStyle: FontStyle.italic,
                                        fontSize: 10 * ratio,
                                        fontWeight: FontWeight.bold))
                              ]),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),

            GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed('/JourneyMonthScreen');
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.cyan,
                  borderRadius: BorderRadius.circular(11),
                ),
                padding: EdgeInsets.symmetric(
                    vertical: 20 * ratio, horizontal: 22 * ratio),
//color: Colors.cyan,
                margin: EdgeInsets.only(
                  top: 20 * ratio,
                  left: 15 * ratio,
                  right: 15 * ratio,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Spacer(),
                    Text('Journey so far !',
                        style: TextStyle(
                            color: Colors.white,
                            fontStyle: FontStyle.italic,
                            fontSize: 20 * ratio,
                            fontWeight: FontWeight.bold)),
                    SizedBox(
                      width: 12,
                    ),
                    Icon(
                      Icons.pedal_bike_sharp,
                      color: Colors.white,
                      size: 33 * ratio,
                    ),
                    Spacer(),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(PhotoGallery.routeName);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.cyan,
                  borderRadius: BorderRadius.circular(11),
                ),
                padding: EdgeInsets.symmetric(
                    vertical: 20 * ratio, horizontal: 22 * ratio),
//color: Colors.cyan,
                margin: EdgeInsets.only(
                  top: 20 * ratio,
                  left: 15 * ratio,
                  right: 15 * ratio,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Spacer(),
                    Icon(
                      Icons.image,
                      color: Colors.white,
                      size: 33 * ratio,
                    ),
                    SizedBox(
                      width: 12 * ratio,
                    ),
                    Text('Photo gallery ',
                        style: TextStyle(
                            color: Colors.white,
                            fontStyle: FontStyle.italic,
                            fontSize: 20 * ratio,
                            fontWeight: FontWeight.bold)),
                    Spacer(),
                  ],
                ),
              ),
            ),
            !initialized
                ? CircularProgressIndicator()
                : Container(
                    decoration: BoxDecoration(
                      color: Colors.blueGrey[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.only(
                        top: 20 * ratio,
                        left: 22 * ratio,
                        right: 22 * ratio,
                        bottom: 22 * ratio),
//color: Colors.cyan,
                    margin: EdgeInsets.only(
                      top: 20 * ratio,
                      left: 15 * ratio,
                      right: 15 * ratio,
                    ),
                    child: Center(
                      child: TextField(
                          maxLength: 50,
                          onChanged: (String note) {
                            print(note);
                            if (note.characters.length < 50)
                              _sharedPreferences.setString('note', note);
                          },
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.blueGrey[400],
                              fontStyle: FontStyle.italic,
                              fontSize: 20 * ratio,
                              fontWeight: FontWeight.bold),
                          decoration: InputDecoration(
                            hintStyle: TextStyle(
                                color: Colors.blueGrey[400],
                                fontStyle: FontStyle.italic,
                                fontSize: 20 * ratio,
                                fontWeight: FontWeight.bold),
                            hintText: 'Write a note for your self...',
                            border: InputBorder.none,
                            labelStyle: TextStyle(color: Colors.white),
                          ),
                          autofocus: false,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          controller: _noteController),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
