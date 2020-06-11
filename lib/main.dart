import 'package:flutter/material.dart';
import 'pages/pages.dart';
import 'package:provider/provider.dart';
import 'package:ChisMe/services/services.dart';
import 'shared/shared.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

void main() {
  InAppPurchaseConnection.enablePendingPurchases();
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
          accentColor: secondaryColor,
          highlightColor: secondaryColor,
          indicatorColor: secondaryColor,
          buttonBarTheme: ButtonBarThemeData(
            
          ),
          popupMenuTheme: PopupMenuThemeData(
            textStyle: TextStyle(color: Colors.black)
          ),
          tooltipTheme: TooltipThemeData(
            textStyle: TextStyle(color:Colors.black),
            decoration: BoxDecoration(
              color: Colors.black
            )
          ),
            brightness: Brightness.light,
            cardTheme: CardTheme(elevation: 10),
            appBarTheme: AppBarTheme(color: primaryColor),
            primaryColor: primaryColor,
            colorScheme: ColorScheme(
              primary: primaryColor,
              onPrimary: Colors.white,
              onSecondary: Colors.black,
              brightness: Brightness.light,
              onBackground: Colors.black,
              onSurface: Colors.white,
              primaryVariant: pDark,
              secondary: secondaryColor,
              secondaryVariant: sDark,
              background: Colors.white,
              onError: Colors.red,
              surface: Colors.white,
              error: Colors.red,
            ),
            backgroundColor: primaryColor,
            buttonColor: secondaryColor,
            secondaryHeaderColor: secondaryColor,
            bottomAppBarColor: Colors.red,
            bottomAppBarTheme: BottomAppBarTheme(color: primaryColor),
            scaffoldBackgroundColor: Colors.white,
            textTheme: GoogleFonts.rubikTextTheme(
                TextTheme().apply(bodyColor: Colors.white)),
            accentTextTheme: GoogleFonts.rubikTextTheme(
                TextTheme().apply(bodyColor: Colors.white)),
            primaryTextTheme: GoogleFonts.rubikTextTheme(
                TextTheme().apply(bodyColor: Colors.white)),
            primarySwatch: Colors.blueGrey,
            accentIconTheme: IconThemeData(color: Colors.black),
            iconTheme: IconThemeData(color: pDark),
            dialogBackgroundColor: primaryColor,
            
            dialogTheme: DialogTheme(
              titleTextStyle: TextStyle(color: Colors.black),
              
              backgroundColor: primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              contentTextStyle: TextStyle(color: Colors.white),
              

            ),
            canvasColor: pLight,
            primaryIconTheme: IconThemeData(color: Colors.white),
            buttonTheme: ButtonThemeData(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                colorScheme: ColorScheme(
                  primary: primaryColor,
                  onPrimary: Colors.white,
                  onSecondary: Colors.black,
                  brightness: Brightness.dark,
                  onBackground: Colors.black,
                  onSurface: Colors.white,
                  primaryVariant: pDark,
                  secondary: secondaryColor,
                  secondaryVariant: sDark,
                  background: Colors.white,
                  onError: Colors.red,
                  surface: Colors.black,
                  error: Colors.red,
                ),
                
                disabledColor: secondaryColor,
                highlightColor: secondaryColor,
                buttonColor: secondaryColor),
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
          '/imageViewer' : (context) => ImageViewer(
            image: ModalRoute.of(context).settings.arguments,
          ),
          '/chat' : (context) => Chat(
            usuarios: ModalRoute.of(context).settings.arguments,
            nombre: ModalRoute.of(context).settings.arguments,
            foto: ModalRoute.of(context).settings.arguments,
            
            
          ),
          '/registro_usuario': (context) => RegistroUsuario(),
          '/misLibretas': (context) => TusLibretas(),
          '/libretasAmigos': (context) => LibretasA(),
          '/creadorLibreta': (context) => FormularioCreator(),
          '/libretaDetalles': (context) => LibretaDetails(),
   
        },
      ),
    );
  }
}
