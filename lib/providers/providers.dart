import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wlbaf/helpers/db_helper.dart';
import 'package:wlbaf/models/modelClasses.dart';
import 'dart:io';
import 'dart:convert';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:intl/intl.dart';

class MaterialNavigatorKey {
  GlobalKey materialNavigatorKey;
  MaterialNavigatorKey({this.materialNavigatorKey});
  GlobalKey get() => materialNavigatorKey;
}

class SharedPreferencesData {
  SharedPreferences prefs;
  set(SharedPreferences prefs) {
    this.prefs = prefs;
  }

  SharedPreferences get() => prefs;
}

class CurrentJourney with ChangeNotifier {
  int currentJourneyId = 0;
  setOnlyINapp(int currentJourneyId, BuildContext context) {
    this.currentJourneyId = currentJourneyId;
    Provider.of<JourneysData>(context, listen: false)
        .setJourney(currentJourneyId);
    notifyListeners();
  }

  Future<void> fetchAndSetCurrentJourneyData(BuildContext context) async {
    SharedPreferences prefs =
        Provider.of<SharedPreferencesData>(context, listen: false).get();
    bool checkJourneyCount = prefs.containsKey('journeyCount');
    print(' checkJourneyCount if empty then false= $checkJourneyCount ');

    if (checkJourneyCount) {
      // print('if $checkJourneyCount checkJourneyCount');
      currentJourneyId = 0; //prefs.getInt('currentJourneyId');
      //  int x = prefs.getInt('journeyCount');
      //  print('$checkJourneyCount$currentJourneyId$x');
    } else {
      //print('else $checkJourneyCount checkJourneyCount');

      // await prefs.setInt('journeyCount', 0);

      // await prefs.setInt('currentJourneyId', 0);
      // print('      await prefs.setInt(currentJourneyId, 0);');
      // print('      await prefs.setInt(journeyCount, 0);');

      currentJourneyId = 0;
      notifyListeners();
      print('$currentJourneyId');
    }

    await Provider.of<JourneysData>(context, listen: false)
        .fetchAndSetData(currentJourneyId: currentJourneyId);

    if (currentJourneyId == 0) {
      await Provider.of<WeightAndPicturesData>(context, listen: false)
          .fetchAndSetData(currentJourneyId);
    }
  }

  set(int id, BuildContext context, bool shouldFetchWeight,
      bool shouldEmpty) async {
    // SharedPreferences prefs =
    //     Provider.of<SharedPreferencesData>(context, listen: false).get();
    // await prefs.setInt('currentJourneyId', id);
    print('-2');
    currentJourneyId = 0;
    await Provider.of<JourneysData>(context, listen: false)
        .setJourney(currentJourneyId);
    print('-3');
    //  imageCache.clear();
    if (shouldEmpty) {
      await Provider.of<WeightAndPicturesData>(context, listen: false)
          .setEmpty();
    }
    print('-4');
    if (shouldFetchWeight) {
      print('shouldFetchWeight $shouldFetchWeight');
      await Provider.of<WeightAndPicturesData>(context, listen: false)
          .fetchAndSetData(0);
    }
    print('-5');
    notifyListeners();
  }

  get() => currentJourneyId;
}

class UnitsData with ChangeNotifier {
  String units = 'lb';
  set(String units, BuildContext context) {
    this.units = units;
    Provider.of<SharedPreferencesData>(context, listen: false)
        .get()
        .setString('units', units);
    notifyListeners();
  }

  Future<void> fetchAndSetUnits(BuildContext context) async {
    var prefs =
        Provider.of<SharedPreferencesData>(context, listen: false).get();
    bool checkUnits = prefs.containsKey('units');
    if (checkUnits) {
      units = prefs.getString('units');
      notifyListeners();
    } else {
      units = 'lb';
      prefs.setString('units', units);
      notifyListeners();
    }
  }

  String get() => units;
}

