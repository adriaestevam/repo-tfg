import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:tfg_v1/Data/Models/StudyBloc.dart';
import 'package:tfg_v1/Data/Models/User-Subject.dart';
import 'package:tfg_v1/Data/Models/Users.dart';
import 'package:tfg_v1/Data/Models/subject.dart';
import 'package:tfg_v1/Data/Models/university.dart';
import 'package:tfg_v1/Domain/SignUpBloc/sing_up_event.dart';
import 'package:tfg_v1/Domain/SignUpBloc/sing_up_state.dart';
import '../../Data/AuthRepository.dart'; 


class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  String email = '';
  String password = ''; 

  SignUpBloc({required AuthRepository authRepository}) : super(SignUpInitial()) {
    

    on<SignUpButtonPressed>((event, emit) async {   
      try {
        emit(SignUpLoading());
        
        if (!checkIfPasswordIsSecure(event.password)) { 
          emit(SignUpFailure(
            error: "Password must contain at least one uppercase letter, one lowercase letter, one digit, and one special character"
          ));
          return; // Return early if the password is not secure
        }
        var emailExists= await authRepository.lookForEmail(event.email);

        if(emailExists){
          emit(SignUpFailure(error: "Email already registered. Login or use another email"));
          return;
        }

        email = event.email;
        password = event.password;

        emit(SignUpSuccess());
        await Future.delayed(Duration(seconds: 1));


      } catch (error) {
        // If an exception occurs during the sign-up process, emit a failure state
        emit(SignUpFailure(error: error.toString()));
      }
    });  

    on<EndOfInitialConfiguration>((event, emit) async {   
      print("end of initial config");
      int universityId;
      int userId;
      int priority = 0;
      int subjectId;

      try {
        // Check if university is registered in the database. If true, get ID; else, register
        if (await authRepository.checkIfUniversityRegistered(event.university)) {
          universityId = await authRepository.getUniversityID(event.university);
        } else {
          universityId = Random().nextInt(1000);
          University university = University(id: universityId, name: event.university);
          await authRepository.registerUniversity(university);
        }

        // Register user
        userId = Random().nextInt(1000);
        User user = User(
          id: userId, 
          universityId: universityId, 
          name: event.user_name, 
          email: email, //email 
          password: password //password
        );

        await authRepository.registerUser(user);

        // Register user's study blocks
        Map<String, TimeOfDay> startTime = event.studyStartTimes;
        Map<String, TimeOfDay> endTime = event.studyEndTimes;

        startTime.forEach((day, startingTime) async { 
          await authRepository.registerStudyBlock(StudyBlock(
            id: Random().nextInt(1000), 
            userId: userId, 
            day: day, 
            startTime: startingTime, 
            endTime: endTime[day]!,
          ));
        });

        // Save subjects and relate them to user and university
        Map<Subject, bool> selectedSubjects = event.selectedSubjects;
        Map<Subject, String> objectives = event.objectives;

        selectedSubjects.forEach((subject, isSelected) async {
          if (isSelected) {
            subjectId = Random().nextInt(1000);

            await authRepository.registerSubject(Subject(
              id: subjectId,
              universityId: universityId,
              name: subject.name,
              credits: subject.credits,
              formula: subject.formula,
            ));

            String objective = objectives[subject]!;
            priority++;

            await authRepository.registerUserSubject(UserSubject(
              userId: userId, 
              subjectId: subjectId, 
              objective: objective, 
              priority: priority, 
              feedback: 3,
            ));
          }
        });

        emit(SignUpSuccess());

      } catch (error) {
        emit(SignUpFailure(error: error.toString()));
      }
    });

  }
}

bool checkIfPasswordIsSecure(String password) {
  // Check if the password length is at least 8 characters
  if (password.length < 8) {
    return false;
  }
    return true;
}
