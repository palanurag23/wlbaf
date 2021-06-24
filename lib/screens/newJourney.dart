import 'package:flutter/material.dart';
import 'package:wlbaf/models/modelClasses.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';
import '../providers/providers.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

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
  File _image;
  final picker = ImagePicker();
  int duration = 1;
  bool isInitialized = false;
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
  void dispose() {
    _noteController.dispose();
    super.dispose();
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

    return Scaffold(
      persistentFooterButtons: [
        ElevatedButton.icon(
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

                await Provider.of<WeightAndPicturesData>(context, listen: false)
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
                Navigator.of(context).pushNamed('/Tabs_screen');
              }
            },
            icon: Icon(Icons.save),
            label: Text('Save $journeyId'))
      ],
      appBar: AppBar(
        title: Text('AddNewJourney'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
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
              child: TextField(
                  maxLength: 50,
                  onChanged: (String note) {
                    //     print(note);
                    print(_noteController.text);
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
                    hintText: 'Title for this journey',
                    border: InputBorder.none,
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                  autofocus: false,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  controller: _noteController),
            ),
            Text('weight'),
            DecimalNumberPicker(
              integerDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.black26),
              ),
              decimalDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.black26),
              ),
              value: _currentWeightValue,
              minValue: 0,
              maxValue: 1000,
              onChanged: (value) => setState(() => _currentWeightValue = value),
            ),
            Text('goal'),
            NumberPicker(
                minValue: 0,
                axis: Axis.horizontal,
                maxValue: 450,
                value: _currentGoalValue,
                onChanged: (value) =>
                    setState(() => _currentGoalValue = value)),
            Text('duration'),
            NumberPicker(
                axis: Axis.horizontal,
                minValue: 1,
                maxValue: 502,
                value: duration,
                onChanged: (value) => setState(() => duration = value)),
            _image == null ? Text('No image selected.') : Image.file(_image),
            ElevatedButton(
                onPressed: () async {
                  await getImage();
                },
                child: Text('pick')),
          ],
        ),
      ),
    );
  }
}
