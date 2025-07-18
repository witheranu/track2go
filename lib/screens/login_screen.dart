import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'passenger_map.dart';
import 'conductor_map.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController otpController = TextEditingController();

  String? verificationId;
  String userRole = 'passenger'; // default role
  bool showOtpField = false;
  bool isLoading = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void sendOtp() async {
    final phone = phoneController.text.trim();

    if (phone.length != 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a valid 10-digit phone number')),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: '+91$phone',
        verificationCompleted: (PhoneAuthCredential credential) async {
          // For instant verification
          await _auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Verification failed: ${e.message}')),
          );
          setState(() => isLoading = false);
        },
        codeSent: (String id, int? token) {
          setState(() {
            verificationId = id;
            showOtpField = true;
            isLoading = false;
          });
        },
        codeAutoRetrievalTimeout: (String id) {
          verificationId = id;
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error sending OTP: $e')),
      );
      setState(() => isLoading = false);
    }
  }

  void verifyOtp() async {
    final otp = otpController.text.trim();

    if (otp.length != 6 || verificationId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a valid 6-digit OTP')),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId!,
        smsCode: otp,
      );

      final userCred = await _auth.signInWithCredential(credential);

      await _firestore.collection('users').doc(userCred.user!.uid).set({
        'phone': userCred.user!.phoneNumber,
        'type': userRole,
      });

      setState(() => isLoading = false);

      if (userRole == 'passenger') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const PassengerMapScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const ConductorMapScreen()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('OTP Verification Failed')),
      );
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration:
                    const InputDecoration(labelText: "Enter phone number"),
              ),
              if (!showOtpField) ...[
                const SizedBox(height: 20),
                DropdownButton<String>(
                  value: userRole,
                  items: const [
                    DropdownMenuItem(
                        value: 'passenger', child: Text("Passenger")),
                    DropdownMenuItem(
                        value: 'conductor', child: Text("Conductor")),
                  ],
                  onChanged: (value) {
                    setState(() => userRole = value!);
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: isLoading ? null : sendOtp,
                  child: isLoading
                      ? const CircularProgressIndicator()
                      : const Text("Send OTP"),
                ),
              ],
              if (showOtpField) ...[
                const SizedBox(height: 20),
                TextField(
                  controller: otpController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: "Enter OTP"),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: isLoading ? null : verifyOtp,
                  child: const Text("Verify OTP & Login"),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
