import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:Ghost_In_the_Machine/rating_view.dart';
import 'package:Ghost_In_the_Machine/setDrawingArea.dart';
import 'package:http/http.dart' as http;
import 'dart:ui'as ui;



class HomeScreen extends StatefulWidget
{
  @override
  _HomeScreenState createState() => _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen>
{
  List<SetDrawingArea> allPoints = [];

  Widget outputImageWidget;


  //图像呈现
  void saveSketchToImage(List<SetDrawingArea>points)async
  {
    final sketchRecorder = ui.PictureRecorder();

    final canvas = Canvas(sketchRecorder,Rect.fromPoints(Offset(0.0,0.0),Offset(200,200)));

    Paint paint = Paint()
      ..color = Colors.white
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2.0;

    final paintBackground = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.black;

    canvas.drawRect(Rect.fromLTWH(0, 0, 356, 256),paintBackground);

    for(int i = 0; i<points.length -1;i++){
      if(points[i] !=null && points[i+1] !=null)
      {
        canvas.drawLine(points[i].points,points[i+1].points,paint);
      }
    }

    final picture = sketchRecorder.endRecording();
    final imgFile = await picture.toImage(356,200);

    final pngBytes = await imgFile.toByteData(format: ui.ImageByteFormat.png);
    final listbites = Uint8List.view(pngBytes.buffer);

    String base64 = base64Encode(listbites);
    retrieveResponse(base64);
  }


  void retrieveResponse(var base64Image)async{
    var data = {"Image":base64Image};

    //:5000/predict
    var urlFlaskServer = "http://192.168.0.133:5000/predict";

    Map<String,String>headers = {
      "Content-type":"application/json",
      "Accept":"application/json",
      "Connection":"Keep-Alive",
    };

    var body = json.encode(data);

    try
    {
      var response = await http.post(Uri.parse(urlFlaskServer),body:body,headers:headers);

      final Map<String,dynamic> responseData = json.decode(response.body);

      String outputBytes = responseData["Image"];

      print("This is OUTPUT Bytes");

      print(outputBytes);

      displayOutputImage(outputBytes.substring(2,outputBytes.length - 1));
      
    }
    catch(e)
    {
      print("Error Occured.");

      print(e);
      return null;
    }

  }

  //输出图像
  void displayOutputImage(String bytes)async
  {
    Uint8List convertedBytes = base64Decode(bytes);

    setState((){
      outputImageWidget = Container(
        width: 256,
        height: 256,
        child: Image.memory(
          convertedBytes,
          fit: BoxFit.cover,
        ),
      );
    });

  }


  @override
  Widget build(BuildContext context)
  {
    //添加背景图
    return Scaffold(
      //标题颜色和主题
      appBar: AppBar(
        //标题❤️❤️❤️❤️❤️❤️❤️❤️
        flexibleSpace: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/title.png'),
              fit: BoxFit.cover
            )
          ),
        ),
      ),
      body: Container(
        //背景图
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/background_img.png"),
              fit:BoxFit.fill
          ),
        ) ,
        

        child: Stack(
          children: [
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  //用户
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 0.2),
                    child: Image(
                      image: AssetImage('assets/human.png'),
                    ),
                  ),

                  //黑色画布大小
                  Padding(
                    padding: EdgeInsets.all(7.0),
                    //黑色画布大小
                    child: Container(
                      width: 356,
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(22)),
                        boxShadow:
                        [
                          BoxShadow(
                            color: Colors.white54,
                            //blurRadius: 6.0,
                            spreadRadius: 2,
                          ),
                        ]
                      ),

                      //✍️✍️✍️✍️✍️✍️ 画笔
                      child: GestureDetector(
                        onPanDown: (details){
                          this.setState(() {
                            allPoints.add(
                              SetDrawingArea(
                                points: details.localPosition,
                                paintArea: Paint()
                                  ..strokeCap = StrokeCap.round
                                  ..isAntiAlias = true
                                  ..color = Colors.white
                                  ..strokeWidth = 2.0
                              ),
                            );
                          });
                        },
                        onPanUpdate: (details){
                          this.setState(() {
                            allPoints.add(
                              SetDrawingArea(
                                  points: details.localPosition,
                                  paintArea: Paint()
                                    ..strokeCap = StrokeCap.round
                                    ..isAntiAlias = true
                                    ..color = Colors.white
                                    ..strokeWidth = 2.0
                              ),
                            );
                          });
                        },
                        onPanEnd: (details)
                        {
                          saveSketchToImage(allPoints);
                          this.setState(() {
                            allPoints.add(null);
                          });
                        },
                        child: SizedBox.expand(
                          child: ClipRRect(
                            borderRadius:BorderRadius.all(
                              Radius.circular(22.0),
                            ),
                            child: CustomPaint(
                              painter: MyCustomPainter(allPoints: allPoints),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),


                  //icon 插入
                  Container(
                    width: MediaQuery.of(context).size.width*0.30,
                    height: 45.0,
                    decoration: BoxDecoration(
                      color: Colors.white10,
                      borderRadius: BorderRadius.circular(22.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(Icons.layers_clear,color: Colors.white,),
                          onPressed: (){
                            this.setState(() {
                              allPoints.clear();
                            });
                          },
                        ),
                      ],
                    ),
                  ),

                  //用户
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 0.2),
                    child: Image(
                      image: AssetImage('assets/machine.png'),
                    ),
                  ),

                  //输出图像
                  Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      child: Container(
                        height: 200,
                        width: 200,
                        child: outputImageWidget,
                      ),
                  ),

                  //rating button
                  TextButton.icon(
                      onPressed: (){
                        openRatingDialog(context);
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          Colors.white10.withOpacity(0.1),
                        ),
                      ),
                      icon: Icon(
                          Icons.star,
                          color: Colors.amberAccent,
                      ),
                      label: Text(
                        'Rate App!',
                        style: Theme.of(context).textTheme.headline6.copyWith(color:Colors.white),

                      ),
                  ),

                ],


              ),
            ),

          ],
        ),
      ),
    );

  }

  openRatingDialog(BuildContext context){
    showDialog(
        context: context,
        builder:(context){
          return Dialog(
            child:RatingView(),
          );
        },
    );
  }

}

//open anaconda prompt
//activate your conda environment
//cd provide your Flask Server Path
//set FLASK_APP = humanFaceFlask.py
//set FLASK_ENV = development
//flask run -h 192.168.0.133

