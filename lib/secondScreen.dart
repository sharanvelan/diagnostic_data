
// import 'package:flutter/material.dart';
// import 'package:roslibdart/roslibdart.dart';

// // class Message{

// //   final String name;
// //   final String value;
// //   final String msg;

// //   Message({required this.name,required this.value,required this.msg});

// // }



// class TopicSubscriber extends StatefulWidget {
  
//   final String topicName;

//   const TopicSubscriber({super.key,required this.topicName});
//   @override
//   _TopicSubscriberState createState() => _TopicSubscriberState();
// }

// class _TopicSubscriberState extends State<TopicSubscriber> {
//   late Ros ros;

//   late Topic topic;

//   var message;
  
//   var topicData=[];

//   Future<void> subscribeHandler(Map<String, dynamic> msg) async {
  
//   //String status=msg['status'][0]['name'];
//   // print(status);
//   print(msg);
//   print('----');

//   // Message data=Message(msg: msg['status'][0]['message'],name:msg['status'][0]['name'],value: msg['status'][0]['value'] ?? '');
//   // topicData.add(data);
  
//   // print(data.msg);
//   setState(() {});
//  }


//  Future<void> initializeRos() async {
//     // Replace 'ws://localhost:9090' with your ROS environment WebSocket URL.
//     ros = Ros(url: 'ws://10.10.0.150:9090');
//     ros.connect();

//     // Replace '/your/topic' with the actual ROS topic you want to subscribe to.
//     topic = Topic(ros:ros,name: widget.topicName,type: 'diagnostic_msgs/DiagnosticArray' ,reconnectOnClose: true, queueLength: 10, queueSize: 10);
    
//     await topic.subscribe(subscribeHandler);

//   }

//   @override
//   void initState(){
//     super.initState();

//     initializeRos();

//   }

//   @override
//   void dispose() {
//     ros.close();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('ROS WebSocket Example'),
//       ),
//       body: Center(
//         child: ListView.builder(
//           itemCount: topicData.length,
//           itemBuilder:(context, index){
//           return ListTile(
//             title: Text(topicData[index].msg),
//             subtitle: Text(topicData[index].name),
//             trailing: Text(topicData[index].value),
           
//           );

//         } )),

      
//     );
//   }
// }

