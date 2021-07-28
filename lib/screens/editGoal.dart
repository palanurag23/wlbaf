import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:wlbaf/models/modelClasses.dart';
import '../providers/providers.dart';
import 'package:toggle_switch/toggle_switch.dart';

class EditGoal extends StatefulWidget {
  static const routeName = 'editGoal.dart';
  // EditGoal({Key? key}) : super(key: key);

  @override
  _EditGoalState createState() => _EditGoalState();
}

class _EditGoalState extends State<EditGoal> {
  int _currentGoalValue = 40;
  GlobalKey materialNavigatorKey;
  bool isInitialized = false;
  int initialLabelIndex = 0;
  @override
  void didChangeDependencies() {
    if (!isInitialized) {
      initialLabelIndex =
          Provider.of<UnitsData>(context, listen: false).get() == 'kg' ? 0 : 1;
      _currentGoalValue = Provider.of<JourneysData>(context, listen: false)
          .journey
          .targetWeight
          .toInt();
      materialNavigatorKey =
          Provider.of<MaterialNavigatorKey>(context, listen: false).get();
      setState(() {
        isInitialized = true;
      });
    }
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  bool saving = false;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    double ratio = MediaQuery.of(context).size.height / 896;
    String units = Provider.of<UnitsData>(
      context,
    ).get();
    return Scaffold(
      bottomNavigationBar: GestureDetector(
        onTap: saving
            ? () {}
            : () async {
                setState(() {
                  saving = true;
                });

                if (true) {
                  Journey journey =
                      Provider.of<JourneysData>(context, listen: false).journey;
                  await Provider.of<JourneysData>(
                          materialNavigatorKey.currentContext,
                          listen: false)
                      .addNewJourney(context, journey.name, _currentGoalValue,
                          journey.durationInWeeks, false, journey.weightLoss);
                  print('journey savrd');

                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      duration: Duration(seconds: 2),
                      backgroundColor: Colors.blueGrey[700],
                      content: RichText(
                        text: TextSpan(
                            text: 'New goal set $_currentGoalValue',
                            style: TextStyle(
                                color: Colors.white,
                                fontStyle: FontStyle.normal,
                                fontSize: 15 * ratio,
                                fontWeight: FontWeight.normal),
                            children: <TextSpan>[
                              TextSpan(
                                  text: '$units',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 7 * ratio,
                                      fontWeight: FontWeight.normal)),
                              // TextSpan(
                              //     text: ' !',
                              //     style: TextStyle(
                              //         color: Colors.white,
                              //         fontStyle: FontStyle.normal,
                              //         fontSize: 12 * ratio,
                              //         fontWeight: FontWeight.bold))
                            ]),
                      )));
                  await Future.delayed(Duration(seconds: 1)); ////
                  Provider.of<WeightAndPicturesData>(context, listen: false)
                      .fetchAndSetData(
                          Provider.of<CurrentJourney>(context, listen: false)
                              .get());
                  print('weight saverd');
                  Navigator.of(context).pop();
                }
              },
        child: BottomAppBar(
          color: Colors.blueGrey[900],
          child: Container(
            height: 50,
            padding: EdgeInsets.only(bottom: 0),
            child: Center(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.save_rounded,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 7,
                  ),
                  Text(saving ? 'Saving...' : 'Save',
                      style: TextStyle(
                          color: Colors.white,
                          fontStyle: FontStyle.normal,
                          fontSize: 20 * ratio,
                          fontWeight: FontWeight.w700))
                ],
              ),
            ),
          ),
        ),
      ),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.blueGrey),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Set new GOAL !',
            style: TextStyle(
                color: Colors.blueGrey[500],
                fontStyle: FontStyle.normal,
                fontSize: 20 * ratio,
                fontWeight: FontWeight.w600)),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: EdgeInsets.only(top: 10 * ratio, left: 40, right: 40),
              padding: EdgeInsets.only(
                top: 20 * ratio, bottom: 20,
                //left: 20, right: 20
              ),
              decoration: BoxDecoration(
                // boxShadow: [
                //   BoxShadow(
                //     color: Colors.grey[400],
                //     offset: Offset(1, 3), //(x,y)
                //     blurRadius: 2.0,
                //   ),
                // ],
                // border: Border.all(color: Colors.black, width: 1),
                color: Colors.blueGrey[50],
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(11),
              ),
              child: Column(
                children: [
                  Container(
                    // color: Colors.blueGrey,
                    margin: EdgeInsets.only(top: 0),
                    child: Text('New Goal !', //+
                        //weightAndPics[firstPicindex].path,
                        style: TextStyle(
                            color: Colors.blueGrey[700],
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.normal,
                            fontFamily: 'Open Sans',
                            fontSize: 15 * ratio)),
                  ),
                  Divider(),
                  RichText(
                    text: TextSpan(
                        text: NumberFormat("###.#").format(_currentGoalValue),
                        style: TextStyle(
                            color: Colors.blueGrey[700],
                            fontStyle: FontStyle.normal,
                            fontSize: 20 * ratio,
                            fontWeight: FontWeight.w500),
                        children: <TextSpan>[
                          TextSpan(
                              text: ' ' + ['kg', 'lb'][initialLabelIndex],
                              style: TextStyle(
                                  color: Colors.blueGrey[500],
                                  fontStyle: FontStyle.normal,
                                  fontSize: 12 * ratio,
                                  fontWeight: FontWeight.bold))
                        ]),
                  ),
                  Divider(),
                  NumberPicker(
                      textStyle: TextStyle(
                          color: Colors.blueGrey[200],
                          fontStyle: FontStyle.normal,
                          fontSize: 15 * ratio,
                          fontWeight: FontWeight.w600),
                      selectedTextStyle: TextStyle(
                          color: Colors.blueGrey[700],
                          fontStyle: FontStyle.normal,
                          fontSize: 20 * ratio,
                          fontWeight: FontWeight.w600),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(33),
                        border: Border.all(color: Colors.white),
                      ),
                      minValue: 0,
                      axis: Axis.vertical,
                      maxValue: 450,
                      value: _currentGoalValue,
                      onChanged: (value) =>
                          setState(() => _currentGoalValue = value)),
                  Divider(),
                  ToggleSwitch(
                    minWidth: 50.0,
                    minHeight: 30,
                    cornerRadius: 20.0,
                    activeBgColors: [
                      [Colors.blueGrey[300], Colors.blueGrey[300]],
                      [Colors.blueGrey[300], Colors.blueGrey[300]]
                    ],
                    activeFgColor: Colors.white,
                    inactiveBgColor: Colors.blueGrey[100],
                    inactiveFgColor: Colors.blueGrey,
                    initialLabelIndex: initialLabelIndex,
                    totalSwitches: 2,
                    labels: ['kg', 'lb'],
                    radiusStyle: true,
                    onToggle: (index) {
                      setState(() {
                        initialLabelIndex = index;
                      });
                      Provider.of<UnitsData>(context, listen: false)
                          .set(['kg', 'lb'][index], context);
                      print('switched to: $index');
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
