import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key, required this.title});

  final String title;

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  int _counter = 0;
  String _str = '';
  String _time = '';
  bool _visible = false;
  bool _buttonenabled = true;

  // final _channel = WebSocketChannel.connect(
  //   Uri.parse('wss://echo.websocket.events'),
  // );

  String _getTime() {
    DateTime now = DateTime.now();

    String date =
        '${now.day.toString()} - ${now.month.toString()} - ${now.year.toString()}';
    String time =
        '${(now.hour % 12).toString()} : ${now.minute.toString()} ${now.hour >= 12 ? 'pm' : 'am'} ';

    return '$time |  $date';
  }

  Future _getData() async {
    var response =
        await http.get(Uri.https('some-random-api.ml', 'animal/cat'));
    var jsonData = jsonDecode(response.body);

    setState(() {
      _str = jsonData["fact"];
      // _echo(_str);
      _time = _getTime();
      _counter++;
      _visible = true;
      _buttonenabled = true;
    });
  }

  // void _echo(String msg) {
  //   _channel.sink.add(msg);
  // }

  void _pressTrigger() {
    setState(() {
      _buttonenabled = false;
    });
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(widget.title),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Icon(
                  Icons.pets_outlined,
                  size: 200.0,
                  color: Color.fromARGB(255, 75, 66, 48),
                ),
                const SizedBox(
                  height: 60.0,
                ),
                Visibility(
                  visible: _visible,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(15.0),
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 255, 221, 120),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                                color:
                                    const Color.fromARGB(255, 175, 116, 27))),
                        // child: StreamBuilder(
                        //   stream: _channel.stream,
                        //   builder: (context, snapshot) {
                        //     return Text(
                        //         snapshot.hasData ? '${snapshot.data}' : '');
                        //   },
                        // ),
                        child: Text(
                          '$_str ',
                          style: const TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 50.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text(
                            'Last Fed At:',
                            style: TextStyle(fontSize: 15),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Chip(
                            padding: const EdgeInsets.all(0),
                            backgroundColor:
                                const Color.fromARGB(255, 46, 127, 182),
                            label: Text(_time,
                                style: const TextStyle(color: Colors.white)),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text(
                            'You have fed the cat this many times:',
                            style: TextStyle(fontSize: 15),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Chip(
                            padding: const EdgeInsets.all(0),
                            backgroundColor: Colors.green,
                            label: Text('$_counter',
                                style: const TextStyle(color: Colors.white)),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _buttonenabled ? Colors.amber : Colors.grey,
                  ),
                  onPressed: _buttonenabled ? _pressTrigger : null,
                  child: const Text(
                    'Feed',
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.w100),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
