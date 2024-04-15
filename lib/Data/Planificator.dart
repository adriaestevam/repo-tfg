import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:genetically_evolving_neural_network/genetically_evolving_neural_network.dart';
import 'package:tfg_v1/Data/Models/Evaluation.dart';
import 'package:tfg_v1/Data/Models/Event.dart';
import 'package:tfg_v1/Data/Models/Plan.dart';
import 'package:tfg_v1/Data/Models/StudyBloc.dart';
import 'package:tfg_v1/Data/Models/User-Subject-Event.dart';

import 'package:tfg_v1/Data/Models/User-Subject.dart';
import 'package:tfg_v1/Data/StudyPlanificatorFitnessService.dart';
import '../../Data/Models/Subject.dart';

import '../../Data/Models/Session.dart';
class Planificator {
  // Define your method signatures and implementations here.

  // This method generates the plan.
  Future<Map<String, dynamic>> generatePlan(
    List<StudyBlock> studyBlocks,
    List<Subject> subjects,
    List<UserSubject> userSubjects,
    List<Event> events,
    List<Evaluation> evaluations,
    List<UserSubjectEvent> userSubjectEvents, 
    Map<String, double> idealPriorityDistribution, 
    Map<String, double> idealUrgencyDistribution) async {

      studyBlocks;


    Plan plan = Plan(userId: 0, sessionId: 0); //Plan
    Map<String,dynamic> mapOfLists = {}; //combination of both list

    //variables for evolutive nn
    int numberOutput = 0;
    List<double> inputsForNN = []; 


    //Calculate number of output elements
    int numberOfSessions = calculateAvailableTime(studyBlocks);

    int numberOfBits = calculateNumberOfBitsFromSubjects(subjects.length);
  
    if(numberOfBits*numberOfSessions > 0){
      numberOutput = numberOfSessions*numberOfBits;
    } else {
      throw ArgumentError("Error when calculating number of outputs.");
    }


    //generate inputs
    inputsForNN = generateInputs(idealPriorityDistribution,subjects);

    //Initialization of de evolutive nn
    int numberOfCombinations = pow(2, numberOfBits).toInt();
    List<int> prohibitedCodes = calculateProhibitedCodes(numberOfCombinations,subjects.length);
 

    List<int> idealPriorityDistributionForNN = prepareDistributionForNN(numberOfSessions,idealPriorityDistribution);
 
    List<int> idealUrgencyDistributionForNN = prepareDistributionForNN(numberOfSessions,idealPriorityDistribution);


    final GENNFitnessService fitnessService = StudyPlanFitnessService(
      inputsForNN,
      numberOfBits,
      numberOfCombinations,
      idealPriorityDistributionForNN,
      idealUrgencyDistributionForNN,
      prohibitedCodes
    );


    

    GENNGeneration? generation;
    late final GENN genn;

    final config = GENNGeneticEvolutionConfig(
      populationSize: 20,
      numOutputs: numberOutput, 
      mutationRate: 0.1,
      numInitialInputs: inputsForNN.length,
      layerMutationRate: 0.25,
      perceptronMutationRate: 0.4,
    );
    genn = GENN.create(
      config: config,
      fitnessService: fitnessService,
    );

    double minimumScore = 240.0;
    //Evolute de solution provided by the nnn
    var result = await runEvolution(genn, minimumScore,inputsForNN, subjects,numberOfBits);
    if (result != null) {
      GENNEntity topScoringEntity = result['topScoringEntity'];
      GENNGeneration winningGeneration = result['generation'];

      List<double> winningPlan = getPlan(topScoringEntity,winningGeneration,inputsForNN);
  
      List<String> winningPlanWithNames = decodePlan(winningPlan,subjects,numberOfBits);

      var results = await createEventsAndSessions(
        winningPlanWithNames, // Decoded plan from your evolution algorithm
        studyBlocks,          // List of available study blocks
        DateTime.now().add(Duration(days: 7)) // Assuming the start date is next Monday
      );


      List<Event> listEvents = results['events'] as List<Event>;
      List<Session> listSessions = results['sessions'] as List<Session>;

      

      // Agregar las listas al mapa
      mapOfLists['events'] = listEvents;
      mapOfLists['sessions'] = listSessions;

      // Retornar el mapa
      return mapOfLists;
    } else {
      print('No se pudo completar la evolución satisfactoriamente.');
    }

    return throw FormatException('Error when generating plan');
    
  }
}

