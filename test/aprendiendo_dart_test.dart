import 'package:aprendiendo_dart/logica/ConvertirInfijaPos.dart';
import 'package:aprendiendo_dart/logica/calculadora.dart';
import 'package:test/test.dart';

void main() {
  test('Covertir cadena logica a lista ', () {
    var calcular = Convertir();
    calcular.expresion = "~ ( A v Q )^B → D ↔ A";
    calcular.convertirAlista();
    var prueba = ['~', '(', 'A', 'v', 'Q', ')', '^', 'B', '→', 'D', '↔', 'A'];
    expect(calcular.listaExpresion, prueba);
  });
  test('Posfija_prueba  parentesis', () {
    var calcular = Convertir();
    calcular.expresion = "( A v Q) → (A v Q)";
    calcular.convertirAlista();
    expect(calcular.posFIja(), "AQvAQv→");
  });

  test('Posfija_prueba doble parentesis', () {
    var calcular = Convertir();
    calcular.expresion = "~( A v Q ) ^ B →(D ↔ A)";
    calcular.convertirAlista();
    expect(calcular.posFIja(), "AQv~B^DA↔→");
  });

  test('Prueba conteo de simbolos', () {
    var calculadora = Calculadora();
    var prueba = calculadora.contarSimbilos("AQv~B^DA↔→");
    expect(prueba, {'A': [], 'Q': [], 'B': [], 'D': []});
  });
  test('Prueba construir Tabla 4 operandos', () {
    var calculadora = Calculadora();
    expect(calculadora.construirTabla({'A': [], 'B': [], 'D': [], 'Q': []}), {
      'A': [0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1],
      'B': [0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1],
      'D': [0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1],
      'Q': [0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1]
    });
  });
  test('Prueba construir Tabla 3 operandos', () {
    var calculadora = Calculadora();
    expect(calculadora.construirTabla({'A': [], 'B': [], 'D': []}), {
      'A': [0, 0, 0, 0, 1, 1, 1, 1],
      'B': [0, 0, 1, 1, 0, 0, 1, 1],
      'D': [0, 1, 0, 1, 0, 1, 0, 1]
    });
  });

  test('Prueba construir Tabla 2 operandos', () {
    var calculadora = Calculadora();
    expect(calculadora.construirTabla({'A': [], 'B': []}), {
      'A': [0, 0, 1, 1],
      'B': [0, 1, 0, 1]
    });
  });

  test('Prueba calcular resultado 1', () {
    var calculadora = Calculadora();
    calculadora.expresion = "( A v Q) → (A v Q)";
    var resultado = calculadora.calcular();
    expect(resultado, {
      'A': [0, 0, 1, 1],
      'Q': [0, 1, 0, 1],
      "(AvQ)": [0, 1, 1, 1],
      "((AvQ)→(AvQ))": [1, 1, 1, 1]
    });
    print(resultado);
  });
  test('Prueba calcular resultado 2 con negacion', () {
    var calculadora = Calculadora();
    calculadora.expresion = "~( A v Q) → (A v Q)";
    var resultado = calculadora.calcular();
    expect(resultado, {
      'A': [0, 0, 1, 1],
      'Q': [0, 1, 0, 1],
      "(AvQ)": [0, 1, 1, 1],
      "(~(AvQ))": [1, 0, 0, 0],
      "((~(AvQ))→(AvQ))": [0, 1, 1, 1]
    });
    print(resultado);
  });
  test('Prueba calcular resultado 3 con negacion', () {
    var calculadora = Calculadora();
    calculadora.expresion = "~( A v Q) → ~A v Q)";
    var resultado = calculadora.calcular();
    expect(resultado, {
      'A': [0, 0, 1, 1],
      'Q': [0, 1, 0, 1],
      "(AvQ)": [0, 1, 1, 1],
      "(~(AvQ))": [1, 0, 0, 0],
      "(~A)": [1, 1, 0, 0],
      "((~A)vQ)": [1, 1, 0, 1],
      "((~(AvQ))→((~A)vQ))": [1, 1, 1, 1]
    });
    print(resultado);
  });
}
