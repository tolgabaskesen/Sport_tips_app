import 'dart:async';
import 'package:app_review/app_review.dart';
import 'package:betsforwin/subscription.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:url_launcher/url_launcher.dart';
import 'purchase.dart';
import 'crud.dart';
import 'deneme.dart';
import 'package:unity_ads_plugin/ad/unity_banner_ad.dart';
import 'package:unity_ads_plugin/unity_ads.dart';

const String testDevice = null; //'Mobile_id';

void main() async {
  InAppPurchaseConnection.enablePendingPurchases();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TipHouse',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(
        title: 'TipHouse',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    keywords: <String>['football', 'sport'],
    contentUrl: 'https://flutter.io',
    testDevices: testDevice != null ? <String>[testDevice] : null,
    childDirected: false,
    nonPersonalizedAds: true,
  );

  void _setTargetPlatformForDesktop() {
    TargetPlatform targetPlatform;
    targetPlatform = TargetPlatform.android;
    debugDefaultTargetPlatformOverride = targetPlatform;
  }

  String resim;
  InterstitialAd _interstitialAd;
  int _coins = 0;
  String appID = "";
  String output = "";
  int sayac = 0;

  InterstitialAd createInterstitialAd() {
    return InterstitialAd(
      adUnitId: 'ca-app-pub-5316337657364445/6570387403',
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        print("InterstitialAd event $event");
      },
    );
  }

  bool _showBanner = false;
  Color renk1;
  Color renk2;

  int _start = 2;
  int reklam;
  Timer timer;
  String icon;
  IconData tur;
  QuerySnapshot maclar;
  QuerySnapshot gecmis;
  QuerySnapshot premium;
  QuerySnapshot uygulama;
  QuerySnapshot futbol;
  QuerySnapshot basket;
  var tuttu = false;
  final formKontrolcu = GlobalKey<FormState>();
  crudMedthods crudObj = new crudMedthods();
  int _currentindex = 2;

  String metin = "";
  void startTimer3() {
    //GEREKSİZSE SİLL
    const oneSec = const Duration(seconds: 1);
    _start = 2;
    timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(() {
        if (_start < 1) {
          _unity();
          timer.cancel();
          if (uygulama != null) {
            FirebaseAdMob.instance
                .initialize(appId: uygulama.docs[0].get("thappid"));
            showBanner();
            AppReview.getAppID.then((String onValue) {
              setState(() {
                appID = uygulama.docs[0].get("thappid");
              });

              print("App ID" + appID);
            });
            if (uygulama.docs[0].get("versiyon") > 11) {
              metin = uygulama.docs[0].get("mesaj1") + "\nUPDATE YOUR APP!!";
            } else {
              metin = uygulama.docs[0].get("mesaj1");
            }
            reklam = uygulama.docs[0].get("reklam");
          } else {
            startTimer3();
          }
          setState(() {});
        } else {
          _start = _start - 1;
        }
      }),
    );
  }

  _launchURL() async {
    const url = 'https://www.instagram.com/tiphouseapp/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Image(
          image: AssetImage(
            'assets/images/logo2.png',
          ),
          width: _width * 0.48,
          fit: BoxFit.cover,
        ),
        elevation: 0,
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () {
              _launchURL();
            },
            child: Container(
              child: Image.asset("assets/images/insta.png"),
            ),
          )
        ],
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 60),
        child: BottomNavigationBar(
          currentIndex: _currentindex,
          backgroundColor: Colors.black,
          iconSize: 15,
          unselectedFontSize: 14,
          selectedFontSize: 17,
          selectedItemColor: Color(0xFF248600),
          selectedIconTheme: IconThemeData(
            size: 20,
            color: Colors.white,
          ),
          unselectedItemColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              label: "VIP",
              icon: Icon(Icons.attach_money),
            ),
            BottomNavigationBarItem(
              label: "Premium",
              icon: Icon(Icons.star),
            ),
            BottomNavigationBarItem(
              label: "Daily",
              icon: Icon(Icons.sports_soccer),
            ),
            BottomNavigationBarItem(
              label: "History",
              icon: Icon(Icons.history),
            ),
            BottomNavigationBarItem(
              label: "Rate Us!",
              icon: Icon(Icons.thumb_up),
            ),
          ],
          onTap: (index) {
            if (index != 4) {
              if (index != 0) {
                if (sayac < 2) {
                  _unityGecis();
                }
                /* _interstitialAd = createInterstitialAd()
                  ..load()
                  ..show(); */
              }
            }
            setState(() {
              _currentindex = index;
            });
          },
        ),
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            width: _width * 0.8,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.0, 1.0],
                colors: [
                  Color(0xFFff005f),
                  Color(0xFF750000),
                ],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              metin,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: _height * 0.015,
                  color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            height: _height * 0.675,
            color: Colors.white,
            child: _sayfaCagir(_currentindex),
          ),
        ],
      ),
    );
  }

  Widget _sayfaCagir(int i) {
    switch (i) {
      case 1:
        {
          print(reklam);
          if (reklam == 0) {
            return _premiumList();
          } else {
            if (_coins != 0) //DÜZELT
              return _premiumList();
            else
              return _kuponGoster();
          }
        }
        return null;

      case 0:
        _coins = 0;
        return _vip();
      case 2:
        _coins = 0;
        return _macList();
      case 3:
        _coins = 0;
        return _gecmisList();
      case 4:
        _coins = 0;
        return _rateUS();
    }
    return null;
  }

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

  turBelirle(int i, QuerySnapshot mac) {
    if (mac.docs[i].get("tur") == "Soccer") {
      tur = (Icons.sports_soccer);
      tuttu = false;
    } else if (mac.docs[i].get("tur") == "Basketball") {
      tur = Icons.sports_basketball;
      tuttu = true;
    }
    return tur;
  }

  _unity() {
    if (uygulama.docs[0].get("unity") == 1) {
      UnityAds.init(
        gameId: AdManager.gameId,
        testMode: false,
        listener: (state, args) => print('Init Listener: $state => $args'),
      );
      _showBanner = true;
    }
  }

  _unityGecis() {
    if (uygulama.docs[0].get("unity") == 1) {
      UnityAds.showVideoAd(
        placementId: AdManager.interstitialVideoAdPlacementId,
        listener: (state, args) {
          sayac++;
          print(sayac);
          print('Interstitial Video Listener: $state => $args');
        },
      );
    }
  }

  _unityReward() {
    if (uygulama.docs[0].get("unity") == 1) {
      UnityAds.showVideoAd(
        placementId: 'rewardedVideo',
        listener: (state, args) {
          print('Rewarded Video Listener: $state => $args');
          setState(() {
            _coins++;
          });
        },
      ).catchError((e) {
        print(e);
      });
    }
  }

  @override
  void initState() {
    UnityAds.init(
      gameId: "3964095",
      testMode: false,
      listener: (state, args) => print('Init Listener: $state => $args'),
    );
    startTimer3();
    _setTargetPlatformForDesktop();
    _coins = 0;

    RewardedVideoAd.instance.listener =
        (RewardedVideoAdEvent event, {String rewardType, int rewardAmount}) {
      print("RewardedVideoAd event $event");
      if (event == RewardedVideoAdEvent.rewarded) {
        setState(() {
          _coins += rewardAmount;
        });
      }
    };
    RewardedVideoAd.instance.load(
        adUnitId: 'ca-app-pub-5316337657364445/2257228562',
        targetingInfo: targetingInfo);

    crudObj.getData().then((results) {
      maclar = results;
    });
    crudObj.getPremium().then((results) {
      premium = results;
    });
    crudObj.getUygulama().then((results) {
      uygulama = results;
    });
    crudObj.getGecmis().then((results) {
      gecmis = results;
    });
    crudObj.getFutbol().then((results) {
      futbol = results;
    });
    crudObj.getBasket().then((results) {
      basket = results;
    });
    crudObj.getVip().then((results) {
      vip = results;
    });
    super.initState();
  }

  Widget _macList() {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    final _size = MediaQuery.of(context).size;

    if (uygulama != null &&
        maclar != null &&
        gecmis != null &&
        vip != null &&
        basket != null &&
        futbol != null) {
      return ListView.builder(
          itemCount: maclar.docs.length,
          padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
          itemBuilder: (context, i) {
            return Card(
              elevation: 20,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              margin: EdgeInsets.all(5),
              color: Colors.green[800],
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: _height * 0.05,
                      child: Image.asset(
                        iconbelirle(i, maclar),
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
                              (maclar.docs[i].get("tur") +
                                  "\n" +
                                  maclar.docs[i].get("ulke") +
                                  "\n" +
                                  maclar.docs[i].get("zaman")),
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
                            maclar.docs[i].get("taraf1") +
                                "\nvs\n" +
                                maclar.docs[i].get("taraf2") +
                                "\nBet: " +
                                maclar.docs[i].get("tahmin") +
                                "\nOdd: " +
                                maclar.docs[i].get("oran"),
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
                          maclar.docs[i].get("logo") +
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
      startTimer();
      return Text(
        "Loading, Please Wait..",
        style: TextStyle(fontWeight: FontWeight.bold),
      );
    }
  }

  Widget _gecmisList() {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    if (uygulama != null &&
        maclar != null &&
        gecmis != null &&
        vip != null &&
        basket != null &&
        futbol != null) {
      return ListView.builder(
          itemCount: gecmis.docs.length,
          padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
          itemBuilder: (context, i) {
            if (gecmis.docs[i].get("tur") == "Premium") {
              renk1 = Colors.blueAccent[400];
            } else if (gecmis.docs[i].get("tur") == "VIP") {
              renk1 = Color(0xFFbd9903);
            } else {
              renk1 = Colors.green[800];
            }
            return Card(
              elevation: 20,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
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
                        iconbelirle(i, gecmis),
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
                              (gecmis.docs[i].get("tur") +
                                  "\n" +
                                  gecmis.docs[i].get("ulke") +
                                  "\n" +
                                  gecmis.docs[i].get("zaman")),
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
                            gecmis.docs[i].get("taraf1") +
                                "\nvs\n" +
                                gecmis.docs[i].get("taraf2") +
                                "\nBet: " +
                                gecmis.docs[i].get("tahmin") +
                                "\nOdd: " +
                                gecmis.docs[i].get("oran"),
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
                          gecmis.docs[i].get("logo") +
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
      startTimer();
      return Text(
        "Loading, Please Wait..",
        style: TextStyle(fontWeight: FontWeight.bold),
      );
    }
  }

  void startTimer2() {
    //GEREKSİZSE SİLL
    _start = 32;
    const oneSec = const Duration(seconds: 1);
    timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(() {
        if (_start < 1) {
          timer.cancel();
          if (_coins != 0) {
            setState(() {
              _currentindex = 0;
            });
          }
        } else {
          _start = _start - 1;
        }
      }),
    );
  }

  void startTimer() {
    //GEREKSİZSE SİLL
    const oneSec = const Duration(seconds: 1);
    _start = 2;
    timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(() {
        if (_start < 1) {
          timer.cancel();
          setState(() {});
        } else {
          _start = _start - 1;
        }
      }),
    );
  }

  Widget _kuponGoster() {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
      alignment: Alignment.center,
      child: Column(
        children: [
          SizedBox(
            height: _height * 0.25,
          ),
          Text(
            "Watch the ad for the coupon of the day and start win!",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: _height * 0.025,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: _height * 0.1,
          ),
          Container(
            width: _width * 0.8,
            height: _height * 0.08,
            child: RaisedButton(
              elevation: 25,
              color: Colors.blueGrey[200],
              onPressed: () {
                UnityAds.showVideoAd(
                  placementId: 'rewardedVideo',
                  listener: (state, args) {
                    print('Rewarded Video Listener: $state => $args');
                  },
                );
                setState(() {
                  _coins++;
                });
                /* RewardedVideoAd.instance.show();
                RewardedVideoAd.instance.load(
                    adUnitId: 'ca-app-pub-5316337657364445/2257228562',
                    targetingInfo: targetingInfo); */
                //startTimer2();
              },
              child: Container(
                child: Text(
                  "Click and Watch Ad!",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: _height * 0.025,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _rateUS() {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
      alignment: Alignment.center,
      child: Column(
        children: [
          SizedBox(
            height: _height * 0.15,
          ),
          Text(
            "We care your opinion! \n Don't forget to rate our app for more bets! \nThank you!!",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: _height * 0.025,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: _height * 0.1,
          ),
          Container(
            width: _width * 0.8,
            height: _height * 0.08,
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.white)),
              elevation: 25,
              color: Colors.teal[400],
              onPressed: () {
                AppReview.storeListing.then((String onValue) {
                  setState(() {
                    output = onValue;
                  });
                  print(onValue);
                });
              },
              child: Container(
                child: Text(
                  "Click and Rate Us!",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: _height * 0.025,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _premiumList() {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    if (uygulama != null &&
        maclar != null &&
        gecmis != null &&
        vip != null &&
        basket != null &&
        futbol != null) {
      return ListView.builder(
          itemCount: premium.docs.length,
          padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
          itemBuilder: (context, i) {
            return Card(
              elevation: 20,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              margin: EdgeInsets.all(5),
              color: Colors.blueAccent[400],
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: _height * 0.05,
                      child: Image.asset(
                        iconbelirle(i, premium),
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
                              (premium.docs[i].get("tur") +
                                  "\n" +
                                  premium.docs[i].get("ulke") +
                                  "\n" +
                                  premium.docs[i].get("zaman")),
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
                            premium.docs[i].get("taraf1") +
                                "\nvs\n" +
                                premium.docs[i].get("taraf2") +
                                "\nBet: " +
                                premium.docs[i].get("tahmin") +
                                "\nOdd: " +
                                premium.docs[i].get("oran"),
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
                          premium.docs[i].get("logo") +
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
      startTimer();
      return Text(
        "Loading, Please Wait..",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: _height * 0.015,
        ),
      );
    }
  }

  showBanner() {
    BannerAd banner = BannerAd(
        adUnitId: uygulama.docs[0].get("thbanner"),
        size: AdSize.fullBanner,
        targetingInfo: targetingInfo);

    banner
      ..load()
      ..show(anchorOffset: 0);

    banner.dispose();
  }

  Widget _vip() {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      alignment: Alignment.topCenter,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "✯TipHouse✯",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: _height * 0.03,
                color: Colors.black),
            textAlign: TextAlign.center,
          ),
          Text(
            "✯VIP TIPS!✯",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: _height * 0.03,
                color: Colors.black),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: _height * 0.04,
          ),
          Text(
            "✯You can see the past VIP tips in our Instagram! \n Click the instagram logo now!✯",
            style: TextStyle(
              fontSize: _height * 0.02,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: _height * 0.012,
          ),
          Text(
            "✯Subscribe VIP to receive our daily exclusive sports bets!✯ \n \n ✯With VIP you will receive our highest odds with the best success rate each day.✯",
            style: TextStyle(
              fontSize: _height * 0.02,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: _height * 0.010,
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            width: _width * 0.8,
            decoration: BoxDecoration(
              color: Colors.white70,
              borderRadius: BorderRadius.circular(29),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Column(children: [
              Text(
                "\n✯VIP SUBSCRIPTION✯\n",
                style: TextStyle(
                  fontSize: _height * 0.02,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              RaisedButton(
                color: Colors.green[300],
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => new InitialScreen()));
                },
                child: Text(
                  "Subscripton",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: _height * 0.015,
                  ),
                ),
              ),
              Text(
                "\nPress the green button if you are already a subscriber.\n",
                style: TextStyle(
                  fontSize: _height * 0.015,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                "You can manage and cancel your subscription anytime.\n",
                style: TextStyle(
                  fontSize: _height * 0.015,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
