import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataMethods {
  final CollectionReference refCollection =
      FirebaseFirestore.instance.collection('users');

  uploadUserInfo(userMap) {
    FirebaseFirestore.instance.collection('users').add(userMap);
  }

  Future<DocumentReference> getUserDocFromUsers() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String uid = pref.getString('userIDReference');
    var reference =
        await FirebaseFirestore.instance.collection('users').doc(uid);

    return reference;
  }

  Future  getUserByUsername(String username) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .where('userName', isEqualTo: username)
        .get();
  }

  Future<DocumentReference> getUserDocFromStory(String docUid,bool viewed) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String isViewed = viewed == true ? 'Public' : 'Private';
    String uid = pref.getString('userIDReference');
    var reference = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid).collection('story').doc(uid).collection(isViewed).doc(docUid);

    print(reference);
    
    return reference;
  }

  Future<DocumentReference> getUserDocFromTheId(String id) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    var reference = await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .collection('story')
        .doc();

    return reference;
  }

  // Future updateUserData(String title, String imageUrl, String detail, String uid) async{
  //   return await refCollection.doc(uid).set({
  //     'title' : title,
  //     'imageUrl' : imageUrl,
  //     'detail' : detail,
  //   });
  // }

  List storyItems = [];
  Future getUsersPublicStories() async {
    try {
      final SharedPreferences pref = await SharedPreferences.getInstance();
      final String uid = pref.getString('userIDReference');
      await refCollection.doc(uid).collection('story').doc(uid).collection('Public').get().then((value) {
        value.docs.forEach((element) {
          var finalData = element.data();
          finalData.putIfAbsent('id', () => element.id);
          storyItems.add(finalData);
          // print(element.data());
        });
      });

      //DESCENDING SORTING
      await storyItems
          .sort((b, a) => a['date'].toString().compareTo(b['date'].toString()));

      //ASCENDING SORTING
      // await storyItems.sort((a,b) => a['date'].toString().compareTo(b['date'].toString()));

      return storyItems;
    } on Exception catch (e) {
      return null;
    }
  }

  Future getUsersPrivateStories() async {
    try {
      final SharedPreferences pref = await SharedPreferences.getInstance();
      final String uid = pref.getString('userIDReference');
      await refCollection.doc(uid).collection('story').doc(uid).collection('Private').get().then((value) {
        value.docs.forEach((element) {
          var finalData = element.data();
          finalData.putIfAbsent('id', () => element.id);
          storyItems.add(finalData);
          // print(element.data());
        });
      });

      //DESCENDING SORTING
      await storyItems
          .sort((b, a) => a['date'].toString().compareTo(b['date'].toString()));

      //ASCENDING SORTING
      // await storyItems.sort((a,b) => a['date'].toString().compareTo(b['date'].toString()));

      return storyItems;
    } on Exception catch (e) {
      return null;
    }
  }

  Future getUsersStoriesById(String id) async {
    try {
      await refCollection.doc(id).collection('story').doc(id).collection('Public').get().then((value) {
        value.docs.forEach((element) {
          var finalData = element.data();
          finalData.putIfAbsent('id', () => element.id);
          storyItems.add(finalData);
          // print(element.data());
        });
      });

      //DESCENDING SORTING
      await storyItems
          .sort((b, a) => a['date'].toString().compareTo(b['date'].toString()));

      //ASCENDING SORTING
      // await storyItems.sort((a,b) => a['date'].toString().compareTo(b['date'].toString()));

      return storyItems;
    } on Exception catch (e) {
      return null;
    }
  }

  Future updateUserData1(String userName, String userEmail, String uid) async {
    return await refCollection.doc(uid).set({
      'userName': userName,
      'userEmail': userEmail,
      'userImage':
          'https://cdn0.iconfinder.com/data/icons/user-pictures/100/unknown2-512.png'
    });
  }

  Future updateUserData2(
      String title, String imageUrl, String detail, String uid) async {
    return await refCollection.doc(uid).collection('story').doc(uid).set({
      'title': title,
      'imageUrl': imageUrl,
      'detail': detail,
    });
  }
}
