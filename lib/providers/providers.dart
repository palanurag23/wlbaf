import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wlbaf/helpers/db_helper.dart';
import 'package:wlbaf/models/modelClasses.dart';
import 'dart:io';
import 'dart:convert';
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

class RateMyAppData {}

class CurrentJourney with ChangeNotifier {
  int currentJourneyId;
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
      print('if $checkJourneyCount checkJourneyCount');
      currentJourneyId = prefs.getInt('currentJourneyId');
      int x = prefs.getInt('journeyCount');
      print('$checkJourneyCount$currentJourneyId$x');
    } else {
      print('else $checkJourneyCount checkJourneyCount');

      await prefs.setInt('journeyCount', 0);

      await prefs.setInt('currentJourneyId', 0);
      print('      await prefs.setInt(currentJourneyId, 0);');
      print('      await prefs.setInt(journeyCount, 0);');

      currentJourneyId = 0;
      notifyListeners();
      print('$currentJourneyId');
    }

    await Provider.of<JourneysData>(context, listen: false)
        .fetchAndSetData(currentJourneyId: currentJourneyId);

    if (currentJourneyId > 0) {
      await Provider.of<WeightAndPicturesData>(context, listen: false)
          .fetchAndSetData(currentJourneyId);
    }
  }

  set(int id, BuildContext context, bool shouldFetchWeight,
      bool shouldEmpty) async {
    SharedPreferences prefs =
        Provider.of<SharedPreferencesData>(context, listen: false).get();
    await prefs.setInt('currentJourneyId', id);

    currentJourneyId = id;
    await Provider.of<JourneysData>(context, listen: false)
        .setJourney(currentJourneyId);
    //  imageCache.clear();
    if (shouldEmpty) {
      await Provider.of<WeightAndPicturesData>(context, listen: false)
          .setEmpty();
    }
    if (shouldFetchWeight) {
      print('shouldFetchWeight $shouldFetchWeight');
      await Provider.of<WeightAndPicturesData>(context, listen: false)
          .fetchAndSetData(id);
    }
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
    SharedPreferences prefs =
        Provider.of<SharedPreferencesData>(context, listen: false).get();

    int id = prefs.getInt('journeyCount') + 1;
    print('$id');
    await prefs.setInt('currentJourneyId', id);
    await prefs.setInt('journeyCount', id);
    await Provider.of<CurrentJourney>(context, listen: false)
        .set(id, context, false, true);
    journey = Journey(
      durationInWeeks: durationInWeeks,
      id: id,
      journeyOver: false,
      name: name,
      targetWeight: targetWeight,
      weightLoss: weightLoss,
      weightTableName: 'weightDatabaseTableName$id',
    );
    journeysList.add(journey);
    print('add journey ${journey.weightLoss}');
    Map<String, Object> journeyMap = {
      'id': id,
      'name': name,
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

  Future<void> deleteSingleJourney(int id, BuildContext context) async {
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
    if (currentJourneyId != 0)
      journey = await journeysList.firstWhere((e) => e.id == currentJourneyId);
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
      await setJourney(currentJourneyId);
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
