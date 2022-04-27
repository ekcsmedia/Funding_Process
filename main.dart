import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_core/firebase_core.dart';
import 'package:loan_app_dsa/phone_verify.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

// import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Splash Screen',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 3),
        () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MyAppHome())));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Image.asset('assets/images/logodsa.png'),
    );
  }
}

class MyAppHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.amberAccent,
              leading: IconButton(
                icon: const Icon(Icons.menu, color: Colors.black),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
              title: Text('FUNDING PROCESS',
                  style: TextStyle(
                    color: Colors.black,
                  )),
              centerTitle: true,
            ),
            body: Center(child: RegisterUser())));
  }
}

class RegisterUser extends StatefulWidget {
  RegisterUserState createState() => RegisterUserState();
}

class RegisterUserState extends State {
  // Boolean variable for CircularProgressIndicator.
  bool visible = false;

  // Getting value from TextField widget.
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  String employment = 'Salaried';
  String loanType = 'Personal Loans';

  var employmentList = ['Salaried', 'Self Employed', 'None'];

  var loansList = [
    'Personal Loans',
    'Credit Card Loans',
    'Home Loans',
    'Car Loans',
    'Two-Wheeler Loans',
    'Small Business Loans',
    'Payday Loans',
    'Cash Advances',
    'Home Renovation Loan',
    'Agriculture Loan',
    'Gold Loan',
    'Loan Against Credit Cards',
    'Education Loan',
    'Consumer Durable Loan',
    'Loan Against the Insurance Schemes',
    'Loan Against Fixed Deposits',
    'Loan Against Mutual Funds and Shares'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: NetworkImage(
                "https://www.loandsa.kcswebtechnologies.com/moneygoldbag.jpg"),
            fit: BoxFit.cover),
      ),
      child: Center(
        child: Column(
          children: <Widget>[
            Divider(),
            Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text('User Loan Registration Form',
                    style: TextStyle(fontSize: 21, color: Colors.white))),
            Divider(),
            Container(
                width: 380,
               color: Colors.black.withOpacity(0.5),
               // padding: EdgeInsets.all(10.0),
                child: TextField(
                  controller: nameController,
                  style: TextStyle(color: Colors.white),
                  autocorrect: true,
                  decoration: InputDecoration(
                      labelText: 'Name',
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
                      hintText: 'Enter Your Name',
                      hintStyle: TextStyle(color: Colors.amberAccent),
                      focusColor: Colors.amberAccent,
                      fillColor: Colors.white),
                )),
            SizedBox(height: 10,),
     /*       Container(
              width: 380,
           //   height: 80,
              // padding: EdgeInsets.all(10.0),
              color: Colors.black.withOpacity(0.5),
              child: IntlPhoneField(
                controller: phoneController,
                style: TextStyle(color: Colors.white),
                dropdownTextStyle: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    labelText: 'Phone',
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
                    hintText: 'Enter Your 10 Digit Phone Number ',
                    hintStyle: TextStyle(color: Colors.amberAccent),
                    fillColor: Colors.white),
                initialCountryCode: 'IN',
                onChanged: (phone) {
                  print(phone.completeNumber);
                  },
                onCountryChanged: (country) {
                  print('Country changed to: ' + country.name);
                },

              ),
            ),  */
           Container(
                width: 380,
               // padding: EdgeInsets.all(10.0),
                color: Colors.black.withOpacity(0.5),
                child: TextField(
                  keyboardType: TextInputType.phone,
                  style: TextStyle(color: Colors.white),
                  controller: phoneController,
                  autocorrect: true,
                  decoration: InputDecoration(
                      labelText: 'Phone',
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
                      hintText: 'Enter +91 and 10 Digit Phone Number ',
                      hintStyle: TextStyle(color: Colors.amberAccent),
                      fillColor: Colors.white),
                )),
            SizedBox(height: 10,),
            Container(
              width: 380,
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.black.withOpacity(0.5),
                  border: Border.all(
                      color: Colors.amberAccent,
                      style: BorderStyle.solid,
                      width: 2.0)
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Choose Loan Type",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Colors.amberAccent,
                    fontSize: 16
                  ),),
                  DropdownButtonHideUnderline(
                    child: DropdownButton(
                      isExpanded: false,
          /*            hint: Text(
                        "Select Item Type",
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.left,
                      ), */
                      dropdownColor: Colors.black,
                      style: TextStyle(color: Colors.white, fontSize: 16),
                      // Initial Value
                      value: loanType,
                      // Down Arrow Icon
                      icon: const Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.white,
                      ),
                      // Array list of items
                      items: loansList.map((String loansList) {
                        return DropdownMenuItem(
                          value: loansList,
                          child: Text(
                            loansList,
                            style: TextStyle(color: Colors.amberAccent),
                          ),
                        );
                      }).toList(),
                      // After selecting the desired option,it will
                      // change button value to selected value
                      onChanged: (String? newValue) {
                        setState(() {
                          loanType = newValue!;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10,),
            Container(
              width: 380,
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.black.withOpacity(0.5),
                  border: Border.all(
                      color: Colors.amberAccent,
                  style: BorderStyle.solid,
                  width: 2.0)
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Choose Employment Type",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Colors.amberAccent,
                        fontSize: 16
                    ),),
                  DropdownButtonHideUnderline(
                    child: DropdownButton(
                      isExpanded: false,
                      dropdownColor: Colors.black,
                      style: TextStyle(color: Colors.white, fontSize: 16),
                      // Initial Value
                      value: employment,
                      // Down Arrow Icon
                      icon: const Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.white,
                      ),
                      // Array list of items
                      items: employmentList.map((String employmentList) {
                        return DropdownMenuItem(
                          value: employmentList,
                          child: Text(
                            employmentList,
                            style: TextStyle(color: Colors.amberAccent),
                          ),
                        );
                      }).toList(),
                      // After selecting the desired option,it will
                      // change button value to selected value
                      onChanged: (String? newValue) {
                        setState(() {
                          employment = newValue!;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10,),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.amberAccent),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PhoneVerify(
                      name: nameController.text,
                      phone: phoneController.text,
                      loanType: loanType,
                      employment: employment )),
                );              },
              //userRegistration,
              child: Text(
                'Submit Loan Application',
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
            ),
            Visibility(
                visible: visible,
                child: Container(
                    margin: EdgeInsets.only(bottom: 30),
                    child: CircularProgressIndicator())),
          ],
        ),
      ),
    ));
  }
}
