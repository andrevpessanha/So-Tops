import 'package:flutter/material.dart';
import 'package:so_tops/animation/button_animation.dart';
import 'package:so_tops/models/user_model.dart';
import 'package:so_tops/screens/signup_screen.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:so_tops/widgets/custom_button.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final emailController = TextEditingController();
  final passController = TextEditingController();

  AnimationController loginButtonController;
  var animationStatus = 0;

  Future<Null> playAnimation() async {
    try {
      await loginButtonController.forward();
      await loginButtonController.reverse();
    } on TickerCanceled {}
  }

  @override
  void initState() {
    super.initState();
    loginButtonController = new AnimationController(
      duration: Duration(milliseconds: 3000),
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: Text("Entrar"),
          centerTitle: true,
        ),
        body: ScopedModelDescendant<UserModel>(
          builder: (context, child, model) {
            return ListView(
              padding: const EdgeInsets.all(0.0),
              children: <Widget>[
                Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 50.0, vertical: 150.0),
                          child: Form(
                            key: formKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
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
                                SizedBox(height: 10.0),
                                TextFormField(
                                  controller: passController,
                                  decoration:
                                      InputDecoration(hintText: "Senha"),
                                  obscureText: true,
                                  validator: (text) {
                                    if (text.isEmpty || text.length < 4)
                                      return "Senha inválida!";
                                  },
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: FlatButton(
                                    onPressed: () {
                                      if (emailController.text.isEmpty) {
                                        onFail(
                                            errorMsg:
                                                "Insira um E-mail válido para recuperar a senha",
                                            error: true);
                                      } else {
                                        model.recoverPass(emailController.text);
                                        onFail(
                                            errorMsg: "Confira seu e-mail!",
                                            error: false);
                                      }
                                    },
                                    padding: EdgeInsets.zero,
                                    child: Text("Esqueci minha senha",
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                            fontSize: 12.0,
                                            color:
                                                Theme.of(context).buttonColor)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    animationStatus == 0
                        ? Padding(
                            padding: const EdgeInsets.only(bottom: 80.0),
                            child: InkWell(
                              onTap: () {
                                if (formKey.currentState.validate()) {
                                  model.signIn(
                                    email: emailController.text,
                                    pass: passController.text,
                                    onSuccess: onSuccess,
                                    onFail: onFail);
                                }
                              },
                              child: CustomButton("Entrar"),
                            ),
                          )
                        : StaggerAnimation(
                            buttonController: loginButtonController.view),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("Não possui conta?",
                              style: TextStyle(fontSize: 12.0)),
                          FlatButton(
                            onPressed: () {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) => SignUpScreen()));
                            },
                            child: Text("Criar Conta",
                                style: TextStyle(
                                    fontSize: 12.0,
                                    color: Theme.of(context).buttonColor)),
                          ),
                        ]),
                  ],
                ),
              ],
            );
          },
        ));
  }

  void onSuccess() {
    setState(() {
      animationStatus = 1;
    });
    playAnimation();
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
}
