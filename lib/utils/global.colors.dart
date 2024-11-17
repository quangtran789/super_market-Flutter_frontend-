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
    'https://img.freepik.com/free-vector/online-grocery-store-horizontal-banner_23-2150107228.jpg?t=st=1731838761~exp=1731842361~hmac=fb6fd225b8b2b2a1764743f01b7880c7a7576b3c873f8f8e23b479cce5b094d2&w=1060',
    'https://img.freepik.com/free-vector/hand-drawn-supermarket-sale-background_23-2149406388.jpg?t=st=1731839241~exp=1731842841~hmac=516a60dd2cd55830c7825d941e296da0633b5004a0e8aee933c974420b53865d&w=1060',
    'https://img.freepik.com/free-vector/hand-drawn-grocery-store-facebook-template_23-2151043919.jpg?t=st=1731839603~exp=1731843203~hmac=093a36addeaeefd426b2c029c8c7f58d1d6db00d0022a6cc0f2362fea3299773&w=1060',
    'https://img.freepik.com/free-vector/flat-supermarket-social-media-post-template_23-2149357980.jpg?t=st=1731839651~exp=1731843251~hmac=565c5ef5b41f048c71931d6b37f48b0643ba2b561509ce046be22be9d26f02ba&w=996',
  ];
}
