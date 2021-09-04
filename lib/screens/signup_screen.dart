import 'dart:io';
import 'package:flutter/material.dart';
import 'package:so_tops/models/user_model.dart';
import 'package:so_tops/screens/login_screen.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:so_tops/widgets/custom_button.dart';


final formKey = GlobalKey<FormState>();
final scaffoldKey = GlobalKey<ScaffoldState>();

final nameController = TextEditingController();
final emailController = TextEditingController();
final passController = TextEditingController();

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  File userFoto;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("Criar Conta"),
        centerTitle: true,
      ),
      body: ScopedModelDescendant<UserModel>(builder: (context, child, model) {
        if (model.isLoading) {
          return Center(child: CircularProgressIndicator());
        }
        return Form(
          key: formKey,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 50.0),
            children: <Widget>[
              GestureDetector(
                onTap: (){
                  editarFoto(context);
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 70.0),
                  width: 140.0,
                  height: 140.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.transparent,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: userFoto != null ? 
                    FileImage(File(userFoto.path)) : AssetImage("assets/user.png"),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.yellow)),
                  hintText: "Nome",
                ),
                validator: (text) {
                  if (text.isEmpty) return "Nome Inválido!";
                },
              ),
              SizedBox(height: 10.0),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: "E-mail",
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (text) {
                  if (text.isEmpty || !text.contains("@"))
                    return "E-mail inválido!";
                },
              ),
              SizedBox(
                height: 10.0,
              ),
              TextFormField(
                controller: passController,
                decoration: InputDecoration(hintText: "Senha"),
                obscureText: true,
                validator: (text) {
                  if (text.isEmpty || text.length < 4) return "Senha inválida!";
                },
              ),
              SizedBox(
                height: 10.0,
              ),
              SizedBox(height: 40.0),
              Padding(
                padding: const EdgeInsets.only( bottom: 20.0),
                child: InkWell(
                  onTap: () async{
                    if (formKey.currentState.validate()) {
                      
                      Map<String, dynamic> userData;
                      if(userFoto != null){
                         userData = {
                          "name": nameController.text,
                          "email": emailController.text,
                          "foto": userFoto.path
                        };
                      }
                      else{
                        userData = {
                          "name": nameController.text,
                          "email": emailController.text,
                          "foto" : ""
                        };
                      }
                      
                      model.signUp(
                          userData: userData,
                          pass: passController.text,
                          onSuccess: onSuccess,
                          onFail: onFail
                      );
                      
                    }
                  },
                  child: CustomButton("Cadastrar"),
                ),
              ),

               Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Já possui conta?",
                      style: TextStyle(fontSize: 12.0)),
                      FlatButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => LoginScreen())
                        );
                      },
                      child: Text(
                        "Fazer Login", 
                        style: TextStyle(
                            fontSize: 12.0,
                            color: Theme.of(context).buttonColor)
                      ),
                    ),
                    ],
                  ),
              
                 
            ],
          ),
        );
      }),
    );
  }

  void onSuccess() {
    Navigator.of(context).pop();
  
  }

  void onFail({@required String errorMsg, @required bool error}) {
    scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(
        errorMsg,
        textAlign: TextAlign.center,
      ),
      backgroundColor:
          (error) ? Colors.redAccent : Theme.of(context).primaryColor,
      duration: Duration(seconds: 2),
    ));
  }

  void editarFoto(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return BottomSheet(
              onClosing: () {},
              builder: (context) {
                return Container(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      FlatButton(
                        child: Text(
                          "Tirar Foto",
                          style: TextStyle(fontSize: 20.0),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          ImagePicker.pickImage(source: ImageSource.camera)
                              .then((file) {
                            if (file == null) return;
                            setState(() {
                              userFoto = file;
                            });
                          });
                        },
                      ),
                      Divider(),
                      FlatButton(
                        child: Text(
                          "Abrir Galeria",
                          style: TextStyle(fontSize: 20.0),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          ImagePicker.pickImage(source: ImageSource.gallery, maxWidth: 1920)
                              .then((file) {
                            if (file == null) return;
                            setState(() {
                              userFoto = file;
                            });
                          });
                        },
                      ),
                    ],
                  ),
                );
              });
        });
  }
}
