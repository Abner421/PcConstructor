import 'package:pc_constructor/screens/homeScreen.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  static Route<dynamic> route() {
    return MaterialPageRoute(
      builder: (context) => LoginScreen(),
    );
  }

  @override
  _LoginScreenState createState() =>
      _LoginScreenState(); // Importante para la creación de estados y buen funcionamiento
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;

  GlobalKey<FormState> _key = GlobalKey();

  RegExp emailRegExp = new RegExp(
      r'^\w+[\w-\.]*\@\w+((-\w+)|(\w*))\.[a-z]{2,3}$'); //Expresión para validación de correo
  RegExp contRegExp = new RegExp(
      r'^([1-zA-Z0-1@.\s]{1,255})$'); //Expresión para validación de contraseña
  String _correo;
  String _contrasena;
  String mensaje = '';

  bool _logged = false;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    animation = CurvedAnimation(parent: controller, curve: Curves.easeIn);
    //    Animación adicional opcional
    //    animation.addStatusListener((status) {
    //      if (status == AnimationStatus.completed) {
    //        controller.reverse();
    //      } else if (status == AnimationStatus.dismissed) {
    //        controller.forward();
    //      }
    //    });

    controller.forward();
  }

  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _logged ? HomeScreen(mensaje: mensaje) : loginForm(),
    );
  }

  Widget loginForm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AnimatedLogo(animation: animation),
          ],
        ),
        Container(
          width: 300.0, //size.width * .6
          child: Form(
            key: _key,
            child: Column(
              children: <Widget>[
                TextFormField(
                  validator: (text) {
                    if (text.length == 0) {
                      return "El campo email no puede ir vacío";
                    } else if (!emailRegExp.hasMatch(text)) {
                      return "Formato de email incorrecto";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                  maxLength: 50,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: 'Ingresa tu email',
                    labelText: 'Email',
                    counterText: '',
                    icon:
                        Icon(Icons.email, size: 32.0, color: Colors.blue[800]),
                  ),
                  onSaved: (text) => _correo = text,
                ),
                TextFormField(
                  validator: (text) {
                    if (text.length == 0) {
                      return "El campo de contraseña es requerido";
                    } else if (text.length <= 5) {
                      return "La contraseña debe contener al menos 5 caracteres";
                    } else if (!contRegExp.hasMatch(text)) {
                      return "La contraseña no cumple los requisitos";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.text,
                  maxLength: 20,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: 'Ingresa tu contraseña',
                    labelText: 'Contraseña',
                    counterText: '',
                    icon: Icon(Icons.lock, size: 32.0, color: Colors.blue[800]),
                  ),
                  onSaved: (text) => _contrasena = text,
                ),
                IconButton(
                  onPressed: () {
                    if (_key.currentState.validate()) {
                      _key.currentState.save();
                      //API para login
                      setState(() {
                        _logged = true;
                      });
                      mensaje =
                          'Registrado con:  \nCorreo: $_correo \n Contraseña: $_contrasena';
                      //Navigator.of(context).push(HomeScreen.route(mensaje));
                    }
                  },
                  icon: Icon(
                    Icons.arrow_forward,
                    size: 42.0,
                    color: Colors.blue[800],
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class AnimatedLogo extends AnimatedWidget {
  //Tweens estáticos, no cambian
  static final _opacityTween = Tween<double>(begin: 0.1, end: 1.0);
  static final _sizeTween = Tween<double>(begin: 0.0, end: 150.0);

  AnimatedLogo({Key key, Animation<double> animation})
      : super(key: key, listenable: animation);

  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;
    return Opacity(
      opacity: _opacityTween.evaluate(animation),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10.0),
        height: _sizeTween.evaluate(animation),
        width: _sizeTween.evaluate(animation),
        child: FlutterLogo(),
      ),
    );
  }
}
