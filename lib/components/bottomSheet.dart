import 'package:flutter/material.dart';
import 'package:bucketo/screens/home.dart';
import 'package:bucketo/util.dart';

class Modal {
  List<String> subTasks = ['Call the restaurant', 'Ask for the date'];

  Widget _buildFabDelete(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).size.height / 25,
      left: 0,
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.elliptical(175, 30)),
        ),
      ),
    );
  }

  Widget _buildAddTaskForm(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).size.height / 2 - 340,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildCloseButton(context),
          _buildTaskDetails(context),
          _buildCategorySelection(context),
          _buildDateTimeSelection(context),
          _buildAddSubtaskButton(context),
          _buildSubtasksList(context),
          _buildAddTaskButton(context),
        ],
      ),
    );
  }

  Widget _buildCloseButton(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        width: 50,
        height: 50,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [CustomColors.PurpleLight, CustomColors.PurpleDark],
          ),
          borderRadius: BorderRadius.all(Radius.circular(50.0)),
          boxShadow: [
            BoxShadow(
              color: CustomColors.PurpleShadow,
              blurRadius: 10.0,
              spreadRadius: 5.0,
              offset: Offset(0.0, 0.0),
            ),
          ],
        ),
        child: Image.asset('assets/images/fab-delete.png'),
      ),
    );
  }

  Widget _buildTaskDetails(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 10),
        const Text(
          'Add new task',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: MediaQuery.of(context).size.width / 1.2,
          child: TextFormField(
            initialValue: 'Book a table for dinner',
            autofocus: true,
            style: const TextStyle(fontSize: 22, fontStyle: FontStyle.normal),
            decoration: const InputDecoration(border: InputBorder.none),
          ),
        ),
        const SizedBox(height: 5),
        // ... Other task details
      ],
    );
  }

  Widget _buildCategorySelection(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 1.2,
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(width: 1.0, color: CustomColors.GreyBorder),
          bottom: BorderSide(width: 1.0, color: CustomColors.GreyBorder),
        ),
      ),
      child: _buildCategoryList(),
    );
  }

  Widget _buildCategoryList() {
    return ListView(
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      children: [
        _buildCategoryItem(CustomColors.YellowAccent, 'Personal'),
        _buildCategoryItem(CustomColors.GreenIcon, 'Work'),
        _buildCategoryItem(CustomColors.PurpleIcon, 'Meeting'),
        _buildCategoryItem(CustomColors.BlueIcon, 'Study'),
        _buildCategoryItem(CustomColors.OrangeIcon, 'Shopping'),
      ],
    );
  }

  Widget _buildCategoryItem(Color color, String label) {
    return Center(
      child: label == 'Work'
          ? _buildWorkCategoryItem(color, label)
          : _buildRegularCategoryItem(color, label),
    );
  }

  Widget _buildWorkCategoryItem(Color color, String label) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        color: color,
        boxShadow: const [
          BoxShadow(
            color: CustomColors.GreenShadow,
            blurRadius: 5.0,
            spreadRadius: 3.0,
            offset: Offset(0.0, 0.0),
          ),
        ],
      ),
      child: const Text(
        'Work',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _buildRegularCategoryItem(Color color, String label) {
    return Row(
      children: [
        Container(
          height: 10.0,
          width: 10.0,
          margin: const EdgeInsets.only(right: 4),
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(right: 10),
          child: Text(label),
        ),
      ],
    );
  }

  Widget _buildDateTimeSelection(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 20),
        SizedBox(
          width: MediaQuery.of(context).size.width / 1.2,
          child: const Text(
            'Choose date',
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 12),
          ),
        ),
        const SizedBox(height: 10),
        // ... Other date and time selection widgets
      ],
    );
  }

  Widget _buildAddSubtaskButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // setState(() {
        //   subTasks.add('New subtask');
        // });
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        padding: const EdgeInsets.all(0.0),
      ),
      child: Container(
        width: 120,
        height: 40,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [CustomColors.BlueLight, CustomColors.BlueDark],
          ),
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          boxShadow: [
            BoxShadow(
              color: CustomColors.BlueShadow,
              blurRadius: 2.0,
              spreadRadius: 1.0,
              offset: Offset(0.0, 0.0),
            ),
          ],
        ),
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: const Center(
          child: Text(
            'Add subtask',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }

  Widget _buildSubtasksList(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 1.2,
      height: 150,
      child: ListView.builder(
        itemCount: subTasks.length,
        itemBuilder: (BuildContext context, int index) {
          return _buildSubtaskTextField(subTasks[index]);
        },
      ),
    );
  }

  Widget _buildSubtaskTextField(String initialValue) {
    return Container(
      margin: const EdgeInsets.only(bottom: 5.0),
      child: TextFormField(
        initialValue: initialValue,
        autofocus: false,
        style: TextStyle(
          fontSize: 18,
          fontStyle: FontStyle.normal,
          color: Colors.grey[850],
        ),
        decoration: const InputDecoration(
          border: InputBorder.none,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 1.0),
            borderRadius: BorderRadius.all(Radius.circular(55.0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue, width: 2.0),
            borderRadius: BorderRadius.all(Radius.circular(50.0)),
          ),
        ),
      ),
    );
  }

  Widget _buildAddTaskButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Home()),
        );
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        padding: const EdgeInsets.all(0.0),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width / 1.2,
        height: 60,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [CustomColors.BlueLight, CustomColors.BlueDark],
          ),
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          boxShadow: [
            BoxShadow(
              color: CustomColors.BlueShadow,
              blurRadius: 2.0,
              spreadRadius: 1.0,
              offset: Offset(0.0, 0.0),
            ),
          ],
        ),
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: const Center(
          child: Text(
            'Add task',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }

  void mainBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height - 80,
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Stack(
            alignment: AlignmentDirectional.topCenter,
            children: [
              _buildFabDelete(context),
              _buildAddTaskForm(context),
            ],
          ),
        );
      },
    );
  }
}
