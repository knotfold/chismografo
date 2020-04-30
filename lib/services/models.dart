//   No se vale decir “no sé” o dejarla en blanco
// 1. ¿Has sido infiel?
// 2. ¿Soportarias una infidelidad?
// 3. ¿Has hecho algo sexual en el último mes? (Besos no cuentan).
// 4. Tipo de beso preferido
// 5. ¿Volverías a estar con tu ex?
// 6.¿ Has mentido a tu mejor amig@?
// 7. Tendrias una cita conmigo?
// 8. ¿Qué te gusta de mí? Fisico
// 9. ¿Qué te gusta de ti?fisico
// 10. ¿Qué opinas sobre mí? Sinceramente.
// 11. ¿Qué te gustaría saber de mí?
// 12. Cuéntame un secreto interesante.
// 13. Tienes que publicar lo mismo que subí yo en tu muro o subo las respuestas.
// 14. Cuando lo publiques en tu muro, te contesto la pregunta 11

import 'package:cloud_firestore/cloud_firestore.dart';

class FormularioModel {
  // List<Map<String,dynamic>> preguntas = [
  //   {
  //     'Nombre': 'hola'
  //   }
  // ];

  List<Pregunta> preguntas = [];
  List<dynamic> usuarios;
  String password;
  String creadorID;
  String creadorUsuario;
  String id;
  bool priv;
  List<dynamic> invitaciones;
  List<dynamic> nombreInvitaciones;
  String nombre;
  DocumentReference reference;
  String fecha;
  String imagen;

  FormularioModel({
    this.creadorID,
    this.creadorUsuario,
    this.id,
    this.password,
    this.preguntas,
    this.usuarios,
    this.priv,
    this.invitaciones,
    this.nombre,
    this.imagen,
  });

  Map<String, dynamic> toMap() {
    List<Map<String, dynamic>> p = [];
    preguntas.forEach((pregunta) {
      p.add(pregunta.toMap());
    });

    return {
      'preguntas': p,
      'creadorID': creadorID,
      'priv': priv,
      'invitaciones': invitaciones,
      'nombre': nombre,
      'creadorUsuario': creadorUsuario,
      'usuarios' : usuarios,
      'fecha' : DateTime.now(),
      'imagen' : imagen
    };
  }

  String dateString(DateTime dateTime) {
    return dateTime.day.toString() +
        '-' +
        dateTime.month.toString() +
        '-' +
        dateTime.year.toString();
  }


  FormularioModel.fromDS(DocumentSnapshot ds) {
    invitaciones = ds['invitaciones'];
    
    nombre = ds['nombre'];
    
    ds['preguntas'].forEach((map) {
      preguntas.add(Pregunta.fromMap(map));
    });
    creadorID = ds['creadorID'] ?? '';
    priv = ds['priv'] ?? '';
    usuarios = ds['usuarios'] ?? [];
    creadorUsuario = ds['creadorUsuario'] ?? '';
    reference = ds.reference;
    Timestamp timestamp = ds['fecha'];
    fecha = dateString(timestamp.toDate()) ?? '';
    imagen = ds['imagen'] ?? '';

  }
}

class Respuesta {
  String respuesta;
  dynamic fecha;
  String usuario;

  Map<String,dynamic> toMap(){
    return {
      'respuesta' : respuesta,
      'fecha' : fecha,
      'usuario': usuario,
    };
  }

  Respuesta.fromString(String res, String user){
    respuesta = res;
    usuario = user;
    fecha = dateString(DateTime.now());
  }

  String dateString(DateTime dateTime) {
    return dateTime.day.toString() +
        '-' +
        dateTime.month.toString() +
        '-' +
        dateTime.year.toString();
  }

  Respuesta.fromMap(Map<String, dynamic> map) {
    respuesta = map['respuesta'];
    fecha = map['fecha'];
    usuario = map['usuario'];
  }
}

class Pregunta {
  String pregunta;
  List<dynamic> respuestas = [
    {
      
    }
  ];

  Pregunta({this.pregunta, this.respuestas});

  Pregunta.fromString(String string) {
    pregunta = string;
    respuestas = [];
  }

  Pregunta.fromMap(Map<String, dynamic> map) {
    pregunta = map['pregunta'];
    respuestas = map['respuestas'];
  }
  Map<String, dynamic> toMap() {
    return {
      'pregunta': pregunta,
      'respuestas': respuestas,
    };
  }
}

class UsuarioModel {
  String contrasena;
  String correo;
  String foto;
  int coins;
  String fotoStorageRef;
  String nombre;
  String usuario;
  DocumentReference reference;
  String documentId;
  List<dynamic> amigos;
  List<dynamic> solicitudesAE;
  bool monedasFree;
  int dailyAnswers;
  int dailyFormularios;

  UsuarioModel({
    this.contrasena,
    this.correo,
    this.foto,
    this.nombre,
    this.documentId,
    this.monedasFree
  });

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'foto': foto,
    };
  }

  UsuarioModel.fromDocumentSnapshot(DocumentSnapshot data) {
    contrasena = data['contrasena'];
    correo = data['correo'];
    foto = data['foto'];
    nombre = data['nombre'] ?? '';
    reference = data.reference;
    documentId = data.documentID;
    amigos = data['amigos'] ?? [];
    solicitudesAE = data['solicitudesAE'] ?? [];
    usuario = data['usuario'] ?? '';
    coins = data['coins'] ?? 0;
    monedasFree = data['monedasFree'] ?? false;
    dailyAnswers = data['dailyAnswers'] ?? 3;
    dailyFormularios = data['dailyFormularios'] ?? 3;
  }
}
