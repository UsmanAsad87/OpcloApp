import * as Functions from "firebase-functions";
import * as admin from "firebase-admin";
import {FirebaseCalls, IAPSource} from "./firebase.calls";
import {PurchaseHandler} from "./purchase-handler";
import {CLOUD_REGION} from "./constants";
import {AppStorePurchaseHandler} from "./app-store.purchase-handler";
import {productDataMap} from "./products";
import {HttpsError} from "firebase-functions/v1/https";
import nodemailer from "nodemailer";

admin.initializeApp();

const functions = Functions.region(CLOUD_REGION);
const firebaseCalls = new FirebaseCalls(admin.firestore());
const purchaseHandlers: { [source in IAPSource]: PurchaseHandler } = {
  "app_store": new AppStorePurchaseHandler(firebaseCalls),
};

const transporter = nodemailer.createTransport({
  host: "smtp-pulse.com",
  port: 465,
  secure: true,
  auth: {
    user: "Opcloapp@gmail.com",
    pass: "rAptfKRfCX",
  },
});

interface VerifyPurchaseParams {
  source: IAPSource;
  verificationData: string;
  productId: string;
}

export const helloWorld = functions.https.onRequest((request, response) => {
  response.send("Hello, World!");
});

export const verifyPurchase = functions.https.onCall(
  async (data: VerifyPurchaseParams, context): Promise<boolean> => {
    // check for auth
    if (!context.auth) {
      console.warn("verifyPurchase was called no authentication");
      throw new HttpsError("unauthenticated", "Request was not authenticated.");
    }

    const productData = productDataMap[data.productId];
    // product data was unknown
    if (!productData) {
      console.warn(
        `verifyPurchase was called for an unknown product ("${data.productId}")`
      );
      return false;
    }
    // called from unknown source
    if (!purchaseHandlers[data.source]) {
      console.warn(
        `verifyPurchase called for an unknown source ("${data.source}")`
      );
      return false;
    }
    // validate the purchase
    return purchaseHandlers[data.source].verifyPurchase(
      context.auth?.uid,
      productData,
      data.verificationData,
    );
  }
);

export const handleAppStoreServerEvent =
// eslint-disable-next-line max-len
     (purchaseHandlers.app_store as AppStorePurchaseHandler).handleServerEvent;


// eslint-disable-next-line max-len
// */10 */1 * * *

export const expireSubscriptions = functions.pubsub.schedule("0 0 * * *")
  .timeZone("America/New_York")
  .onRun(() => firebaseCalls.exporeSubscriptions());


export const sendWeeklyReport = functions.pubsub.schedule("every monday 00:00").onRun(
// export const sendWeeklyReport = functions.pubsub.schedule("every 1 minutes").onRun(
  async () => {
    const selectionsRef = admin.firestore().collection("preferences-collection");

    const oneWeekAgo = new Date(Date.now() - 7 * 24 * 60 * 60 * 1000);
    try {
      const snapshot = await selectionsRef.where("date", ">", oneWeekAgo.toISOString()).get();

      // Initialize counters for each goal
      const counts: { [key: string]: number } = {
        achieveTravelGoals: 0,
        receiveGreatDeals: 0,
        discoverNewPlaces: 0,
        stayInformedWithPlaceAlerts: 0,
        buildBucketLists: 0,
        planSpecialOccasions: 0,
        organizeDailyLife: 0,
      };

      // Count occurrences of each goal
      snapshot.forEach((doc) => {
        const goals = doc.data().goal as string[];
        goals.forEach((goal) => {
          if (counts[goal] !== undefined) {
            counts[goal]++;
          }
        });
      });

      const emailContent = `
      Weekly Onboarding Report:
      achieveTravelGoals: ${counts.achieveTravelGoals}
      receiveGreatDeals: ${counts.receiveGreatDeals}
      discoverNewPlaces: ${counts.discoverNewPlaces}
      stayInformedWithPlaceAlerts: ${counts.stayInformedWithPlaceAlerts}
      buildBucketLists: ${counts.buildBucketLists}
      planSpecialOccasions: ${counts.planSpecialOccasions}
      organizeDailyLife: ${counts.organizeDailyLife}
    `;

      const emailDoc = await admin.firestore().collection("email-collection").doc("email").get();
      const toEmail = emailDoc.data()?.preferenceEmail as string;
      // Send the email
      const message = {
        from: "support@opclo.app",
        to: toEmail,
        // to: "opcloapp@gmail.com",
        subject: "Opclo Users preferences record of last week",
        text: emailContent};
      await transporter.sendMail(message);
    } catch (error) {
      console.error("Error sending weekly report:", error);
    }
    return null;
  }
);

