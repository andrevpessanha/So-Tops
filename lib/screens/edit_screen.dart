import 'dart:io';
import 'package:flutter/material.dart';
import 'package:so_tops/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:so_tops/widgets/custom_button.dart';



final formKey = GlobalKey<FormState>();
final scaffoldKey = GlobalKey<ScaffoldState>();

TextEditingController nameController;

class EditScreen extends StatefulWidget {
  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {

  File userFoto;

  @override
  void initState() {
    super.initState();
      nameController = TextEditingController(text: UserModel.of(context).userData["name"]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
            title: Text("Editar Perfil"),
            centerTitle: true,
      ),
      key: scaffoldKey,
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
                    FileImage(File(userFoto.path)) : model.userData["foto"] != "" ?  NetworkImage(model.userData["foto"]) : AssetImage("assets/user.png") ,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  hintText: "Nome",
                ),
                validator: (text) {
                  if (text.isEmpty) return "Nome Inválido!";
                },
              ),
              SizedBox(height: 50.0),

              Container(
                padding: const EdgeInsets.only(bottom: 80.0),
                child: InkWell(
                  onTap: () {
                    if (formKey.currentState.validate()) {
                      Map<String, dynamic> userData;

                      if(userFoto != null){
                        userData = {
                          "name" : nameController.text,
                          "foto" : userFoto.path
                        };
                      }
                      else{
                        userData = {
                          "name" : nameController.text,
                          "foto" : model.userData["foto"]
                        };
                      }
                      
                      model.updateUserData(userData);
                      Navigator.of(context).pop();
                    }
                  },
                  child: CustomButton("Atualizar"),
                ),
              ),
                
              SizedBox(height: 20.0),
            ],
          ),
        );
      }),
    );
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
                          ImagePicker.pickImage(source: ImageSource.camera, maxWidth: 1920)
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
                          ImagePicker.pickImage(source: ImageSource.gallery)
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
