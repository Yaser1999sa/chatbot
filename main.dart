import 'package:bubble/bubble.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialogflow/dialogflow_v2.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final messageController = TextEditingController();
  List<Map> messages = new List();

  void response(query) async{
    AuthGoogle authGoogle = await AuthGoogle(
    fileJson: "assets/services.json"
    ).build();
    Dialogflow dialogflow = Dialogflow(authGoogle: authGoogle, language: Language.english);
    AIResponse aiResponse = await dialogflow.detectIntent(query);
    setState(() {
    messages.insert(0, {
      "data": 0,
      "messages": aiResponse.getListMessage()[0]["text"]["text"][0].toString()
    });
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: AppBar(
        title: Text("Chat Bot"),

      ),
        body: Container(
          child: Column(
          children: [
            Center(
              child: Container(
                padding: EdgeInsets.only(top: 15, bottom: 10),
                child: Text("Today, ${DateFormat("Hm").format(DateTime.now())}", style: TextStyle(
                  fontSize: 20
                ),),
              ),
            ),

            Flexible(
              child: ListView.builder(
                  reverse: true,
                  itemCount: 0,
                  itemBuilder: (context, index) => chat (
                  messages[index]["message"].toString(),
                  messages[index]["data"]
    )),

            ),

            Divider(
              height: 5,
              color: Colors.greenAccent,
            ),
            Container(
              child: ListTile(
                leading: IconButton(
                  icon: Icon(Icons.camera_alt, color: Colors.greenAccent, size: 35,), onPressed: () {  },
                ),
                title: Container(
                  height: 35,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    color: Color.fromRGBO(220, 220, 220, 1)
                  ),
                  padding: EdgeInsets.only(left: 15),
                  child: TextFormField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: "Enter a message",
                      hintStyle: TextStyle(
                        color: Colors.black26
                      ),
                      border:         InputBorder.none,
                      focusedBorder:  InputBorder.none,
                      enabledBorder:  InputBorder.none,
                      errorBorder:    InputBorder.none,
                      disabledBorder: InputBorder.none,
                    ),

                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black
                    ),
                  ),
                ),

                trailing: IconButton(
                  icon: Icon(Icons.send,
                  size:30,
                  color: Colors.greenAccent,
                  ),
                  onPressed: (){
                    if(messageController.text.isEmpty){
                      print("empty message");
                    }
                    else{
                      setState(() {
                      messages.insert(0, {"data": 1, "message": messageController.text });
                      });
                      response(messageController.text);
                      messageController.clear();
                    }
                    FocusScopeNode currentFocus = FocusScope.of(context);
                    if(!currentFocus.hasPrimaryFocus){
                      currentFocus.unfocus();
                    }
                  },
                ),
              ),
            )
          ],
          ),
        ),
    );
  }

  Widget chat(String message, int data){
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: Row(
        mainAxisAlignment: data == 1 ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          data == 0 ? Container(
            height: 60,
            width: 60,
            child: CircleAvatar(
              backgroundImage: AssetImage("assets/robot.png"),
            ),
          ) : Container(),

          Padding(
            padding: EdgeInsets.all(10),
            child: Bubble(
              radius: Radius.circular(15),
              color: data == 0 ? Color.fromRGBO(23, 157, 139, 1) : Colors.orangeAccent,
              elevation: 0,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Flexible(
                    child: Container(
                      constraints: BoxConstraints(maxWidth: 200),
                      child: Text(
                        message,
                        style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )

          data == 1 ? Container(
            height: 60,
            width: 60,
            child: CircleAvatar(
              backgroundImage: AssetImage("assets/default.jpg"),
            ),
          ) : Container(),
        ],
      ),
    );
  }
}
