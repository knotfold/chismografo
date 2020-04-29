import 'package:flutter/material.dart';
import 'pages/pages.dart';
import 'package:provider/provider.dart';
import 'package:trivia_form/services/services.dart';
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
          cardTheme:CardTheme(color:primaryLight ) ,
          appBarTheme: AppBarTheme(color: primaryColor),
          primaryColor: Colors.black,
          bottomAppBarColor: primaryColor,
         bottomAppBarTheme: BottomAppBarTheme(color: primaryColor),
        
          scaffoldBackgroundColor:Colors.white,
          backgroundColor: backgroundColor,
          dialogBackgroundColor: primaryColor,
        
          textTheme: GoogleFonts.rubikTextTheme(),
          accentTextTheme: GoogleFonts.rubikTextTheme(),
          primaryTextTheme: GoogleFonts.rubikTextTheme(),
          primarySwatch: Colors.blueGrey,
          iconTheme: IconThemeData(color: primaryDark ),
         floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor: secondaryColor,elevation: 4,shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)) )
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
        },
      ),
    );
  }
}
