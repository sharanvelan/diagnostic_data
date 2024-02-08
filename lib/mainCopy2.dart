// import 'dart:async';

// import 'package:diagnostic_data/model/topicModel.dart';
// import 'package:diagnostic_data/secondScreen.dart';
// import 'package:diagnostic_data/valuesPage.dart';
// import 'dart:convert';
// //import 'package:diagnostic_data/secondScreen.dart';
// import 'package:flutter/material.dart';
// import 'package:roslibdart/roslibdart.dart';
// import 'package:web_socket_channel/io.dart';
// import 'package:web_socket_channel/web_socket_channel.dart';

// void main(){
//   runApp(MyApp());
// }

// class MyApp extends StatefulWidget {
//   const MyApp({super.key});

//   @override
//   State<MyApp> createState() => _MyAppState();
// }



// class _MyAppState extends State<MyApp> {
  
//   //to make ros connection
//   late Ros ros;
  
//   late WebSocketChannel channel;
//   StreamSubscription<dynamic>? _streamSubscription;
     
//   late Topic topic;
  
//   late Service service;

//    List<String> TopicList = [
//     // 'vehicle_safety_diagnostics',
//     // 'diagnostics',
//   ];

//   Map<String, Message> topicData={};
  
//   Future<void> subscribeHandler(msg,String name) async {
//     print(name);
//    try {
    
//     final decodedMessage = Message.fromJson(msg,true);

//     //print('Received message for $name:');
//     // print(decodedMessage.status.length);
//     // print(decodedMessage.status[2].message);

//     Future.microtask(() {
//     setState(() {
//       topicData[name] = decodedMessage;
//       //print(topicData[name]?.status[0]?.message ?? '-');
//     });
   
//   });
//   } catch (e, stackTrace) {
//     print('Error in subscribeHandler for $name: $e');
//     print('Stack Trace: $stackTrace');
//   }
   
//  }
 
//  void callService() async {
//   try {
//     // Call the service
//     dynamic response = await service.call({});

   
//   } catch (error) {
//     print('Error calling service: $error');
//   }
// }

   

//   Future<void> initializeRos() async {
//     // Replace 'ws://localhost:9090' with your ROS environment WebSocket URL.
//     channel=IOWebSocketChannel.connect('ws://10.10.0.150:9090');
  

//     ros = Ros(url: 'ws://10.10.0.150:9090');
//     ros.connect();
    
//     service=Service(name: 'rosapi/topics',ros: ros,type: 'rosapi/Topics');
    
//    // callService();
    
//     // Map<dynamic,dynamic> result=await service.call({});
//     // print(result);

//     final List<Topic> topics = TopicList.map((topicName) {
      
//     return Topic(ros: ros, name: topicName, type: 'diagnostic_msgs/DiagnosticArray',reconnectOnClose: true, queueLength: 10, queueSize: 10);
//        }).toList();

//   for (int i = 0; i < topics.length; i++) {
//     final int index = i;
    

   
//     await topics[i].subscribe((msg)=>subscribeHandler(msg,TopicList[index]));
      
    
    
//     // topics[i].subscribe((message) {
//     //   Handle messages for each topic
//     //   print('Received from ${TopicList[index]}: $message');

//     //   Decode the JSON message into a Message instance
//     //   final decodedMessage = Message.fromJson(json.decode(message));

//     //   // Update the data map
//     //   topicData[topicNames[index]] = decodedMessage;
//     //   print('Updated data map: $topicData');
//    // }
//     //);
//   }
//     // Replace '/your/topic' with the actual ROS topic you want to subscribe to.
    
//   }

//   Color getColorForStatus(int status) {
//     switch (status) {
//       case 0:
//         return Colors.green;
//       case 1:
//         return Colors.yellow;
//       case 2:
//         return Colors.red;
//       default:
//         return Colors.black;
//     }
//   }

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();

//     channel=IOWebSocketChannel.connect('ws://10.10.0.150:9090');
//     _sendServiceRequest();
//     _streamSubscription = channel.stream.listen(_handleResponse);

   

//   }
  
//   @override
//   Widget build(BuildContext context) {
//          TextEditingController _textController=TextEditingController();

