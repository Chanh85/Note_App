import 'package:flutter/material.dart';
import 'package:note_app/Screens/otp_verification_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgetPasswordScreenState createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  String phoneNumber = '';
  String _verificationId = '';

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Hàm này sẽ được gọi khi xác minh tự động hoàn tất
          try {
            await FirebaseAuth.instance.signInWithCredential(credential);
            // Lưu trữ verificationId để kiểm tra mã OTP sau
            setState(() {
              _verificationId = credential.verificationId!;
            });
            // Chuyển đến màn hình OTP Verification
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (ctx) => OTPVerificationScreen(
                  phoneNumber: phoneNumber,
                  verificationId: _verificationId,
                ),
              ),
            );
          } catch (e) {
            print('Error with auto-verification: $e');
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          // Xử lý lỗi xác minh tại đây
          print('Verification failed: ${e.message}');
        },
        codeSent: (String verificationId, int? resendToken) {
          // Lưu trữ verificationId để kiểm tra mã OTP sau
          setState(() {
            _verificationId = verificationId;
          });
          // Chuyển đến màn hình OTP Verification
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (ctx) => OTPVerificationScreen(
                phoneNumber: phoneNumber,
                verificationId: _verificationId,
              ),
            ),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // Hàm này sẽ được gọi khi hết thời gian tự động lấy mã
          print('Auto-retrieval timeout: $verificationId');
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forget Password'),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(
                  height: 30,
                ),
                Text(
                  'Forget Password',
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
                  onSaved: (value) {
                    phoneNumber = value ?? '';
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    if (!RegExp(r'^(\+\d{1,3}[- ]?)?\d{10}$').hasMatch(value)) {
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
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size.fromHeight(55)),
                  onPressed: _submitForm,
                  child: Text('Send OTP'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
