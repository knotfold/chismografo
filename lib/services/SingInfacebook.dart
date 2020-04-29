import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:trivia_form/services/controller.dart';
import 'package:trivia_form/services/services.dart';

final FacebookLogin facebookSignIn = new FacebookLogin();
final FirebaseAuth _auth = FirebaseAuth.instance;

//String _message = 'Log in/out by pressing the buttons below.';

Future<String> login(Controller controlador) async {
  final FacebookLoginResult result = await facebookSignIn.logIn(['email']);

  switch (result.status) {
    case FacebookLoginStatus.loggedIn:
      final FacebookAccessToken accessToken = await result.accessToken;

      final AuthCredential credential =
          await FacebookAuthProvider.getCredential(
              accessToken: accessToken.token);
      try {
        final FirebaseUser user =
            (await _auth.signInWithCredential(credential)).user;
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
            'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email,picture.width(800).height(800)&access_token=${token}');
        final profile = json.decode(graphResponse.body);
        controlador.name = (profile['first_name'] + ' ' + profile['last_name']);
        controlador.email = (profile['email']);
        controlador.imageUrl = (profile['picture']['data']['url']);
        print(profile['picture']);
        print(profile['email']);
      } catch (e) {
        print("Error: $e");
        print(e.code.toString());
        if (e.code == 'ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL') {
          print('ando aqui we');
          final signInMethods = await FirebaseAuth.instance
              .fetchSignInMethodsForEmail(email: controlador.email);

          if (signInMethods.contains("google.com")) {
            print(signInMethods);
            print('entre aqui we');
            final authGoogleResult = await signInWithGoogle(controlador);
            // print(authGoogleResult);
            final token = result.accessToken.token;
            final graphResponse = await http.get(
                'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email,picture.width(800).height(800)&access_token=${token}');
            final profile = json.decode(graphResponse.body);
            controlador.name =
                (profile['first_name'] + ' ' + profile['last_name']);
            controlador.email = (profile['email']);
            controlador.imageUrl = (profile['picture']['data']['url']);
            if (authGoogleResult.email == controlador.email) {
              await authGoogleResult.linkWithCredential(credential);
              //await authGoogleResult.user.linkWithCredential(onError.credential);
            }
          }
        }
      }
//       final FirebaseUser user = (await _auth.signInWithCredential(credential).catchError((e) async{
//         print(e.toString());
//           print(e.code.toString());
//             print(e.exeption.toString());

//         if(e.message == 'ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL'){
//                    final token = result.accessToken.token;
// final graphResponse = await http.get(
//             'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email,picture&access_token=${token}');
// final profile = json.decode(graphResponse.body);
// controlador.name= (profile['first_name']+' '+profile['last_name']);
// controlador.email= (profile['email']);
// controlador.imageUrl=(profile['picture']['data']['url']);
//          final signInMethods = await FirebaseAuth.instance
//               .fetchSignInMethodsForEmail(email: controlador.email);
//           if (signInMethods.contains("google.com")) {
//             final authGoogleResult = await signInWithGoogle(controlador);
//             print(authGoogleResult);
//             // if (authGoogleResult..email == onError.email) {
//             //   await authGoogleResult.user.linkWithCredential(onError.credential);
//             // }
//           }
//         }
//         //print(onError.toString());
//       }
//       )).user;

      // final FirebaseUser currentUser = await _auth.currentUser();
      //firebaseAuthWithFacebook(loginResult.getAccessToken());

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
