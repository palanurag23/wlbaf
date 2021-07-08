import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import '../models/modelClasses.dart';
import '../providers/providers.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:toggle_switch/toggle_switch.dart';

class AddWeight extends StatefulWidget {
  static const routeName = '/AddWeightScreen';

  @override
  _AddWeightState createState() => _AddWeightState();
}

class _AddWeightState extends State<AddWeight> {
  double _currentValue = 3;
  bool weightListEmpty;
  int initialLabelIndex = 0;
  bool isInitialized = false;
  bool weightAddedToday;
  bool addImage = false;
  List<WeightAndPic> weightAndPics = [];
  File _image;
  final picker = ImagePicker();
  int journeyId;
  var weightAndPicturesData;
  //bool isFirst = true;
  int dayCount;
  @override
  void didChangeDependencies() {
    if (!isInitialized) {
      initialLabelIndex =
          Provider.of<UnitsData>(context, listen: false).get() == 'kg' ? 0 : 1;
      weightAndPicturesData =
          Provider.of<WeightAndPicturesData>(context, listen: false);

      journeyId = Provider.of<CurrentJourney>(context, listen: false).get();
      weightAndPics = weightAndPicturesData.weightAndPics;
      //
      dayCount = ((DateTime.now()
                      .difference(DateTime.parse(weightAndPics.first.dateTime))
                      .inHours) /
                  24)
              .round() +
          1;
      //
      // isFirst = weightAndPics.length == 1 &&
      //     DateFormat('dd/MM/yy').format(DateTime.now()) ==
      //         DateFormat('dd/MM/yy')
      //             .format(DateTime.parse(weightAndPics.last.dateTime));
      weightListEmpty = weightAndPics.isEmpty;
      weightAddedToday = weightListEmpty
          ? false
          : DateFormat('dd/MM/yy').format(DateTime.now()) ==
              DateFormat('dd/MM/yy')
                  .format(DateTime.parse(weightAndPics.last.dateTime));
      if (!weightListEmpty) {
        _currentValue = weightAndPics.last.weight;
      }
      if (weightAddedToday) {
        WeightAndPic weightAndPic = weightAndPics.last;
        if (weightAndPic.havePicture) {
          _image = File(weightAndPic.path);
        }
      }
      setState(() {
        isInitialized = true;
      });
    }
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
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

// Find the ScaffoldMessenger in the widget tree
// and use it to show a SnackBar.

  @override
  Widget build(BuildContext context) {
    double ratio = MediaQuery.of(context).size.height / 896;

    var size = MediaQuery.of(context).size;
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        color: Colors.blueGrey[900],
        child: GestureDetector(
          onTap: journeyId == 0
              ? () {}
              : () {
                  weightAndPicturesData.addWeightAndPic(
                      _currentValue,
                      journeyId,
                      _image != null,
                      _image != null ? _image.path : '.....');
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      duration: Duration(seconds: 1),
                      backgroundColor: Colors.blueGrey[700],
                      content: Text(_image != null
                          ? 'Weight and Picture added'
                          : 'Weight added')));

                  Navigator.of(context).pop();
                },
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
                  Text('Save',
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
        //    GestureDetector(
        //   onTap: journeyId == 0
        //       ? () {}
        //       : () {
        //           weightAndPicturesData.addWeightAndPic(_currentValue, journeyId,
        //               _image != null, _image != null ? _image.path : '.....');
        //           Navigator.of(context).pop();
        //         },
        //   child: Container(
        //     padding: EdgeInsets.only(bottom: 15),
        //     child: Center(
        //       child: Row(
        //         mainAxisSize: MainAxisSize.min,
        //         children: [
        //           Icon(
        //             Icons.save_rounded,
        //             color: Colors.white,
        //           ),
        //           SizedBox(
        //             width: 7,
        //           ),
        //           Text('Save',
        //               style: TextStyle(
        //                   color: Colors.white,
        //                   fontStyle: FontStyle.normal,
        //                   fontSize: 20 * ratio,
        //                   fontWeight: FontWeight.w900))
        //         ],
        //       ),
        //     ),
        //     height: 80,
        //     color: Colors.blueGrey[900],
        //   ),
        // ),
        // persistentFooterButtons: [
        //   ElevatedButton.icon(
        //       onPressed: journeyId == 0
        //           ? () {}
        //           : () {
        //               weightAndPicturesData.addWeightAndPic(
        //                   _currentValue,
        //                   journeyId,
        //                   _image != null,
        //                   _image != null ? _image.path : '.....');
        //               Navigator.of(context).pop();
        //             },
        //       icon: Icon(Icons.save),
        //       label: Text('Save $journeyId'))
        // ],
      ),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.blueGrey),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: weightAddedToday
            ? Text(
                'Edit Weight and Picture',
                style: TextStyle(
                    color: Colors.blueGrey[700],
                    fontStyle: FontStyle.italic,
                    fontSize: 20 * ratio,
                    fontWeight: FontWeight.w800),
              )
            : Text(
                'Add Weight and Picture',
                style: TextStyle(
                    color: Colors.blueGrey[700],
                    fontStyle: FontStyle.italic,
                    fontSize: 20 * ratio,
                    fontWeight: FontWeight.w800),
              ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // if (weightListEmpty)
            ToggleSwitch(
              minWidth: 90.0,
              cornerRadius: 20.0,
              activeBgColors: [
                [Colors.blueGrey, Colors.blueGrey[800]],
                [Colors.blueGrey[800], Colors.blueGrey]
              ],
              activeFgColor: Colors.white,
              inactiveBgColor: Colors.blueGrey[200],
              inactiveFgColor: Colors.white,
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
            SizedBox(
              height: 22,
            ),
            _image == null
                ? GestureDetector(
                    onTap: () async {
                      await _showPicker(context, ratio);
                    },
                    child: Card(
                      elevation: 2,
                      semanticContainer: true,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      child: Container(
                        color: Colors.blueGrey[50],
                        width: size.width * 0.4,
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.add_a_photo_outlined,
                                size: 40,
                                color: Colors.blueGrey[300],
                              ),
                              Text('Add picture',
                                  style: TextStyle(
                                      color: Colors.blueGrey[300],
                                      fontStyle: FontStyle.italic,
                                      fontSize: 20 * ratio,
                                      fontWeight: FontWeight.w900))
                            ],
                          ),
                        ),
                        height: size.width * 0.5,
                      ),
                    ),
                  )
                : Stack(
                    children: [
                      Container(
                        width: size.width * 0.5,
                        child: Card(
                            elevation: 2,
                            semanticContainer: true,
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            child: Image.file(_image)),
                      ),
                      Positioned(
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
                  ),
            // Container(
            //   margin: EdgeInsets.symmetric(
            //       vertical: 25 * ratio, horizontal: 25 * ratio),
            //   padding: EdgeInsets.all(55 * ratio),
            //   decoration: BoxDecoration(
            //     // border: Border.all(color: Colors.black, width: 1),
            //     color: Colors.blueGrey[50],
            //     shape: BoxShape.circle,
            //   ),
            //   //circle widget
            //   //
            //   child: RichText(
            //     text: TextSpan(
            //         text: NumberFormat("###.#").format(_currentValue),
            //         style: TextStyle(
            //             color: Colors.blueGrey[700],
            //             fontStyle: FontStyle.italic,
            //             fontSize: 40 * ratio,
            //             fontWeight: FontWeight.w900),
            //         children: <TextSpan>[
            //           TextSpan(
            //               text: 'kg',
            //               style: TextStyle(
            //                   color: Colors.blueGrey[400],
            //                   fontStyle: FontStyle.italic,
            //                   fontSize: 10 * ratio,
            //                   fontWeight: FontWeight.bold))
            //         ]),
            //   ),
            // ),
            // isFirst
            //     ? Text(weightAndPics.last.weight.toString())
            //     :
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
                  Container(
                    // color: Colors.blueGrey,
                    margin: EdgeInsets.only(top: 0),
                    child: Text('Day $dayCount', //+
                        //weightAndPics[firstPicindex].path,
                        style: TextStyle(
                            color: Colors.blueGrey[500],
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.italic,
                            fontFamily: 'Open Sans',
                            fontSize: 20 * ratio)),
                  ),
                  RichText(
                    text: TextSpan(
                        text: NumberFormat("###.#").format(_currentValue),
                        style: TextStyle(
                            color: Colors.blueGrey[700],
                            fontStyle: FontStyle.italic,
                            fontSize: 50 * ratio,
                            fontWeight: FontWeight.w900),
                        children: <TextSpan>[
                          TextSpan(
                              text: ['kg', 'lb'][initialLabelIndex],
                              style: TextStyle(
                                  color: Colors.blueGrey[500],
                                  fontStyle: FontStyle.italic,
                                  fontSize: 15 * ratio,
                                  fontWeight: FontWeight.bold))
                        ]),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Divider(),
                  DecimalNumberPicker(
                    textStyle: TextStyle(
                        color: Colors.blueGrey[200],
                        fontStyle: FontStyle.italic,
                        fontSize: 20 * ratio,
                        fontWeight: FontWeight.w600),
                    selectedTextStyle: TextStyle(
                        color: Colors.blueGrey[500],
                        fontStyle: FontStyle.italic,
                        fontSize: 30 * ratio,
                        fontWeight: FontWeight.w600),
                    integerDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(33),
                      border: Border.all(color: Colors.grey[400]),
                    ),
                    decimalDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(33),
                      border: Border.all(color: Colors.grey[400]),
                    ),
                    value: _currentValue,
                    minValue: 0,
                    maxValue: 1000,
                    onChanged: (value) => setState(() => _currentValue = value),
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
