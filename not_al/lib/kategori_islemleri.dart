import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:not_al/utils/database_helper.dart';

import 'models/kategori.dart';

class Kategoriler extends StatefulWidget {
  @override
  _KategorilerState createState() => _KategorilerState();
}

class _KategorilerState extends State<Kategoriler> {
  List<Kategori> tumKategoriler;
  DatabaseHelper databaseHelper;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    databaseHelper = DatabaseHelper();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyleBaslik = Theme.of(context).textTheme.bodyText2.copyWith(
        fontSize: 16, fontWeight: FontWeight.w700, fontFamily: 'Raleway');

    if (tumKategoriler == null) {
      tumKategoriler = List<Kategori>();
      kategoriListesiniGuncelle();
    }

    return Scaffold(
     appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          "Kategoriler",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Container(color:Colors.white,
        child: ListView.builder(
            itemCount: tumKategoriler.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  ListTile(
                    onTap: () => _kategoriGuncelle(tumKategoriler[index], context),
                    title: Text(
                      tumKategoriler[index].kategoriBaslik,
                      style: textStyleBaslik,
                    ),
                    trailing: InkWell(
                      child: Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onTap: () => _kategoriSil(tumKategoriler[index].kategoriID),
                    ),
                    leading: Icon(
                      Icons.import_contacts,
                      color: Colors.indigo,
                    ),
                  ),
                  AdmobBanner(
          adUnitId: "ca-app-pub-2062750101933669/9964889896",
                                adSize: AdmobBannerSize.BANNER,
                                listener: (AdmobAdEvent event,
                                    Map<String, dynamic> args) {
                                  handleEvent(event, args, 'Banner');
                                },
                                onBannerCreated:
                                    (AdmobBannerController controller) {
                                },
                              ),
                ],
              );
            }),
      ),
    );
  }

  void kategoriListesiniGuncelle() {
    databaseHelper.kategoriListesiniGetir().then((kategorileriIcerenList) {
      setState(() {
        tumKategoriler = kategorileriIcerenList;
      });
    });
  }

  _kategoriSil(int kategoriID) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text("Kategori Sil ",
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.blueGrey,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Raleway')),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                    "Kategoriyi sildiğinizde bununla ilgili tüm notlar da silinecektir.\n\nEmin Misiniz ?"),
                ButtonBar(
                  children: <Widget>[
                    OutlineButton(
                      borderSide:
                          BorderSide(color: Theme.of(context).primaryColor),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("Vazgeç",style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 20, fontWeight: FontWeight.w700),),
                    ),
                    OutlineButton(
                      borderSide:
                          BorderSide(color: Theme.of(context).accentColor),
                      onPressed: () {
                        databaseHelper
                            .kategoriSil(kategoriID)
                            .then((silinenKategori) {
                          if (silinenKategori != 0) {
                            setState(() {
                              kategoriListesiniGuncelle();
                              Navigator.pop(context);
                            });
                          }
                        });
                      },
                      child: Text(
                        "Sil",
                        style: TextStyle(
                            color: Theme.of(context).accentColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        });
  }

  _kategoriGuncelle(Kategori guncellenecekKategori, BuildContext c) {
    kategoriGuncelleDialog(c, guncellenecekKategori);
  }

  void kategoriGuncelleDialog(
      BuildContext myContext, Kategori guncellenekKategori) {
    var formKey = GlobalKey<FormState>();
    String guncellenecekKategoriAdi;

    showDialog(
        barrierDismissible: false,
        context: myContext,
        builder: (context) {
          return SimpleDialog(
            title: Text(
              "Kategori Güncelle",
              style: TextStyle(
                  fontFamily: "Raleway",
                  fontWeight: FontWeight.w700,
                  color: Colors.blueGrey),
            ),
            children: <Widget>[
              Form(
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    initialValue: guncellenekKategori.kategoriBaslik,
                    onSaved: (yeniDeger) {
                      guncellenecekKategoriAdi = yeniDeger;
                    },
                    decoration: InputDecoration(
                      labelText: "Kategori Adı",
                      border: OutlineInputBorder(),
                    ),
                    validator: (girilenKategoriAdi) {
                      if (girilenKategoriAdi.length < 3) {
                        return "En az 3 karakter giriniz";
                      }
                    },
                  ),
                ),
              ),
              ButtonBar(
                children: <Widget>[
                  OutlineButton(
                    borderSide:
                        BorderSide(color: Theme.of(context).primaryColor),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    color: Colors.orangeAccent,
                    child: Text(
                      "Vazgeç",
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  OutlineButton(
                    borderSide:
                        BorderSide(color: Theme.of(context).accentColor),
                    onPressed: () {
                      if (formKey.currentState.validate()) {
                        formKey.currentState.save();

                        databaseHelper
                            .kategoriGuncelle(Kategori.withID(
                                guncellenekKategori.kategoriID,
                                guncellenecekKategoriAdi))
                            .then((katID) {
                          if (katID != 0) {
                            Scaffold.of(myContext).showSnackBar(
                              SnackBar(
                                content: Text("Kategori Güncellendi"),
                                duration: Duration(seconds: 1),
                              ),
                            );
                            kategoriListesiniGuncelle();
                            Navigator.of(context).pop();
                          }
                        });
                      }
                    },
                    color: Colors.redAccent,
                    child: Text(
                      "Kaydet",
                      style: TextStyle(
                          color: Theme.of(context).accentColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              )
            ],
          );
        });
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