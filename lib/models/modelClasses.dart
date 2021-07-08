class WeightAndPic {
  String dateTime;
  num weight;
  bool havePicture;
  String path;
  WeightAndPic({
    this.dateTime,
    this.havePicture,
    this.path,
    this.weight,
  });
}

class Journey {
  int id;
  String name;
  num targetWeight;
  int durationInWeeks;
  bool journeyOver;
  String weightTableName;
  bool weightLoss;
  Journey({
    this.durationInWeeks,
    this.id,
    this.journeyOver,
    this.name,
    this.targetWeight,
    this.weightLoss,
    this.weightTableName,
  });
}

class ScreenArguments {
  ScreenArguments({this.list, this.appBarTitle, this.number});
  String appBarTitle;
  List<WeightAndPic> list;
  int number;
}
