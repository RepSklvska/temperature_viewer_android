import 'package:flutter/material.dart';
import 'package:temperature_viewer/resultPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: false,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _queryCounter = 5;

  final TextEditingController _textFieldController = TextEditingController();
  late SharedPreferences prefs;

  void _setTextFieldValue(String value) {
    _textFieldController.clear();
    _textFieldController.value = _textFieldController.value.copyWith(text: value, composing: null);
  }

  void _initializeTextField() async {
    prefs = await SharedPreferences.getInstance();
    if (prefs.getString('queryUrl') == null) {
      await prefs.setString('queryUrl', 'http://192.168.1.230:7000');
    }
    String queryUrl = prefs.getString('queryUrl')!;
    _setTextFieldValue(queryUrl);
  }

  @override
  void initState() {
    super.initState();
    _initializeTextField();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('温度湿度记录查询'),
      ),
      resizeToAvoidBottomInset: true,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 32, right: 32),
              child: TextField(
                textAlign: TextAlign.center,
                controller: _textFieldController,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('查询 $_queryCounter 条数据'),
                ),
                IconButton(
                  onPressed: _queryCounter != 1 ? () => setState(() => _queryCounter -= 1) : null,
                  icon: const Icon(Icons.remove),
                ),
                IconButton(
                  onPressed: () => setState(() => _queryCounter += 1),
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
            OutlinedButton(
              onPressed: () {
                _setTextFieldValue(_textFieldController.text.replaceAll(RegExp(r'/+$'), ''));
                prefs.setString('queryUrl', _textFieldController.text);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ResultPage(
                      url: _textFieldController.text,
                      lines: _queryCounter,
                    ),
                  ),
                ).then((_) => _initializeTextField());
              },
              child: const Text('查询'),
            ),
          ],
        ),
      ),
    );
  }
}
