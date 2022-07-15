import * as functions from "firebase-functions"
import * as admin from "firebase-admin"

export const sendChatNotification = functions.firestore
    .document("chats/{chatId}/messages/{messageId}")
    .onCreate(async (snap, context) => {
        const db = admin.firestore()
        const rtdb = admin.database()

        const messageData = snap.data()

        const messageId = context.params.messageId
        const chatId = context.params.chatId
        const chatDocRef = db.collection("chats").doc(chatId)

        const chatDoc = await chatDocRef.get()
        const chatData = chatDoc.data()

        // get notification reciver uid
        let notificationReciverUid = null
        let senderName = ""
        chatData.participantsData.forEach((participant) => {
            if (messageData.author != participant.uid) {
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

        // prepare message
        const message = {
            data: {
                type: "CHAT/NEW_MESSAGE",
                id: chatId,
                senderName: senderName,
            },
            notification: {
                title: senderName,
                body: "New messages",
            },
            android: {
                notification: {
                    tag: chatId,
                },
            },
            tokens: reciverTokens,
        }

        // send notification
        const messaging = admin.messaging()
        await messaging.sendMulticast(message)

        // update chat
        chatDocRef.update({
            lastMessageTime: messageData.time,
            lastMessageAuthor: senderName.split(" ")[0],
            lastMessageContent: messageData.content,
        })

        if (messageData.type == "TIC_TAC_TOE/DEFAULT") {
            const rtdbRef = rtdb.ref(`games/tic-tac-toe/${chatId}`)
            const gameSettings = messageData.overchatData

            // Generate cols helper
            const generateCols = (n) => {
                const c = []
                for (let i = 0; i < n; i++) {
                    c.push("")
                }
                return c
            }

            // Generate board
            const board = []
            for (let i = 0; i < gameSettings.boardSize; i++) {
                board.push(generateCols(gameSettings.boardSize))
            }

            functions.logger.log(
                `Board ${gameSettings.boardSize}x${gameSettings.boardSize} generated`,
                board
            )

            await rtdbRef.set({
                board: board,
                playerX: messageData.author,
                playerY: notificationReciverUid,
                settings: gameSettings,
                messageId: messageId,
            })
        }

        functions.logger.log(`is pending: ${messageData.isPending}`)

        functions.logger.log(`path: chats/${chatId}/messages/${messageId}`)

        if (messageData.isPending == true) {
            await db.doc(`chats/${chatId}/messages/${messageId}`).update({
                isPending: false,
            })
        }
    })
