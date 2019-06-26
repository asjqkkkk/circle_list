# circle_list

A new Flutter package for Circle List.

## Add dependency

```
dependencies:
  circle_list: ^0.0.3
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
          innerCircleColor: Colors.white,
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

### another background


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

