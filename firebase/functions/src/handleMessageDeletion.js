import * as functions from "firebase-functions"
import * as admin from "firebase-admin"

export const handleMessageDeletion = functions.firestore
    .document("chats/{chatId}/messages/{messageId}")
    .onDelete(async (snap, context) => {
        const db = admin.firestore()

        const messageData = snap.data()

        const chatId = context.params.chatId
        const chatDocRef = db.collection("chats").doc(chatId)

        const chatDoc = await chatDocRef.get()
        const chatData = chatDoc.data()

        // Get previous message
        let previousMessage = {}
        const previousMessagesSnapshot = await db
            .collection(`chats/${chatId}/messages`)
            .orderBy("time", "desc")
            .limit(1)
            .get()
        previousMessagesSnapshot.forEach((doc) => {
            previousMessage = doc.data()
        })

        let senderName = ""
        chatData.participantsData.forEach((participant) => {
            if (previousMessage.author == participant.uid) {
                senderName = participant.name
            }
        })

        // Update last message fields in chat document
        await chatDocRef.update({
            lastMessageTime: previousMessage.time,
            lastMessageAuthor: senderName.split(" ")[0],
            lastMessageContent: previousMessage.content,
        })

        // get notification reciver uid
        let notificationReciverUid = null
        chatData.participantsData.forEach((participant) => {
            if (messageData.author != participant.uid) {
                notificationReciverUid = participant.uid
            }
        })

        functions.logger.log(`Reciver uid is ${notificationReciverUid}`)

        // get reciver's tokens
        const reciverRef = db.collection("users").doc(notificationReciverUid)
        const reciverDoc = await reciverRef.get()
        const reciverDocData = reciverDoc.data()
        const reciverTokens = reciverDocData.notificationsTokens

        functions.logger.log("Got reciver tokens", { tokens: reciverTokens })

        // check if there are any tokens
        if (reciverTokens.length == 0) {
            return
        }

        // update notification
        const message = {
            data: {
                type: "CHAT/NEW_MESSAGE",
                senderName: "Somebody",
            },
            notification: {
                title: "Somebody",
                body: "Deleted messages",
            },
            android: {
                notification: {
                    tag: chatId,
                },
            },
            tokens: reciverTokens,
        }
        const messaging = admin.messaging()
        await messaging.sendMulticast(message)
    })
