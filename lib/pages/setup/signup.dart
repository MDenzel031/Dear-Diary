import 'package:deardiary/authenticate.dart';
import 'package:deardiary/pages/setup/signin.dart';
import 'package:deardiary/pages/setup/verifyemail.dart';
import 'package:deardiary/services/auth.dart';
import 'package:deardiary/services/database.dart';
import 'package:deardiary/toast.dart';
import 'package:deardiary/widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  final Function toggle;

  SignUp(this.toggle);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final formKey = GlobalKey<FormState>(); // Controls the Form
  String username, email, password;
  bool isLoading =
      false; //Shows when it's the data is still on the haven't yet return
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  AuthMethods authMethods = AuthMethods();
  DataMethods dataMethods = DataMethods();

  signMeUp() async {
    if (formKey.currentState.validate()) {
      //Determines if all the TextFormFields are valid the code below executes
      setState(() {
        isLoading = true;
      });

      FirebaseAuth auth = await FirebaseAuth.instance;
      await auth
          .createUserWithEmailAndPassword(
              email: emailController.text, password: passwordController.text)
          .then((uservalue) {
        DataMethods().updateUserData1(
            userNameController.text, emailController.text, uservalue.user.uid);

        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => VerifyEmail(uservalue.user.email)));
      });

      authMethods.signUpwithEmailAndPassword(userNameController.text,
          emailController.text, passwordController.text);
    }
  }

  _delayBoot() async {
    setState(() {
      isLoading = true;
    });
    await Future.delayed(Duration(milliseconds: 500));
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    _delayBoot();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: isLoading
            ? loadingScreen()
            : Container(
                width: size.width,
                height: size.height,
                color: Colors.white30,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      top: 2,
                      left: -20,
                      child: Image.asset(
                        'assets/images/left.png',
                        width: size.width * 0.3,
                      ),
                    ),
                    Positioned(
                      top: 2,
                      right: -20,
                      child: Image.asset(
                        'assets/design/right.png',
                        width: size.width * 0.3,
                      ),
                    ),
                    Positioned(
                        bottom: 0,
                        child: Container(
                          width: size.width,
                          height: 30,
                          color: Colors.white30,
                        )),
                    Positioned(
                      child: SingleChildScrollView(
                        child: Container(
                          height: MediaQuery.of(context).size.height,
                          alignment: Alignment.bottomCenter,
                          decoration: BoxDecoration(),
                          child: Container(
                            height: MediaQuery.of(context).size.height,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(bottom: 50),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'WELCOME TO',
                                        style: TextStyle(
                                          fontFamily: 'Lato',
                                          fontSize: 20,
                                        ),
                                      ),
                                      Container(
                                        child: Image.asset(
                                          'assets/images/LogoDearDiary.png',
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              100,
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(top: 20),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 50, vertical: 10),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          gradient: LinearGradient(colors: [
                                            Colors.white30,
                                            Colors.white30,
                                          ]),
                                        ),
                                        child: Text(
                                          'JOIN US',
                                          style: TextStyle(
                                            fontFamily: 'Lato',
                                            fontSize: 25,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.white),
                                  margin: EdgeInsets.only(
                                      left: 15, right: 15, bottom: 10),
                                  padding: EdgeInsets.only(left: 15, right: 15),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Form(
                                        key: formKey,
                                        child: Column(
                                          children: [
                                            TextFormField(
                                              maxLength: 20,
                                              validator: (val) {
                                                return val.isEmpty ||
                                                        val.length < 5
                                                    ? "Username should be 5+ characters"
                                                    : null;
                                              },
                                              controller: userNameController,
                                              onSaved: (val) => email = val,
                                              style: signInTextStyle(),
                                              decoration:
                                                  textFieldInputDecoration(
                                                      "Username",
                                                      Icon(Icons.person_rounded,
                                                          color: Colors
                                                              .grey[500])),
                                            ),
                                            TextFormField(
                                              maxLength: 50,
                                              validator: (val) {
                                                return RegExp(
                                                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                                        .hasMatch(val)
                                                    ? null
                                                    : "Invalid Email address";
                                              },
                                              controller: emailController,
                                              onSaved: (val) => email = val,
                                              style: signInTextStyle(),
                                              decoration:
                                                  textFieldInputDecoration(
                                                      "Email",
                                                      Icon(Icons.email_rounded,
                                                          color: Colors
                                                              .grey[500])),
                                            ),
                                            TextFormField(
                                              maxLength: 100,
                                              validator: (val) {
                                                return val.length > 6
                                                    ? null
                                                    : "Please provide password 6+ characters";
                                              },
                                              controller: passwordController,
                                              style: signInTextStyle(),
                                              obscureText: true,
                                              onSaved: (val) => password = val,
                                              decoration:
                                                  textFieldInputDecoration(
                                                      "Password",
                                                      Icon(Icons.lock_rounded,
                                                          color: Colors
                                                              .grey[500])),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      GestureDetector(
                                        onTap: signMeUp,
                                        child: Container(
                                          alignment: Alignment.center,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          padding: EdgeInsets.symmetric(
                                              vertical: 20),
                                          decoration: BoxDecoration(
                                              gradient: LinearGradient(colors: [
                                                Colors.white30,
                                                Colors.white30,
                                              ]),
                                              borderRadius:
                                                  BorderRadius.circular(30)),
                                          child: Text(
                                            "Sign Up",
                                            style: simpleTextStyle(),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 16,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            'Aleady have account? ',
                                            style: signInTextStyle(),
                                          ),
                                          GestureDetector(
                                            onTap: () => {widget.toggle},
                                            child: Text(
                                              'SignIn now',
                                              style: TextStyle(
                                                  color: Colors.blueAccent,
                                                  fontSize: 17,
                                                  decoration:
                                                      TextDecoration.underline),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ));
  }
}
