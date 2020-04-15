import 'dart:math';

import 'package:flare_dart/math/mat2d.dart';
import 'package:flare_dart/math/vec2d.dart';
import 'package:flare_flutter/flare.dart';
import 'package:flare_flutter/flare_controller.dart';
import 'package:flare_flutter/flare_controls.dart';
import 'package:flutter/material.dart';


class MyController extends FlareControls{

  //用于获取ctrl_eyes节点
  ActorNode _eyeControl;

  // 用于存储从flare转换到flutter的矩阵
  Mat2D _globalToFlareWorld = Mat2D();

  // 在flutter中当前焦点所在的坐标
  Vec2D _caretGlobal = Vec2D();

  // 在flare中当前焦点所在的坐标
  Vec2D _caretWorld = Vec2D();

  // 存储"约束脸部节点"坐标
  Vec2D _eyeOrigin = Vec2D();
  Vec2D _eyeOriginLocal = Vec2D();

  //判断是否正在输入
  bool _hasFocus = false;

  String _password = "";


  MyController({this.projectGaze = 100});

  //这个参数用于缩放从输入焦点到约束节点之间的距离
  final double projectGaze;

  @override
  bool advance(FlutterActorArtboard artboard, double elapsed) {
    super.advance(artboard, elapsed);
    Vec2D targetTranslation;

    if(_hasFocus){
      // 获取到flare中当前焦点所在的坐标
      Vec2D.transformMat2D(_caretWorld, _caretGlobal, _globalToFlareWorld);

      //这里是实现了动画的"呼吸"效果，是为了避免动画静止不动，让动画更加有趣
      _caretWorld[1] += sin(new DateTime.now().millisecondsSinceEpoch / 300.0) * 70.0;

      // 计算矢量方向
      Vec2D toCaret = Vec2D.subtract(Vec2D(), _caretWorld, _eyeOrigin);

      //获取比例，再进行缩放
      Vec2D.normalize(toCaret, toCaret);
      Vec2D.scale(toCaret, toCaret, projectGaze);

      //用于计算"约束节点"到输入焦点到距离
      Mat2D toFaceTransform = Mat2D();
      if (Mat2D.invert(toFaceTransform, _eyeControl.parent.worldTransform)) {
        // Put toCaret in local space, note we're using a direction vector
        // not a translation so transform without translation
        Vec2D.transformMat2(toCaret, toCaret, toFaceTransform);
        // Our final "ctrl_face" position is the original face translation plus this direction vector
        targetTranslation = Vec2D.add(Vec2D(), toCaret, _eyeOriginLocal);
      }
    } else {
      targetTranslation = Vec2D.clone(_eyeOriginLocal);
    }


    // We could just set _faceControl.translation to targetTranslation, but we want to animate it smoothly to this target
    // so we interpolate towards it by a factor of elapsed time in order to maintain speed regardless of frame rate.
    Vec2D diff =
    Vec2D.subtract(Vec2D(), targetTranslation, _eyeControl.translation);
    Vec2D frameTranslation = Vec2D.add(Vec2D(), _eyeControl.translation,
        Vec2D.scale(diff, diff, min(1.0, elapsed * 5.0)));


    _eyeControl.translation = frameTranslation;

    return true;
  }

  @override
  void initialize(FlutterActorArtboard artboard) {
    super.initialize(artboard);
    _eyeControl = artboard.getNode("ctrl_eyes");
    if (_eyeControl != null) {
      _eyeControl.getWorldTranslation(_eyeOrigin);
      Vec2D.copy(_eyeOriginLocal, _eyeControl.translation);
    }
    play("idle");
  }

  onCompleted(String name) {
    play("idle");
  }

  @override
  void setViewTransform(Mat2D viewTransform) {
    super.setViewTransform(viewTransform);
    Mat2D.invert(_globalToFlareWorld, viewTransform);
  }

  void lookAt(Offset caret) {
    _hasFocus = true;
    if(caret == null) return;
    _caretGlobal[0] = caret.dx;
    _caretGlobal[1] = caret.dy;
  }

  set hasFocus(bool value) {
    _hasFocus = value;
  }

  void setPassword(String password){
    _password = password;
  }

  void submitPassword() {
    debugPrint("password:${_password}");
    if (_password == "onepunch") {
      play("success");
    } else {
      play("fail");
      debugPrint("提交");

    }
  }

}