class JourneysData with ChangeNotifier {
  List<Journey> journeysList = [];
  List<Journey> get getJourneysList => [...journeysList];
  Journey journey = Journey();
  Future<void> addNewJourney(
    BuildContext context,
    String name,
    num targetWeight,
    int durationInWeeks,
    bool journeyOver,
    bool weightLoss,
  ) async {
    // SharedPreferences prefs =
    //     Provider.of<SharedPreferencesData>(context, listen: false).get();
    print('-1');
    int id = 0;
    //prefs.getInt('journeyCount') + 1;
    // print('$id');
    // await prefs.setInt('currentJourneyId', id);
    // await prefs.setInt('journeyCount', id);

    print('0');

    journey = Journey(
      durationInWeeks: durationInWeeks,
      id: id,
      journeyOver: false,
      name: name,
      targetWeight: targetWeight,
      weightLoss: weightLoss,
      weightTableName: 'weightDatabaseTableName$id',
    );
    print('1');
    journeysList = [journey]; //.add();
    await Provider.of<CurrentJourney>(context, listen: false)
        .set(id, context, false, true);
    print('add journey ${journey.weightLoss}');
    Map<String, Object> journeyMap = {
      'id': id,
      'name': 'name',
      'targetWeight': targetWeight,
      'targetDurationInWeeks': durationInWeeks,
      'weightTableName': journey.weightTableName,
      'lose0Gain1': weightLoss ? 0 : 1,
      'journeyOver': 0
    };
    await DbHelper.insertJourney(
      'Journeys',
      journeyMap,
    );

    notifyListeners();
  }

  Future<void> deleteSingleJourney(BuildContext context) async {
    int id = 0;
    bool sameId =
        Provider.of<CurrentJourney>(context, listen: false).get() == id;
    if (sameId) {
      Provider.of<CurrentJourney>(context, listen: false)
          .set(0, context, false, false);
    }

    print('deleting .... journey......................$id');
    await DbHelper.deleteSingleJourney(id, 'Journeys');
    journeysList.removeWhere((element) => element.id == id);
    Provider.of<WeightAndPicturesData>(context, listen: false).setEmpty();
    await DbHelper.deleteDatabase('weightDatabaseTableName$id');
    notifyListeners();
  }

  Future<void> setJourney(int currentJourneyId) async {
    journey = journeysList[0];
    notifyListeners();
  }

  Future<void> fetchAndSetData({int currentJourneyId}) async {
    final journeyList = await DbHelper.getJourneyData();
    if (journeyList.isEmpty) {
      print('....................................empty journey database');
    } else {
      print(journeyList);
      journeysList = journeyList
          .map((e) => Journey(
              durationInWeeks: e['targetDurationInWeeks'],
              id: e['id'],
              journeyOver: e['journeyOver'] == 1,
              name: e['name'],
              targetWeight: e['targetWeight'],
              weightLoss: e['lose0Gain1'] == 0,
              weightTableName: e['weightTableName']))
          .toList();
    }

    if (currentJourneyId != null && journeysList.isNotEmpty) {
      print('currentJourneyId$currentJourneyId');
      await setJourney(0);
    }

    notifyListeners();
    print('................journeys list fetched and set ');
  }
}

class WeightAndPicturesData with ChangeNotifier {
  List<WeightAndPic> _weightAndPicList = [];
//without '_' like weightAndPicList not _weightAndPicList
//it will be editable from outside
//like Provider.of<WeightAndPicturesData>(context).weightAndPicList.SORT;
// USE '_'  AND USE GETTER //List<WeightAndPic> get weightAndPics

  List<WeightAndPic> get weightAndPics {
    return [..._weightAndPicList];
  }

  setEmpty() {
    _weightAndPicList = [];
    notifyListeners();
  }

