// import firestore from "firebase-admin/lib/firestore";
import firestoreAdmin from "firebase-admin";
import {USER_COLLECTION, PURCHASE_COLLECTION, OPCLO_FREE, OPCLO_MONTHLY, OPCLO_YEARLY, OPCLO_FREE_NAME, OPCLO_MONTHLY_NAME, OPCLO_YEARLY_NAME} from "./constants";

import Timestamp = firestoreAdmin.firestore.Timestamp;

export type SubscriptionStatus = "PENDING" | "ACTIVE" | "EXPIRED";
export type NonSubscriptionStatus = "PENDING" | "COMPLETE" | "CANCELED"

export type IAPSource = "app_store";
export type Purchase = SubscriptionPurchase | NonSubscriptionPurchase;

export interface BasePurchase {
  iapSource: IAPSource;
  orderId: string;
  productId: string;
  userId: string;
  purchaseDate: firestoreAdmin.firestore.Timestamp;
}

export interface SubscriptionPurchase extends BasePurchase {
  type: "SUBSCRIPTION";
  expiryDate: firestoreAdmin.firestore.Timestamp;
  status: SubscriptionStatus
}

export interface NonSubscriptionPurchase extends BasePurchase {
  type: "NON_SUBSCRIPTION";
  status: NonSubscriptionStatus
}

export class FirebaseCalls {
  constructor(private firestore: FirebaseFirestore.Firestore) {}

  async createOrUpdatePurchase(purchaseData: Purchase): Promise<void> {
    const purchases = this.firestore.collection(PURCHASE_COLLECTION);
    const purchaseId = `${purchaseData.iapSource}_${purchaseData.orderId}`;
    const purchase = purchases.doc(purchaseId);
    await purchase.set(purchaseData);
    this.updateUserWithPurchase(purchase);
  }

  async updatePurchase(
    purchaseData: {iapSource: IAPSource; orderId: string;} & Partial<Purchase>
  ) : Promise<void> {
    const purchases = this.firestore.collection(PURCHASE_COLLECTION);
    const purchaseId = `${purchaseData.iapSource}_${purchaseData.orderId}`;
    const purchase = purchases.doc(purchaseId);
    await purchase.update(purchaseData);
    this.updateUserWithPurchase(purchase);
  }

  async updateUserWithPurchase(
    purchaseRef: firestoreAdmin.firestore.DocumentReference
  ): Promise<void> {
    const purchaseDoc = await purchaseRef.get();
    if (typeof purchaseDoc?.data()?.userId != undefined) {
      // eslint-disable-next-line max-len
      const userRef = this.firestore.collection(USER_COLLECTION).doc(purchaseDoc?.data()?.userId);
      // eslint-disable-next-line max-len
      if (![OPCLO_MONTHLY, OPCLO_YEARLY].includes(purchaseDoc?.data()?.productId)) return;
      if (purchaseDoc?.data()?.status == "ACTIVE") {
        userRef.update({
          // eslint-disable-next-line max-len
          subscriptionAdded: convertTimestampToMillis(purchaseDoc?.data()?.purchaseDate),
          subscriptionApproved: true,
          // eslint-disable-next-line max-len
          subscriptionExpire: convertTimestampToMillis(purchaseDoc?.data()?.expiryDate),
          subscriptionIsValid: true,
          subscriptionId: purchaseDoc?.data()?.productId,
          // eslint-disable-next-line max-len
          subscriptionName: purchaseDoc?.data()?.productId==OPCLO_MONTHLY?OPCLO_MONTHLY_NAME:OPCLO_YEARLY_NAME,
        });
      } else if (purchaseDoc?.data()?.status == "EXPIRED") {
        userRef.update({
          // eslint-disable-next-line max-len
          subscriptionAdded: convertTimestampToMillis(purchaseDoc?.data()?.purchaseDate),
          subscriptionApproved: false,
          // eslint-disable-next-line max-len
          subscriptionExpire: convertTimestampToMillis(purchaseDoc?.data()?.expiryDate),
          subscriptionIsValid: false,
          subscriptionId: OPCLO_FREE,
          subscriptionName: OPCLO_FREE_NAME,
        });
      }
    }
  }

  async exporeSubscriptions(): Promise<void> {
    const documents = await this.firestore.collection(PURCHASE_COLLECTION)
      .where("expiryDate", "<=", Timestamp.now())
      .where("status", "==", "ACTIVE")
      .get();
    if (!documents.size) return;
    const writeBatch = this.firestore.batch();
    documents.docs.forEach((doc) => {
      if ([OPCLO_MONTHLY, OPCLO_YEARLY].includes(doc.data().productId)) {
        // eslint-disable-next-line max-len
        const userRef = this.firestore.collection(USER_COLLECTION).doc(doc.data().userId);
        userRef.update({
          subscriptionApproved: false,
          subscriptionIsValid: false,
          subscriptionId: OPCLO_FREE,
          subscriptionName: OPCLO_FREE_NAME,
        });
      }
      writeBatch.update(doc.ref, {status: "EXPIRED"});
    });
    await writeBatch.commit();
  }
}

// Function to convert Firestore Timestamp to milliseconds since epoch
// eslint-disable-next-line max-len
// function convertTimestampToMillis2(timestamp: firestoreAdmin.firestore.Timestamp): string {
//   return timestamp.toDate().toISOString();
// }
// eslint-disable-next-line max-len
function convertTimestampToMillis(timestamp: firestoreAdmin.firestore.Timestamp): string {
  return timestamp.toDate().toISOString();
}
