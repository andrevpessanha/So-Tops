import 'package:flutter/material.dart';
import 'package:so_tops/models/user_model.dart';
import 'package:so_tops/screens/edit_screen.dart';

class DrawerTile extends StatelessWidget {

  final IconData icon;
  final String text;
  final PageController pageController;
  final int page;

  DrawerTile(this.icon, this.text, this.pageController, this.page);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: (){
          Navigator.of(context).pop();
           if(text == "Sair"){
            UserModel.of(context).signOut();
          } 
          else if(text == "Editar Perfil"){
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => EditScreen())
            );
          }
          else{
            pageController.jumpToPage(page);
          }
          
        } ,
        child: Container(
          height: 60.0,
          child: Row(
            children: <Widget>[
              Icon(
                icon, size: 20.0,
                color: pageController.page.round() == page ? Color(0xFFfacf5a) : Colors.grey,
              ),
              SizedBox(width: 32.0,),
              Text( text, 
              style: TextStyle(
                  fontSize: 17.0,
                  color: pageController.page.round() == page ? Color(0xFFfacf5a): Colors.white,
                )
              ),
            ],
          ),
        )
      ),
    );
  }
}