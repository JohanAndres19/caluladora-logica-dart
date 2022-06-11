import "package:aprendiendo_dart/logica/ConvertirInfijaPos.dart" as convertir;

int calculate() {
  return 6 * 7;
}

void funcionDePrueba() {
  /*var teas = ['green', 'black', 'chamomile', 'earl grey'];
  var loudTeas = teas.map((tea) => tea.toUpperCase());
  loudTeas.forEach(print);
  print(loudTeas.toList());
  var operEntonces = RegExp(r'[->]');
  var letras = RegExp(r'[A-Z]');
  String prueba = "A -> ( B ^ D -> W )";
  var listaoperadores = prueba.split(" ");
  var pos = [];
  */
  String prueba = "~ ( A v Q ) ^ B -> ( D <-> A)";
  var conver = convertir.Convertir();
  print(prueba);
  conver.expresion = prueba;
  conver.convertirAlista();
  print(conver.listaExpresion);
  print(conver.posFIja());
}
