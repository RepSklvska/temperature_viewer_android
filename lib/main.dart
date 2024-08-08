import 'package:flutter/material.dart';
import 'package:temperature_viewer/resultPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:scaled_app/scaled_app.dart';

void main() async {
  ScaledWidgetsFlutterBinding.ensureInitialized();

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.getDouble('appScale') ?? prefs.setDouble('appScale', 1.0);
  double scale = prefs.getDouble('appScale')!;

  runAppScaled(const MyApp());

  ScaledWidgetsFlutterBinding.instance.scaleFactor = (deviceSize) {
    return scale;
  };
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
  double _selectedScale = 1.0;

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

  void _initializeSliderValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedScale = prefs.getDouble('appScale') ?? 1.0;
    });
  }

  @override
  void initState() {
    super.initState();
    _initializeTextField();
    _initializeSliderValue();
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
              child: Slider(
                value: _selectedScale,
                max: 1.5,
                min: 0.8,
                divisions: 7,
                onChanged: (value) {
                  SharedPreferences.getInstance().then((prefs) {
                    prefs.setDouble('appScale', value);
                  });
                  ScaledWidgetsFlutterBinding.instance.scaleFactor = (deviceSize) {
                    return value;
                  };
                  setState(() {
                    _selectedScale = value;
                  });
                },
              ),
            ),
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
