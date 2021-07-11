import 'dart:ffi';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:wlbaf/models/modelClasses.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';
import '../providers/providers.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:intl/intl.dart';

class AddNewJourney extends StatefulWidget {
  static const routeName = '/AddNewJourney';
  @override
  _AddNewJourneyState createState() => _AddNewJourneyState();
}

class _AddNewJourneyState extends State<AddNewJourney> {
  TextEditingController _noteController;
  String note = '';
  double _currentWeightValue = 150;
  int _currentGoalValue = 40;
  int initialLabelIndex = 0;

  File _image;
  final picker = ImagePicker();
  int duration = 1;
  bool isInitialized = false;
  bool addImage = false;
  int steps = 5;
  GlobalKey materialNavigatorKey;
  @override
  void initState() {
    super.initState();
    _noteController = TextEditingController.fromValue(
      TextEditingValue(
        text: note,
      ),
    );
  }

  void _showPicker(BuildContext context, num ratio) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        elevation: 0,
        barrierColor: Colors.black12,
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blueGrey[50],
                borderRadius: BorderRadius.circular(11),
              ),
              padding: EdgeInsets.symmetric(
                  vertical: 10 * ratio, horizontal: 22 * ratio),
//color: Colors.cyan,
              margin: EdgeInsets.only(
                top: 20 * ratio,
                left: 15 * ratio,
                right: 15 * ratio,
              ),
              child: new Wrap(
                direction: Axis.horizontal,
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(
                        Icons.photo_library,
                        color: Colors.blueGrey[700],
                      ),
                      title: new Text(
                        'Photos',
                        style: TextStyle(
                            color: Colors.blueGrey[900],
                            fontStyle: FontStyle.normal,
                            fontSize: 15,
                            fontWeight: FontWeight.w400),
                      ),
                      onTap: () {
                        getImage(ImageSource.gallery);
                        Navigator.of(context).pop();
                      }),
                  Divider(),
                  new ListTile(
                    leading: new Icon(
                      Icons.photo_camera,
                      color: Colors.blueGrey[700],
                    ),
                    title: new Text('Camera',
                        style: TextStyle(
                            color: Colors.blueGrey[900],
                            fontStyle: FontStyle.normal,
                            fontSize: 15,
                            fontWeight: FontWeight.w400)),
                    onTap: () {
                      getImage(ImageSource.camera);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  void didChangeDependencies() {
    if (!isInitialized) {
      initialLabelIndex =
          Provider.of<UnitsData>(context, listen: false).get() == 'kg' ? 0 : 1;

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
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future getImage(ImageSource imageSource) async {
    print('a');
    PickedFile pickedFile;
    // final pickedFile = await picker.getImage(source: ImageSource.gallery);
    try {
      print('b');
      pickedFile = await picker.getImage(
        source: imageSource,
      );
      print('${pickedFile.path}');
    } catch (e) {
      print('c');
      print(e.code);
    }
    setState(() {
      print('d');
      if (pickedFile != null) {
        print('e');
        addImage = true;

        _image = File(pickedFile.path);
      } else {
        print('f');
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double ratio = MediaQuery.of(context).size.height / 896;
    int journeyId =
        Provider.of<CurrentJourney>(context, listen: false).currentJourneyId;
    var size = MediaQuery.of(context).size;

    return Scaffold(
      persistentFooterButtons: [
        if (steps > 1)
          IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                setState(() {
                  steps = steps - 1;
                });
              }),
        // Spacer(),
        steps < 5
            ? ElevatedButton(
                onPressed: () {
                  setState(() {
                    steps = steps + 1;
                  });
                },
                child: Text('next '))
            : ElevatedButton.icon(
                onPressed:
                    // journeyId == 0
                    //  ? () {}
                    //:
                    () async {
                  print('if' +
                      _noteController.text.isNotEmpty.toString() +
                      (_image != null).toString());

                  if (_noteController.text.isNotEmpty && _image != null) {
                    print('if' +
                        _noteController.text.isNotEmpty.toString() +
                        (_image != null).toString());

                    await Provider.of<JourneysData>(
                            materialNavigatorKey.currentContext,
                            listen: false)
                        .addNewJourney(
                            context,
                            _noteController.text,
                            _currentGoalValue,
                            duration,
                            false,
                            _currentGoalValue <= _currentWeightValue);
                    print('journey savrd');
                    await Future.delayed(Duration(seconds: 1)); ////
                    await Provider.of<WeightAndPicturesData>(context,
                            listen: false)
                        .addWeightAndPic(
                            _currentWeightValue,
                            Provider.of<CurrentJourney>(context, listen: false)
                                .get(),
                            _image != null ? true : false,
                            _image.path);
                    Provider.of<WeightAndPicturesData>(context, listen: false)
                        .fetchAndSetData(
                            Provider.of<CurrentJourney>(context, listen: false)
                                .get());
                    print('weight saverd');
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        duration: Duration(seconds: 3),
                        backgroundColor: Colors.blueGrey[700],
                        content: Text('New Journey Started !')));

                    Navigator.of(context).pushReplacementNamed('/Tabs_screen');
                  }
                },
                icon: Icon(Icons.save),
                label: Text('Save $journeyId'))
      ],
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Starting weight loss journey !',
            style: TextStyle(
                color: Colors.blueGrey[500],
                fontStyle: FontStyle.italic,
                fontSize: 20 * ratio,
                fontWeight: FontWeight.w800)),
      ),
      body: SingleChildScrollView(
          child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 22 * ratio,
            ),

            //  if (steps == 1)
            Container(
                child: _image == null
                    ? GestureDetector(
                        onTap: () async {
                          await _showPicker(context, ratio);
                        },
                        child: Card(
                          elevation: 0,
                          semanticContainer: true,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          child: Container(
                            color: Colors.blueGrey[50],
                            width: size.width * 0.7,
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.add_a_photo_outlined,
                                    size: 25,
                                    color: Colors.blueGrey[300],
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text('Add picture',
                                      style: TextStyle(
                                          color: Colors.blueGrey[700],
                                          fontStyle: FontStyle.normal,
                                          fontSize: 15 * ratio,
                                          fontWeight: FontWeight.w500))
                                ],
                              ),
                            ),
                            height: size.width * 0.8,
                          ),
                        ),
                      )
                    : Stack(
                        children: [
                          Container(
                            height: size.width * 0.8,
                            width: size.width * 0.7,
                            child: Card(
                                elevation: 2,
                                semanticContainer: true,
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                                child: Image.file(
                                  _image,
                                  fit: BoxFit.cover,
                                )),
                          ),
                          Positioned(
                              top: 0,
                              right: 0,
                              child: IconButton(
                                icon: Icon(
                                  Icons.cancel_rounded,
                                  color: Colors.white,
                                  size: 30,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _image = null;
                                    addImage = false;
                                  });
                                },
                              ))
                        ],
                      )),

            // if (steps == 2)
            Container(
              margin: EdgeInsets.only(top: 35 * ratio, left: 40, right: 40),
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
                    child: Text('Your Weight !', //+
                        //weightAndPics[firstPicindex].path,
                        style: TextStyle(
                            color: Colors.blueGrey[500],
                            fontWeight: FontWeight.w800,
                            fontStyle: FontStyle.normal,
                            fontFamily: 'Open Sans',
                            fontSize: 20 * ratio)),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Divider(
                    color: Colors.blueGrey[300],
                  ),
                  RichText(
                    text: TextSpan(
                        text: NumberFormat("###.#").format(_currentWeightValue),
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
                  Divider(
                    color: Colors.white,
                    thickness: 1,
                  ),
                  DecimalNumberPicker(
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
                    integerDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(33),
                      border: Border.all(color: Colors.white),
                    ),
                    decimalDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(33),
                      border: Border.all(color: Colors.white),
                    ),
                    value: _currentWeightValue,
                    minValue: 0,
                    maxValue: 1000,
                    onChanged: (value) =>
                        setState(() => _currentWeightValue = value),
                  ),
                  Divider(
                    color: Colors.blueGrey[300],
                  ),
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
            //    if (steps == 1)
            Container(
              decoration: BoxDecoration(
                color: Colors.blueGrey[50],
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.only(
                  top: 5 * ratio,
                  left: 22 * ratio,
                  right: 22 * ratio,
                  bottom: 5 * ratio),
//color: Colors.cyan,
              margin: EdgeInsets.only(
                top: 20 * ratio,
                left: 15 * ratio,
                right: 15 * ratio,
              ),
              child: TextField(
                  scrollPadding: EdgeInsets.all(0),
                  maxLength: 20,
                  onChanged: (String note) {
                    //     print(note);
                    print(_noteController.text);
                  },
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.blueGrey[400],
                      fontStyle: FontStyle.normal,
                      fontSize: 15 * ratio,
                      fontWeight: FontWeight.w500),
                  decoration: InputDecoration(
                    hintStyle: TextStyle(
                        color: Colors.blueGrey[400],
                        fontStyle: FontStyle.normal,
                        fontSize: 15 * ratio,
                        fontWeight: FontWeight.w500),
                    hintText: 'Title for this journey',
                    border: InputBorder.none,
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                  autofocus: false,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  controller: _noteController),
            ),
            //    if (steps == 4)
            Container(
              margin: EdgeInsets.only(top: 35 * ratio, left: 40, right: 40),
              padding: EdgeInsets.only(
                  top: 30 * ratio, bottom: 50, left: 20, right: 20),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey[400],
                    offset: Offset(1, 3), //(x,y)
                    blurRadius: 2.0,
                  ),
                ],
                // border: Border.all(color: Colors.black, width: 1),
                color: Colors.blueGrey[50],
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(31),
              ),
              child: Column(
                children: [
                  NumberPicker(
                      minValue: 0,
                      axis: Axis.vertical,
                      maxValue: 450,
                      value: _currentGoalValue,
                      onChanged: (value) =>
                          setState(() => _currentGoalValue = value)),
                ],
              ),
            ),
            // Text('duration'),
            //DURATION
            // if (steps == 5)
            NumberPicker(
                axis: Axis.horizontal,
                minValue: 1,
                maxValue: 52,
                value: duration,
                onChanged: (value) => setState(() => duration = value)),
            //   _image == null ? Text('No image selected.') : Image.file(_image),
            SizedBox(
              height: 0,
            ),
            // Text('goal'),
          ],
        ),
      )),
    );
  }
}
