import * as admin from "firebase-admin"

const firestore = admin.firestore()

const getFcmTokensByUid = async (uid: string) => {
    const ref = firestore.collection("users").doc(uid)
    const doc = await ref.get()
    const data = doc.data()

    if (data == undefined) throw Error(`User ${uid} does not exist`)

    return data.notificationsTokens
}

export default getFcmTokensByUid
