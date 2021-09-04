import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:so_tops/models/user_model.dart';

class UserAvatar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(right: 15.0),
        alignment: Alignment.center,
        child:
            ScopedModelDescendant<UserModel>(builder: (context, child, model) {
          return Container(
            width: 40.0,
            height: 40.0,
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
          );
        }));
  }
}
