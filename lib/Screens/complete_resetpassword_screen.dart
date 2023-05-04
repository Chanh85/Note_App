import 'package:flutter/material.dart';
import 'package:note_app/Screens/login_screen.dart';

class ResetPasswordSuccessScreen extends StatelessWidget {
  void _navigateToLoginScreen(BuildContext context) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (ctx) => LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reset Password Success'),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 100,
            ),
            SizedBox(height: 25),
            Text(
              'Your password has been reset successfully!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            SizedBox(height: 25),
            Text(
              'Please login with your new password.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            SizedBox(height: 25),
            ElevatedButton(
              style: ElevatedButton.styleFrom(minimumSize: Size.fromHeight(55)),
              onPressed: () => _navigateToLoginScreen(context),
              child: Text('Go to Login'),
            ),
          ],
        ),
      ),
    );
  }
}
