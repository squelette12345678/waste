import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map_example/pages/home.dart';

import '../constant/imagepath.dart';


class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
             image: DecorationImage(fit: BoxFit.cover,
                 image: AssetImage(Imagepath.logo))
          ),

          child: Stack(
            children: [
              Center(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 70,
                        backgroundImage: AssetImage(Imagepath.dechet),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "West",
                        style: TextStyle(
                          color: Colors.white,
                            fontWeight: FontWeight.bold, fontSize: 20),
                      )
                    ],
                  ),
                ),
              ),
              Positioned(
                  bottom: 40,
                  left: 135,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage()));
                    },
                    child: Text('Connection'),
                  )),
              Positioned(
                  bottom: 90,
                  left: 135,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text('Inscription'),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
