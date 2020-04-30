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
          cardTheme: CardTheme(
            elevation: 10
          ),
            appBarTheme: AppBarTheme(color: primaryColor),
            primaryColor: primaryColor,
            colorScheme: ColorScheme(
              primary: primaryColor,
              onPrimary: Colors.black,
              onSecondary: Colors.black,
              brightness: Brightness.dark,
              onBackground: Colors.black,
              onSurface: Colors.black,
              primaryVariant: pDark,
              secondary: secondaryColor,
              secondaryVariant: sDark,
              background: Colors.white,
              onError: Colors.red,
              surface: Colors.white,
              error: Colors.red,
            ),
            secondaryHeaderColor: secondaryColor,
            bottomAppBarColor: Colors.red,
            bottomAppBarTheme: BottomAppBarTheme(color: primaryColor),
            scaffoldBackgroundColor: Colors.white,
            dialogBackgroundColor: color1,
            textTheme: GoogleFonts.rubikTextTheme(),
            accentTextTheme: GoogleFonts.rubikTextTheme(),
            primaryTextTheme: GoogleFonts.rubikTextTheme(),
            primarySwatch: Colors.blueGrey,
            accentIconTheme: IconThemeData(color: Colors.black),
            iconTheme: IconThemeData(color: pDark),
            dialogTheme: DialogTheme(backgroundColor: primaryColor,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
            primaryIconTheme: IconThemeData(color: Colors.white),
            floatingActionButtonTheme: FloatingActionButtonThemeData(
              backgroundColor: secondaryColor,
              elevation: 5,
            )),
        home: LogIn(),
        routes: {
          '/home': (context) => Home(),
          'login': (context) => LogIn(),
          '/responderLibreta': (context) => FormularioPV(
                formularioModel: ModalRoute.of(context).settings.arguments,
              ),
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
