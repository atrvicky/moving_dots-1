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

  // this websocket streams json files of the following structure:
  //{image: [[[121, 255, 125, 255], [121, 255, 125, 255], [121, 255, 125, 255], [121, 255, 125, 255], [121, 255, 125, 255], [121, 255, 125, 255], [121, 255, 125, 255], [121, 255, 125, 255], [121, 255, 125, 255], [121, 255, 125, 255], [121, 255, 125, 255], [121, 255, 125, 255], [121, 255, 125, 255], [121, 255, 125, 255], [121, 255, 125, 255], [121, 255, 125, 255], [121, 255, 125, 255], [121, 255, 125, 255], [121, 255, 125, 255], [121, 255, 125, 255], [121, 255, 125, 255], [121, 255, 125, 255], [121, 255, 125, 255], [121, 255, 125, 255], [121, 255, 125, 255], [121, 255, 125, 255], [121, 255, 125, 255], [121, 255, 125, 255], [121, 255, 125, 255], [121, 255, 125, 255], [121, 255, 125, 255], [121, 255, 125, 255], [121, 255, 125, 255], [121, 255, 125, 255], [121, 255, 125, 255], [121, 255, 125, 255], [121, 255, 125, 255], [121, 255, 125, 255], [121, 255, 125, 255], [121, 255, 125, 255], [121, 255, 125, 255], [121, 255, 125, 255], [121, 255, 125, 255], [121, 255, 125, 255], [121, 255, 125, 255], [121, 255, 125, 255]
  // so below _streamData['image'] gives a 100x100x4 uint8array
  connectWebSocket() async {
    _channel = IOWebSocketChannel.connect(
      'ws://142.93.238.122:8000/pc/ws-71c37e86-dd9a-4b3d-8980-5d27a655b5d7',
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
                    // _streamData['image'] is a uint8 array of size 100x100x4
                    // TODO: _streamData['image'] 100x100x array to img with ImagePainter
                    // TODO: maybe use https://pub.dev/packages/bitmap?
                    print(_streamData['image']);

                    return SizedBox(
                      width: double.infinity,
                      height: double.infinity,
                      child: CanvasTouchDetector(
                        builder: (context) => CustomPaint(
                          // if we have values use DotPainter to draw the dots on the canvas
                          painter: ImagePainter(
                            img: _streamData['image'],
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
            // I've added this builder (it needs to be a builder, because otherwise it doesn't work)
            Builder(builder: (BuildContext context) {
              return GestureDetector(
                onPanUpdate: (DragUpdateDetails details) {},
                onPanEnd: (DragEndDetails details) {},
                child: CustomPaint(
                  painter: OtherPainter(),
                  size: Size.infinite,
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
