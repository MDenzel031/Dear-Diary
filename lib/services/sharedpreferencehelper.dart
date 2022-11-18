import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deardiary/pages/setup/HomePage.dart';
import 'package:deardiary/pages/setup/allpagecontainer.dart';
import 'package:deardiary/pages/setup/publicstorieshomepage.dart';
import 'package:deardiary/toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHelper {
  // String title;
  // String imageUrl;
  // String detail;
  // bool ispublic;

  String uid;
  String email;
  var ref;

  SharedPreferenceHelper({this.uid}) {
    ref = FirebaseFirestore.instance.collection('user').doc().collection('story').doc(uid);
  }

  void discardStory(BuildContext context) {
    resetSharedPref();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => MainHomePage()));
    ShowToast('Discarded Story');
  }

  Future<String> getTitle() async {
    final SharedPreferences ref = await SharedPreferences.getInstance();
    return ref.getString('title');
  }

  Future<String> getImageUrl() async {
    final SharedPreferences ref = await SharedPreferences.getInstance();
    return ref.getString('imageUrl');
  }

  Future<String> getDetail() async {
    final SharedPreferences ref = await SharedPreferences.getInstance();
    return ref.getString('detail');
  }

  saveTitle(String title) async {
    final SharedPreferences ref = await SharedPreferences.getInstance();
    ref.setString('title', title);
  }

  saveImageUrl(String imageUrl) async {
    final SharedPreferences ref = await SharedPreferences.getInstance();
    ref.setString('imageUrl', imageUrl);
  }

  saveDate(String date) async {
    final SharedPreferences ref = await SharedPreferences.getInstance();
    ref.setString('date', date);
  }

  saveDetail(String detail) async {
    final SharedPreferences ref = await SharedPreferences.getInstance();
    ref.setString('detail', detail);
  }

  saveInFirebase(String title, String imageUrl, String detail, String date,
      bool viewed) async {
    try {
      Map<String, dynamic> currData = {
        'viewed' : viewed,
        'date': date,
        'title': title,
        'imageUrl': (imageUrl == null) ? "Temporary" : imageUrl,
        'detail': detail,
      };
      if (viewed == true) {
        var ref = await FirebaseFirestore.instance.collection('users').doc(uid);
        ref.collection('story').doc(uid).collection('Public').add(currData);
      }

      if (viewed == false) {
        var ref = await FirebaseFirestore.instance.collection('users').doc(uid);
        ref.collection('story').doc(uid).collection('Private').add(currData);
      }

      resetSharedPref();
      ShowToast('Sucessfully Added to Firebase');
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  resetSharedPref() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove('title');
    pref.remove('imageUrl');
    pref.remove('detail');
    pref.remove('date');
    // pref.setString('title', null);
    // pref.setString('imageUrl', null);
    // pref.setString('detail', null);
  }
}
