import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:note_app/Screens/resetpassword_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OTPVerificationScreen extends StatefulWidget {
  final String phoneNumber;
  final String verificationId;

  OTPVerificationScreen({
    required this.phoneNumber,
    required this.verificationId,
  });

  @override
  _OTPVerificationScreenState createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  void _navigateToResetPassword(PhoneAuthCredential credential) async {
    // Sign in with the provided credential
    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      print("Error signing in with the provided credential: $e");
    }

    // Navigate to the Reset Password screen
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (ctx) =>
                ResetPasswordScreen(phoneNumber: widget.phoneNumber)));
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
              'Enter the verification code sent at ${widget.phoneNumber}',
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
                  final credential = PhoneAuthProvider.credential(
                      verificationId: widget.verificationId, smsCode: pin);
                  _navigateToResetPassword(credential);
                }),
            SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}