Future<Map<String, List<dynamic>>> createEventsAndSessions(
  List<String> plan, 
  List<StudyBlock> studyBlocks, 
  DateTime startDate) async {
  
  List<Event> events = [];
  List<Session> sessions = [];

  Map<String, List<StudyBlock>> weeklyBlocks = groupBlocksByWeekday(studyBlocks);
  int eventId = 1;
  int sessionId = 1;

  DateTime currentDate = startDate;
  int planIndex = 0;

  // Itera a través de los días de la semana desde la fecha de inicio
  while (planIndex < plan.length) {
    String currentDay = dayOfWeekToString(currentDate.weekday);

    if (!weeklyBlocks.containsKey(currentDay)) {
      currentDate = currentDate.add(Duration(days: 1));
      continue;
    }

    List<StudyBlock> blocksForDay = weeklyBlocks[currentDay]!;
    for (var block in blocksForDay) {
      DateTime blockStart = DateTime(currentDate.year, currentDate.month, currentDate.day, block.startTime.hour, block.startTime.minute);
      DateTime blockEnd = DateTime(currentDate.year, currentDate.month, currentDate.day, block.endTime.hour, block.endTime.minute);

      while (blockStart.add(Duration(hours: 1)).isBefore(blockEnd) || blockStart.add(Duration(hours: 1)).isAtSameMomentAs(blockEnd)) {
        if (planIndex >= plan.length) {
          break; // Si no quedan más sesiones en el plan, detiene la creación de sesiones
        }

        DateTime sessionEnd = blockStart.add(Duration(minutes: 59));
        String subjectName = plan[planIndex];
        
        events.add(Event(id: eventId, name: 'Auto Session of Subject $subjectName', isDone: false));
        sessions.add(Session(id: sessionId, startTime: blockStart, endTime: sessionEnd));

        eventId++;
        sessionId++;
        planIndex++;
        blockStart = sessionEnd.add(Duration(minutes: 1)); // Un minuto de pausa entre sesiones
      }
      if (planIndex >= plan.length) {
        break; // Si no quedan más sesiones en el plan, detiene la iteración sobre los bloques
      }
    }
    currentDate = currentDate.add(Duration(days: 1)); // Avanza al siguiente día
  }

  return {
    'events': events,
    'sessions': sessions
  };
}

int timeOfDayToMinutes(TimeOfDay time) {
  return time.hour * 60 + time.minute;
}


Map<String, List<StudyBlock>> groupBlocksByWeekday(List<StudyBlock> blocks) {
  Map<String, List<StudyBlock>> weeklyBlocks = {};
  for (var block in blocks) {
    String weekday = block.day;
    if (weeklyBlocks.containsKey(weekday)) {
      weeklyBlocks[weekday]!.add(block);
    } else {
      weeklyBlocks[weekday] = [block];
    }
  }
  for (var dayBlocks in weeklyBlocks.values) {
    // Here we sort using the helper function to convert TimeOfDay to minutes
    dayBlocks.sort((a, b) => timeOfDayToMinutes(a.startTime).compareTo(timeOfDayToMinutes(b.startTime)));
  }
  return weeklyBlocks;
}

String dayOfWeekToString(int day) {
  switch (day) {
    case 1:
      return "Monday";
    case 2:
      return "Tuesday";
    case 3:
      return "Wednesday";
    case 4:
      return "Thursday";
    case 5:
      return "Friday";
    case 6:
      return "Saturday";
    case 7:
      return "Sunday";
    default:
      return "Unknown";
  }
}



Future<Map<String, dynamic>?> runEvolution(GENN genn, double minimumScore, List<double> inputs, List<Subject> subjects, int numberOfBits) async {
  GENNEntity? topScoringEntity;
  GENNGeneration? topGeneration;

  while (true) { // Utiliza un bucle infinito que solo se rompe internamente
    GENNGeneration? generation = await genn.nextGeneration();
    if (generation == null) {
      print("No more generations available or an error occurred.");
      break; // Si no hay más generaciones o hay un error, terminamos el bucle
    }

    // Siempre actualizamos con la última entidad de puntuación más alta
    topScoringEntity = generation.population.topScoringEntity;
    topGeneration = generation;

    // Verifica el criterio para ver si necesitamos detener la evolución
    if (generationCriteria(generation, minimumScore, inputs, subjects, numberOfBits)) {
      return {
        'topScoringEntity': topScoringEntity,
        'generation': topGeneration
      };
    }
  }

  print('Evolution process completed.');
  return null; // Si salimos del bucle sin un return, devuelve null para indicar que no se encontró una solución válida
}



