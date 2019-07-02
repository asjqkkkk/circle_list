# circle_list

A new Flutter package for Circle List.

## Add dependency

```
dependencies:
  circle_list: ^0.0.9
```

## Super simple to use


```
import 'package:flutter/material.dart';
import 'package:circle_list/circle_list.dart';

class ShowDemoPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white,),
      body: Center(
        child: CircleList(
          origin: Offset(0, 0),
          children: List.generate(10, (index) {
            return Icon(
              Icons.details,
              color: index % 2 == 0 ? Colors.blue : Colors.orange,
            );
          }),
        ),
      ),
    );
  }
}
```

![image](https://blog-pic-1256696029.cos.ap-guangzhou.myqcloud.com/circl_list/001.gif)


### If you want to add gradient background


```
CircleList(
          gradient: LinearGradient(
            colors: [Colors.redAccent, Colors.blueAccent],
          ),
          origin: Offset(0, 0),
          children: List.generate(10, (index) {
            return Icon(
              Icons.details,
              color: index % 2 == 0 ? Colors.blue : Colors.orange,
            );
          }),
        ),
```


![image](https://blog-pic-1256696029.cos.ap-guangzhou.myqcloud.com/circl_list/002.png)

### Another background


```
CircleList(
          innerCircleColor: Colors.redAccent,
          outerCircleColor: Colors.greenAccent,
          origin: Offset(0, 0),
          children: List.generate(10, (index) {
            return Icon(
              Icons.details,
              color: index % 2 == 0 ? Colors.blue : Colors.orange,
            );
          }),
        )
```

![image](https://blog-pic-1256696029.cos.ap-guangzhou.myqcloud.com/circl_list/003.png)

### CenterWidget



```
CircleList(
          origin: Offset(0, 0),
          children: List.generate(10, (index) {
            return Icon(
              Icons.details,
              color: index % 2 == 0 ? Colors.blue : Colors.orange,
            );
          }),
          centerWidget: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(100)),
              child: Image.asset("images/avator.jpg")),
        ),
```

![image](https://blog-pic-1256696029.cos.ap-guangzhou.myqcloud.com/circl_list/004.png)


## Demo

![image](https://blog-pic-1256696029.cos.ap-guangzhou.myqcloud.com/circl_list/005.gif)


## Params

-  double innerRadius;
-  double outerRadius;
-  double childrenPadding: 
-  double initialAngle;
-  Color outerCircleColor;
-  Color innerCircleColor;
-  Gradient gradient;
-  Offset origin;
-  List<Widget> children;
-  bool isChildrenVertical;
-  bool outerCircleRotateWithChildren;
-  bool innerCircleRotateWithChildren;
-  bool showInitialAnimation;
-  Widget centerWidget;
-  RadialDragStart onDragStart;
-  RadialDragUpdate onDragUpdate;
-  RadialDragEnd onDragEnd;
-  AnimationSetting animationSetting;
