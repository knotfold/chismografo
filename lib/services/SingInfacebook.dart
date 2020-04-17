import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:trivia_form/services/controller.dart';


final FacebookLogin facebookSignIn = new FacebookLogin();
final FirebaseAuth _auth = FirebaseAuth.instance;

//String _message = 'Log in/out by pressing the buttons below.';

  Future<String> login(Controller controlador) async {

    final FacebookLoginResult result =
        await facebookSignIn.logIn(['email']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final FacebookAccessToken accessToken = await result.accessToken;
       final AuthCredential credential =await FacebookAuthProvider.getCredential(accessToken: accessToken.token);
       final FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
        final FirebaseUser currentUser = await _auth.currentUser();
        //firebaseAuthWithFacebook(loginResult.getAccessToken());
        
        print('''
         Logged in!
         
         Token: ${accessToken.token}
         User id: ${accessToken.userId}
         Expires: ${accessToken.expires}
         Permissions: ${accessToken.permissions}
         Declined permissions: ${accessToken.declinedPermissions}
         ''');
         final token = result.accessToken.token;
final graphResponse = await http.get(
            'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email,picture&access_token=${token}');
final profile = json.decode(graphResponse.body);
controlador.name= (profile['first_name']+' '+profile['last_name']);
controlador.email= (profile['email']);
controlador.imageUrl=(profile['picture']['data']['url']);

print(profile['picture']);
print(profile['email']);
       
        break;
      case FacebookLoginStatus.cancelledByUser:
        print('Login cancelled by the user.');
        break;
      case FacebookLoginStatus.error:
       print('Something went wrong with the login process.\n'
            'Here\'s the error Facebook gave us: ${result.errorMessage}');
        break;
    }
  }


   Future<Null> logOut() async {
    await facebookSignIn.logOut();
    print('Logged out.');
  }

  //  void print(String message) async{
    
  
  //     _message = message;
   
  // }
