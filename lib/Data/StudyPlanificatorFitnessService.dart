import 'dart:math';
import 'package:genetically_evolving_neural_network/genetically_evolving_neural_network.dart';

class StudyPlanFitnessService extends GENNFitnessService {
  List<double> inputsForNN;
  int numberOfBits;
  int numberOfCombinations;
  List<int> idealPriorityDistribution;
  List<int> idealUrgencyDistribution;
  List<int> prohibitedCodes;

 

  StudyPlanFitnessService(
    this.inputsForNN,
    this.numberOfBits,
    this.numberOfCombinations,
    this.idealPriorityDistribution,
    this.idealUrgencyDistribution, 
    this.prohibitedCodes
  ); 

  @override
  Future<double> gennScoringFunction({
    required GENNNeuralNetwork neuralNetwork,
  }) async {
    double score = 100.0; // Comienza con la puntuación máxima posible
    const int penaltyPerProhibitedCode = 50; // Penalización por cada código prohibido
    const int bonusForNoProhibitedCodes = 100; // Bonificación por no tener códigos prohibidos
    const int rewardForExactMatch = 30; // Recompensa por coincidencia exacta con la distribución deseada
    const int penaltyPerExcessUnit = 30; // Penalización lineal por cada unidad de exceso

    // Generar un plan de estudios usando la red neuronal.
    List<double> rawPlan = neuralNetwork.guess(inputs: inputsForNN);
    List<double> plan = rawPlan.map((x) => x > 0.5 ? 1.0 : 0.0).toList();
  

    // Interpretar la salida como asignaturas y contar la frecuencia de cada código.
    List<int> subjectCounts = List.filled(numberOfCombinations,0);
    int countProhibitedCodes = 0;  // Contador de códigos prohibidos
   
    
    for (int i = 0; i < plan.length; i += numberOfBits) {
        List<double> bits = plan.sublist(i, i + numberOfBits);
        int subjectCode = convertCode(bits);
        if (prohibitedCodes.contains(subjectCode)) {
            countProhibitedCodes++;  // Incrementa por cada código prohibido encontrado
        }
        subjectCounts[subjectCode]++;
    }

    // Aplicar penalización por códigos prohibidos
    if (countProhibitedCodes > 0) {
        score -= penaltyPerProhibitedCode * countProhibitedCodes; // Penalización que escala con el número de códigos prohibidos
    } else {
        score += bonusForNoProhibitedCodes; // Bonificación sustancial por no tener códigos prohibidos
    }

    print('perro');
    // Calcular puntuación basada en la frecuencia deseada de cada asignatura.
        double penalty = 0;
    for (int i = 0; i < idealPriorityDistribution.length; i++) {
      int expected = idealPriorityDistribution[i];
      int actual = subjectCounts[i];
      int difference = actual - expected;

      if (difference == 0) {
          // Recompensa por coincidencia exacta
          score += rewardForExactMatch;
      } else if (difference > 0) {
          // Penalización lineal si la asignatura excede el porcentaje deseado
          penalty += penaltyPerExcessUnit * difference; // Penalización lineal por cada unidad de exceso
      } else {
          // Penalización estándar para déficits
          penalty += pow(difference.abs(), 2);
      }
    }

    // Reducción de la puntuación basada en el penalty calculado
    score -= sqrt(penalty); // Raíz cuadrada para suavizar la penalización
    return max(score, 0); // Asegurar que la puntuación no sea negativa
  }
}

int convertCode(List<double> bits) {
  int code = 0;

  for (int i = 0; i < bits.length; i++) {
    code += (bits[i].round() * pow(2, bits.length - 1 - i)).toInt();
  }
  return code;
}

