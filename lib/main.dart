import 'package:flutter/material.dart';
import 'employee.dart';
import './db_helper.dart';

void main()=>runApp(MyApp());


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  
  final formKey = GlobalKey<FormState>();
  var controller =TextEditingController();
  DBHelper dbHelper;
  String name;
  int curuntUsrId;
  bool isUpdating;
  Future<List<Employee>> employees;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dbHelper=DBHelper();
    isUpdating=false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.blueGrey.shade900,
      appBar: AppBar(
        title: Text('CRUD',),
        centerTitle: true,
        backgroundColor: Colors.redAccent.shade400,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: <Widget>[
            form(),
            SizedBox(
            height: 20,
          ),
            list(),
          ],
        ),
      ),
    );
  }

  form(){
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(top: 30),
            child: TextFormField(
              controller: controller,
              decoration: InputDecoration(
                labelText: 'Name',
                labelStyle: TextStyle(
                  color: Colors.redAccent.shade700,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                )
              ),
              validator: (val)=>val.length==0?'Enter VALUE':null,
              onSaved: (val)=> name=val,
            ),
          ),SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FlatButton(
                child: Text(isUpdating?'SAVE' : 'ADD'),
                onPressed: validate,
              ),
            ],
          ),
        ],
      ),
    );
  }
  validate(){
    var formState =formKey.currentState;
    if(formState.validate()){
      formState.save();
      if(isUpdating){
        Employee e = Employee(id: curuntUsrId,name: name);
        dbHelper.update(e);
        setState(() {
          isUpdating=false;
        });
        
      }else{
      Employee e =Employee(id: null,name: name);
      dbHelper.save(e);
      }
      clearName();
      refreshList();
    }
  }


  clearName(){
    setState(() {
      controller.text='';
    });
  }


  refreshList(){
    setState(() {
      employees = dbHelper.getEmployees();
    });
  }

  list(){
    return Expanded(
      child:FutureBuilder(
        future: employees,
        //initialData: InitialDatida,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if(snapshot.hasData){
            return dataTable(snapshot.data);
          }
          if(null==snapshot.data||snapshot.data.lenght==0){
            return Center(child: Text('No Data Found'));
          }
          return CircularProgressIndicator();
        },
      ),);
  }

  SingleChildScrollView dataTable(List<Employee> employees){
    
    return SingleChildScrollView(
        child: DataTable(
        columns: [
          DataColumn(label: Text('Name')),
          DataColumn(label: Text('Delete'))
        ],
        rows: employees.map((emp)=>DataRow(
          cells: [
            DataCell(
              Text(emp.name),
              onTap: (){
                setState(() {
                  isUpdating=true;
                  curuntUsrId =emp.id;

                });
                controller.text=emp.name;
              }
            ),
            DataCell(
              IconButton(
                onPressed: (){
                  dbHelper.delete(emp.id);
                  refreshList();
                },
                icon: Icon(Icons.delete , color: Colors.redAccent.shade700,),
              )
            )
            ]
        )).toList(),
      ),
    );
  }
}