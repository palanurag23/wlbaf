import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wlbaf/models/modelClasses.dart';
import 'package:wlbaf/providers/providers.dart';
import 'package:wlbaf/testingFolder/BlocClass.dart';

import '../testingFolder/bloc.dart';

class WeightAndPicBloc extends Bloc {
  List<WeightAndPic> weightAndPic = [];
  List<WeightAndPic> pics = [];

  BuildContext _context;

  //
  WeightAndPicBloc(BuildContext context, int days) {
    _context = context;

    weightAndPic = Provider.of<WeightAndPicturesData>(context, listen: false)
        .weightAndPics;
    weightAndPic.forEach((element) {
      if (element.havePicture) {
        pics.add(element);
      }
    });
    addData(days);
  }
  int getLength() => pics.length;
  void addData(int days) {
    int length = pics.length;
    if (length <= days) {
      _streamController.sink.add(pics);
    } else {
      _streamController.sink.add(pics.sublist(length - days));
    }
  }

  //
  StreamController<List<WeightAndPic>> _streamController = StreamController();
  Stream<List<WeightAndPic>> get stream => _streamController.stream;
//

//
  @override
  void dispose() {
    _streamController.close();
    // TODO: implement dispose
  }
//

}
