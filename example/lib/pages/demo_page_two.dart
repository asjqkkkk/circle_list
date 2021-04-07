import 'package:circle_list_demo/flare/my_controller.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:circle_list/circle_list.dart';

class ShowDemoPageTwo extends StatefulWidget {
  @override
  _ShowDemoPageTwoState createState() => _ShowDemoPageTwoState();
}

class _ShowDemoPageTwoState extends State<ShowDemoPageTwo> {
  MyController? myController;

  @override
  void initState() {
    super.initState();
    myController = MyController();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircleList(
          origin: Offset(0, 0),
          centerWidget: FlareActor(
            "images/one_punch.flr",
            controller: myController,
          ),
          children: List.generate(10, (index) {
            return ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(50)),
                child: Container(
                    color: Colors.blue,
                    width: 50,
                    height: 50,
                    child: Image.asset("images/${index + 1}.png")));
          }),
          onDragUpdate: (update) {
            Offset point = Offset(update.point.dx * 2, update.point.dy * 2);
            myController!.lookAt(point);
          },
        ),
      ),
    );
  }
}
