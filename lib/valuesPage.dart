


import 'package:diagnostic_data/model/topicModel.dart';
import 'package:flutter/material.dart';

class Values extends StatefulWidget {

  final List<Value> valuesData;

  const Values({super.key,required this.valuesData});

  @override
  State<Values> createState() => _ValuesState();
}

class _ValuesState extends State<Values> {
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(

      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        
        children: [
          Container(
            height: 300,
            margin: EdgeInsets.fromLTRB(100,0, 100, 0),
            child: Scrollbar(
              thumbVisibility: true,
              child: ListView.builder(
                
                itemCount: widget.valuesData.length,
                itemBuilder: (context, index){
                        return ListTile(
                          contentPadding: EdgeInsets.only(left: 50,right: 50),
                          title: Text(widget.valuesData[index].key,style: TextStyle(color: Colors.yellow),),
                          trailing: Text(widget.valuesData[index].value,style: TextStyle(color: Colors.lightBlueAccent)),
                        );
               }
            
              ),
            )
            ),
        ],
      ),
    );
  }
}