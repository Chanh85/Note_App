import 'package:flutter/material.dart';
import 'package:note_app/Screens/NoteListScreen.dart';
import 'package:note_app/Screens/register_screen.dart';
import 'package:note_app/Screens/forget_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isObscure = true;

  var _key = GlobalKey<FormState>();

  late FocusNode myFocusNode;

  @override
  void initState() {
    super.initState();
    myFocusNode = FocusNode();
  }

  void _handleSubmit() {
    if (_key.currentState?.validate() ?? false) {
      _key.currentState?.save();
      print(username);
      print(password);
      _key.currentState?.reset();
      myFocusNode.requestFocus();
      Navigator.push(
          context, MaterialPageRoute(builder: (ctx) => NoteListScreen()));
    } else {
      print('Invalid form');
    }
  }

  String username = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Form(
            key: _key,
            child: Column(
              children: [
                SizedBox(
                  height: 30,
                ),
                Text(
                  'Login',
                  style: TextStyle(
                      fontSize: 30,
                      color: Colors.purple,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 25,
                ),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  focusNode: myFocusNode,
                  onSaved: (v) {
                    username = v ?? '';
                  },
                  validator: (v) {
                    if (v == null || v.isEmpty || v.length < 3) {
                      return 'Please enter your username';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    labelText: "Username",
                    hintText: "Your username",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person_4),
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onSaved: (v) {
                    password = v ?? '';
                  },
                  validator: (v) {
                    RegExp regex = RegExp(
                        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
                    var passNonNullValue = v ?? "";
                    if (passNonNullValue.isEmpty) {
                      return ("Password is required");
                    } else if (passNonNullValue.length < 6) {
                      return ("Password Must be more than 5 characters");
                    } else if (!regex.hasMatch(passNonNullValue)) {
                      return ("Password should contain upper,lower,digit and Special character ");
                    }
                    return null;
                  },
                  obscureText: _isObscure,
                  enableSuggestions: false,
                  autocorrect: false,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: "Password",
                    hintText: "Password",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.password),
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _isObscure = !_isObscure;
                          });
                        },
                        icon: Icon(_isObscure
                            ? Icons.visibility
                            : Icons.visibility_off)),
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size.fromHeight(55)),
                  onPressed: _handleSubmit,
                  child: Text('Login'),
                ),
                SizedBox(
                  height: 25,
                ),
                Text.rich(
                  TextSpan(
                    text: "Don't have an account? ",
                    children: [
                      WidgetSpan(
                        child: InkWell(
                          onTap: () {},
                          child: Text(
                            "Register here",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      TextSpan(
                        text: "  |  ",
                      ),
                      WidgetSpan(
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (ctx) => ForgetPasswordScreen()));
                          },
                          child: Text(
                            "Forget Password",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
