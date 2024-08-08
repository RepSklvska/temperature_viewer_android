import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:simple_http_api/simple_http_api.dart';

class RecordStruct {
  String id;
  String date;
  String temperature;
  String humidity;

  RecordStruct(this.id, this.date, this.temperature, this.humidity);
}

class DataStruct {
  // List<RecordStruct>
}

class ResultPage extends StatefulWidget {
  final String url;
  final int lines;

  const ResultPage({super.key, required this.url, required this.lines});

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  int _tabIndex = 0;
  final Map<String, List<RecordStruct>> _data = {};
  static const List<String> sensors = ['FC94', 'AB68', 'CE30', '18B8'];

  List<Container>? _renderData(String sensorId) {
    return _data[sensorId]
        ?.map(
          (record) => Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: 1,
                  color: Colors.black12,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    color: Colors.transparent,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          record.id,
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          record.date,
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Text('${record.temperature}℃', style: const TextStyle(fontSize: 16)),
                const SizedBox(width: 8),
                Text('${record.humidity}%', style: const TextStyle(fontSize: 16)),
              ],
            ),
          ),
        )
        .toList();
  }

  @override
  void initState() {
    super.initState();

    final url = Uri.parse('${widget.url}/list?i=${widget.lines}');
    () async {
      try {
        final response = await Api.get(url);
        final result = jsonDecode(response.body);
        for (var sensor in sensors) {
          final List<RecordStruct> recordList = [];
          for (int i = 0; i < result[sensor].length; i++) {
            var record = result[sensor][i];
            String id = record['id'].toString();
            String date = record['date'].toString();
            String temperature = record['temperature'].toString();
            String humidity = record['humidity'].toString();
            recordList.add(RecordStruct(id, date, temperature, humidity));
          }
          setState(() {
            _data[sensor] = recordList;
          });
        }
      } catch (error) {
        print('Error $error');
      }
    }();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('查询结果'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: _renderData(sensors[_tabIndex]) ?? [],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _tabIndex,
        onTap: (index) => setState(() => _tabIndex = index),
        unselectedItemColor: Colors.black54,
        selectedItemColor: Colors.blue,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.elevator_outlined),
            activeIcon: Icon(Icons.elevator),
            label: '电梯',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.meeting_room_outlined),
            activeIcon: Icon(Icons.meeting_room),
            label: '中厅',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.kitchen_outlined),
            activeIcon: Icon(Icons.kitchen),
            label: '厨房',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.storage_outlined),
            activeIcon: Icon(Icons.storage),
            label: 'PVE',
          )
        ],
      ),
    );
  }
}