//          return MaterialApp(
//           theme: ThemeData.dark(),
//           debugShowCheckedModeBanner: false,
//           home: Scaffold(
//             appBar: AppBar(title: Text("Diagnostic Data"),elevation: 0,),
//             body:
//             Container(
//                   alignment: Alignment.center,
//                   decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0)),
//                   child: ListView.builder(
                    
//                       itemCount: TopicList.length,
//                       itemBuilder: (BuildContext context, int index) {
//                         return Container(
                        
//                           child: ExpansionTile(
                
//                             tilePadding: EdgeInsets.all(10),
                
//                             // backgroundColor: Color.fromARGB(255, 88, 88, 85),
                
//                             // collapsedBackgroundColor: Color.fromARGB(255, 88, 88, 85),
                
//                             // shape: RoundedRectangleBorder(
//                             //   borderRadius: BorderRadius.circular(10.0),
//                             // ),

//                             title: Text(
//                               TopicList[index],
                              
//                             ),
//                           //  trailing:Text( topicData[TopicList[index]]?.isTopicAvailable.toString() ?? 'Null' ) , 
//                           trailing: topicData[TopicList[index]]?.isTopicAvailable ?? false ? Icon(Icons.check, color: Colors.green, size: 24.0) :Icon(Icons.close, color: Colors.red, size: 24.0)
// ,
//                             children:[
//                                 ListView.builder(
//                                   shrinkWrap: true,
//                                   itemCount:topicData[TopicList[index]]?.status?.length ?? 0,
//                                   itemBuilder:(BuildContext context,int statusIndex){
//                                        final color = getColorForStatus(topicData[TopicList[index]]?.status[statusIndex].level?? 3);
//                                        print(topicData[TopicList[index]]?.status?.length ?? 0);
//                                        print("---");
//                                        return ListTile(
//                                         onTap: (){
//                                           Navigator.push(context, MaterialPageRoute(builder: (context)=>Values(valuesData:topicData[TopicList[index]]?.status[statusIndex]?.values ?? [Value(key: 'Empty', value: 'Empty')])));
//                                         },
//                                         title: Text(topicData[TopicList[index]]?.status[statusIndex]?.name ?? 'null'),
//                                         subtitle: Text(topicData[TopicList[index]]?.status[statusIndex]?.message ?? 'null' ,style: TextStyle(color: color),),
//                                         trailing: Text(topicData[TopicList[index]]?.status[statusIndex]?.level.toString()??'null' ,style: TextStyle(color: color)),
//                                        );
//                                 }),
//                             ]
//                           ),
//                         );
//                       })
//                       ),
//           ),
//          );
//   }
//   @override
//   void dispose() {
//      ros.close();
//     super.dispose();
//   }


//   void _sendServiceRequest() async {
//     final request = {
//       'op': 'call_service',
//       'service': '/rosapi/topics',
//       'args': {}
//     };

//     try {
//       channel.sink.add(jsonEncode(request));
//     } catch (e) {
//       setState(() {
        
//       });
//     }
//   }
//    void _handleResponse(dynamic response) {
//    // print(response);
//       Map<String, dynamic> responseMap = json.decode(response);

//   // Extract topics from the response
//      List<String> topics = List<String>.from(responseMap['values']['topics']);
//      print(topics.length);
//      setState(() {
     
//        for(var i in topics){
//         if(i.endsWith("diagnostics")){
//           TopicList.add(i);
//         }
//        }
//      });
//       topicData = Map.fromIterable(
//     TopicList,
//     key: (topicName) => topicName,
//     value: (topicName) => Message(
//       header: Header(seq: 0, stamp: Stamp(secs: 0, nsecs: 0), frameId: ''),
//       status: [],
//       isTopicAvailable: false
//     ),
//   );
    
//     initializeRos();
//     // setState(() {
//     //   final Map<String, dynamic> jsonResponse = json.decode(response);

//     //   if (jsonResponse['service'] == '/run_the_file') {
//     //     print(jsonResponse['values']);
        
//     //   } else {
       
//     //     final Map<String, dynamic> values = jsonResponse['values'];
//     //     print(values['files'].runtimeType);
//     //     print("DATA LIST:");
       
//     //   }
//     // });
//   }
// }