import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeConver extends StatefulWidget {
  const HomeConver({Key? key}) : super(key: key);

  @override
  State<HomeConver> createState() => _HomeConverState();
}

class _HomeConverState extends State<HomeConver> {
  final realControl = TextEditingController();
  final dolarControl = TextEditingController();
  final euroControl = TextEditingController();
  final ieneControl =  TextEditingController();
  final yuanControl = TextEditingController();


  double dolar = 0;
  double euro = 0;
  double iene = 0;
  double yuan = 0;

  @override
  void dispose() {
    realControl.dispose();
    dolarControl.dispose();
    euroControl.dispose();
    ieneControl.dispose();
    yuanControl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Conversor de Moedas'),
        ),
        body: FutureBuilder<Map>(
          future: getData(),
          builder: (context, snapshot) {
            if (!snapshot.hasError) {
              if (snapshot.connectionState == ConnectionState.done) {
                dolar = double.parse(snapshot.data!['USDBRL']['bid']);
                euro = double.parse(snapshot.data!['EURBRL']['bid']);
                iene = double.parse(snapshot.data!['JPYBRL']['bid']);
                yuan = double.parse(snapshot.data!['CNYBRL']['bid']);
                // dolar = snapshot.data!['USD']['buy'];
                // euro = snapshot.data!['EUR']['buy'];
                return SingleChildScrollView(
                  padding: const EdgeInsets.only(top: 15, left: 10, right: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      const Icon(
                        Icons.monetization_on_outlined,
                        color: Colors.blue,
                        size: 120,
                      ),
                      const SizedBox(height: 20),
                      currencyTextField(
                          'Reais ', 'R\$ ', realControl, _convertReal),
                      const SizedBox(height: 20),
                      currencyTextField(
                          'Dolares', 'US\$ ', dolarControl, _convertDolar),
                      const SizedBox(height: 20),
                      currencyTextField(
                          'Euros', '€ ', euroControl, _convertEuro),
                      const SizedBox(height: 20),
                      currencyTextField(
                          'Ienes ', '¥ ', ieneControl, _convertIene),
                      const SizedBox(height: 20),
                      currencyTextField(
                          'Yuan ', ' ¥ ', yuanControl, _convertYuan),
                    ],
                  ),
                );
              } else {
                return waitingIndicator();
              }
            } else {
              return waitingIndicator();
            }
          },
        ));
  }

  TextField currencyTextField(String label, String prefixText,
      TextEditingController controller, Function f) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        prefixText: prefixText,
      ),
      onChanged: (value) => f(value),
      keyboardType: TextInputType.number,
    );
  }

  Center waitingIndicator() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  void _convertReal(String text) {
    if (text.trim().isEmpty) {
      _clearFields();
      return;
    }

    double real = double.parse(text);
    dolarControl.text = (real / dolar).toStringAsFixed(2);
    euroControl.text = (real / euro).toStringAsFixed(2);
    ieneControl.text = (real / iene).toStringAsFixed(2);
    yuanControl.text = (real / yuan).toStringAsFixed(2);
  }

  void _convertDolar(String text) {
    if (text.trim().isEmpty) {
      _clearFields();
      return;
    }

    double dolar = double.parse(text);
    realControl.text = (this.dolar * dolar).toStringAsFixed(2);
    euroControl.text = ((this.dolar * dolar) / euro).toStringAsFixed(2);
    ieneControl.text = ((this.dolar * dolar) / iene).toStringAsFixed(2);
    yuanControl.text = ((this.dolar * dolar) / iene).toStringAsFixed(2);
  }

  void _convertEuro(String text) {
    if (text.trim().isEmpty) {
      _clearFields();
      return;
    }

    double euro = double.parse(text);
    realControl.text = (this.euro * euro).toStringAsFixed(2);
    dolarControl.text = ((this.euro * euro) / dolar).toStringAsFixed(2);
    ieneControl.text = ((this.euro * euro) / iene).toStringAsFixed(2);
    yuanControl.text = ((this.euro * euro) / yuan).toStringAsFixed(2);
  }

  void _convertIene(String text) {
    if (text.trim().isEmpty) {
      _clearFields();
      return;
    }

    double iene = double.parse(text);
    realControl.text = (this.iene * iene).toStringAsFixed(2);
    dolarControl.text = ((this.iene * iene) / dolar).toStringAsFixed(2);
    euroControl.text = ((this.iene * iene) / euro).toStringAsFixed(2);
    yuanControl.text = ((this.iene * iene) / yuan).toStringAsFixed(2);
  }

  void _convertYuan(String text) {
    if (text.trim().isEmpty) {
      _clearFields();
      return;
    }

    double yuan = double.parse(text);
    realControl.text = (this.yuan * yuan).toStringAsFixed(2);
    dolarControl.text = ((this.yuan * yuan) / dolar).toStringAsFixed(2);
    euroControl.text = ((this.yuan * yuan) / euro).toStringAsFixed(2);
    ieneControl.text = ((this.yuan * yuan) / iene).toStringAsFixed(2);

  }

  void _clearFields() {
    realControl.clear();
    dolarControl.clear();
    euroControl.clear();
    ieneControl.clear();
    yuanControl.clear();
  }
}

Future<Map> getData() async {
  //* ENDEREÇO DA API NOVA
  //* https://docs.awesomeapi.com.br/api-de-moedas

  const requestApi =
      "https://economia.awesomeapi.com.br/json/last/USD-BRL,EUR-BRL,CNY-BRL,JPY-BRL";
  var response = await http.get(Uri.parse(requestApi));
  return jsonDecode(response.body);

  //* json manual para teste em caso de
  //* problema com a conexão http
/*   var response = {
    "USDBRL": {
      "code": "USD",
      "codein": "BRL",
      "name": "Dólar Americano/Real Brasileiro",
      "high": "5.3388",
      "low": "5.2976",
      "varBid": "0.0382",
      "pctChange": "0.72",
      "bid": "5.3348",
      "ask": "5.3363",
      "timestamp": "1679660987",
      "create_date": "2023-03-24 09:29:47"
    },
    "EURBRL": {
      "code": "EUR",
      "codein": "BRL",
      "name": "Euro/Real Brasileiro",
      "high": "5.7429",
      "low": "5.6772",
      "varBid": "-0.0095",
      "pctChange": "-0.17",
      "bid": "5.7256",
      "ask": "5.7293",
      "timestamp": "1679660999",
      "create_date": "2023-03-24 09:29:59"
    },

    "BTCBRL": {
        "code": "BTC",
        "codein": "BRL",
        "name": "Bitcoin/Real Brasileiro",
        "high": "360000",
        "low": "340500",
        "varBid": "17072.9",
        "pctChange": "4.98",
        "bid": "359973.9",
        "ask": "359974",
        "timestamp": "1618315092",
        "create_date": "2021-04-13 08:58:12"
    }
  };

  <BRL-CNY>Real Brasileiro/Yuan Chinês</BRL-CNY>
  <BRL-JPY>Real Brasileiro/Iene Japonês</BRL-JPY>
  <XAU>Ouro</XAU>

  return jsonDecode(jsonEncode(response));
 */
}