  Future<void> addWeightAndPic(
      num weight, int journeyId, bool havePic, String picPath) async {
    final dateTime = DateTime.now();
    // .add(Duration(
    //     days:
    //         35)); //..............................................[[[[[[[[[[[[]]]]]]]]]]]]
    WeightAndPic weightAndPic = WeightAndPic(
        path: picPath,
        weight: weight,
        havePicture: havePic,
        dateTime: dateTime.toIso8601String());
    if (_weightAndPicList.isEmpty) {
      print('weightListEmpty');

      _weightAndPicList.add(weightAndPic);
      await DbHelper.insertWeight('weightDatabaseTableName$journeyId', {
        'dateTime': weightAndPic.dateTime,
        'weight': weightAndPic.weight,
        'havePicture01': weightAndPic.havePicture ? 1 : 0,
        'picturePath': weightAndPic.path
      });
      notifyListeners();
    } else {
      if (DateFormat('dd/MM/yy').format(dateTime) !=
          DateFormat('dd/MM/yy')
              .format(DateTime.parse(_weightAndPicList.last.dateTime))) {
        print('date not same ..adding weightandpic');
        _weightAndPicList.add(weightAndPic);
        await DbHelper.insertWeight('weightDatabaseTableName$journeyId', {
          'dateTime': weightAndPic.dateTime,
          'weight': weightAndPic.weight,
          'havePicture01': weightAndPic.havePicture ? 1 : 0,
          'picturePath': weightAndPic.path
        });
        notifyListeners();
      } else {
        print('....weightListNotEmpty ... date is same ... replacing');

        await deleteSingleWeightAndPics(
            _weightAndPicList.last.dateTime, journeyId);
        await DbHelper.insertWeight('weightDatabaseTableName$journeyId', {
          'dateTime': weightAndPic.dateTime,
          'weight': weightAndPic.weight,
          'havePicture01': weightAndPic.havePicture ? 1 : 0,
          'picturePath': weightAndPic.path
        });
        // weightAndPicList.removeLast();
        _weightAndPicList.add(weightAndPic);
        notifyListeners();
      }
    }
  }

  Future<void> deleteSingleWeightAndPics(String dateTime, int journeyId) async {
    print('deleting .... weight......................$dateTime');
    await DbHelper.deleteSingleWeight(
        dateTime, 'weightDatabaseTableName$journeyId');
    _weightAndPicList.removeWhere((element) => element.dateTime == dateTime);
    notifyListeners();
  }

  Future<void> fetchAndSetData(int journeyId) async {
    final weightAndPicDataList =
        await DbHelper.getWeightData('weightDatabaseTableName$journeyId');
    if (weightAndPicDataList.isEmpty) {
      print('....................................empty WEIGHTandPic database');
    } else {
      print(weightAndPicDataList);
    }
    _weightAndPicList = weightAndPicDataList
        .map((e) => WeightAndPic(
            dateTime: e['dateTime'],
            weight: e['weight'],
            havePicture: e['havePicture01'] != 0,
            path: e['picturePath']))
        .toList();
    notifyListeners();
    print(
        '................weightsAndpic length=${weightAndPicDataList.length} fetched and set for weightDatabaseTableName$journeyId');
  }
}

class RateMyAppData with ChangeNotifier {
  String comment;
  RateMyApp _rateMyApp;
  set(RateMyApp rateMyApp) {
    _rateMyApp = rateMyApp;
  }

  Future<void> addRatingCheck(BuildContext context) async {
    SharedPreferences prefs =
        Provider.of<SharedPreferencesData>(context, listen: false).get();
    DateTime lastRatingDateTime =
        DateTime.parse(prefs.getString('last_Rating_DateTime'));
    int difference = DateTime.now().difference(lastRatingDateTime).inDays;
    print('now minus last rating = $difference');
    if (difference >= 7) {
      print(difference);
      Provider.of<RateMyAppData>(context, listen: false)
          .showStarDialog(context);
    }
  }

  RateMyApp get() => _rateMyApp;

