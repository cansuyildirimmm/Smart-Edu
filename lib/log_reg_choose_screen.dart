import 'package:flutter/material.dart';

class LogRegChooseScreen extends StatefulWidget {
  const LogRegChooseScreen({super.key});

  @override
  State<LogRegChooseScreen> createState() => _LogRegChooseScreenState();
}

class _LogRegChooseScreenState extends State<LogRegChooseScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xFFFFB3A4),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/smartedu_logo",
          width: 200,
            fit: BoxFit.contain,
            height: 200,

          ),
          SizedBox(height: 40,),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.1,),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Öğretmen Platformuna Hoş Geldiniz',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color(0xFF1F1F39),
                    fontSize: size.width * 0.08,
                    fontFamily: 'Urbanist',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                ElevatedButton(onPressed: (){},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF3D5CFF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 17),
                      minimumSize: Size(double.infinity, 50),
                    )
                    , child:
                  Text("Giriş Yap",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontFamily: 'Urbanist',
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.20,
                  ),
                  )
                ),
                SizedBox(height: 20),
                ElevatedButton(onPressed: (){},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFF3F1F1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 17),
                      minimumSize: Size(double.infinity, 50),
                    )
                    , child:
                    Text("Kayıt Ol",
                      style: TextStyle(
                        color: Color(0xFFA7A7A7),
                        fontSize: 18,
                        fontFamily: 'Urbanist',
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.20,
                      ),
                    )
                ),
                SizedBox(height: 20),
                Text(
                  'Hesabınızla Devam Edin',
                  style: TextStyle(
                    color: const Color(0xFF1F1F39),
                    fontSize: size.width * 0.045,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: size.width * 0.5,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFD44638)),
                    ),
                    child: Center(
                      child: Text(
                        'GOOGLE',
                        style: TextStyle(

                          color: const Color(0xFFD44638),
                          fontSize: size.width * 0.045,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}
