import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class crudMedthods {
  getData() async {
    return await FirebaseFirestore.instance.collection('maclar1').get();
  }

  getUygulama() async {
    return await FirebaseFirestore.instance.collection('uygulamas').get();
  }

  getGecmis() async {
    return await FirebaseFirestore.instance.collection('gecmis1').get();
  }

  getPremium() async {
    return await FirebaseFirestore.instance.collection('premium1').get();
  }

  getVip() async {
    return await FirebaseFirestore.instance.collection('vip1').get();
  }

  getFutbol() async {
    return await FirebaseFirestore.instance
        .collection('maclar1')
        .where('tur', isEqualTo: 'Soccer')
        .get();
  }

  getBasket() async {
    return await FirebaseFirestore.instance
        .collection('maclar1')
        .where('tur', isEqualTo: 'Basketball')
        .get();
  }

  deleteMac(documentID) async {
    return await FirebaseFirestore.instance
        .collection('maclar1')
        .doc(documentID)
        .delete();
  }
  deleteGecmis(documentID) async {
    return await FirebaseFirestore.instance
        .collection('gecmis1')
        .doc(documentID)
        .delete();
  }
  

  Future<void> gecmisEkle(gecmis) async {
    FirebaseFirestore.instance
        .collection('/gecmis1')
        .add(gecmis)
        .catchError((e) {
      print(e);
    });
  }

  Future<void> macEkle(mac) async {
    FirebaseFirestore.instance.collection('/maclar1').add(mac).catchError((e) {
      print(e);
    });
  }

  Future<void> vipEkle(mac) async {
    FirebaseFirestore.instance.collection('/vip1').add(mac).catchError((e) {
      print(e);
    });
  }

  Future<void> premium(mac) async {
    FirebaseFirestore.instance.collection('/premium1').add(mac).catchError((e) {
      print(e);
    });
  }
}
