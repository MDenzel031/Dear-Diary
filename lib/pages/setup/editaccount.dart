import 'package:deardiary/pages/setup/allpagecontainer.dart';
import 'package:deardiary/services/auth.dart';
import 'package:deardiary/toast.dart';
import 'package:deardiary/widget.dart';
import 'package:flutter/material.dart';

import 'HomePage.dart';

class EditAccount extends StatefulWidget {
  dynamic ref;
  EditAccount(this.ref);

  @override
  _EditAccountState createState() => _EditAccountState();
}

class _EditAccountState extends State<EditAccount> {
  bool isLoading = false;
  TextEditingController currentPassword = TextEditingController();

  TextEditingController newPassword = TextEditingController();

  TextEditingController confirmPassword = TextEditingController();
  final formKey = GlobalKey<FormState>();

  bool checkCurrentPasswordValid = true; 

  dynamic userDetails;

  _getUserDetails() async {
    setState(() {
      userDetails = widget.ref;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getUserDetails();
  }


  saveChanges()async{
    checkCurrentPasswordValid = await AuthMethods().validateCurrentPassword(currentPassword.text);
    if(formKey.currentState.validate() && checkCurrentPasswordValid){
      setState(() {
        
      });
      AuthMethods().updateUserPassword(newPassword.text);
      showDialogMain(context, 'Ok', 'Password Change', 'Password Sucessfully changed');
      
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MainHomePage()));
    }
  }

  clearFields(){
    setState(() {
      currentPassword.text = '';
      newPassword.text = '';
      confirmPassword.text = '';
    });
  }




     Widget cancelButton(BuildContext context) {
    return FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(this.context).pop();
      },
    );
  }

  Widget continueButton(BuildContext context) {
    return FlatButton(
      child: Text("Save Changes"),
      onPressed: () {
        saveChanges();
        Navigator.of(context).pop();
        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Authenticate()));
      },
    );
  }

  Future<void> showChoiceDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Confirm?', style: TextStyle(color: Colors.red)),
            content: Text('Confirm Password Changes?'),
            actions: [cancelButton(context), continueButton(context)],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: darkTheme(),
        ),
        title: Text('Edit Account'),
        // actions: [
        //   GestureDetector(
        //     onTap: () {
        //       // updateUserDetails();
        //     },
        //     child: Container(
        //       padding: EdgeInsets.symmetric(horizontal: 10),
        //       child: Row(
        //         children: [
        //           Icon(Icons.exit_to_app),
        //           Text('Save'),
        //         ],
        //       ),
        //     ),
        //   )
        // ],
      ),
      body: isLoading == true
          ? loadingScreen()
          : SingleChildScrollView(
              child: Container(
                color: Colors.white,
                height: MediaQuery.of(context).size.height,
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.all(15),
                      child: Text(
                        'My Account',
                        style: TextStyle(
                          fontSize: 25,
                        ),
                      ),
                    ),
                    Container(
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        child: ListTile(
                          title: Text(
                            userDetails['userName'],
                            style: simpleStoriesTextStyle(),
                          ),
                          subtitle: Text(
                            userDetails['userEmail'],
                            style: TextStyle(
                              fontFamily: 'Lato',
                              fontSize: 15,
                            ),
                          ),
                          leading: CircleAvatar(
                            backgroundImage:
                                NetworkImage(userDetails['userImage']),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Card(
                        elevation: 10,
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Text(
                                'Change Password',
                                style: TextStyle(
                                  fontSize: 25,
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(15),
                              margin: EdgeInsets.only(top: 10),
                              child: Form(
                                key: formKey,
                                child: Column(
                                  children: [
                                    TextFormField(
                                      validator: (value) {
                                        return value.isEmpty
                                            ? 'This must be filled'
                                            : null;
                                      },
                                      keyboardType: TextInputType.text,
                                      controller: currentPassword,
                                      obscureText: true,
                                      decoration: textFieldInputDecorationV2(
                                          'Current Password',
                                          Icon(Icons.lock_rounded,
                                              color: Colors.grey[500]),checkCurrentPasswordValid),
                                        
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    TextFormField(
                                      validator: (value) {
                                        return value.isEmpty
                                            ? 'This must be filled'
                                            : null;
                                      },
                                      controller: newPassword,
                                      obscureText: true,
                                      decoration: textFieldInputDecoration(
                                          'New Password',
                                          Icon(Icons.lock_rounded,
                                              color: Colors.grey[500])),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    TextFormField(
                                      validator: (value) {
                                       return newPassword.text == value ? null : 'Please validate your entered password';
                                      },
                                      controller: confirmPassword,
                                      obscureText: true,
                                      decoration: textFieldInputDecoration(
                                          'Repeat Password',
                                          Icon(Icons.lock_rounded,
                                              color: Colors.grey[500])),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      alignment: Alignment.center,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              clearFields();
                                            },
                                            child: Container(
                                              alignment: Alignment.center,
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 5),
                                              child: Container(
                                                margin: EdgeInsets.only(
                                                    top: 10, bottom: 10),
                                                alignment: Alignment.center,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    250,
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 15),
                                                decoration: darkTheme(),
                                                child: Text(
                                                  "Clear",
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              showChoiceDialog(context);
                                            },
                                            child: Container(
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 5),
                                                alignment: Alignment.center,
                                                child: Container(
                                                  margin: EdgeInsets.only(
                                                      top: 10, bottom: 10),
                                                  alignment: Alignment.center,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width -
                                                      250,
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 15),
                                                  decoration: darkTheme(),
                                                  child: Text(
                                                    "Save Changes",
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}


