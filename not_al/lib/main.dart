import 'dart:io';
import 'package:flutter/material.dart';
import 'package:not_al/kategori_islemleri.dart';
import 'package:not_al/not_detay.dart';
import 'package:not_al/utils/database_helper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'models/kategori.dart';
import 'models/notlar.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NoteApp',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.indigo, accentColor: Colors.indigo),
      home: NotListesi(),
    );
  }
}

class NotListesi extends StatelessWidget {
  DatabaseHelper databaseHelper = DatabaseHelper();
  var _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        actions: <Widget>[
          PopupMenuButton(
            icon: Icon(FontAwesomeIcons.archive, color: Colors.black38),
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  child: ListTile(
                    leading: Icon(FontAwesomeIcons.alignLeft),
                    title: Text("Kategoriler"),
                    onTap:()=> _kategorilerSayfasinaGit(context),
                  ),
                ),
              ];
            },
          ),
        ],
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          "NoteApp",
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic),
        ),
        centerTitle: true,
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            backgroundColor: Colors.indigo,
            onPressed: () {
              kategoriEkleDialog(context);
            },
            heroTag: "KategoriEkle",
            tooltip: "Kategori Ekle",
            child: Icon(
              FontAwesomeIcons.tags,
              size: 15,
              color: Colors.white,
            ),
            mini: true,
          ),
          FloatingActionButton(
            backgroundColor: Colors.indigo,
            tooltip: "Not Ekle",
            heroTag: "NotEkle",
            onPressed: () => _detaySayfasinaGit(context),
            child: Icon(FontAwesomeIcons.solidEdit),
          ),
        ],
      ),
      body: Notlar(),
    );
  }

  void kategoriEkleDialog(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    String yeniKategoriAdi;

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text("Kategori Ekle"),
            children: <Widget>[
              Form(
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    onSaved: (yeniDeger) {
                      yeniKategoriAdi = yeniDeger;
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
                    color: Colors.red,
                    child: Text(
                      "Vazgeç",
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                  ),
                  OutlineButton(
                    borderSide:
                        BorderSide(color: Theme.of(context).accentColor),
                    onPressed: () {
                      if (formKey.currentState.validate()) {
                        formKey.currentState.save();
                        databaseHelper
                            .kategoriEkle(Kategori(yeniKategoriAdi))
                            .then((kategoriID) {
                          if (kategoriID > 0) {
                            _scaffoldKey.currentState.showSnackBar(
                              SnackBar(
                                content: Text("Kategori Eklendi"),
                                duration: Duration(seconds: 3),
                              ),
                            );
                            Navigator.pop(context);
                          }
                        });
                      }
                    },
                    color: Colors.green,
                    child: Text(
                      "Kaydet",
                      style: TextStyle(
                          color: Colors.green, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              )
            ],
          );
        });
  }

  _detaySayfasinaGit(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => NotDetay(
                  baslik: "Yeni Not",
                )));
  }
}

class Notlar extends StatefulWidget {
  @override
  _NotlarState createState() => _NotlarState();
}

class _NotlarState extends State<Notlar> {
  List<Not> tumNotlar;
  DatabaseHelper databaseHelper;

  @override
  void initState() {
    super.initState();
    tumNotlar = List<Not>();
    databaseHelper = DatabaseHelper();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: FutureBuilder(
        future: databaseHelper.notListesiniGetir(),
        builder: (context, AsyncSnapshot<List<Not>> snapShot) {
          if (snapShot.connectionState == ConnectionState.done) {
            tumNotlar = snapShot.data;
            sleep(Duration(milliseconds: 2000));
            return ListView.builder(
              itemCount: tumNotlar.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: ExpansionTile(
                    leading: _oncelikIconAta(tumNotlar[index].notOncelik),
                    title: Text(tumNotlar[index].notBaslik),
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Kategori: ",
                                    style: TextStyle(
                                        color: Colors.indigo, fontSize: 18),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    tumNotlar[index].kategoriBaslik,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 18),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "İçerik: \n" + tumNotlar[index].notIcerik,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16),
                              ),
                            ),
                            ButtonBar(
                              children: <Widget>[
                                FlatButton(
                                    onPressed: () =>
                                        _notSil(tumNotlar[index].notID),
                                    child: Text(
                                      "Sil",
                                      style: TextStyle(color: Colors.red),
                                    )),
                                FlatButton(
                                    onPressed: () {
                                      _detaySayfasinaGit(
                                          context, tumNotlar[index]);
                                    },
                                    child: Text(
                                      "Düzenle",
                                      style: TextStyle(color: Colors.green),
                                    )),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
            );
          } else {
            return Center(child: Text("Yükleniyor\nFrom:ONUR AKDOĞAN"));
          }
        },
      ),
    );
  }

  _detaySayfasinaGit(BuildContext context, Not not) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => NotDetay(
                  baslik: "Notu Düzenle",
                  duzenlenecekNot: not,
                )));
  }

  _oncelikIconAta(int notOncelik) {
    switch (notOncelik) {
      case 0:
        return CircleAvatar(
          child: Text("AZ", style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.green.shade200,
        );
        break;
      case 1:
        return CircleAvatar(
          child: Text("ORTA", style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.orange.shade400,
        );

        break;
      case 2:
        return CircleAvatar(
          child: Text("ACIL", style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.red.shade700,
        );

        break;
    }
  }

  _notSil(int notID) {
    databaseHelper.notSil(notID).then((silinenID) {
      if (silinenID != 0) {
        Scaffold.of(context)
            .showSnackBar(SnackBar(content: Text("Notu Sildiniz")));
        setState(() {});
      }
    });
  }
}

void _kategorilerSayfasinaGit(BuildContext context) {
  Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => Kategoriler()));
}
