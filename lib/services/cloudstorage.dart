import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:firebase_storage/firebase_storage.dart';

class CloudStorageService{
  
  Future<String> saveImageToCloud(File imageFile)async{
    FirebaseStorage storage = await FirebaseStorage.instance;
      var snapshot = await storage.ref().child('Images/$imageFile').putFile(imageFile);
      var donwloadUrl = await snapshot.ref.getDownloadURL();
      return donwloadUrl;
  }
}