class Convertir {
  var pila = Pila();
  String _expresion = "";
  List<String> listaSalida = [];
  List<String> listaExpresion = [];
  final listaExpreRegulares = [
    RegExp(r'~'),
    RegExp(r'\^'),
    RegExp(r'v'),
    RegExp(r'→'),
    RegExp(r'↔')
  ];

  set expresion(var valor) => _expresion = valor;

  get expresion => _expresion;

  void convertirAlista() {
    expresion = expresion.toString().replaceAll(" ", "");
    var listaExpreComparar = [
      RegExp(r'~'),
      RegExp(r'\^'),
      RegExp(r'v'),
      RegExp(r'\→'),
      RegExp(r'\↔'),
      RegExp(r'[A-Z]'),
      RegExp(r'\('),
      RegExp(r'\)')
    ];
    while (expresion.toString().isNotEmpty) {
      for (var i in listaExpreComparar) {
        var firstmatch = i.firstMatch(expresion.toString());
        if (firstmatch != null && firstmatch.start == 0) {
          listaExpresion.add(
              expresion.toString().substring(firstmatch.start, firstmatch.end));
          expresion = expresion
              .toString()
              .replaceFirst(firstmatch.group(0).toString(),'');
        }
      }
    }
  }

  String posFIja() {
    String expresionPos = "";
    int posIncial = 0;
    while (listaExpresion.isNotEmpty) {
      if (listaExpresion[posIncial].contains(RegExp(r'[A-Z]'))) {
        listaSalida.add(listaExpresion[posIncial]);
        listaExpresion.removeAt(posIncial);
      } else if (listaExpresion[posIncial] == "(") {
        pila.push(listaExpresion[posIncial]);
        listaExpresion.removeAt(posIncial);
      } else if (listaExpresion[posIncial] == ")") {
        while (!pila.empty() && pila.peek() != "(") {
          listaSalida.add(pila.pop());
        }
        if (pila.peek() == "(") {
          pila.pop();
        }
        listaExpresion.removeAt(posIncial);
      } else if (listaExpresion[posIncial] != "(" &&
          listaExpresion[posIncial] != ")") {
        while (pila.empty() == false &&
            comparar(pila.peek(), listaExpresion[posIncial])) {
          listaSalida.add(pila.pop());
        }
        pila.push(listaExpresion[posIncial]);
        listaExpresion.removeAt(posIncial);
      }
    }
    while (!pila.empty()) {
      listaSalida.add(pila.pop());
    }
    for (int i = 0; i < listaSalida.length; i++) {
      expresionPos += listaSalida[i];
    }
    return expresionPos;
  }

  comparar(var valor1, var valor2) =>
      (prioridad(valor1) >= prioridad(valor2)) ? true : false;

  prioridad(String valor) {
    if (valor.contains("(")) {
      return 0;
    } else if (listaExpreRegulares[0].hasMatch(valor)) {
      return 5;
    } else if (listaExpreRegulares[1].hasMatch(valor)) {
      return 4;
    } else if (listaExpreRegulares[2].hasMatch(valor)) {
      return 3;
    } else if (listaExpreRegulares[3].hasMatch(valor)) {
      return 2;
    } else if (listaExpreRegulares[4].hasMatch(valor)) {
      return 1;
    }
  }
}

class Pila {
  var listapila = [];

  void push(var valor) {
    listapila.add(valor);
  }

  bool empty() => listapila.isEmpty;

  pop() {
    var valor = listapila[listapila.length - 1];
    listapila.removeAt(listapila.length - 1);
    return valor;
  }

  peek() => (listapila.isNotEmpty) ? listapila[listapila.length - 1] : 0;
}
