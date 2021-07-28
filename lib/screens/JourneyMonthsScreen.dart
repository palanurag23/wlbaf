import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:wlbaf/models/modelClasses.dart';
import 'package:wlbaf/providers/providers.dart';

class JourneyMonthScreen extends StatefulWidget {
  static const routeName = '/JourneyMonthScreen';

  @override
  _JourneyMonthScreenState createState() => _JourneyMonthScreenState();
}

class _JourneyMonthScreenState extends State<JourneyMonthScreen> {
  int minYear = 0;
  bool initialized = false;
  List<WeightAndPic> weightAndPicList;
  List<WeightAndPic> yearSubList;
  List<WeightAndPic> monthSubList;
  bool yearListExpanded = false;
  int selectedYear;
  int selectedMonth;
  int maxYear = 0;
  List<int> years = [];
  List<int> months = [];
  bool showMonths;
  List<int> setYearList(List<WeightAndPic> weightAndPicList) {
    weightAndPicList.forEach((element) {
      int year = DateTime.parse(element.dateTime).year;
      if (year > years.last) {
        years.add(year);
      }
    });
  }

  List<WeightAndPic> setListForMonth(
      List<WeightAndPic> yearSubList, int selectedMonth) {
    List<WeightAndPic> sortedYearSubList = yearSubList;
    sortedYearSubList.sort((a, b) =>
        DateTime.parse(b.dateTime).compareTo(DateTime.parse(a.dateTime)));

    return sortedYearSubList.sublist(
        sortedYearSubList.indexWhere(
            (e) => DateTime.parse(e.dateTime).month == selectedMonth),
        sortedYearSubList.lastIndexWhere(
                (e) => DateTime.parse(e.dateTime).month == selectedMonth) +
            1);
  }

  List<int> setMonthList(List<WeightAndPic> yearSubList) {
    yearSubList.forEach((e) {
      int month = DateTime.parse(e.dateTime).month;
      if (month > months.last) {
        months.add(month);
      }
    });
  }

