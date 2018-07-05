import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class DrawerBloc {

  final _school = BehaviorSubject<String>();
  final _course = BehaviorSubject<String>();

  Function(String) get setSchool => _school.sink.add;
  Function(String) get setCourse => _course.sink.add;

  String get school => _school.value;
  String get course => _course.value;


  dispose(){
    _school.close();
    _course.close();
  }
}