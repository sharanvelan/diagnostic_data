import 'dart:async';

import 'package:diagnostic_data/model/topicModel.dart';
// import 'package:diagnostic_data/secondScreen.dart';
import 'package:diagnostic_data/valuesPage.dart';
import 'dart:convert';
//import 'package:diagnostic_data/secondScreen.dart';
import 'package:flutter/material.dart';
import 'package:roslibdart/roslibdart.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}



class _MyAppState extends State<MyApp> {
  
  //to make ros connection
  late Ros ros;
  
  late WebSocketChannel channel;
  StreamSubscription<dynamic>? _streamSubscription;
     
  late Topic topic;
  
  late Service service;
  
  bool checkConnection=false;

   List<String> TopicList = [
    // 'vehicle_safety_diagnostics',
    // 'diagnostics',
  ];

  Map<String, Message> topicData={};
  
  Future<void> subscribeHandler(msg,String name) async {
    print(name);
   try {
    
    final decodedMessage = Message.fromJson(msg,true);

    //print('Received message for $name:');
    // print(decodedMessage.status.length);
    // print(decodedMessage.status[2].message);

    Future.microtask(() {
    setState(() {
      topicData[name] = decodedMessage;
      //print(topicData[name]?.status[0]?.message ?? '-');
    });
   
  });
  } catch (e, stackTrace) {
    print('Error in subscribeHandler for $name: $e');
    print('Stack Trace: $stackTrace');
  }
   
 }
 
 
   
   

  Future<void> initializeRos() async {
    
    //yellow dragon 192.168.42.3:9090
    //constan 192.168.42.254:9090
    //129 for hmi
    //192.168.42.254
    ros = Ros(url: 'ws://10.10.0.150:9090');

    try{

    ros.connect();
    setState(() {
      
    checkConnection=true;
    });
    }
    catch(e){
          print("-------");
          print(e);
          setState(() {
            
      checkConnection=false;
          });
    }


    final List<Topic> topics = TopicList.map((topicName) {
      
    return Topic(ros: ros, name: topicName, type: 'diagnostic_msgs/DiagnosticArray',reconnectOnClose: true, queueLength: 10, queueSize: 10);
       }).toList();

  for (int i = 0; i < topics.length; i++) {
    final int index = i;
    

   
    await topics[i].subscribe((msg)=>subscribeHandler(msg,TopicList[index]));
      
    
 
  }
   
  }

  Color getColorForStatus(int status) {
    switch (status) {
      case 0:
        return Colors.green;
      case 1:
        return Colors.yellow;
      case 2:
        return Colors.red;
      default:
        return Colors.black;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
    //call the service "/rosapi/topics" to get the list of topics 
    try{
    //192.168.42.254
    channel=IOWebSocketChannel.connect('ws://10.10.0.150:9090');
    }
    catch(e){
      print("---");
      print(e);
      print("---");
    }

    //for disconnection happen
    channel.sink.done.then((dynamic closeCode) {
      print('WebSocket disconnected with code: $closeCode');
      setState(() {
        checkConnection = false;
      });
    });

    _sendServiceRequest();

    _streamSubscription = channel.stream.listen(_handleResponse);

   

  }
  
  @override
  Widget build(BuildContext context) {
         TextEditingController _textController=TextEditingController();

         return MaterialApp(
          theme: ThemeData.dark(),
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            appBar: AppBar(
              actions: [ Icon(
              checkConnection ? Icons.offline_bolt_rounded : Icons.offline_bolt_rounded,
              color: checkConnection ? Colors.green : Colors.red,
            ),
            SizedBox(
              width: 40,
            )],
              title: Text("Diagnostic Data"),elevation: 0,
              ),
            body:
            Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0)),
                  child: GridView.builder(
                    gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,mainAxisSpacing: 10,crossAxisSpacing: 10,mainAxisExtent: 300), 
                    itemCount: TopicList.length,
                    itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text(TopicList[index].substring(1),style: TextStyle(fontSize: 20,),)),
                        Expanded(
                              child: ListView.builder(
                                
                                      shrinkWrap: true,
                                      itemCount:topicData[TopicList[index]]?.status?.length ?? 0,
                                      itemBuilder:(BuildContext context,int statusIndex){
                                           final color = getColorForStatus(topicData[TopicList[index]]?.status[statusIndex].level?? 3);
                                           print(topicData[TopicList[index]]?.status?.length ?? 0);
                                           print("---");
                                           return ListTile(
                                            onTap: (){
                                              Navigator.push(context, MaterialPageRoute(builder: (context)=>Values(valuesData:topicData[TopicList[index]]?.status[statusIndex]?.values ?? [Value(key: 'Empty', value: 'Empty')])));
                                            },
                                            title: Text(topicData[TopicList[index]]?.status[statusIndex]?.name ?? 'null',style: TextStyle(  fontSize: 13 , fontWeight: FontWeight.w300),),
                                            subtitle: Text(topicData[TopicList[index]]?.status[statusIndex]?.message ?? 'null' ,style: TextStyle(color: color,fontSize: 13),),
                                            trailing: Text(topicData[TopicList[index]]?.status[statusIndex]?.level.toString()??'null' ,style: TextStyle(color: color)),
                                           );
                                    }),
                        ),
                      ],
                    );
                  },)
                  )
                  ,
                  floatingActionButton: SizedBox(
                    width: 35,
                    height: 35,
                    child: FloatingActionButton(onPressed: (){
                      
                      _sendServiceRequest();
                    },
                    child: Icon(Icons.replay_rounded),),
                  ),
          ),
         );
  }
  @override
  void dispose() {
     ros.close();
    super.dispose();
  }


  void _sendServiceRequest() async {
    final request = {
      'op': 'call_service',
      'service': '/rosapi/topics',
      'args': {}
    };

    try {
      channel.sink.add(jsonEncode(request));
    } catch (e) {
      setState(() {
        
      });
    }
  }
   void _handleResponse(dynamic response) {
   // print(response);
      Map<String, dynamic> responseMap = json.decode(response);

  // Extract topics from the response
     List<String> topics = List<String>.from(responseMap['values']['topics']);
     print(topics.length);
     setState(() {
     
       for(var i in topics){
        if(i.endsWith("diagnostics")){
          TopicList.add(i);
        }
       }
     });
      topicData = Map.fromIterable(
    TopicList,
    key: (topicName) => topicName,
    value: (topicName) => Message(
      header: Header(seq: 0, stamp: Stamp(secs: 0, nsecs: 0), frameId: ''),
      status: [],
      isTopicAvailable: false
    ),
  );
    
    initializeRos();
   
  }
}