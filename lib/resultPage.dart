import 'package:flutter/material.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({super.key});

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  int _tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('查询结果'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Row(
              children: [
                Expanded(
                  child: Container(
                    color: Colors.transparent,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'c.name',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Text(
                          'c.messageText',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Text('data'),
                SizedBox(
                  width: 8,
                ),
                Text('data2'),
              ],
            )
          ],
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
            icon: Icon(Icons.looks_one_outlined),
            activeIcon: Icon(Icons.looks_one),
            label: '一号位',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.looks_two_outlined),
            activeIcon: Icon(Icons.looks_two),
            label: '二号位',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.looks_3_outlined),
            activeIcon: Icon(Icons.looks_3),
            label: '三号位',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.looks_4_outlined),
            activeIcon: Icon(Icons.looks_4),
            label: '四号位',
          )
        ],
      ),
    );
  }
}
