import 'package:aprendiendo_dart/aprendiendo_dart.dart' as aprendiendo_dart;

void main() {
  //print('Hello world: ${aprendiendo_dart.calculate()}!');
  RegExp regExp = RegExp(r'[->]');
  String sampleString = " -> Dart programming language tutorials  ";
  print(regExp.hasMatch(sampleString));
  sampleString.replaceAll(" ", "");
  var firstMatch = regExp.allMatches(sampleString);
  
  if (firstMatch != null) {
    print(firstMatch.toString());
    /*print(
        "First match substring: ${sampleString.substring(firstMatch.start, firstMatch.end)}");
  */
  }
   else {
    print("No matched.");
  }
  //aprendiendo_dart.funcionDePrueba();
}
