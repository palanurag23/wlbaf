import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './BlocClass.dart';

class WeightBloc extends Bloc {
  num weigth = 55;
  BuildContext context;
  List<int> nums = [0];
  // List<Weight> weights = [];
  // List<Weight> weightForBloc = [];
  // //
  // StreamController<List<Weight>> _controller = StreamController();
  // Stream<List<Weight>> get streamWeights => _controller.stream;
  // //
  StreamController<List<int>> _streamController = StreamController();
  Stream<List<int>> get stream => _streamController.stream;
  //
  WeightBloc(context) {
    this.context = context;
    // weights = Provider.of<AllWeights>(context, listen: false).weights;
    // weightForBloc = [weights[0]];
    // _controller.sink.add(weightForBloc);
    _streamController.sink.add(nums);
  }
  void deleteNum(int index) {
    nums.removeAt(index);
    _streamController.add(nums);
  }

  void addNum() {
    nums.add(nums.length > 0 ? nums.last + 1 : 0);
    _streamController.sink.add(nums);
  }

  void startTimer(int index) async {
    for (int i = nums[index]; nums.length >= index + 1; i++) {
      nums[index] = nums[index] + 1;
      _streamController.sink.add(nums);
      await Future.delayed(Duration(seconds: 1));
    }
  }

  @override
  void dispose() {
    // _controller.close();
    _streamController.close();
    // TODO: implement dispose
  }
}
