# circle_list

A new Flutter package for Circle List.

## Add dependency

```
dependencies:
  dio: 0.0.1
```

## Super simple to use


```
import 'package:flutter/material.dart';
import 'package:circle_list/circle_list.dart';

class ShowDemoPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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
```

![image](https://test-1256696029.cos.ap-chengdu.myqcloud.com/demo.gif)
