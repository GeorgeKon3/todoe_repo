import 'package:flutter/material.dart';
import 'package:todoe/utils/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              Spacer(),
              Image(
                //color: kMainCustomizingColor,
                height: 200,
                width: 200,
                image: AssetImage('assets/minimal_logo.png'),
              ),
              SizedBox(height: 20),

              Text(
                'Get your Money',
                style: titleTextStyle(),
              ),
              SizedBox(height: 5),
              Text(
                'Under Control',
                style: titleTextStyle(),
              ),
              SizedBox(height: 15),

              Text(
                'Manage your expenses.',
                style: subtitleTextStyle(),
              ),
              SizedBox(height: 5),
              Text(
                'Seamlessly.',
                style: subtitleTextStyle(),
              ),
              SizedBox(height: 60),

              /// Sign Up With Google
              InkWell(
                onTap: () async {
                  bool res = await AuthProvider().loginWithGoogle();
                  if (!res) print("error logging in with google");
                },
                child: Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3.0),
                    border: Border.all(color: Colors.grey[400], width: 1.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(height: 20, width: 20, image: AssetImage('assets/google_logo.png')),
                      Padding(
                        padding: EdgeInsets.only(left: 5, top: 2),
                        child: Text(
                          'Sign Up With Google',
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'KumbhSans',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 10),

              /// Sign Up With Facebook
              Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3.0),
                  border: Border.all(color: Colors.grey[400], width: 1.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(height: 20, width: 20, image: AssetImage('assets/facebook_logo.png')),
                    Padding(
                      padding: EdgeInsets.only(left: 2, top: 2),
                      child: Text(
                        'Sign Up With Facebook',
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'KumbhSans',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40),

              /// Already have an account?
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account?',
                    style: TextStyle(
                      fontFamily: 'KumbhSans',
                    ),
                  ),
                  SizedBox(width: 5),
                  Text(
                    'Sign In',
                    style: TextStyle(
                      fontFamily: 'KumbhSans',
                      decoration: TextDecoration.underline,
                    ),
                  )
                ],
              ),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  TextStyle titleTextStyle() {
    return TextStyle(
      fontSize: 25,
      fontWeight: FontWeight.w900,
      fontFamily: 'KumbhSans',
    );
  }

  TextStyle subtitleTextStyle() {
    return TextStyle(
      color: Colors.black45,
      fontSize: 16,
      fontWeight: FontWeight.w700,
      fontFamily: 'KumbhSans',
    );
  }
}
