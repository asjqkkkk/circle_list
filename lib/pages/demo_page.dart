import 'package:circle_list_demo/bottom_show_widget.dart';
import 'package:circle_list_demo/full_screen_dialog_util.dart';
import 'package:circle_list_demo/pages/demo_page_two.dart';
import 'package:flutter/material.dart';

class ShowDemoPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: SizedBox(),
        title: Text("Circle List Demo", style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          FullScreenDialog.getInstance()
              .showDialog(context, BottomShowWidget());
        },
        backgroundColor: Colors.black,
        child: Icon(
          Icons.drive_eta,
          size: 30,
        ),
      ),
    );
  }
}