import * as functions from "firebase-functions"
import * as admin from "firebase-admin"

exports.sendDankNotification = functions.firestore
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

exports.sendChatNotification = functions.firestore
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

exports.cleanUpAfterMessageDeletion = functions.firestore
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

exports.finishTicTacToe = functions.database
    .ref("/games/tic-tac-toe/{chatId}/isEnded")
    .onCreate((snapshot, context) => {
        const db = admin.firestore()
        const chatId = context.params.chatId
        const gameRef = snapshot.ref.parent.ref

        functions.logger.log("Got chatId", chatId)

        return gameRef.once(
            "value",
            (gameSnapshot) => {
                const messageId = gameSnapshot.child("messageId").val()
                const winner = gameSnapshot.child("winner").exists
                    ? gameSnapshot.child("winner").val()
                    : null

                functions.logger.log(
                    `Winner is ${winner} for message ${messageId}`
                )

                return db.doc(`chats/${chatId}/messages/${messageId}`).update({
                    overchatData: { isEnded: true, winner: winner },
                })
            },
            (errorObject) => {
                functions.logger.error(
                    `The messageId read failed: ${errorObject.name}`,
                    errorObject
                )
                return null
            }
        )
    })
