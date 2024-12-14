export interface ProductData {
    productId: string;
    type: "SUBSCRIPTION" | "NON_SUBSCRIPTION";
  }

export const productDataMap: { [productId: string]: ProductData} = {
  "opclo_monthly": {
    productId: "opclo_monthly",
    type: "SUBSCRIPTION",
  },
  "opclo_yearly": {
    productId: "opclo_yearly",
    type: "SUBSCRIPTION",
  },
};
