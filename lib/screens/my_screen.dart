import 'dart:collection';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:ui' as ui;
import 'dart:typed_data';

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
  HashMap<String, List<dynamic>> streamData; // initialize stream data
  bool isImageloaded = false;

  ui.Image returnImage;

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
                    streamData = new HashMap<String, List<dynamic>>.from(
                      json.decode(snapshot.data),
                    );
                    // _streamData['image'] is a uint8 array of size 100x100x4
                    // _streamData['image'] 100x100x array to img with ImagePainter

                    List<int> colorData = List();
                    // properly format the output data into a List<List<int>>
                    for (int i = 0; i < 100; i++) {
                      List<List> row = List.from(streamData['image'][i]);
                      for (int j = 0; j < 100; j++) {
                        List<int> col = new List.from(row[j]);
                        // convert the incoming image data into a color value
                        // even though this is ARGB, input the values in the order of
                        // 0 through 3 because, when rendered it considers this as rgba
                        // change the input order, if needed
                        int color =
                            Color.fromARGB(col[0], col[1], col[2], col[3])
                                .value;
                        // add each color info to a color list
                        colorData.add(color);
                      }
                    }
                    // List<int> colorList = colorData
                    //     .map((val) => val
                    //         .map((value) => Color.fromRGBO(
                    //                 value[0],
                    //                 value[1],
                    //                 value[2],
                    //                 value[3].toDouble())
                    //             .value)
                    //         .toList())
                    //     .toList();

                    // call renderimage with the color data
                    renderImage(colorData);

                    return SizedBox(
                      width: 100,
                      height: 100,
                      child: CustomPaint(
                        painter: new ImagePainter(img: returnImage),
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

  static const imageDimension = 100;

  void renderImage(List<int> pixelVals) {
    final pixels = Uint32List.fromList(pixelVals);
    ui.decodeImageFromPixels(
      pixels.buffer.asUint8List(),
      imageDimension,
      imageDimension,
      ui.PixelFormat.rgba8888,
      (image) {
        setState(() {
          returnImage = image;
          isImageloaded = true;
        });
      },
    );
  }
}
