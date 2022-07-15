import * as admin from "firebase-admin"

admin.initializeApp()

export { finishTicTacToe } from "./finishTicTacToe"
export { handleMessageDeletion } from "./handleMessageDeletion"
export { sendChatNotification } from "./sendChatNotification"
export { sendDankNotification } from "./sendDankNotification"
