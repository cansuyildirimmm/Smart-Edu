import 'package:flutter/material.dart';


class RetmeniinWidget extends StatefulWidget {
  @override
  _RetmeniinWidgetState createState() => _RetmeniinWidgetState();
}

class _RetmeniinWidgetState extends State<RetmeniinWidget> {
  @override
  Widget build(BuildContext context) {
    // Figma Flutter Generator RetmeniinWidget - FRAME

    return Container(
        width: 458,
        height: 864,
        decoration: BoxDecoration(
          borderRadius : BorderRadius.only(
            topLeft: Radius.circular(18),
            topRight: Radius.circular(18),
            bottomLeft: Radius.circular(18),
            bottomRight: Radius.circular(18),
          ),
          color : Color.fromRGBO(255, 179, 164, 1),
        ),
        child: Stack(
            children: <Widget>[
              Positioned(
                  top: 341,
                  left: 79,
                  child: Text('Öğretmen Platformuna Hoş Geldiniz', textAlign: TextAlign.center, style: TextStyle(
                      color: Color.fromRGBO(31, 31, 57, 1),
                      fontFamily: 'Urbanist',
                      fontSize: 40,
                      letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                      fontWeight: FontWeight.normal,
                      height: 1.5 /*PERCENT not supported*/
                  ),)
              ),Positioned(
                  top: 542,
                  left: 46,
                  child: Container(
                    decoration: BoxDecoration(

                    ),
                    padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,

                      children: <Widget>[Container(
                        decoration: BoxDecoration(
                          borderRadius : BorderRadius.only(
                            topLeft: Radius.circular(14),
                            topRight: Radius.circular(14),
                            bottomLeft: Radius.circular(14),
                            bottomRight: Radius.circular(14),
                          ),
                          boxShadow : [BoxShadow(
                              color: Color.fromRGBO(23, 206, 146, 0.25),
                              offset: Offset(4,8),
                              blurRadius: 24
                          )],
                          color : Color.fromRGBO(61, 92, 255, 1),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 15.272727012634277, vertical: 17.18181800842285),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,

                          children: <Widget>[
                            Text('Giriş Yap', textAlign: TextAlign.center, style: TextStyle(
                                color: Color.fromRGBO(255, 255, 255, 1),
                                fontFamily: 'Urbanist',
                                fontSize: 18,
                                letterSpacing: 0.20000000298023224,
                                fontWeight: FontWeight.normal,
                                height: 1.5 /*PERCENT not supported*/
                            ),),

                          ],
                        ),
                      ), SizedBox(height : 27),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius : BorderRadius.only(
                              topLeft: Radius.circular(14),
                              topRight: Radius.circular(14),
                              bottomLeft: Radius.circular(14),
                              bottomRight: Radius.circular(14),
                            ),
                            color : Color.fromRGBO(243, 241, 241, 1),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 15.272727012634277, vertical: 17.18181800842285),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,

                            children: <Widget>[
                              Text('Kayıt Ol', textAlign: TextAlign.center, style: TextStyle(
                                  color: Color.fromRGBO(166, 166, 166, 1),
                                  fontFamily: 'Urbanist',
                                  fontSize: 17.18181800842285,
                                  letterSpacing: 0.19090908765792847,
                                  fontWeight: FontWeight.normal,
                                  height: 1.5 /*PERCENT not supported*/
                              ),),

                            ],
                          ),
                        ),
                      ],
                    ),
                  )
              ),Positioned(
                  top: 716,
                  left: 138,
                  child: Container(
                      width: 190,
                      height: 119,

                      child: Stack(
                          children: <Widget>[
                            Positioned(
                                top: 62,
                                left: 14,
                                child: Container(
                                    width: 165,
                                    height: 57,

                                    child: Stack(
                                        children: <Widget>[
                                          Positioned(
                                              top: 0,
                                              left: 0,
                                              child: Container(
                                                  width: 165,
                                                  height: 57,

                                                  child: Stack(
                                                      children: <Widget>[
                                                        Positioned(
                                                            top: 0,
                                                            left: 0,
                                                            child: Container(
                                                                width: 165,
                                                                height: 57,
                                                                decoration: BoxDecoration(
                                                                  borderRadius : BorderRadius.only(
                                                                    topLeft: Radius.circular(10),
                                                                    topRight: Radius.circular(10),
                                                                    bottomLeft: Radius.circular(10),
                                                                    bottomRight: Radius.circular(10),
                                                                  ),
                                                                  color : Color.fromRGBO(212, 70, 56, 0.25),
                                                                )
                                                            )
                                                        ),Positioned(
                                                            top: 18,
                                                            left: 47,
                                                            child: Text('Google', textAlign: TextAlign.center, style: TextStyle(
                                                                color: Color.fromRGBO(212, 70, 56, 1),
                                                                fontFamily: 'Poppins',
                                                                fontSize: 14,
                                                                letterSpacing: 2.549999952316284,
                                                                fontWeight: FontWeight.normal,
                                                                height: 1
                                                            ),)
                                                        ),
                                                      ]
                                                  )
                                              )
                                          ),
                                        ]
                                    )
                                )
                            ),Positioned(
                                top: 0,
                                left: 0,
                                child: Text('Hesabınızla Devam Edin', textAlign: TextAlign.left, style: TextStyle(
                                    color: Color.fromRGBO(31, 31, 57, 1),
                                    fontFamily: 'Poppins',
                                    fontSize: 16,
                                    letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                                    fontWeight: FontWeight.normal,
                                    height: 1
                                ),)
                            ),
                          ]
                      )
                  )
              ),
            ]
        )
    );
  }
}
