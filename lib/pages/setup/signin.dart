import 'package:deardiary/authenticate.dart';
import 'package:deardiary/pages/setup/HomePage.dart';
import 'package:deardiary/pages/setup/allpagecontainer.dart';
import 'package:deardiary/pages/setup/publicstorieshomepage.dart';
import 'package:deardiary/pages/setup/resetpassword.dart';
import 'package:deardiary/pages/setup/signup.dart';
import 'package:deardiary/pages/setup/verifyemail.dart';
import 'package:deardiary/services/auth.dart';
import 'package:deardiary/services/sharedpreferencehelper.dart';
import 'package:deardiary/toast.dart';
import 'package:deardiary/widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignIn extends StatefulWidget {
  final Function toggle;

  SignIn(this.toggle);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  String email, password;
  final formKey = GlobalKey<FormState>(); // Controls the Form
  bool isLoading = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  AuthMethods authMethods = AuthMethods();

  _keepUserSignIn() async {
    final pref = await SharedPreferences.getInstance();
    try {
      String isUserExist = pref.getString('userIDReference');
      if (isUserExist.isNotEmpty) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MainHomePage()));
      }
    } on Exception catch (e) {
      // TODO
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
    _delayBoot();
    super.initState();
    _keepUserSignIn();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: isLoading
            ? loadingScreen()
            : Container(
                height: size.height,
                color: Colors.white30,
                width: double.infinity,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Positioned(
                    //   top: 230,
                    //   left: 200,
                    //   child: Image.asset('assets/design/center.png',width: size.width * 0.3,),
                    //   ),

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
                          decoration: BoxDecoration(),
                          height: MediaQuery.of(context).size.height,
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                              'SIGN IN',
                                              style: TextStyle(
                                                fontFamily: 'Lato',
                                                fontSize: 18,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: SingleChildScrollView(
                                    child: Container(
                                      margin: EdgeInsets.only(
                                          left: 15, right: 15, bottom: 10),
                                      padding:
                                          EdgeInsets.only(left: 15, right: 15),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          color: Colors.white),
                                      child: Column(
                                        children: [
                                          Form(
                                            key: formKey,
                                            child: Column(
                                              children: [
                                                TextFormField(
                                                  validator: (val) {
                                                    return RegExp(
                                                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                                            .hasMatch(val)
                                                        ? null
                                                        : "Invalid Email address";
                                                  },
                                                  onSaved: (val) {
                                                    email = val;
                                                  },
                                                  controller: emailController,
                                                  keyboardType: TextInputType
                                                      .emailAddress,
                                                  autofillHints: [
                                                    AutofillHints.email
                                                  ],
                                                  style: signInTextStyle(),
                                                  decoration:
                                                      textFieldInputDecoration(
                                                          "Email",
                                                          Icon(
                                                              Icons
                                                                  .email_rounded,
                                                              color: Colors
                                                                  .grey[500])),
                                                ),
                                                Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 20)),
                                                TextFormField(
                                                  validator: (val) {
                                                    return val.length < 6
                                                        ? 'Password must be 6+ length'
                                                        : null;
                                                  },
                                                  onSaved: (val) {
                                                    password = val;
                                                  },
                                                  controller:
                                                      passwordController,
                                                  style: signInTextStyle(),
                                                  obscureText: true,
                                                  decoration:
                                                      textFieldInputDecoration(
                                                          "Password",
                                                          Icon(
                                                              Icons
                                                                  .lock_rounded,
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
                                            onTap: () {
                                              navigateForgotPassword();
                                            },
                                            child: Container(
                                              alignment: Alignment.centerRight,
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 16,
                                                    vertical: 8),
                                                child: Text(
                                                  'Forgot Password?',
                                                  style: TextStyle(
                                                      fontSize: 17,
                                                      color: Colors.blueAccent,
                                                      decoration: TextDecoration
                                                          .underline),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              signInme(context);
                                            },
                                            child: Container(
                                              alignment: Alignment.center,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 20),
                                              decoration: BoxDecoration(
                                                  gradient:
                                                      LinearGradient(colors: [
                                                    Colors.white30,
        Colors.white30,
                                                  ]),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30)),
                                              child: Text(
                                                "Sign In",
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
                                            children: [
                                              Text(
                                                'Dont have account? ',
                                                style: signInTextStyle(),
                                              ),
                                              GestureDetector(
                                                onTap: widget.toggle,
                                                child: Text(
                                                  'Register now',
                                                  style: TextStyle(
                                                      color: Colors.blueAccent,
                                                      fontSize: 17,
                                                      decoration: TextDecoration
                                                          .underline),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
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

  Widget cancelButton(BuildContext context) {
    return FlatButton(
      child: Text("Maybe later"),
      onPressed: () {
        Navigator.of(this.context).pop();
        navigateHomePage();
      },
    );
  }

  Widget continueButton(BuildContext context, String email) {
    return FlatButton(
      child: Text("Verify"),
      onPressed: () {
        Navigator.of(this.context).pop();
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => VerifyEmail(email)));
      },
    );
  }

  Future<void> showChoiceDialog(BuildContext context, String email) {
        return showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Verification', style: TextStyle(color: Colors.red)),
                content: Text(
                    'This email has not been verified yet. you can verify it later but It will be good to verify now?'),
                actions: [
                  cancelButton(context),
                  continueButton(this.context, email)
                ],
              );
            });
      }

  signInme(BuildContext context) async {
    if (formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });
      //Determines if all the TextFormFields are valid the code below executes
      FirebaseAuth auth = await FirebaseAuth.instance;
      final pref = await SharedPreferences.getInstance();
      try {
        UserCredential user = await auth.signInWithEmailAndPassword(
            email: emailController.text, password: passwordController.text);

        if (user.user.emailVerified) {
          pref.setString('userIDReference', user.user.uid);
          navigateHomePage();
        } else {
          if (user.user != null) {
            pref.setString('userIDReference', user.user.uid);
            showChoiceDialog(context, user.user.email);
          }
        }
      } catch (e) {
        setState(() {
          isLoading = false;
          showDialogMain(context, 'I Understand', 'Incorrect Email or Password', 'Something went wrong please try again');
        });
      }

      setState(() {
        isLoading = false;
      });
    }
  }

  navigateForgotPassword() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => ResetPassword()));
  }

  navigateSignUp() {
    setState(() {
      isLoading = true;
    });

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Authenticate()));
  }

  navigateHomePage() {
    setState(() {
      isLoading = true;
    });

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => MainHomePage()));
  }
}
