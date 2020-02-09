const functions = require('firebase-functions');

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//  response.send("Hello from Firebase!");
// });

const admin = require('firebase-admin')
admin.initializeApp()

exports.sendNotification = functions.firestore
  .document('orders/{message}')
  .onCreate((snap, context) => {
    console.log('----------------start function--------------------')

    const doc = snap.data()
    console.log(doc)

    admin.firestore().collection('orders').doc('0').get().then(snapshot => {
        const token = snapshot.data().token
        console.log(token)
    
        const payload = {
            notification: {
              title: `New Message from ${doc.name} (${doc.email})`,
              body: `${doc.subject}\n${doc.body}`,
              badge: '1',
              sound: 'default'
            }
          }
          // Let push to the target device
          admin
            .messaging()
            .sendToDevice(token, payload)
            .then(response => {
              console.log('Successfully sent message:', response)
            })
            .catch(error => {
              console.log('Error sending message:', error)
            })
    
    })
    
    return null
  })