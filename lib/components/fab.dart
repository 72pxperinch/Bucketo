import 'package:flutter/material.dart';

import 'package:bucketo/screens/addTask.dart';
import 'package:bucketo/util.dart';

FloatingActionButton customFab(context) {
// Create an instance of the Modal class

  return FloatingActionButton(
    onPressed: () {
      Navigator.pushNamed(context, AddTaskScreen.id);
    },
    elevation: 5,
    backgroundColor: Colors.transparent,
    child: Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            CustomColors.HeaderBlueLight,
            CustomColors.HeaderBlueDark,
          ],
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(50.0),
        ),
        boxShadow: [
          BoxShadow(
            color: CustomColors.BlueBackground,
            blurRadius: 10.0,
            spreadRadius: 5.0,
            offset: Offset(0.0, 0.0),
          ),
        ],
      ),
      child: Image.asset('assets/images/fab-add.png'),
    ),
  );
}
