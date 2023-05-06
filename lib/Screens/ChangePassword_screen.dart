import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:note_app/Screens/ChangePassword_Screen.dart';
import 'package:note_app/Screens/login_Screen.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _oldPasswordController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  String? _oldPasswordError;

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Verify the old password and update the new password
      try {
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          // Re-authenticate the user with the old password
          AuthCredential credential = EmailAuthProvider.credential(
              email: user.email!, password: _oldPasswordController.text);

          try {
            await user.reauthenticateWithCredential(credential);
          } on FirebaseAuthException catch (e) {
            if (e.code == 'wrong-password') {
              setState(() {
                _oldPasswordError = 'Incorrect old password.';
              });
              return;
            } else {
              throw e; // Rethrow other exceptions
            }
          }

          // Update the password
          await user.updatePassword(_newPasswordController.text);

          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Password updated successfully.'),
          ));

          // Navigate to login screen
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => LoginScreen()));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('No user is currently signed in.'),
          ));
        }
      } catch (e) {
        print('Error updating password: $e');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to update password: $e'),
        ));
      }
    }
  }

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Change Password'),
        ),
        body: Container(
          padding: EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(height: 30),
                  Text(
                    'Change Password',
                    style: TextStyle(
                        fontSize: 30,
                        color: Colors.purple,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 25),
                  // Old Password TextFormField
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (v) {
                      if (_oldPasswordError != null) {
                        String? error = _oldPasswordError;
                        _oldPasswordError = null;
                        return error;
                      }
                      if (v!.isEmpty) {
                        return ("Old password is required");
                      }
                      return null;
                    },
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Old Password",
                      hintText: "Your old password",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock),
                    ),
                    controller: _oldPasswordController,
                  ),
                  SizedBox(height: 25),
                  // New Password TextFormField
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
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
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "New Password",
                      hintText: "Your new password",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock),
                    ),
                    controller: _newPasswordController,
                  ),
                  SizedBox(height: 25),
                  // Confirm Password TextFormField
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (v) {
                      RegExp regex = RegExp(
                          r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
                      var passNonNullValue = v ?? "";
                      if (passNonNullValue.isEmpty) {
                        return ("Confirm password is required");
                      } else if (passNonNullValue !=
                          _newPasswordController.text) {
                        return 'Passwords do not match';
                      } else if (!regex.hasMatch(passNonNullValue)) {
                        return ("Password should contain upper, lower, digit, and special character");
                      }
                      return null;
                    },
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Confirm Password",
                      hintText: "Confirm your new password",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock),
                    ),
                    controller: _confirmPasswordController,
                  ),
                  SizedBox(height: 25),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: Size.fromHeight(55)),
                    onPressed: _submitForm,
                    child: Text('Change Password'),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
