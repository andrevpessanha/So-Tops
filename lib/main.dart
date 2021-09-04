import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:so_tops/models/user_model.dart';
import 'package:so_tops/screens/home_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModel<UserModel>(
      model: UserModel(),
      child:  MaterialApp(
        title: 'Só Tops',
        theme: ThemeData(
          //primarySwatch: Colors.blue,
          primaryColor: Color(0XFF233142),
          buttonColor: Color(0XFF4f9da6)
          
        ),
        debugShowCheckedModeBanner: false,
        home: HomeScreen()
      ),
    );
  }
}