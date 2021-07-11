import 'package:flutter/material.dart';
import 'package:wlbaf/models/modelClasses.dart';
import 'package:intl/intl.dart';

class CircleWidget extends StatelessWidget {
  List<WeightAndPic> weightAndPics;
  CircleWidget(this.weightAndPics, this.units);
  String units;
  @override
  Widget build(BuildContext context) {
    int dayCount = (DateTime.parse(weightAndPics.last.dateTime)
                    .difference(DateTime.parse(weightAndPics.first.dateTime))
                    .inHours /
                24)
            .round() +
        1;
    print('dayCount $dayCount');
    double ratio = MediaQuery.of(context).size.height / 896;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 25 * ratio),
      padding: EdgeInsets.all(33 * ratio),
      decoration: BoxDecoration(
        // border: Border.all(color: Colors.black, width: 1),
        color: Colors.blueGrey[50],
        shape: BoxShape.circle,
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.grey.withOpacity(0.3),
        //     spreadRadius: 5,
        //     blurRadius: 7,
        //     offset: Offset(03, 3), // changes position of shadow
        //   ),
        // ]
      ),
      child: Column(
        children: [
          Container(
            // color: Colors.blueGrey,
            margin: EdgeInsets.only(top: 0),
            child: Text('Day $dayCount', //+
                //weightAndPics[firstPicindex].path,
                style: TextStyle(
                    color: Colors.blueGrey[300],
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.normal,
                    fontFamily: 'Open Sans',
                    fontSize: 25 * ratio)),
          ),
          Container(
            // color: Colors.amber,
            margin: EdgeInsets.only(top: 11 * ratio, bottom: 0 * ratio),
            child: RichText(
              text: TextSpan(
                  text: NumberFormat("###.#").format(weightAndPics.last.weight),
                  style: TextStyle(
                      color: Colors.blueGrey[900],
                      fontStyle: FontStyle.normal,
                      fontSize: 30 * ratio,
                      fontWeight: FontWeight.w900),
                  children: <TextSpan>[
                    TextSpan(
                        text: ' ' + units,
                        style: TextStyle(
                            color: Colors.blueGrey[900],
                            fontStyle: FontStyle.italic,
                            fontSize: 15 * ratio,
                            fontWeight: FontWeight.bold))
                  ]),
            ),
          )
        ],
      ),
    );
  }
}
