import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

@immutable
abstract class AddNewSubjectEvent{}

class AddNewSubjectButtonPressed extends AddNewSubjectEvent {}
  