  List<String> monthNames = [
    'January',
    'Febuary',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];
  // List<Color> monthsColors = [
  //   Colors.lightBlue[200],
  //   Colors.lightBlue[100],
  // Colors.ge];
  @override
  void didChangeDependencies() {
    if (!initialized) {
      print('object1');
      weightAndPicList =
          Provider.of<WeightAndPicturesData>(context, listen: false)
              .weightAndPics;
      print('object2');

      weightAndPicList.sort((a, b) => DateTime.parse(a.dateTime)
          .year
          .compareTo(DateTime.parse(b.dateTime).year));
      print('object3');

      minYear = DateTime.parse(weightAndPicList.first.dateTime).year;
      maxYear = DateTime.parse(weightAndPicList.last.dateTime).year;
      years = [minYear];
      print('object4');

      setYearList(weightAndPicList);
      selectedYear = years.last;
      print('object5  $selectedYear');
      yearSubList = weightAndPicList.sublist(
          weightAndPicList.indexWhere(
              (e) => DateTime.parse(e.dateTime).year == selectedYear),
          weightAndPicList.lastIndexWhere(
                  (e) => DateTime.parse(e.dateTime).year == selectedYear) +
              1);
      // yearSubList = weightAndPicList.sublist(
      //     weightAndPicList.indexWhere(
      //         (e) => DateTime.parse(e.dateTime).year == selectedYear),
      //     weightAndPicList.lastIndexWhere(
      //             (e) => DateTime.parse(e.dateTime).year == selectedYear) +
      //         1);
      print('object6' + yearSubList.length.toString());
      yearSubList.sort((a, b) => DateTime.parse(a.dateTime)
          .month
          .compareTo(DateTime.parse(b.dateTime).month));
      print(yearSubList.first.weight);
      print('object7');

      months = [DateTime.parse(yearSubList.first.dateTime).month];
      print('object8');

      setMonthList(yearSubList);
      selectedMonth = months.last;
      print('selected month $selectedMonth');
      monthSubList = setListForMonth(yearSubList, selectedMonth);
      print('object9');

      setState(() {
        initialized = true;
      });
      print('object');
    }
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    double ratio = MediaQuery.of(context).size.height / 896;

    weightAndPicList =
        Provider.of<WeightAndPicturesData>(context).weightAndPics;
    if (weightAndPicList.isNotEmpty) {
      weightAndPicList.sort((a, b) => DateTime.parse(a.dateTime)
          .year
          .compareTo(DateTime.parse(b.dateTime).year));
      minYear = DateTime.parse(weightAndPicList.first.dateTime).year;
      maxYear = DateTime.parse(weightAndPicList.last.dateTime).year;
      years = [minYear];

      setYearList(weightAndPicList);
      if (!years.contains(selectedYear)) {
        selectedYear = years.last;
      }
      yearSubList = weightAndPicList.sublist(
          weightAndPicList.indexWhere(
              (e) => DateTime.parse(e.dateTime).year == selectedYear),
          weightAndPicList.lastIndexWhere(
                  (e) => DateTime.parse(e.dateTime).year == selectedYear) +
              1);
      yearSubList.sort((a, b) => DateTime.parse(a.dateTime)
          .month
          .compareTo(DateTime.parse(b.dateTime).month));
      months = [DateTime.parse(yearSubList.first.dateTime).month];

      setMonthList(yearSubList);
      selectedMonth = months.last;
      monthSubList = setListForMonth(yearSubList, selectedMonth);
    }

    print(months);
    return Scaffold(
      appBar: AppBar(
        title: Text('Journey so far !',
            style: TextStyle(
                color: Colors.blueGrey[900],
                fontStyle: FontStyle.italic,
                fontSize: 20 * ratio,
                fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.blueGrey[900]),
      ),
      body: !initialized
          ? CircularProgressIndicator()
          : SingleChildScrollView(
              child: weightAndPicList.isEmpty
                  ? Center(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .pushReplacementNamed('/AddNewJourney');
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
                                Icons.pedal_bike_outlined,
                                color: Colors.white,
                                size: 33 * ratio,
                              ),
                              SizedBox(
                                width: 12 * ratio,
                              ),
                              Text('Start new journey !',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 20 * ratio,
                                      fontWeight: FontWeight.bold)),
                              Spacer(),
                            ],
                          ),
                        ),
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedContainer(
                          duration: Duration(milliseconds: 331),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(11),
                          ),
                          padding: EdgeInsets.only(
                              top: yearListExpanded ? 5 * ratio : 11 * ratio,
                              left: 0 * ratio,
                              bottom:
                                  yearListExpanded ? 5 * ratio : 11 * ratio),
//color: Colors.cyan,
                          margin: EdgeInsets.only(
                            top: 0 * ratio,
                            left: 15 * ratio,
                            right: 15 * ratio,
                          ),
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    //    vertical: 20 * ratio
                                    horizontal: 22 * ratio),
                                child: Row(
                                  children: [
                                    Text('$selectedYear',
                                        style: TextStyle(
                                            color: Colors.cyan,
                                            fontStyle: FontStyle.italic,
                                            fontSize: 25 * ratio,
                                            fontWeight: FontWeight.bold)),
                                    Spacer(),
                                    if (years.length > 1)
                                      IconButton(
                                        icon: Icon(yearListExpanded
                                            ? Icons.keyboard_arrow_up
                                            : Icons.keyboard_arrow_down_sharp),
                                        iconSize: 40,
                                        color: Colors.cyan,
                                        onPressed: () {
                                          setState(() {
                                            yearListExpanded =
                                                !yearListExpanded;
                                          });
                                        },
                                      )
                                  ],
                                ),
                              ),
                              if (yearListExpanded)
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(11),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 5 * ratio,
                                      horizontal: 22 * ratio),
