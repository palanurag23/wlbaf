import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:io' as io;

class TwoImages extends StatefulWidget {
  num firstImageWeight;
  String units;
  String path1;
  String path2;

  TwoImages({this.firstImageWeight, this.units, this.path1, this.path2});

  @override
  _TwoImagesState createState() => _TwoImagesState();
}

class _TwoImagesState extends State<TwoImages> {
  // double width1 = 0.42;
  // double width2 = 0.54;
  double width1 = 0.40;
  double width2 = 0.52;

  @override
  Widget build(BuildContext context) {
    double ratio = MediaQuery.of(context).size.height / 896;
    double width = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.only(top: 22 * ratio),
      //  color: Colors.amber[400],
      width: width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    width1 = 0.52;
                    width2 = 0.40;
                  });
                },
                child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey
                              .withOpacity(width2 > width1 ? 0.0 : 0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(03, 3), // changes position of shadow
                        ),
                      ],
                      color: Colors.blueGrey,
                      borderRadius: BorderRadius.circular(11),
                    ),
                    //  height: 200,
                    width: width * width1,
                    //   margin: EdgeInsets.only(bottom: 0),
                    padding: EdgeInsets.symmetric(vertical: 0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(11),
                      child: Image.file(
                        //'./lib/assets/mmm.png',
                        io.File(widget.path1),
                        fit: BoxFit.cover,
                      ),
                    )
                    //  Icon(
                    //   Icons.image,
                    //   color: Colors.grey,
                    //   size: 150,
                    // ),
                    ),
              ),
              RichText(
                text: TextSpan(
                    text: NumberFormat("###.#").format(widget.firstImageWeight),
                    style: TextStyle(
                        color: Colors.blueGrey[300],
                        fontStyle: FontStyle.normal,
                        fontSize: 20 * ratio,
                        fontWeight: FontWeight.w900),
                    children: <TextSpan>[
                      TextSpan(
                          text: ' ' + widget.units,
                          style: TextStyle(
                              color: Colors.blueGrey[300],
                              fontStyle: FontStyle.italic,
                              fontSize: 10 * ratio,
                              fontWeight: FontWeight.bold))
                    ]),
              ),
            ],
          ),
          Column(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    width2 = 0.52;
                    width1 = 0.40;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color:
                            Colors.grey.withOpacity(width2 > width1 ? 0.3 : 0),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(-3, 3), // changes position of shadow
                      ),
                    ],
                    color: Colors.blueGrey,
                    borderRadius: BorderRadius.circular(11),
                  ),
                  width: width * width2,
                  //   height: 330,
                  //  margin: EdgeInsets.only(top: 30),
                  padding: EdgeInsets.symmetric(vertical: 0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(11),
                    child: Image.file(
                      //'./lib/assets/mmm.png',
                      io.File(widget.path2),
                      fit: BoxFit.cover,
                    ),
                  ),
                  //  Icon(
                  //   Icons.image,
                  //   color: Colors.grey,
                  //   size: 230,
                  // ),
                ),
              ),
              Text('Now', //+
                  //weightAndPics[firstPicindex].path,
                  style: TextStyle(
                      color: Colors.blueGrey[300],
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal,
                      fontFamily: 'Open Sans',
                      fontSize: 20 * ratio)),
            ],
          )
        ],
      ),
    );
  }
}
