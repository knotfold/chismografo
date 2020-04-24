const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp(functions.config().firebase);



// exports.helloWorld = functions.https.onRequest((request, response) => {
//  response.send("Hello from Firebase!");
// });

// exports.scheduledFunctionCrontab = functions.pubsub.schedule('5 8 * * *')
//   .timeZone('America/New_York') // Users can choose timezone - default is America/Los_Angeles
//   .onRun((context) => {
//   console.log('This will be run every day at 8:05 AM Eastern!');
//   return null;
// });

// exports.scheduledFunctionCrontab = functions.pubsub.schedule('1 23 * * *')
//   .timeZone('America/New_York') // Users can choose timezone - default is America/Los_Angeles
//   .onRun((context) => {
//   console.log('This will be run every day at 23:01 PM Eastern!');
//   return null;
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
    var usuarioAfterData = snapshot.after.data();
    var usuarioBeforeData = snapshot.before.data();
    var listaTokens = [];

    if (usuarioAfterData.solicitudesAE != null) {
        let newSolicitudes = usuarioAfterData.solicitudesAE.filter(x => !usuarioBeforeData.solicitudesAE.includes(x));

        if (newSolicitudes.length > 0) {
            console.log('nueva solicitud');

            for (var usuarioID of newSolicitudes) {
                console.log(usuarioID);
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
                            "title": usuarioAfterData.usuario + " te a invitado una solicitud de amistad",
                            "body": ':)',
                            "sound": "default"
                        },
                        "data": {
                            "sendername": usuarioAfterData.nombre,
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

        let accepted = usuarioBeforeData.solicitudesAE.filter(x => !usuarioAfterData.solicitudesAE.includes(x));
        if (accepted.length > 0) {
            if (usuarioAfterData.amigos.length == 0) {
                console.log('NO amigos wtfff');

                return;
            }
            if (!usuarioAfterData.amigos.includes(accepted[0])) {
                console.log('cancelaste la solicitud');
                return;
            }
            console.log('nuevo amigo me acepto');
            var usuarioData = usuarioAfterData;
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
                    "title": accepted[0] + " A aceptado tu solicitud de amistad",
                    "body": ':)',
                    "sound": "default"
                },
                "data": {
                    "sendername": usuarioAfterData.nombre,
                    "message": 'idk',
                }
            }

            return admin.messaging().sendToDevice(listaTokens, payload).then((response) => {
                console.log('Se enviaron todas las notificaciones');
                listaTokens.length = 0;

            }).catch((err) => {
                console.log(err);
            });
        }


    }
})

exports.formularioChanged = functions.firestore.document('formularios/{formulario}'
).onUpdate((snapshot, context) => {
    var formularioAfterData = snapshot.after.data();
    var formularioBeforeData = snapshot.before.data();
    var listaTokens = [];
    var formularioID = snapshot.after.id;



    if (formularioAfterData.invitaciones != null) {

        if (formularioAfterData.invitaciones.length == formularioBeforeData.invitaciones.length) {
            return;
        }

        let newInvs = formularioAfterData.invitaciones.filter(x => !formularioBeforeData.invitaciones.includes(x));
        if (newInvs.length == 0) {
            return;
        }
        for (var usuarioID of newInvs) {
            if (formularioAfterData.usuarios != null) {
                if (formularioAfterData.usuarios.includes(usuarioID)) {
                    return;
                }
            }

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
            for (var usuarioID of formularioAfterData.usuarios) {
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