  Future<void> showStarDialog(BuildContext context) async {
    /////either if user choose to rate or we asked him to..
    ///ddialog is shown...so we shuold wait
    SharedPreferences prefs =
        Provider.of<SharedPreferencesData>(context, listen: false).get();
    prefs.setString(
        'last_Rating_DateTime', "${DateTime.now().toIso8601String()}");
    ////
    _rateMyApp.showStarRateDialog(context,
        dialogStyle: DialogStyle(
            messageStyle: TextStyle(
                color: Colors.blueGrey[800], fontWeight: FontWeight.normal),
            titleStyle: TextStyle(color: Colors.blueGrey[900], fontSize: 24),
            titleAlign: TextAlign.center,
            messagePadding:
                EdgeInsets.only(left: 5, right: 5, bottom: 20, top: 5)),
        // contentBuilder: (context, defaultContent) => Container(
        //       height: 6,
        //       width: 6,
        //       color: Colors.amber,
        //     ),
        title: 'Did you like the app ?', // The dialog title.
        message: 'How was your experience with us?', // The dialog message.
        starRatingOptions: StarRatingOptions(initialRating: 5),
        ignoreNativeDialog: true
        //Platform
        //  .isAndroid, // Set to false if you want to show the Apple's native app rating dialog on iOS or Google's native app rating dialog (depends on the current Platform).
        ,
        onDismissed: () =>
            () {}, // Called when the user dismissed the dialog (either by taping outside or by pressing the "back" button).

        actionsBuilder: (context, stars) {
          // Triggered when the user updates the star rating.
          return [
            // RateMyAppNoButton(_rateMyApp, text: 'NO, THANKS'),
            TextButton(
                child: Text('NO, THANKS',
                    style:
                        TextStyle(color: Colors.blueGrey[400], fontSize: 15)),
                onPressed: () async {
                  Navigator.of(context).pop();
                }),
            // Return a list of actions (that will be shown at the bottom of the dialog).
            TextButton(
              child: Text('SUBMIT',
                  style: TextStyle(color: Colors.pinkAccent, fontSize: 15)),
              onPressed: () async {
                bool nativeSupported =
                    await _rateMyApp.isNativeReviewDialogSupported;
                print('native supported= $nativeSupported ');
                Navigator.of(context).pop();

                stars >= 4
                    ? nativeSupported
                        ? _rateMyApp.showRateDialog(context,
                            ignoreNativeDialog: false)
                        : _rateMyApp.launchStore()
                    : showCommentDialog(context, stars);
                print('Thanks for the ' +
                    (stars == null ? '0' : stars.round().toString()) +
                    ' star(s) !');
                _rateMyApp.callEvent(//to let system know
                    RateMyAppEventType.rateButtonPressed);
                // This allows to mimic the behavior of the default "Rate" button. See "Advanced > Broadcasting events" for more information :
                // if (stars >= 4) {
                //   showThanks(context);
                // }
              },
            ),
          ];
        });
  }

  Future<void> showCommentDialog(BuildContext context, double stars) async {
    final controller = TextEditingController();

    _rateMyApp.showRateDialog(context,
        ignoreNativeDialog: true,
        contentBuilder: (context, _) => TextFormField(
              controller: controller,
              autofocus: true,
              onFieldSubmitted: (_) => Navigator.of(context).pop(),
              onChanged: (comment) {
                // setState(() {
                //   this.comment = comment;
                // });
              },
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'comment',
                border: OutlineInputBorder(),
              ),
            ),
        title: 'Your experience',
        actionsBuilder: (context) {
          return [
            RateMyAppNoButton(
              _rateMyApp,
              text: 'CANCEL',
            ),
            TextButton(
                onPressed: () async {
                  print('$comment');
                  print('${controller.text}');
                  Navigator.of(context).pop();

                  // sendRatingsToFirebase(controller.text, stars);
                  showThanks(context);
                },
                child: Text('send'))
          ];
        });
  }

  Future<void> showThanks(BuildContext context) async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          Future.delayed(Duration(milliseconds: 1500))
              .then((value) => Navigator.of(context).pop());

          return Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10)),
                border: Border.all(
                  width: 2,
                  color: Colors.amber,
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.stars_sharp,
                    color: Colors.amber,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    'Thank you! for feedback',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey[800]),
                  ),
                ],
              ),
            ),
          );
        });
  }

  // Future<void> sendRatingsToFirebase(String comment, double stars) async {
  //   DateTime dt = DateTime.now();
  //   print('ratings to firebase');
  //   const url =
  //       'https://bodytrac-e1b7b-default-rtdb.firebaseio.com/Ratings.json';
  //   try {
  //     final response = await http.post(url,
  //         body: json.encode({
  //           'Comment': '${dt.day}/${dt.month}/${dt.year}--$comment',
  //           'Stars': stars
  //         }));
  //     print(response.body);
  //   } catch (error) {}
  // }
}
