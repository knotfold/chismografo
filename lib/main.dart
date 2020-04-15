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
          primaryColor: backgroundColor,
          bottomAppBarColor: backgroundColor,
          bottomAppBarTheme: BottomAppBarTheme(
            color: Colors.grey
          ),
          scaffoldBackgroundColor: backgroundColor,
          backgroundColor: backgroundColor,
          dialogBackgroundColor: backgroundColor,
          textTheme: GoogleFonts.rubikTextTheme(),
          accentTextTheme: GoogleFonts.rubikTextTheme(),
          primaryTextTheme: GoogleFonts.rubikTextTheme(),
          primarySwatch: Colors.grey,
        ),
        home: Home(),
        routes: {
          '/misLibretas' : (context) => TusLibretas(),
          '/libretasAmigos' : (context) => LibretasA(),
          '/creadorLibreta' : (context) => FormularioCreator()
        },
      ),
    );
  }
}