//color: Colors.cyan,
                                  margin: EdgeInsets.only(left: 11, right: 11),
                                  child: ListView.builder(
                                    padding: EdgeInsets.only(),
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      return AnimationConfiguration
                                          .staggeredList(
                                        position: index,
                                        child: FlipAnimation(
                                          child: Column(
                                            //  crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              InkWell(
                                                onTap: () async {
                                                  setState(() {
                                                    selectedYear = years[index];

                                                    yearSubList = weightAndPicList.sublist(
                                                        weightAndPicList
                                                            .indexWhere((e) =>
                                                                DateTime.parse(e
                                                                        .dateTime)
                                                                    .year ==
                                                                selectedYear),
                                                        weightAndPicList.lastIndexWhere((e) =>
                                                                DateTime.parse(e
                                                                        .dateTime)
                                                                    .year ==
                                                                selectedYear) +
                                                            1);
                                                    print(
                                                        'object6 weight in year' +
                                                            yearSubList.length
                                                                .toString());
                                                    yearSubList.sort((a, b) =>
                                                        DateTime.parse(
                                                                a.dateTime)
                                                            .month
                                                            .compareTo(
                                                                DateTime.parse(b
                                                                        .dateTime)
                                                                    .month));
                                                    print(yearSubList
                                                        .first.weight);
                                                    print('object7');

                                                    months = [
                                                      DateTime.parse(yearSubList
                                                              .first.dateTime)
                                                          .month
                                                    ];
                                                    print('object8');

                                                    setMonthList(yearSubList);
                                                  });
                                                  await Future.delayed(Duration(
                                                      milliseconds: 00));
                                                  setState(() {
                                                    yearListExpanded =
                                                        !yearListExpanded;
                                                  });
                                                },
                                                child: Text('${years[index]}',
                                                    style: TextStyle(
                                                        color: years[index] ==
                                                                selectedYear
                                                            ? Colors.cyan
                                                            : Colors.blueGrey,
                                                        fontStyle:
                                                            FontStyle.italic,
                                                        fontSize:
                                                            years[index] ==
                                                                    selectedYear
                                                                ? 27 * ratio
                                                                : 25 * ratio,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ),
                                              if (index != (years.length - 1))
                                                Divider()
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                    itemCount: years.length,
                                  ),
                                )
                            ],
                          ),
                        ),
                        Container(
                          child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedMonth = months[index];
                                    monthSubList = setListForMonth(
                                        yearSubList, selectedMonth);
                                  });
                                  Navigator.of(context).pushNamed(
                                      '/MonthsWeightAndPicsScreen',
                                      arguments: ScreenArguments(
                                          list: monthSubList,
                                          appBarTitle:
                                              '${monthNames[months[index] - 1]} $selectedYear'));
                                },
                                child: AnimationConfiguration.staggeredList(
                                  position: index,
                                  child: SlideAnimation(
                                    // duration: Duration(seconds: 3),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      padding: EdgeInsets.only(
                                          top: 11 * ratio,
                                          left: 11 * ratio,
                                          bottom: 11 * ratio),
//color: Colors.cyan,
                                      margin: EdgeInsets.only(
                                        top: 5 * ratio,
                                        left: 15 * ratio,
                                        right: 15 * ratio,
                                      ),
                                      child: Text(monthNames[months[index] - 1],
                                          style: TextStyle(
                                              color: Colors.blueGrey[400],
                                              fontStyle: FontStyle.italic,
                                              fontSize: 20 * ratio,
                                              fontWeight: FontWeight.w900)),
                                    ),
                                  ),
                                ),
                              );
                            },
                            itemCount: months.length,
                          ),
                        ),
                        // Text(
                        //     'selected mon $selectedMonth ,mon ${monthSubList.length}'),

                        // Container(
                        //   width: 400,
                        //   color: Colors.greenAccent,
                        //   height: 300,
                        //   child: ListView.builder(
                        //     itemBuilder: (context, index) {
                        //       print(monthSubList.length);
                        //       return GestureDetector(
                        //         onTap: () {},
                        //         child: Text(
                        //             'weight ${monthSubList[index].weight.toString()},,${monthSubList[index].dateTime}'),
                        //       );
                        //     },
                        //     itemCount: monthSubList.length,
                        //   ),
                        // )
                      ],
                    ),
            ),
    );
  }
}
/* Container(
                    color: Colors.greenAccent,
                    height: 200,
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedYear = years[index];

                              yearSubList = weightAndPicList.sublist(
                                  weightAndPicList.indexWhere((e) =>
                                      DateTime.parse(e.dateTime).year ==
                                      selectedYear),
                                  weightAndPicList.lastIndexWhere((e) =>
                                          DateTime.parse(e.dateTime).year ==
                                          selectedYear) +
                                      1);
                              print('object6 weight in year' +
                                  yearSubList.length.toString());
                              yearSubList.sort((a, b) =>
                                  DateTime.parse(a.dateTime).month.compareTo(
                                      DateTime.parse(b.dateTime).month));
                              print(yearSubList.first.weight);
                              print('object7');

                              months = [
                                DateTime.parse(yearSubList.first.dateTime).month
                              ];
                              print('object8');

                              setMonthList(yearSubList);
                            });
                          },
                          child: Text(years[index].toString(),
                              style: TextStyle(
                                  color: Colors.blueGrey[400],
                                  fontStyle: FontStyle.italic,
                                  fontSize: 20 * ratio,
                                  fontWeight: FontWeight.w900)),
                        );
                      },
                      itemCount: years.length,
                    ),
                  ),
                  Text('selected Year $selectedYear'),
                   */
