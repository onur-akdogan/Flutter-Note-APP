import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:not_al/models/kategori.dart';
import 'package:not_al/models/notlar.dart';
import 'package:not_al/utils/database_helper.dart';

class NotDetay extends StatefulWidget {
  String baslik;
  Not duzenlenecekNot;

  NotDetay({this.baslik, this.duzenlenecekNot});

  @override
  _NotDetayState createState() => _NotDetayState();
}

class _NotDetayState extends State<NotDetay> {
  var formKey = GlobalKey<FormState>();
  List<Kategori> tumKategoriler;
  DatabaseHelper databaseHelper;
  int kategoriID;
  int secilenOncelik;
  String notBaslik, notIcerik;
  static var _oncelik = ["Düşük", "Orta", "Yüksek"];
  
  @override
  void initState() {
    super.initState();
    tumKategoriler = List<Kategori>();
    databaseHelper = DatabaseHelper();
    databaseHelper.kategorileriGetir().then((kategoriIcerenMapListesi) {
      for (Map okunanMap in kategoriIcerenMapListesi) {
        tumKategoriler.add(Kategori.fromMap(okunanMap));
      }

      if (widget.duzenlenecekNot != null) {
        kategoriID = widget.duzenlenecekNot.kategoriID;
        secilenOncelik = widget.duzenlenecekNot.notOncelik;
      } else {
        kategoriID = 1;
        secilenOncelik = 0;
      }

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
          child: Column(
        children: <Widget>[
          AdmobBanner(
          adUnitId: "ca-app-pub-2062750101933669/4408885858",
                                adSize: AdmobBannerSize.BANNER,
                                listener: (AdmobAdEvent event,
                                    Map<String, dynamic> args) {
                                  handleEvent(event, args, 'Banner');
                                },
                                onBannerCreated:
                                    (AdmobBannerController controller) {
                                },
                              ),
          Container(
            width: 300,
            height: 100,
            child: Padding(
              padding: const EdgeInsets.only(top: 0),
              child: Center(
                child: Text(
                  widget.baslik,
                  style: TextStyle(
                      fontSize: 22,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic),
                ),
              ),
            ),
          ),
          tumKategoriler.length <= 0
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Container(
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 12.0, left: 12),
                              child: Text(
                                "Kategori : ",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 20),
                              margin: EdgeInsets.only(top: 12),
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.teal, width: 1),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                  items: kategoriItemleriOlustur(),
                                  value: kategoriID,
                                  onChanged: (secilenKategoriID) {
                                    setState(() {
                                      kategoriID = secilenKategoriID;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            initialValue: widget.duzenlenecekNot != null
                                ? widget.duzenlenecekNot.notBaslik
                                : "",
                            validator: (text) {
                              if (text.length < 3) {
                                return "En Az 3 Karekter Giriniz !";
                              }
                            },
                            onSaved: (text) {
                              notBaslik = text;
                            },
                            decoration: InputDecoration(
                              hintText: "Not Başlığını Giriniz",
                              labelText: "Başlık",
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            initialValue: widget.duzenlenecekNot != null
                                ? widget.duzenlenecekNot.notIcerik
                                : "",
                            onSaved: (text) {
                              notIcerik = text;
                            },
                            maxLines: 6,
                            decoration: InputDecoration(
                              hintText: "Not İçeriğini Giriniz",
                              labelText: "İçerik",
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                               AdmobBanner(
          adUnitId: "ca-app-pub-2062750101933669/5530395835",
                                adSize: AdmobBannerSize.BANNER,
                                listener: (AdmobAdEvent event,
                                    Map<String, dynamic> args) {
                                  handleEvent(event, args, 'Banner');
                                },
                                onBannerCreated:
                                    (AdmobBannerController controller) {
                                },
                              ),
                        Row(
                          children: <Widget>[
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 12.0, left: 12),
                              child: Text(
                                "Öncelik : ",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 20),
                              margin: EdgeInsets.only(top: 12),
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.teal, width: 1),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<int>(
                                  items: _oncelik.map((oncelik) {
                                    return DropdownMenuItem<int>(
                                      child: Text(
                                        oncelik,
                                        style: TextStyle(fontSize: 24),
                                      ),
                                      value: _oncelik.indexOf(oncelik),
                                    );
                                  }).toList(),
                                  value: secilenOncelik,
                                  onChanged: (secilenOncelikID) {
                                    setState(
                                      () {
                                        secilenOncelik = secilenOncelikID;
                                      },
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: ButtonBar(
                            alignment: MainAxisAlignment.spaceEvenly,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              RaisedButton(
                                splashColor: Colors.red,
                                padding: EdgeInsets.only(
                                    top: 20, bottom: 20, left: 30, right: 30),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text("Vazgeç"),
                                color: Colors.red.shade300,
                              ),
                              RaisedButton(
                                  padding: EdgeInsets.only(
                                      top: 20, bottom: 20, left: 30, right: 30),
                                  splashColor: Colors.teal,
                                  color: Colors.green.shade300,
                                  onPressed: () {
                                    if (formKey.currentState.validate()) {
                                      formKey.currentState.save();

                                      var suan = DateTime.now();
                                      if (widget.duzenlenecekNot == null) {
                                        databaseHelper
                                            .notEkle(Not(
                                                kategoriID,
                                                notBaslik,
                                                notIcerik,
                                                suan.toString(),
                                                secilenOncelik))
                                            .then((kaydedilenNotID) {
                                          if (kaydedilenNotID != 0) {
                                            Navigator.pop(context);
                                          }
                                        });
                                      } else {
                                        databaseHelper
                                            .notGuncelle(Not.withID(
                                                widget.duzenlenecekNot.notID,
                                                kategoriID,
                                                notBaslik,
                                                notIcerik,
                                                suan.toString(),
                                                secilenOncelik))
                                            .then((guncellenenID) {
                                          if (guncellenenID != 0) {
                                            Navigator.pop(context);
                                          }
                                        });
                                      }
                                    }
                                  },
                                  child: Text(
                                    "KAYDET",style: TextStyle(
                                    color: Colors.white,
                                  )),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        ],
      )),
    );
  }

  List<DropdownMenuItem<int>> kategoriItemleriOlustur() {
    return tumKategoriler
        .map((kategori) => DropdownMenuItem<int>(
              value: kategori.kategoriID,
              child: Text(
                kategori.kategoriBaslik,
                style: TextStyle(fontSize: 24),
              ),
            ))
        .toList();
  }
}

GlobalKey<ScaffoldState> scaffoldState = GlobalKey();
     AdmobBannerSize bannerSize;
   AdmobInterstitial interstitialAd;
   AdmobReward rewardAd;

     void handleEvent(
      AdmobAdEvent event, Map<String, dynamic> args, String adType) {
    switch (event) {
      case AdmobAdEvent.loaded:
    
        break;
      case AdmobAdEvent.opened:
    
        break;
      case AdmobAdEvent.closed:
       
        break;
      case AdmobAdEvent.failedToLoad:
  
      break;
      case AdmobAdEvent.rewarded:
      }}