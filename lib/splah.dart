import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:wether_api/homeapp.dart';
class SplahScrren extends StatefulWidget {
  const SplahScrren({Key? key}) : super(key: key);

  @override
  State<SplahScrren> createState() => _SplahScrrenState();
}

class _SplahScrrenState extends State<SplahScrren> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(
      seconds: 3,
      
    )).then((value){
      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MyHomeApp()));
    });
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      backgroundColor: Color(0xff071D31),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Stack(

        children: [


          Container( width: double.infinity,
            height: double.infinity,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(12),

                child: Image.asset("images/a.jpg",fit: BoxFit.cover,)),
          ),

        SizedBox(
          height: MediaQuery.of(context).size.height*0.02,
        ),
        Positioned(
          top: 100,
            bottom: 100,
            right: 100,
            left: 100,

            child:  SpinKitSpinningLines(
          color: Colors.white,
          size: 139.0,
        ))

      ],),),
    ));
  }
}
