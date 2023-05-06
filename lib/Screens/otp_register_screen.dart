import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:note_app/Screens/NoteListScreen.dart';
import 'package:note_app/Screens/login_screen.dart';

class OTPVerificationScreen extends StatefulWidget {
  final String phoneNumber;

  OTPVerificationScreen({required this.phoneNumber});

  @override
  _OTPVerificationScreenState createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final _auth = FirebaseAuth.instance;
  String _verificationId = '';
  String _otpCode = '';

  void _verifyPhoneNumber() async {
    await _auth.verifyPhoneNumber(
      phoneNumber: widget.phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
        _navigateToMainScreen();
      },
      verificationFailed: (FirebaseAuthException e) {
        // TODO: Handle failed verification
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          _verificationId = verificationId;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        setState(() {
          _verificationId = verificationId;
        });
      },
    );
  }

  Future<void> _verifyOtpAndNavigate() async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId, smsCode: _otpCode);
    try {
      // Xác thực mã OTP
      final User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        await currentUser.linkWithCredential(credential);
        _showSuccessDialogAndNavigate();
      } else {
        throw FirebaseAuthException(
            message: "No current user to link phone number",
            code: "no-current-user");
      }
    } on FirebaseAuthException catch (e) {
      // Xử lý lỗi xác thực
      _showOtpErrorDialog();
    }
  }

  void _showSuccessDialogAndNavigate() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('OTP Verification Success'),
            content: Text(
                'The entered OTP is correct. You will now be redirected to the login page.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (ctx) => LoginScreen()),
                  );
                },
              ),
            ],
          );
        });
  }

  void _showOtpErrorDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('OTP Verification Failed'),
            content: Text('The entered OTP is incorrect. Please try again.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  void _skipVerification() {
    Navigator.push(
        context, MaterialPageRoute(builder: (ctx) => NoteListScreen()));
  }

  void _navigateToMainScreen() {
    Navigator.push(
        context, MaterialPageRoute(builder: (ctx) => NoteListScreen()));
  }

  @override
  void initState() {
    super.initState();
    _verifyPhoneNumber();
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
              'Enter the verification code sent to ${widget.phoneNumber}',
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
                  _otpCode = pin;
                  print("Changed: " + pin);
                },
                onCompleted: (pin) {}),
            SizedBox(height: 25),
            ElevatedButton(
              style: ElevatedButton.styleFrom(minimumSize: Size.fromHeight(55)),
              onPressed: _verifyOtpAndNavigate,
              child: Text('Verify OTP'),
            ),
            SizedBox(height: 25),
            InkWell(
              onTap: _skipVerification,
              child: Container(
                height: 55,
                width: double.infinity,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: Theme.of(context).primaryColor,
                ),
                child: Text(
                  'Skip',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
