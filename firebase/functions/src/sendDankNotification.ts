import * as functions from "firebase-functions"
import * as admin from "firebase-admin"
import Participant from "./interfaces/Participant"
import getFcmTokensByUid from "./utils/getFcmTokensByUid"

const messaging = admin.messaging()

export const sendDankNotification = functions.firestore
    .document("chats/{chatId}")
    .onUpdate(async (change) => {
        const data = change.after.data()

        // check if danks have been incremented
        if (data.danks == change.before.data().danks) {
            return null
        }

        const sender: Participant = data.participantsData.find(
            (participant: Participant) => participant.uid == data.lastDankAuthor
        )
        const reciver: Participant = data.participantsData.find(
            (participant: Participant) => participant.uid != data.lastDankAuthor
        )

        // prepare payload
        const payload = {
            notification: {
                title: `${sender.name} has danked you!`,
                body: `You have got ${data.danks} danks so far.`,
            },
        }

        // send notification
        return messaging.sendToDevice(
            await getFcmTokensByUid(reciver.uid),
            payload
        )
    })
