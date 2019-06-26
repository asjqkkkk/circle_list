import 'package:flutter/material.dart';
import 'package:circle_list/circle_list.dart';

class ShowDemoPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white,),
      body: Center(
        child: CircleList(
          childrenPadding: 30,
          origin: Offset(0, 0),
          children: List.generate(10, (index){
            return Icon(Icons.details,color: index % 2 ==0 ?Colors.blue:Colors.orange,);
          }),
        ),
      ),
    );
  }
}