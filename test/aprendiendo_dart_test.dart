import 'package:aprendiendo_dart/aprendiendo_dart.dart';
import 'package:aprendiendo_dart/logica/ConvertirInfijaPos.dart';
import 'package:test/test.dart';

void main() {
  test('Posfija_prueba  parentesis', () {
    var calcular = Convertir();
    calcular.expresion = "~ ( A v Q ) ^ B -> D <-> A";
    calcular.convertirAlista();
    expect(calcular.posFIja(), "AQv~B^D->A<->");
  });

  test('Posfija_prueba doble parentesis', () {
    var calcular = Convertir();
    calcular.expresion = "~ ( A v Q ) ^ B -> ( D <-> A )";
    calcular.convertirAlista();
    expect(calcular.posFIja(), "AQv~B^DA<->->");
  });
}