bool generationCriteria(GENNGeneration generation, double minimumScore, List<double> inputs, List<Subject> subjects, int numberOfBits) {
  List<double> plan = getPlan(generation.population.topScoringEntity, generation, inputs);
  List<String> decodedPlan = decodePlan(plan, subjects, numberOfBits);
  print('decoded plan se ve asi $decodedPlan');
  return !decodedPlan.contains('x');
}




List<String> decodePlan(List<double> plan,List<Subject> subjects, int numberOfBits) {
  List<String> decodedPlan = [];
  for (int i = 0; i < plan.length; i += numberOfBits) {
    int subjectCode = convertCode(plan.sublist(i, i + numberOfBits));
    if(subjectCode >= subjects.length){
      decodedPlan.add('x');
    } else {
      decodedPlan.add(subjects[subjectCode].name);
    }
    
  }
  return decodedPlan;
}


List<double> getPlan(GENNEntity topScoringEntity,GENNGeneration generation, inputs) {
    if (generation == null) {
      print('No generation data available.');
    }

    final topScoringEntity = generation!.population.topScoringEntity;
  

    // Suponiendo que GENNDNA ya tiene una lista de GENNGene
    GENNDNA dna = topScoringEntity.dna;

    // Construir la red neuronal desde los genes
    GENNNeuralNetwork neuralNetwork = GENNNeuralNetwork.fromGenes(
      genes: dna.genes,  // Reemplaza esto con tu implementación real de GuessService
    );

    return neuralNetwork.guess(inputs: inputs);
  }

List<int> prepareDistributionForNN(int numberOfSessions, Map<String, double> idealPriorityDistribution) {
  List<int> distribution = [];
  idealPriorityDistribution.forEach((subject, percentage) {
    // Calculate the number of sessions for each subject based on its percentage
    int sessionsForSubject = (numberOfSessions * percentage).round();
    distribution.add(sessionsForSubject);
  });
  return distribution;
}


List<int> calculateProhibitedCodes(int numberOfCombinations, int length) {
  if (numberOfCombinations <= length) {
    throw Exception("numberOfCombinations must be greater than length");
  }

  // Create a list of integers starting from 'length' up to 'numberOfCombinations - 1'
  List<int> prohibitedCodes = [];
  for (int i = length; i < numberOfCombinations; i++) {
    prohibitedCodes.add(i);
  }

  return prohibitedCodes;
}


List<double> generateInputs(Map<String, double> idealPriorityDistribution, List<Subject> subjects) {
  List<double> inputs = [];
  int totalSlots = 10;  // Total slots representing 100% distribution

  // Calculate the total priority to normalize it to 10 slots
  double totalPriority = idealPriorityDistribution.values.fold(0, (sum, element) => sum + element);

  for (var subject in subjects) {
      // Calculate the number of slots for each subject based on its priority
      double priorityPercentage = idealPriorityDistribution[subject.name] ?? 0.0;
      double normalizedSlots = (priorityPercentage / totalPriority) * totalSlots;

      // Round to the nearest slot count and add to inputs
      int slotsForSubject = (normalizedSlots + 0.5).floor();  // Using floor() after adding 0.5 to simulate rounding
      inputs.add(slotsForSubject.toDouble());
  }

  // Normalize the inputs to ensure they sum up to exactly 10
  int currentSum = inputs.fold(0, (sum, element) => sum + element.toInt());
  if (currentSum != totalSlots) {
      // Adjust the last element to make the sum exactly 10
      int lastValue = inputs.last.toInt();
      inputs[inputs.length - 1] = (lastValue + (totalSlots - currentSum)).toDouble();
  }

  return inputs;
}


// Calculate the duration in hours between startTime and endTime
double getDurationInHours(TimeOfDay startTime, TimeOfDay endTime) {
    int startMinutes = startTime.hour * 60 + startTime.minute;
    int endMinutes = endTime.hour * 60 + endTime.minute;
    if (endMinutes < startMinutes) {
      // Adjust for cases where the end time is on the next day
      endMinutes += 24 * 60;
    }
    int durationMinutes = endMinutes - startMinutes;
    // Ensure only full hours are counted
    return (durationMinutes / 60.0).floor().toDouble();
}

int calculateAvailableTime(List<StudyBlock> studyBlocks) {
    double totalHours = 0.0;
    for (StudyBlock block in studyBlocks) {
        totalHours += getDurationInHours(block.startTime,block.endTime);
    }
    // Using floor to make sure we only count full hours available
    return totalHours.floor();
}


int calculateNumberOfBitsFromSubjects(int numberOfSubjects) {
  if (numberOfSubjects < 1) {
    throw ArgumentError("Number of subjects must be at least 1.");
  }
  return (log(numberOfSubjects) / log(2)).ceil();
}
