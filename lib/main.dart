import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:genetically_evolving_neural_network/genetically_evolving_neural_network.dart';

List<double> get inputs {
  return [010, 010, 010, 010, 010]; // Distribuciones porcentuales de las asignaturas.
}


class StudyPlanFitnessService extends GENNFitnessService {
  @override
  Future<double> gennScoringFunction({
    required GENNNeuralNetwork neuralNetwork,
  }) async {
    double score = 0.0;

    // Generar un plan de estudios usando la red neuronal.
    List<double> rawPlan = neuralNetwork.guess(inputs: inputs);
    List<double> plan = rawPlan.map((x) => x > 0.5 ? 1.0 : 0.0).toList();
    print('Esto es un plan $plan'); 

    // Interpretar la salida como asignaturas.
    // Supongamos que la longitud de 'plan' es 24 y cada 3 bits representan una asignatura.
    List<int> subjectCounts = List.filled(8, 0); // Haremos un contados para cada asignatura y 3 exyra que son asignaturas innexistentes pero que pueden salir en el plan
   
    
    for (int i = 0; i < plan.length; i += 3) {
      // Obtener los 3 bits para esta asignatura.
      List<double> bits = plan.sublist(i, i + 3);
      int subjectCode = convertCode(bits);
      subjectCounts[subjectCode]++;
    }

    // Penaliza la puntuación si se encuentran los códigos de asignatura 5, 6 o 7
    for (int i = 5; i <= 7; i++) {
      if (subjectCounts[i] > 0) {
        score -= 200; // Penaliza por cada ocurrencia de los códigos no deseados
      }
    }

    // Comparar la frecuencia de cada asignatura con las distribuciones deseadas.
    // 'inputs' contiene las distribuciones deseadas.
    for (int i = 0; i < subjectCounts.length; i++) {
      if(i < 5){
        double expectedDistribution = inputs[i];
        double actualDistribution = (subjectCounts[i] / 8.0) * 100; // Convertir conteo a porcentaje.

        // Agregar puntos basados en qué tan cerca está la distribución real de la esperada.
        // Nota: Esta es una forma muy simplificada de puntuación.
        score += 100 - (expectedDistribution - actualDistribution).abs(); // Restar la diferencia absoluta.
      }
      
    }

    return score;
  }
}

int convertCode(List<double> bits) {
  // Convertir los bits a un número entero. 
  // Asumiendo que 'bits' tiene exactamente 3 elementos.
  int code = 0;
  for (int i = 0; i < bits.length; i++) {
    code += (bits[i].round() * pow(2, 2 - i)).toInt();
  }
  return code;
}



void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GENNFitnessService fitnessService = StudyPlanFitnessService();

  GENNGeneration? generation;

  late final GENN genn;

  @override
  void initState() {
    final config = GENNGeneticEvolutionConfig(
      populationSize: 20,
      numOutputs: 24,
      mutationRate: 0.1,
      numInitialInputs: 5,
      layerMutationRate: 0.25,
      perceptronMutationRate: 0.4,
    );

    genn = GENN.create(
      config: config,
      fitnessService: fitnessService,
    );

    genn.nextGeneration().then((value) {
      setState(() {
        generation = value;
      });
    });

    super.initState();
  }

  List<double> getPlan(GENNEntity topScoringEntity) {
    if (generation == null) {
      print('No generation data available.');
    }

    final topScoringEntity = generation!.population.topScoringEntity;
    print('Top scoring entity obtenido');

    // Suponiendo que GENNDNA ya tiene una lista de GENNGene
    GENNDNA dna = topScoringEntity.dna;

    // Construir la red neuronal desde los genes
    GENNNeuralNetwork neuralNetwork = GENNNeuralNetwork.fromGenes(
      genes: dna.genes,  // Reemplaza esto con tu implementación real de GuessService
    );

    return neuralNetwork.guess(inputs: inputs);
  }


  @override
  Widget build(BuildContext context) {
    final generation = this.generation;
    if (generation == null) {
      return const CircularProgressIndicator();
    }

    List<double> plan = getPlan(generation!.population.topScoringEntity); 
    List<String> decodedPlan = decodePlan(plan);

    return MaterialApp(
      title: 'GENN Study Plan',
      home: Scaffold(
        appBar: AppBar(title: const Text('Study Plan Visualization')),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Top Score: ${generation.population.topScoringEntity.fitnessScore.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: buildScheduleWidget(decodedPlan),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          label: const Text('Next Generation'),
          onPressed: () {
            genn.nextGeneration().then((value) {
              setState(() {
                this.generation = value;
                plan = getPlan(generation.population.topScoringEntity);
                decodedPlan = decodePlan(plan);
              });
            });
          },
        ),
      ),
    );
  }

  String decodeSubject(int code) {
    switch (code) {
      case 0:
        return 'a';
      case 1:
        return 'b';
      case 2:
        return 'c';
      case 3:
        return 'd';
      case 4:
        return 'e';
      default:
        return 'X';
    }
  }

  List<String> decodePlan(List<double> plan) {
    List<String> decodedPlan = [];
    for (int i = 0; i < plan.length; i += 3) {
      int subjectCode = convertCode(plan.sublist(i, i + 3));
      decodedPlan.add(decodeSubject(subjectCode));
    }
    return decodedPlan;
  }

  Widget buildScheduleWidget(List<String> decodedPlan) {
    Map<String, Color> subjectColors = {
      'a': Colors.blue,
      'b': Colors.green,
      'c': Colors.red,
      'd': Colors.purple,
      'e': Colors.orange,
      'X': Colors.grey,
    };

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,  // Una sola columna
        childAspectRatio: 6, // Hace los bloques más alargados
      ),
      itemCount: decodedPlan.length,
      itemBuilder: (context, index) {
        String subject = decodedPlan[index];
        return Container(
          color: subjectColors[subject],
          alignment: Alignment.center,
          child: Text(
            subject.toUpperCase(),
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        );
      },
    );
  }




}