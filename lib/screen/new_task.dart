import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;
import 'package:meal_analyzer_app/models/new_model.dart';

class NewTask extends StatefulWidget {
  const NewTask({super.key});

  @override
  State<NewTask> createState() => _NewTaskState();
}

class _NewTaskState extends State<NewTask> {
List<dynamic> dataList=[];
   Future<List<NewModel>> fetchData ()async{
     final response=await  http.get(Uri.parse('https://jsonplaceholder.typicode.com/todos'));
     if(response.statusCode==200){

      final List<dynamic>  dataListee= jsonDecode(response.body);

       print(dataList);

     // return dataListee.map((e) => NewModel.fromJson(e)).toList();
      return dataListee.map((e) => NewModel.fromJson(e),).toList();
     }
     else{
       throw Exception('Failed to load data');
     }




  }
  @override
  Widget build(BuildContext context) {
 return Scaffold(
   body: Container(
     child: FutureBuilder(future: fetchData(), builder:(context, snapshot) {
       var tdata=snapshot.data;
       if(snapshot.connectionState==ConnectionState.waiting){
         return CircularProgressIndicator();
       }
       if(!snapshot.hasData){
         return CircularProgressIndicator();
       }


       return ListView.builder(
         itemCount: snapshot.data!.length,
         itemBuilder: (context, index) {





         return ListTile(
          // title:Text('hi'),
          title:  Text(tdata![index].title),
           // leading: Text(dataList[index]['id'].toString()),
           // trailing: Checkbox(value:dataList[index]['completed'] , onChanged: (value) {
           //   dataList[index]['completed']=!dataList[index]['completed'];
           //   setState(() {
           //
           //   });
           //
           // },),
         );
       },);
     },),
   ),
 );
  }
}
