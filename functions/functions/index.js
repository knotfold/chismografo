const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp(functions.config().firebase);



// exports.helloWorld = functions.https.onRequest((request, response) => {
//  response.send("Hello from Firebase!");
// });

exports.nuevoFormulario = functions.firestore.document('/formularios/{formulario}'
).onCreate((snapshot, context) => {
    var formularioData = snapshot.data();
    var listaTokens = [];

    if (invitaciones == null) {
        console.log('no hay invitaciones');
        return;
    }

    admin.firestore().collection('usuarios').get().then((snapshot) => {

        var listaUsuarios = snapshot.docs;
        for (var usuario of listaUsuarios) {
            for (var invitado of fomularioData.invitaciones) {
                if (usuario.data().usuario == invitado) {
                    if (usuario.data().tokens != undefined) {
                        console.log('tokens definido');
                        if (usuario.data().tokens != null) {
                            console.log('tokens no nulo');
                            for (var token of usuario.data().tokens) {
                                console.log('adding token');
                                listaTokens.push(token);
                            }
                        }
                    }
                }
            }




        }
        var payload = {
            "notification": {
                "title": formularioData.creadorUsuario + " te a invitado a un nuevo formulario",
                "body": formularioData.nombre,
                "sound": "default"
            },
            "data": {
                "sendername": formularioData.nombre,
                "message": 'idk',
            }
        }

        return admin.messaging().sendToDevice(listaTokens, payload).then((response) => {
            console.log('Se enviaron todas las notificaciones');

        }).catch((err) => {
            console.log(err);
        });
    })
})

exports.friends = functions.firestore.document('usuarios/{usuario}'
).onUpdate((snapshot, context) => { 
    
})

exports.formularioChanged = functions.firestore.document('formularios/{formulario}'
).onUpdate((snapshot, context) => {
    var formularioAfterData = snapshot.after.data();
    var formularioBeforeData = snapshot.before.data();
    var listaTokens = [];
    var adopcionID = snapshot.after.id;



    if (formularioAfterData.invitaciones != null) {

        if (formularioAfterData.invitaciones.length == formularioBeforeData.invitaciones.length) {
            return;
        }

        let newInvs = formularioAfterData.invitaciones.filter(x => !formularioBeforeData.invitaciones.includes(x));
        for (var usuarioID in newInvs) {
            admin.firestore().collection('usuarios').doc(usuarioID).get().then((doc) => {
                var usuarioData = doc.data();
                if (usuarioData.tokens != undefined) {
                    console.log('tokens definido');
                    if (usuarioData.tokens != null) {
                        console.log('tokens no nulo');
                        for (var token of usuarioData.tokens) {
                            console.log('adding token');
                            listaTokens.push(token);
                        }
                    }
                }

                var payload = {
                    "notification": {
                        "title": formularioAfterData.creadorUsuario + " te a invitado a un nuevo formulario",
                        "body": formularioAfterData.nombre,
                        "sound": "default"
                    },
                    "data": {
                        "sendername": formularioAfterData.nombre,
                        "message": 'idk',
                    }
                }

                return admin.messaging().sendToDevice(listaTokens, payload).then((response) => {
                    console.log('Se enviaron todas las notificaciones');
                    listaTokens.length = 0;

                }).catch((err) => {
                    console.log(err);
                });
            })

        }
        return;
    }

    if (formularioAfterData.usuarios != null) {
        //do nothing
        if (formularioAfterData.usuarios.length == formularioBeforeData.usuarios.length) {
            return;
        }

        let newUsuarios = formularioAfterData.usuarios.filter(x => !formularioBeforeData.usuarios.includes(x));

        //notify unlock
        if (formularioAfterData.usuario.length == 3) {
            //notify creator
            admin.firestore().collection('usuarios').doc(formularioAfterData.creadorID).get().then((doc) => {
                var usuarioData = doc.data();
                if (usuarioData.tokens != undefined) {
                    console.log('tokens definido');
                    if (usuarioData.tokens != null) {
                        console.log('tokens no nulo');
                        for (var token of usuarioData.tokens) {
                            console.log('adding token');
                            listaTokens.push(token);
                        }
                    }
                }
                var payload = {
                    "notification": {
                        "title": formularioAfterData.nombre + " Esta desbloqueado",
                        "body": "Ya puedes ver las respuestas",
                        "sound": "default"
                    },
                    "data": {
                        "sendername": formularioAfterData.nombre,
                        "message": 'idk',
                    }
                }

                return admin.messaging().sendToDevice(listaTokens, payload).then((response) => {
                    console.log('Se enviaron todas las notificaciones');
                    listaTokens.length = 0;

                }).catch((err) => {
                    console.log(err);
                });
            })

            //notify users
            for (var usuarioID in formularioAfterData.usuarios) {
                admin.firestore().collection('usuarios').doc(usuarioID).get().then((doc) => {
                    var usuarioData = doc.data();
                    if (usuarioData.tokens != undefined) {
                        console.log('tokens definido');
                        if (usuarioData.tokens != null) {
                            console.log('tokens no nulo');
                            for (var token of usuarioData.tokens) {
                                console.log('adding token');
                                listaTokens.push(token);
                            }
                        }
                    }
                    var payload = {
                        "notification": {
                            "title": formularioAfterData.nombre + " Esta desbloqueado",
                            "body": "Ya puedes ver las respuestas",
                            "sound": "default"
                        },
                        "data": {
                            "sendername": formularioAfterData.nombre,
                            "message": 'idk',
                        }
                    }

                    return admin.messaging().sendToDevice(listaTokens, payload).then((response) => {
                        console.log('Se enviaron todas las notificaciones');
                        listaTokens.length = 0;

                    }).catch((err) => {
                        console.log(err);
                    });
                })
            }
            return;
        }

    }


})


