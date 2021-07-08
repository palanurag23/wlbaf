import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OneImage extends StatelessWidget {
  num firstImageWeight;
  OneImage(this.firstImageWeight, this.units);
  String units;

  @override
  Widget build(BuildContext context) {
    double ratio = MediaQuery.of(context).size.height / 896;
    double width = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.only(top: 22 * ratio),
      width: width,
      child: Column(
        children: [
          Container(
              margin: EdgeInsets.only(bottom: 12 * ratio),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(01, 1), // changes position of shadow
                  ),
                ],
                color: Colors.blueGrey,
                borderRadius: BorderRadius.circular(11),
              ),
              //  height: 200,
              width: width * 0.54,
              //   margin: EdgeInsets.only(bottom: 0),
              padding: EdgeInsets.symmetric(vertical: 0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(11),
                child: Image.asset(
                  //'./lib/assets/mmm.png',
                  './lib/assets/ooo.jpeg',
                  fit: BoxFit.cover,
                ),
              )
              //  Icon(
              //   Icons.image,
              //   color: Colors.grey,
              //   size: 150,
              // ),
              ),
          RichText(
            text: TextSpan(
                text: 'Starting with ',
                style: TextStyle(
                    color: Colors.blueGrey[300],
                    fontStyle: FontStyle.italic,
                    fontSize: 20 * ratio,
                    fontWeight: FontWeight.w900),
                children: <TextSpan>[
                  TextSpan(
                      text: NumberFormat("###.#").format(firstImageWeight),
                      style: TextStyle(
                          color: Colors.blueGrey[300],
                          fontStyle: FontStyle.italic,
                          fontSize: 30 * ratio,
                          fontWeight: FontWeight.w900)),
                  TextSpan(
                      text: units,
                      style: TextStyle(
                          color: Colors.blueGrey[300],
                          fontStyle: FontStyle.italic,
                          fontSize: 20 * ratio,
                          fontWeight: FontWeight.bold))
                ]),
          ),
        ],
      ),
    );
  }
}
