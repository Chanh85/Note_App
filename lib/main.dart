import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  bool _isObscure = true;

  var _key = GlobalKey<FormState>();

  late FocusNode myFocusNode;

  @override
  void initState() {
    super.initState();
    myFocusNode = FocusNode();
  }

  void _handleSubmit(){
    if(_key.currentState?.validate() ?? false)
      {
        _key.currentState?.save();
        print(fullname);
        print(username);
        print(email);
        print(password);
        _key.currentState?.reset();
        myFocusNode.requestFocus();
      }
    else
      {
        print('Invalid form');
      }
  }

  String fullname = '';
  String username = '';
  String email = '';
  String password = '';


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Note'),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Form(
            key: _key,
            child: Column(
              children: [
                SizedBox(height: 30,),
                Text('User Registration', style: TextStyle(fontSize: 30, color: Colors.blue, fontWeight: FontWeight.bold),),
                SizedBox(height: 25,),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  focusNode: myFocusNode,
                  onSaved: (v){
                    fullname = v ?? '';
                  },
                  validator: (v){
                    if(v  == null || v.isEmpty || v.length < 3)
                      {
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
                SizedBox(height: 25,),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onSaved: (v){
                    username = v ?? '';
                  },
                  validator: (v){
                    if(v  == null || v.isEmpty || v.length < 3)
                    {
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
                SizedBox(height: 25,),
                TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  onSaved: (v){
                    email = v?? '';
                  },
                  validator: (v) => EmailValidator.validate(v!) ? null : 'Please enter a valid email',
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: "Email",
                    hintText: "Email",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                ),
                SizedBox(height: 25,),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onSaved: (v){
                    password = v??'';
                  },
                  validator: (v){
                    RegExp regex=RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
                    var passNonNullValue=v??"";
                    if(passNonNullValue.isEmpty){
                      return ("Password is required");
                    }
                    else if(passNonNullValue.length<6){
                      return ("Password Must be more than 5 characters");
                    }
                    else if(!regex.hasMatch(passNonNullValue)){
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
                        onPressed: (){
                          setState(() {
                            _isObscure = !_isObscure;
                          });
                        },
                        icon: Icon(_isObscure ? Icons.visibility : Icons.visibility_off)
                    ),
                  ),
                ),
                SizedBox(height: 25,),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(minimumSize: Size.fromHeight(55)),
                    onPressed: _handleSubmit,
                    child: Text('Login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
