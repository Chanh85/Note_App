import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:note_app/Screens/otp_register_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _auth = FirebaseAuth.instance;
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
    print(fullname);
    print(username);
    print(email);
    print(phoneNumber);
    print(password);
    _key.currentState?.reset();
    myFocusNode.requestFocus();

    _auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((result) {
      // Đăng nhập thành công, chuyển đến màn hình OTP
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (ctx) =>
                  OTPVerificationScreen(phoneNumber: phoneNumber)));
    }).catchError((error) {
      // Xử lý lỗi đăng ký
      print("Error: $error");
    });
  } else {
    print('Invalid form');
  }
}

  String fullname = '';
  String username = '';
  String email = '';
  String phoneNumber = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
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
                  'Registration',
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
                    fullname = v ?? '';
                  },
                  validator: (v) {
                    if (v == null || v.isEmpty || v.length < 3) {
                      return 'Please enter your full name';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    labelText: "Full name",
                    hintText: "Your full name",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
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
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onSaved: (v) {
                    email = v ?? '';
                  },
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return 'Please enter your email';
                    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(v)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: "Email",
                    hintText: "Your email",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onSaved: (v) {
                    phoneNumber = v ?? '';
                  },
                  validator: (v) {
                    if (v == null || v.isEmpty || v.length < 10) {
                      return 'Please enter a valid phone number';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: "Phone Number",
                    hintText: "Your phone number",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.phone),
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
                      return ("Password should contain upper, lower, digit, and special character");
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
                  child: Text('Sign Up'),
                ),
                SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
