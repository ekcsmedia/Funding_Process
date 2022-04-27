import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:flutter/material.dart';
import 'package:loan_app_dsa/main.dart';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PhoneVerify extends StatelessWidget {

  String phone;
  String name;
  String loanType;
  String employment;

  PhoneVerify({Key? key, required this.name, required this.phone,required this.loanType, required this.employment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FirebasePhoneAuthProvider(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: VerifyPhoneNumberScreen(phoneNumber: phone, name: name, loanType: loanType, employment: employment),
      ),
    );
  }
}

// ignore: must_be_immutable
class VerifyPhoneNumberScreen extends StatefulWidget {

  final String phoneNumber;
  final String name;
  final String loanType;
  final String employment;


  VerifyPhoneNumberScreen({
    Key? key,
    required this.phoneNumber,
    required this.name,
    required this.loanType,
    required this.employment

  }) : super(key: key);

  @override
  State<VerifyPhoneNumberScreen> createState() => _VerifyPhoneNumberScreenState();
}

class _VerifyPhoneNumberScreenState extends State<VerifyPhoneNumberScreen> {
  bool visible = false;

  String? _enteredOTP;

  Future userRegistration(name, phone, loanType, employment) async {
    // Showing CircularProgressIndicator.
    setState(() {
      visible = true;
    });

    // Getting value from Controller
    String username = name;
    String userphone = phone;
    String userloanType = loanType;
    String useremployment = employment;

    print(username);
    print(userphone);
    print(userloanType);
    print(useremployment);


    // SERVER API URL
    var url =
        'https://www.loandsa.kcswebtechnologies.com/loan_user_registration.php';

    // Store all data with Param Name.
    var data = {
      'name': username,
      'mobile': userphone,
      'loan': userloanType,
      'employment': useremployment
    };

    // Starting Web API Call.
    var response = await http.post(Uri.parse(url), body: json.encode(data));

    // Getting Server response into variable.
    var message = jsonDecode(response.body);

    // If Web call Success than Hide the CircularProgressIndicator.
    if (response.statusCode == 200) {
      setState(() {
        visible = false;
      });
    }

    // Showing Alert Dialog with Response JSON Message.
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(message),
          actions: <Widget>[
            FlatButton(
              child: new Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showSnackBar(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text,
      style: TextStyle(color: Colors.amberAccent),),
      backgroundColor: Colors.black,
      duration: Duration(seconds: 15),),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FirebasePhoneAuthHandler(
        phoneNumber: widget.phoneNumber,
        timeOutDuration: const Duration(seconds: 60),
        onLoginSuccess: (userCredential, autoVerified) async {
          userRegistration(widget.name, widget.phoneNumber, widget.loanType, widget.employment);

          Center(
            child: Container(
              color: Colors.black.withOpacity(0.5),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  'Congratulations!!!...'
                      'Your details has been recorded - We are processing your loan request'
                      'Our agent will contact you soon !!!',
                  style: TextStyle(
                    color: Colors.amberAccent
                  ),
                ),
              ),
            ),
          );

          _showSnackBar(
            context,
            'Congratulations!!!...'
            'Your details has been recorded - We are processing your loan request'
                'Our agent will contact you soon..',

          );

          debugPrint(
            autoVerified
                ? "OTP was fetched automatically"
                : "OTP was verified manually",
          );

          debugPrint("Login Success UID: ${userCredential.user?.uid}");
        },
        onLoginFailed: (authException) {
          _showSnackBar(
            context,
            'Something went wrong (${authException.message})',
          );

          debugPrint(authException.message);
          // handle error further if needed
        },
        builder: (context, controller) {
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: true,
              title: const Text("Verify Phone Number",
              style: TextStyle(
                  color: Colors.black)),
              centerTitle: true,
              backgroundColor: Colors.amberAccent,
              actions: [
                if (controller.codeSent)
                  TextButton(
                    child: Text(
                      controller.timerIsActive
                          ? "${controller.timerCount.inSeconds}s"
                          : "RESEND",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    ),
                    onPressed: controller.timerIsActive
                        ? null
                        : () async => await controller.sendOTP(),
                  ),
                const SizedBox(width: 5),
              ],
            ),
            body: Container(
              height: double.infinity,
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(
                        "https://www.loandsa.kcswebtechnologies.com/moneygoldbag.jpg"),
                    fit: BoxFit.cover),
              ),
              child: controller.codeSent
                  ? ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  Text(
                    "We've sent an SMS with a verification code to ${widget.phoneNumber}",
                    style: const TextStyle(
                      color: Colors.amberAccent,
                      fontSize: 25,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Divider(),
                  AnimatedContainer(
                    duration: const Duration(seconds: 1),
                    height: controller.timerIsActive ? null : 0,
                    child: Column(
                      children: const [
                        CircularProgressIndicator.adaptive(),
                        SizedBox(height: 50),
                        Text(
                          "Listening for OTP",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.amberAccent,
                            fontSize: 25,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Divider(),
                        Text("OR", textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.amberAccent,
                        ),),
                        Divider(),
                      ],
                    ),
                  ),

                  TextField(
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                        labelText: 'Enter Your OTP Here',
                        labelStyle: TextStyle(
                            color: Colors.amberAccent
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.amberAccent, width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.amberAccent, width: 2.0),
                        ),
                        hintText: 'Enter Your OTP',
                        hintStyle: TextStyle(color: Colors.amberAccent),
                        focusColor: Colors.amberAccent,
                        fillColor: Colors.white),
                    maxLength: 6,
                    keyboardType: TextInputType.number,
                    onChanged: (String v) async {
                      _enteredOTP = v;
                      if (_enteredOTP?.length == 6) {
                        final isValidOTP = await controller.verifyOTP(
                          otp: _enteredOTP!,
                        );
                        // Incorrect OTP
                        if (!isValidOTP) {
                          _showSnackBar(
                            context,
                            "Please enter the correct OTP sent to ${widget.phoneNumber}",
                          );
                        }
                      }
                    },
                  ),
                ],
              )
                  : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  CircularProgressIndicator.adaptive(),
                  SizedBox(height: 50),
                  Center(
                    child: Text(
                      "Sending OTP",
                      style: TextStyle(fontSize: 25),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}