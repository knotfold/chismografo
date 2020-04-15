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

class Formulario1{
  // List<Map<String,dynamic>> preguntas = [
  //   {
  //     'Nombre': 'hola'
  //   }
  // ];



  List<Pregunta> preguntas = [
    Pregunta(pregunta: '1. ¿Has sido infiel?' ),
    Pregunta(pregunta: '2. ¿Soportarias una infidelidad?'),
    Pregunta(pregunta: '3. ¿Has hecho algo sexual en el último mes? (Besos no cuentan).'),
    Pregunta(pregunta: '4. Tipo de beso preferido'),
    Pregunta(pregunta: '5. ¿Volverías a estar con tu ex?'),
    Pregunta(pregunta: '6.¿ Has mentido a tu mejor amig@?'),
    Pregunta(pregunta: '7. Tendrias una cita conmigo?'),
    Pregunta(pregunta: '8. ¿Qué te gusta de mí? Fisico'),
    Pregunta(pregunta: '9. ¿Qué te gusta de ti? (Fisico)'),
    Pregunta(pregunta: '10. ¿Qué opinas sobre mí? Sinceramente.'),
    Pregunta(pregunta: '11. ¿Qué te gustaría saber de mí?'),
    Pregunta(pregunta: '12. Cuéntame un secreto interesante.'),
    Pregunta(pregunta: '13. Tienes que publicar lo mismo que subí yo en tu muro o subo las respuestas.'),
    Pregunta(pregunta: '14. Cuando lo publiques en tu muro, te contesto la pregunta 11'),

  ];
  List<Usuario> usuarios;
  String password;
  String creadorId;
  String creadorNombre;
  String id;

  Map<String ,dynamic> toMap(){
  List<Map<String,dynamic>> p;
  preguntas.forEach((pregunta){
    p.add(pregunta.toMap());
  });

  List<Map<String,dynamic>> u;
  usuarios.forEach((usuario){
    u.add(usuario.toMap());
  });
    
    return {
      'preguntas' : p,
      'usuarios' : u,
      'password': password,
      'creadorId': creadorId,
      'creadorNombre': creadorNombre,

    };
  }
}

class Usuario {
  String nombre;
  String foto;
  String correo;
  String id;
  DocumentReference ref;

  Usuario.fromDS(DocumentSnapshot ds){
    nombre =  ds['nombre'];
    foto = ds['foto'];
    correo  = ds['correo'];
    id = ds.documentID;
    ref = ds.reference;
  }

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'foto': foto,
    };
  }
}

class Pregunta {
  String pregunta;
  List<Map<String, dynamic>> respuestas = [
    {'respuesta': 'hola',
    'usuarioNombre' : 'Memo',
    'usuarioFoto' : 'https://scontent-ssn1-1.xx.fbcdn.net/v/t1.0-9/90590478_3194401850588829_8179029891061121024_o.jpg?_nc_cat=111&_nc_sid=85a577&_nc_ohc=Ds1ApjyXdy8AX8gQWIP&_nc_ht=scontent-ssn1-1.xx&oh=5e2f518ff1449c1bc8f0f3894e32a39a&oe=5EBB0839',
    }
  ];

  Pregunta({this.pregunta, this.respuestas});

  Map<String,dynamic> toMap(){
    return {
      'pregunta' : pregunta,
      'respuestas' : respuestas,
    };
  }
}

class UsuarioModel {
  String contrasena;
  String correo;
  String foto;
  String fotoStorageRef;
  String nombre;
  DocumentReference reference;
  String documentId;

  UsuarioModel({
    this.contrasena,
    this.correo,
    this.foto,
    this.nombre,
    this.documentId,
  });

  UsuarioModel.fromDocumentSnapshot(DocumentSnapshot data) {
    contrasena = data['contrasena'];
    correo = data['correo'];
    foto = data['foto'];
    nombre = data['nombre']??'';
    reference = data.reference;
    documentId = data.documentID;
  }
}
