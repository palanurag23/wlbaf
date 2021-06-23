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
  bool isInitialized = false;
  bool weightAddedToday;
  bool addImage = false;
  List<WeightAndPic> weightAndPics = [];
  File _image;
  final picker = ImagePicker();
  int journeyId;
  var weightAndPicturesData;
  @override
  void didChangeDependencies() {
    if (!isInitialized) {
      weightAndPicturesData =
          Provider.of<WeightAndPicturesData>(context, listen: false);
      journeyId = Provider.of<CurrentJourney>(context, listen: false).get();
      weightAndPics = weightAndPicturesData.weightAndPicList;
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

  Future getImage() async {
    print('a');
    PickedFile pickedFile;
    // final pickedFile = await picker.getImage(source: ImageSource.gallery);
    try {
      print('b');
      pickedFile = await picker.getImage(
        source: ImageSource.gallery,
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
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: Icon(Icons.save),
        label: Text('save'),
      ),
      persistentFooterButtons: [
        ElevatedButton.icon(
            onPressed: journeyId == 0
                ? () {}
                : () {
                    weightAndPicturesData.addWeightAndPic(_currentValue,
                        journeyId, addImage, addImage ? _image.path : '.....');
                    Navigator.of(context).pop();
                  },
            icon: Icon(Icons.save),
            label: Text('Save $journeyId'))
      ],
      appBar: AppBar(
        title: weightAddedToday
            ? Text('Edid Weight and Pic')
            : Text('Add Weight and Pic'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 22,
            ),
            if (weightListEmpty)
              ToggleSwitch(
                minWidth: 90.0,
                cornerRadius: 20.0,
                activeBgColors: [
                  [Colors.lightBlue, Colors.cyan],
                  [Colors.red[800], Colors.amber]
                ],
                activeFgColor: Colors.white,
                inactiveBgColor: Colors.blueGrey[200],
                inactiveFgColor: Colors.white,
                initialLabelIndex: 0,
                totalSwitches: 2,
                labels: ['kg', 'lb'],
                radiusStyle: true,
                onToggle: (index) {
                  print('switched to: $index');
                },
              ),
            DecimalNumberPicker(
              integerDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.black26),
              ),
              decimalDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.black26),
              ),
              value: _currentValue,
              minValue: 0,
              maxValue: 100,
              onChanged: (value) => setState(() => _currentValue = value),
            ),
            Text('Current value: $_currentValue'),
            _image == null ? Text('No image selected.') : Image.file(_image),
            ElevatedButton(
                onPressed: () async {
                  await getImage();
                },
                child: Text('pick')),
            Text('addImage $addImage'),
            ElevatedButton(
                onPressed: () async {
                  setState(() {
                    addImage = false;
                  });
                },
                child: Text('un-pick image'))
          ],
        ),
      ),
    );
  }
}
