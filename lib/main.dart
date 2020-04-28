import 'package:flutter/material.dart';
import 'pages/pages.dart';
import 'package:provider/provider.dart';
import 'package:trivia_form/services/services.dart';
import 'pages/pages.dart';
import 'shared/shared.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Controller controller = Controller();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => controller,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          appBarTheme: AppBarTheme(color: Colors.blue),
          primaryColor: Colors.black,
          bottomAppBarColor: Colors.red,
         bottomAppBarTheme: BottomAppBarTheme(color: Colors.red),
          scaffoldBackgroundColor:backgroundColor,
          backgroundColor: backgroundColor,
          dialogBackgroundColor: color1,
          textTheme: GoogleFonts.rubikTextTheme(),
          accentTextTheme: GoogleFonts.rubikTextTheme(),
          primaryTextTheme: GoogleFonts.rubikTextTheme(),
          primarySwatch: Colors.blueGrey,
          iconTheme: IconThemeData(color: buttonColors ),
         floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor: buttonColors,elevation: 1)
        ),
        home: LogIn(),
        routes: {
          '/home': (context) => Home(),
          'login': (context) => LogIn(),
          '/responderLibreta' : (context) => FormularioPV(formularioModel: ModalRoute.of(context).settings.arguments,),
          '/registro_usuario': (context) => RegistroUsuario(),
          '/misLibretas': (context) => TusLibretas(),
          '/libretasAmigos': (context) => LibretasA(),
          '/creadorLibreta': (context) => FormularioCreator(),
          '/libretaDetalles' : (context) => LibretaDetails(),
          'perfil' : (context) => Perfil(),
        },
      ),
    );
  }
}
