import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import 'crud.dart';

class InitialScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<InitialScreen> {
  PurchaserInfo _purchaserInfo;
  Offerings _offerings;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    await Purchases.setDebugLogsEnabled(true);
    await Purchases.setup("hKsojVRVgmCdlhWIZxOiJfwfmXmrUiAt");
    Purchases.addAttributionData({}, PurchasesAttributionNetwork.facebook);
    PurchaserInfo purchaserInfo = await Purchases.getPurchaserInfo();
    Offerings offerings = await Purchases.getOfferings();
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _purchaserInfo = purchaserInfo;
      _offerings = offerings;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_purchaserInfo == null) {
      return Scaffold(
        body: Center(
          child: Text("Loading..."),
        ),
      );
    } else {
      var isPro = _purchaserInfo.entitlements.active.containsKey("30gun");
      if (isPro) {
        return CatsScreen();
      } else {
        //return CatsScreen();///DÜZELT!!
        return UpsellScreen(
          offerings: _offerings,
        );
      }
    }
  }
}

class UpsellScreen extends StatelessWidget {
  final Offerings offerings;

  UpsellScreen({Key key, @required this.offerings}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (offerings != null) {
      final offering = offerings.current;
      if (offering != null) {
        final monthly = offering.monthly;

        if (monthly != null) {
          return Scaffold(
              body: Center(
                  child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              PurchaseButton(package: monthly),
            ],
          )));
        }
      }
    }
    return Scaffold(
        body: Center(
      child: Text("Loading, Please wait..."),
    ));
  }
}

class PurchaseButton extends StatelessWidget {
  final Package package;

  PurchaseButton({Key key, @required this.package}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    return Container(
      height: _height,
      width: _width,
      color: Colors.white,
      child: Column(
        children: [
          Image(
            image: AssetImage(
              'assets/images/logo2.png',
            ),
            width: _width * 0.48,
            fit: BoxFit.cover,
          ),
          SizedBox(
            height: _height * 0.40,
          ),
          RaisedButton(
            color: Colors.green[300],
            onPressed: () async {
              try {
                PurchaserInfo purchaserInfo =
                    await Purchases.purchasePackage(package);
                var isPro = purchaserInfo.entitlements.all["30gun"].isActive;
                if (isPro) {
                  return CatsScreen();
                }
              } on PlatformException catch (e) {
                var errorCode = PurchasesErrorHelper.getErrorCode(e);
                if (errorCode == PurchasesErrorCode.purchaseCancelledError) {
                  print("User cancelled");
                } else if (errorCode ==
                    PurchasesErrorCode.purchaseNotAllowedError) {
                  print("User not allowed to purchase");
                }
              }
              return InitialScreen();
            },
            child: Container(
              alignment: Alignment.center,
              height: _height * 0.06,
              width: _width * 0.4,
              child: Text(
                "Buy - (${package.product.priceString}) \n 30 DAY TO VIP TIPS!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: _height * 0.015,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CatsScreen extends StatefulWidget {
  @override
  _CatsScreenState createState() => _CatsScreenState();
}

class _CatsScreenState extends State<CatsScreen> {
  @override
  void initState() {
    super.initState();
    crudObj.getVip().then((results) {
      vip = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color(0XFFEFE3DC),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Color(0XFFEFE3DC),
        title: Image(
          image: AssetImage(
            'assets/images/logo2.png',
          ),
          width: _width * 0.48,
          fit: BoxFit.cover,
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
          height: _height * 0.75,
          padding: EdgeInsets.fromLTRB(4, _height * 0.07, 4, 0),
          child: _premiumList(context)),
    );
  }
}

QuerySnapshot vip;
var tuttu = false;
final formKontrolcu = GlobalKey<FormState>();
crudMedthods crudObj = new crudMedthods();
String icon;
IconData tur;

iconbelirle(int i, QuerySnapshot mac) {
  if (mac.docs[i].get("durum") == "0") {
    //Resmi eşitle!!
    icon = "assets/images/beklemede.png";
    tuttu = false;
  } else if (mac.docs[i].get("durum") == "1") {
    icon = "assets/images/tuttu.png";
    tuttu = true;
  } else if (mac.docs[i].get("durum") == "2") {
    icon = "assets/images/yatti.png";
  }
  return icon;
}

Widget _premiumList(BuildContext context) {
  Color renk1 = Color(0xFFbd9903);
  final _width = MediaQuery.of(context).size.width;
  final _height = MediaQuery.of(context).size.height;
  if (vip != null) {
    return ListView.builder(
        itemCount: vip.docs.length,
        padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
        itemBuilder: (context, i) {
          return Card(
            elevation: 20,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            margin: EdgeInsets.all(5),
            color: renk1,
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: _height * 0.05,
                    child: Image.asset(
                      iconbelirle(i, vip),
                      fit: BoxFit.fill,
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                    width: _width * 0.5,
                    child: Row(
                      children: [
                        Container(
                          width: _width * 0.17,
                          child: Text(
                            (vip.docs[i].get("tur") +
                                "\n" +
                                vip.docs[i].get("ulke") +
                                "\n" +
                                vip.docs[i].get("zaman")),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: _height * 0.015,
                                color: Colors.black),
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          vip.docs[i].get("taraf1") +
                              "\nvs\n" +
                              vip.docs[i].get("taraf2") +
                              "\nBet: " +
                              vip.docs[i].get("tahmin") +
                              "\nOdd: " +
                              vip.docs[i].get("oran"),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: _height * 0.015,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  Image(
                    width: _width * 0.15,
                    image: AssetImage('assets/images/flags/' +
                        vip.docs[i].get("logo") +
                        '.png'),
                    fit: BoxFit.fill,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                ],
              ),
            ),
          );
        });
  } else {
    return Text(
      "Loading, Please Wait..",
      style: TextStyle(fontWeight: FontWeight.bold),
    );
  }
}
