import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:touchable/touchable.dart';
import 'dart:convert';
import '../utilities/drawer.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class MyScreen extends StatefulWidget {
  static String id = 'my_screen';

  @override
  _MyScreenState createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  WebSocketChannel _channel; // initialize channel
  HashMap<String, dynamic> _streamData; // initialize stream data

  connectWebSocket() async {
    _channel = IOWebSocketChannel.connect(
      'ws://142.93.238.122:8000/ws-217bce6e-c501-4dcf-8d22-37d2e967d4e6',
    );
  }

  @override
  void initState() {
    super.initState();
    // connect to private websocket. This websocket delivers a new value every 100 milliseconds
    connectWebSocket();
  }

  @override // need this to close if we kill the homepage
  void dispose() {
    _channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            StreamBuilder(
              stream: _channel.stream,
              initialData:
                  HashMap<String, dynamic>(), //initialize with empty data
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasError) {
                  // if errors return empty container?
                  return Container(width: 0.0, height: 0.0);
                } else if (!snapshot.hasData) {
                  // if no data return empty container?
                  return Container(width: 0.0, height: 0.0);
                } else {
                  try {
                    // convert incoming JSON object :
                    // the json object looks like this:
                    _streamData = new HashMap<String, dynamic>.from(
                      json.decode(snapshot.data),
                    );
                    return SizedBox(
                      width: double.infinity,
                      height: double.infinity,
                      child: CanvasTouchDetector(
                        builder: (context) => CustomPaint(
                          // if we have values use DotPainter to draw the dots on the canvas
                          painter: ForegroundPainter(
                            dots: _streamData['players'],
                            context: context,
                          ),
                        ),
                      ),
                    );
                  } catch (e) {
                    print(e);
                    return Container(width: 0.0, height: 0.0);
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
