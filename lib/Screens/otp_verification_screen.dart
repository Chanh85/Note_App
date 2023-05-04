import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:note_app/Screens/login_screen.dart';
import 'package:note_app/Screens/resetpassword_screen.dart';

class OTPVerificationScreen extends StatefulWidget {
  final String email;

  OTPVerificationScreen({required this.email});

  @override
  _OTPVerificationScreenState createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  void _handleSubmit() {
    Navigator.push(context, MaterialPageRoute(builder: (ctx) => LoginScreen()));
  }

  void _navigateToResetPassword() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (ctx) => ResetPasswordScreen(email: widget.email)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OTP Verification'),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Enter the verification code sent at ${widget.email}',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 50),
            OTPTextField(
                length: 6,
                width: MediaQuery.of(context).size.width,
                textFieldAlignment: MainAxisAlignment.spaceAround,
                fieldWidth: 55,
                fieldStyle: FieldStyle.underline,
                otpFieldStyle: OtpFieldStyle(
                  focusBorderColor: Colors.black,
                ),
                outlineBorderRadius: 15,
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.black,
                ),
                onChanged: (pin) {
                  print("Changed: " + pin);
                },
                onCompleted: (pin) {
                  print("Completed: " + pin);
                  _navigateToResetPassword();
                }),
            SizedBox(height: 25),
            ElevatedButton(
              style: ElevatedButton.styleFrom(minimumSize: Size.fromHeight(55)),
              onPressed: _handleSubmit,
              child: Text('Verification'),
            ),
          ],
        ),
      ),
    );
  }
}
