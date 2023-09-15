import 'package:flutter/material.dart';

class loading_screen extends StatefulWidget {
  Loading_Screen createState() => Loading_Screen();
}

class Loading_Screen extends State<loading_screen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white
      ),
      child: Align(
        alignment: Alignment(0,0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('asset/image/loading_logo.png',
            width: MediaQuery.of(context).size.width/2.5,),
            SizedBox(
                height: MediaQuery.of(context).size.height*0.05,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '오늘',
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.w900,
                    fontSize: 50,
                    decoration: TextDecoration.none
                  ),
                ),
                Text(
                  '뭐먹지',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 30,
                      fontWeight: FontWeight.w400,
                      decoration: TextDecoration.none
                  ),
                ),
                Text(
                  '?',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                    decoration: TextDecoration.none,
                    fontSize: 70,
                  ),
                )
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height/10,),

            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
