import 'dart:collection';
import 'dart:math';
import 'package:aprendiendo_dart/logica/ConvertirInfijaPos.dart';

class Calculadora {
  var _Tabla = [];
  var _expresion = "";
  var listaExpreCompararSimbolos = [
    RegExp(r'~'),
    RegExp(r'\^'),
    RegExp(r'v'),
    RegExp(r'→'),
    RegExp(r'↔'),
  ];

  set expresion(var valor) => _expresion = valor;

  get expresion => _expresion;

  calcular() {
    var valoresComparar = RegExp(r'[A-Z]');
    var pilaSimbolos = [];
    var pilaValores = [];
    var calcularPosfija = Convertir();
    calcularPosfija.expresion = expresion;
    calcularPosfija.convertirAlista();
    var expresionPosfija = calcularPosfija.posFIja();
    var operandos = contarSimbilos(expresionPosfija);
    var operandosOrganizados = SplayTreeMap<String, List>.from(
        operandos, ((key1, key2) => key1.compareTo(key2)));
    operandosOrganizados = construirTabla(operandosOrganizados);
    operandosOrganizados = operandosOrganizados;
    while (expresionPosfija.toString().isNotEmpty) {
      if (isOperador(expresionPosfija[0])) {
        if (listaExpreCompararSimbolos[0].hasMatch(expresionPosfija[0])) {
          var operandoActual = pilaValores.removeAt(pilaValores.length - 1);
          var expresionAct = "(" + expresionPosfija[0] + operandoActual + ")";
          if (!operandosOrganizados.keys.contains(expresionAct)) {
            operandosOrganizados[expresionAct] =
                operacionNegacion(operandosOrganizados[operandoActual]);
          }
          pilaValores.add(expresionAct);
          expresionPosfija =
              expresionPosfija.replaceFirst(listaExpreCompararSimbolos[0], "");
        } else {
          var operando2 = pilaValores.removeAt(pilaValores.length - 1);
          var operando1 = pilaValores.removeAt(pilaValores.length - 1);
          var expresionAct =
              "(" + operando1 + expresionPosfija[0] + operando2 + ")";
          if (!operandosOrganizados.keys.contains(expresionAct)) {
            if (listaExpreCompararSimbolos[1].hasMatch(expresionPosfija[0])) {
              operandosOrganizados[expresionAct] = operacionConjuncion(
                  operandosOrganizados[operando1],
                  operandosOrganizados[operando2]);
              expresionPosfija = expresionPosfija.replaceFirst(
                  listaExpreCompararSimbolos[1], "");
            } else if (listaExpreCompararSimbolos[2]
                .hasMatch(expresionPosfija[0])) {
              operandosOrganizados[expresionAct] = operacionDisyuncion(
                  operandosOrganizados[operando1],
                  operandosOrganizados[operando2]);
              expresionPosfija = expresionPosfija.replaceFirst(
                  listaExpreCompararSimbolos[2], "");
            } else if (listaExpreCompararSimbolos[3]
                .hasMatch(expresionPosfija[0])) {
              operandosOrganizados[expresionAct] = operacionCondicional(
                  operandosOrganizados[operando1],
                  operandosOrganizados[operando2]);
              expresionPosfija = expresionPosfija.replaceFirst(
                  listaExpreCompararSimbolos[3], "");
            } else if (listaExpreCompararSimbolos[4]
                .hasMatch(expresionPosfija[0])) {
              operandosOrganizados[expresionAct] = operacionBicondiconal(
                  operandosOrganizados[operando1],
                  operandosOrganizados[operando2]);
              expresionPosfija = expresionPosfija.replaceFirst(
                  listaExpreCompararSimbolos[4], "");
            }
          } else {
            expresionPosfija =
                expresionPosfija.replaceFirst(expresionPosfija[0], "");
          }

          pilaValores.add(expresionAct);
        }
      } else if (valoresComparar.hasMatch(expresionPosfija[0])) {
        pilaValores.add(expresionPosfija[0]);
        expresionPosfija = expresionPosfija.replaceFirst(valoresComparar, "");
      }
    }
    var resultadoTabla =
        operandosOrganizados[operandosOrganizados.keys.toList()[0]];
    var resultado = "";
    if (resultadoTabla != null &&
        resultadoTabla.contains(0) &&
        !resultadoTabla.contains(1)) {
      resultado = "Contradiccion";
    } else if (resultadoTabla != null &&
        !resultadoTabla.contains(0) &&
        resultadoTabla.contains(1)) {
      resultado = "Tautologia";
    } else {
      resultado = "Contigencia";
    }
    return [operandosOrganizados,resultado];
  }

  isOperador(expresion) {
    for (var i in listaExpreCompararSimbolos) {
      if (i.hasMatch(expresion)) {
        return true;
      }
    }
    return false;
  }

  construirTabla(var diccionario) {
    for (int m = 1; m <= diccionario.length; m++) {
      diccionario[diccionario.keys.toList()[m - 1]] = generarValores(
          pow(2, diccionario.length),
          (pow(2, diccionario.length) / pow(2, m).toInt()));
    }
    return diccionario;
  }

  generarValores(var cota, var multiplo) {
    var lista = [];
    while (lista.length < cota) {
      lista += concatenar(0, multiplo) + concatenar(1, multiplo);
    }
    return lista;
  }

  concatenar(var valor, var cantidad) {
    var lista = [];
    for (int i = 0; i < cantidad; i++) {
      lista.add(valor);
    }
    return lista;
  }

  contarSimbilos(var valor) {
    var simbolos = valor;
    for (var i in listaExpreCompararSimbolos) {
      if (i.hasMatch(simbolos)) {
        simbolos = simbolos.replaceAll(i, "#");
      }
    }
    var valores = {};
    for (int i = 0; i < simbolos.length; i++) {
      if (simbolos[i] != "#") {
        if (!valores.containsKey(simbolos[i])) {
          valores[simbolos[i]] = [];
        }
      }
    }
    return valores;
  }

  operacionNegacion(var valor) {
    var lista = [];
    for (int i = 0; i < valor.length; i++) {
      if (valor[i] == 1) {
        lista.add(0);
      } else {
        lista.add(1);
      }
    }
    return lista;
  }

  operacionConjuncion(var valor1, valor2) {
    var lista = [];
    for (int i = 0; i < valor1.length; i++) {
      if (valor1[i] == 1 && valor2[i] == 1) {
        lista.add(1);
      } else {
        lista.add(0);
      }
    }
    return lista;
  }

  operacionDisyuncion(var valor1, valor2) {
    var lista = [];
    for (int i = 0; i < valor1.length; i++) {
      if (valor1[i] == 1 || valor2[i] == 1) {
        lista.add(1);
      } else {
        lista.add(0);
      }
    }
    return lista;
  }

  operacionCondicional(var valor1, valor2) {
    var lista = [];
    for (int i = 0; i < valor1.length; i++) {
      if (valor1[i] == 1 && valor2[i] == 0) {
        lista.add(0);
      } else {
        lista.add(1);
      }
    }
    return lista;
  }

  operacionBicondiconal(var valor1, valor2) {
    var lista = [];
    for (int i = 0; i < valor1.length; i++) {
      if ((valor1[i] == valor2[i])) {
        lista.add(1);
      } else {
        lista.add(0);
      }
    }
    return lista;
  }
}
