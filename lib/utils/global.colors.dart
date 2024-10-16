import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class GlobalColors {
  static HexColor mainColor = HexColor('#1E3190');
  static HexColor textColor = HexColor('#F5F5F5');
}

const kscaffoldColor = Color(0xffffffff);
const kcontentColor = Color(0xffF5F5F5);
const kprimaryColor = Color(0xff1E3190);

class GlobalVariables {
  // COLORS
  static const appBarGradient = LinearGradient(
    colors: [
      Color(0xffffc6c7),
      Color.fromARGB(255, 234, 44, 168),
    ],
    stops: [0.5, 1.0],
  );

  static const secondaryColor = Color.fromRGBO(255, 153, 0, 1);
  static const backgroundColor = Colors.white;
  static const Color greyBackgroundCOlor = Color(0xffebecee);
  static var selectedNavBarColor = Colors.cyan[800]!;
  static const unselectedNavBarColor = Colors.black87;
  // STATIC IMAGES
  static const List<String> carouselImages = [
    'https://img.freepik.com/free-photo/grapes-strawberries-pineapple-kiwi-apricot-banana-whole-pineapple_23-2147968680.jpg?t=st=1728916548~exp=1728920148~hmac=27890902a6c35c6793355ee7f24b1f9ebc25ef1b136d369bee3797c2f42405cb&w=900',
    'https://img.freepik.com/free-photo/top-view-fresh-vegetables-composition-white-background_140725-76664.jpg?t=st=1728916599~exp=1728920199~hmac=45a91482f19b0421154414c2a73ed559853093453896efd10edd98195f827661&w=996',
    'https://img.freepik.com/free-photo/cherry-drops-water-close-up-arrangement-berries-background-fresh-harvest-juicy-cherries-pie-juice-ingredient_166373-1607.jpg?t=st=1728916767~exp=1728920367~hmac=a92be3048764f5a248d53d88cfeaf66670f712cf022074beebb67117c9992eab&w=996',
    'https://img.freepik.com/free-photo/front-view-delicious-shrimps_23-2148393704.jpg?t=st=1728917052~exp=1728920652~hmac=bff81ad069d5a534858dd5b667ce2637a58c8dbc6deb4cdd3ea8ced29ca77c83&w=996',
  ];

  static const List<Map<String, String>> categoryImages = [
    {
      'title': 'Hoa tươi',
      'image': 'assets/images/ornamental-cabbage.png',
    },
    {
      'title': 'Hoa khô',
      'image': 'assets/images/flower.png',
    },
    {
      'title': 'Hạt giống',
      'image': 'assets/images/fruit-tree.png',
    },
    {
      'title': 'Chậu hoa',
      'image': 'assets/images/flower (1).png',
    },
    {
      'title': 'Hoa sự kiện',
      'image': 'assets/images/mandala.png',
    },
  ];
}
