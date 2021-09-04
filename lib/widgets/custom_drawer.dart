import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:so_tops/models/user_model.dart';
import 'package:so_tops/screens/login_screen.dart';
import 'package:so_tops/tiles/drawer_tile.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomDrawer extends StatelessWidget {
  final PageController pageController;

  CustomDrawer(this.pageController);

  @override
  Widget build(BuildContext context) {
    Widget buildDrawerGradient() => Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            Color(0XFF3c415e),
            Color(0XFF233142),
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        );

    return Drawer(
      child: Stack(
        children: <Widget>[
          buildDrawerGradient(),
          ListView(
            padding: EdgeInsets.only(left: 32.0, top: 16.0),
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: 8.0),
                padding: EdgeInsets.fromLTRB(0.0, 16.0, 16.0, 8.0),
                height: 170.0,
                child: Stack(
                  children: <Widget>[
                    Positioned(
                        left: 0.0,
                        bottom: 0.0,
                        child: ScopedModelDescendant<UserModel>(
                            builder: (context, child, model) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 70.0),
                                width: 90.0,
                                height: 90.0,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.transparent,
                                  image: DecorationImage(
                                    
                                    fit: BoxFit.cover,
                                    image: model.isLoggedIn()
                                        ? model.userData["foto"] != "" ? NetworkImage(model.userData["foto"]) : AssetImage("assets/user.png")
                                        : AssetImage("assets/user.png"),
                                  ),
                                ),
                              ),
                              SizedBox(height: 2.0),
                              Text(
                                  "Olá, ${!model.isLoggedIn() ? "seja bem-vindo!" : model.userData["name"]}",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(height: 10.0),
                              !model.isLoggedIn() ?
                              GestureDetector(
                                child: Text(
                                     "Entrar ou Criar Conta",
                                      style: TextStyle(
                                        color: Color(0xFFfacf5a),
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold)),
                                onTap: () {
                                  if (!model.isLoggedIn()) {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                LoginScreen()));
                                  }
                                },
                              ) : Container(),
                            ],
                          );
                        })),
                  ],
                ),
              ),
              Divider(),
              DrawerTile(FontAwesomeIcons.home, "Início", pageController, 0),  
              DrawerTile(Icons.location_on, "Dicas", pageController, 1),
              DrawerTile(
                  FontAwesomeIcons.solidStar, "Favoritos", pageController, 2),
              Container(
                child: ScopedModelDescendant<UserModel>(
                  builder: (context, child, model){
                    
                    return model.isLoggedIn() ?
                    Column(
                      children: <Widget>[
                        DrawerTile(FontAwesomeIcons.userEdit, "Editar Perfil",pageController, 3),
                        DrawerTile(FontAwesomeIcons.signOutAlt, "Sair",pageController, 0)
                      ],
                    ) : Container(); 
                  },
                ),
              )
              
            ],
          ),
        ],
      ),
    );
  }
}
