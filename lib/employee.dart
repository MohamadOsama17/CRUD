
import 'package:flutter/foundation.dart';


class Employee {
  String name;
  int id;

  Employee({@required this.id,@required this.name});


// use for write to database(insert or update)
  Map <String , dynamic> toMap(){
    var map = <String, dynamic> {
      'id' : id,
      'name' : name
    }; 
    return map;
  }

// use for read from databae (retrive data )
  Employee.fromMap(Map<String , dynamic> map){
    id = map['id'];
    name =map['name'];
  }
}