import * as functions from "firebase-functions"
import * as admin from "firebase-admin"

export const finishTicTacToe = functions.database
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
