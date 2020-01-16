import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MaterialApp(
    title: 'CPF Validator',
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _digits = "";
  static String alert = "";

  Text _message = Text(alert);

  TextEditingController _cpfController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _valida() {
    String cpf = _cpfController.text;
    var newCpf = cpf.split('');

    var numberDigits = newCpf.map((item) => int.parse(item));

    print(numberDigits);
    int sumA = 0;
    int counter = 0;

    print(numberDigits);

    for (int i = 10; i > 1; i--) {
      sumA += numberDigits.elementAt(counter) * i;
      counter++;
    }

    int rest = sumA % 11;
    int firstDigit = rest < 2 ? 0 : 11 - rest;

    int sumB = 0;
    counter = 0;

    for (int i = 11; i > 1; i--) {
      sumB += numberDigits.elementAt(counter) * i;
      counter++;
    }

    rest = sumB % 11;
    int secondaryDigit = rest < 2 ? 0 : 11 - rest;

    print("Digitos corretos: ${firstDigit} - ${secondaryDigit}");

    print("Primeiro digito do campo: " + newCpf[9]);
    print("Segundo digito do campo: " + newCpf[10]);

    String firstCompare = firstDigit.toString();
    String secondaryCompare = secondaryDigit.toString();

    setState(() {
      if (firstCompare == newCpf[9] && secondaryCompare == newCpf[10]) {
        alert = "CPF VÁLIDO";
        _message = Text(alert,
            style: TextStyle(
                color: Colors.teal,
                fontWeight: FontWeight.bold,
                fontSize: 20.0));
      } else {
        alert = "CPF INVÁLIDO";
        _message = Text(alert,
            style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 20.0));
      }
    });
  }

  void _format(String text) {
    if (_cpfController.text.length == 11) {
      String digitos = _cpfController.text;
      List<String> newDigitos = digitos.split('');

      String digitosMask = newDigitos[0] +
          newDigitos[1] +
          newDigitos[2] +
          "." +
          newDigitos[3] +
          newDigitos[4] +
          newDigitos[5] +
          "." +
          newDigitos[6] +
          newDigitos[7] +
          newDigitos[8] +
          "-" +
          newDigitos[9] +
          newDigitos[10];

//      _cpfController.text = digitosMask;

      print("Digitos do cpf com máscara: " + digitosMask);

      setState(() {
        _digits = digitosMask;
      });
    }
  }

  void _resetFields(){
    setState(() {
      _digits = "";
      alert = "";
      _cpfController.text = "";

      _message = Text(alert);
      _formKey = GlobalKey<FormState>();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "CPF VALIDATOR",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        actions: <Widget>[
          IconButton(
              icon: Icon(
            Icons.refresh,
            color: Colors.white,
          ),
          onPressed: _resetFields,),
        ],
      ),
      body: SingleChildScrollView(
          child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(15.0, 30.0, 15.0, 10.0),
              child: Center(
                child: Text(
                  _digits,
                  style: TextStyle(
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 0.0),
              child: Center(
                child: _message,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0.0),
              child: TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: "INFORME O CPF:",
                    labelStyle: TextStyle(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                    border: OutlineInputBorder(),
//                    helperText: "Digite apenas números",
                    helperStyle: TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.bold),
                    errorStyle: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold)),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0),
                textAlign: TextAlign.left,
                controller: _cpfController,
                validator: (value) {
                  if (value.isEmpty) {
                    return "Insira o CPF";
                  } else if (value.length < 11) {
                    return "Insira todos os dígitos do CPF";
                  }
                },
//                onChanged: _format,
                maxLength: 11,
                inputFormatters: <TextInputFormatter>[
                  WhitelistingTextInputFormatter.digitsOnly,
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(15.0),
              child: RaisedButton(
                child: Text(
                  "VERIFICAR",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0),
                ),
                color: Colors.teal,
                padding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 15.0),
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    _valida();
                    _format("");
                  }
                },
              ),
            ),
          ],
        ),
      )),
      backgroundColor: Colors.white,
    );
  }
}
