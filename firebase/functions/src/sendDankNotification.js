import * as functions from "firebase-functions"
import * as admin from "firebase-admin"

export const sendDankNotification = functions.firestore
    .document("chats/{chatId}")
    .onUpdate(async (change) => {
        const db = admin.firestore()
        const data = change.after.data()

        // check if danks have been incremented
        if (data.danks == change.before.data().danks) {
            return
        }

        functions.logger.log("Got chat data", { data: data })

        // get notification reciver uid
        let notificationReciverUid = null
        let senderName = ""
        data.participantsData.forEach((participant) => {
            if (data.lastDankAuthor != participant.uid) {
                notificationReciverUid = participant.uid
            } else {
                senderName = participant.name
            }
        })

        functions.logger.log(`Reciver uid is ${notificationReciverUid}`)

        // get recivger's tokens
        const reciverRef = db.collection("users").doc(notificationReciverUid)
        const reciverDoc = await reciverRef.get()
        const reciverDocData = reciverDoc.data()
        const reciverTokens = reciverDocData.notificationsTokens

        functions.logger.log("Got reciver tokens", { tokens: reciverTokens })

        // check if there are any tokens
        if (reciverTokens.length == 0) {
            return
        }

        // prepare payload
        const payload = {
            notification: {
                title: `${senderName} has danked you!`,
                body: `You have got ${data.danks} danks so far.`,
            },
        }

        // send notification
        const messaging = admin.messaging()
        await messaging.sendToDevice(reciverTokens, payload)
    })
