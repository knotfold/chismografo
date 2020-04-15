import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:trivia_form/services/services.dart';
final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

String name;
String email;
String imageUrl;
String uid;

Future<String> signInWithGoogle(Controller controlador1) async {
  print('entré a signinwithgoogle');
  final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn().catchError((onError){
    print(onError);
  });
  print('paso1');
  final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;
  print('paso2');

  final AuthCredential credential = GoogleAuthProvider.getCredential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );
  print('paso3');

  final FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
  // final FirebaseUser user = authResult.user;
  print('capturé datos de usuario');
//801510547545-dcsc4i7c1tuqume0vkimhkfk7dbbtjrj.apps.googleusercontent.com
  assert(!user.isAnonymous);
  assert(await user.getIdToken() != null);

  assert(user.email != null);
  assert(user.displayName != null);
  assert(user.photoUrl != null);
  assert(user.uid != null);
  controlador1.uid = user.uid;
  controlador1.name = user.displayName;
  print('no la estoy dando con' + controlador1.name.toString());
  controlador1.email = user.email;
  controlador1.imageUrl = user.photoUrl;
  final FirebaseUser currentUser = await _auth.currentUser();
  assert(user.uid == currentUser.uid);

  return 'signInWithGoogle succeeded: $user';
}

void signOutGoogle() async {
  await googleSignIn.signOut();

  print("User Sign Out");
}
