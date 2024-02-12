import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter PostgreSQL Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  @override
  void initState() {
    super.initState();
    connectToDatabase();
  }

  void connectToDatabase() async {
    try {
      final conn = await Connection.open(Endpoint(
        host: 'localhost',
        port: 5433,
        database: 'app',
        username: 'administrador',
        password: 'administrador',
      )
    );

    

      print('Database Connected!');

      // Add the user 'adria' to the database
      
    } catch (e) {
      print('Error connecting to database: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter PostgreSQL Demo'),
      ),
      body: Center(
        child: Text(
          'Check console for database connection status!',
          style: TextStyle(fontSize: 20.0),
        ),
      ),
    );
  }

 
}
