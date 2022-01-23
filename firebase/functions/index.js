const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp(functions.config().firebase);

exports.sendDankNotification = functions.firestore
  .document("chats/{chatId}")
  .onUpdate(async (change, context) => {
    const db = admin.firestore();
    const data = change.after.data();

    // check if danks have been incremented
    if (data.danks == change.before.data().danks) {
      return;
    }

    functions.logger.log("Got chat data", { data: data });

    // get notification reciver uid
    let notificationReciverUid = null;
    let senderName = "";
    data.participantsData.forEach((participant) => {
      if (data.lastDankAuthor != participant.uid) {
        notificationReciverUid = participant.uid;
      } else {
        senderName = participant.name;
      }
    });

    functions.logger.log(`Reciver uid is ${notificationReciverUid}`);

    // get recivger's tokens
    const reciverRef = db.collection("users").doc(notificationReciverUid);
    const reciverDoc = await reciverRef.get();
    const reciverDocData = reciverDoc.data();
    const reciverTokens = reciverDocData.notificationsTokens;

    functions.logger.log("Got reciver tokens", { tokens: reciverTokens });

    // check if there are any tokens
    if (reciverTokens.length == 0) {
      return;
    }

    // prepare payload
    const payload = {
      notification: {
        title: `${senderName} has danked you!`,
        body: `You have got ${data.danks} danks so far.`,
      },
    };

    // sent notification
    const messaging = admin.messaging();
    await messaging.sendToDevice(reciverTokens, payload);
  });

exports.sendChatNotification = functions.firestore
  .document("chats/{chatId}/messages/{messageId}")
  .onCreate(async (snap, context) => {
    const db = admin.firestore();

    const messageData = snap.data();

    const chatId = context.params.chatId;
    const chatDocRef = db.collection("chats").doc(chatId);

    const chatDoc = await chatDocRef.get();
    const chatData = chatDoc.data();

    // get notification reciver uid
    let notificationReciverUid = null;
    let senderName = "";
    chatData.participantsData.forEach((participant) => {
      if (messageData.author != participant.uid) {
        notificationReciverUid = participant.uid;
      } else {
        senderName = participant.name;
      }
    });

    functions.logger.log(`Reciver uid is ${notificationReciverUid}`);

    // get recivger's tokens
    const reciverRef = db.collection("users").doc(notificationReciverUid);
    const reciverDoc = await reciverRef.get();
    const reciverDocData = reciverDoc.data();
    const reciverTokens = reciverDocData.notificationsTokens;

    functions.logger.log("Got reciver tokens", { tokens: reciverTokens });

    // check if there are any tokens
    if (reciverTokens.length == 0) {
      return;
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
        body: "New messages"
      },
      android: {
        notification: {
          tag: chatId
        }
      },
      tokens: reciverTokens,
    };

    // sent notification
    const messaging = admin.messaging();
    await messaging.sendMulticast(message);

    // update chat
    chatDocRef.update({
      lastMessageTime: messageData.time,
      lastMessageAuthor: senderName.split(" ")[0],
      lastMessageContent: messageData.content
    })
  });
