import 'package:flutter/material.dart';

void bottomSheetComponent(BuildContext context, Widget child,
    {double horizontalPadding = 20,
    bool isDismissible = true,
    bool adjustSizeOnOpenKeyboard = true}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    enableDrag: isDismissible,
    isDismissible: isDismissible,
    useRootNavigator: true,
    builder: (context) {
      return WillPopScope(
        onWillPop: () async => isDismissible,
        child: Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            padding: EdgeInsets.fromLTRB(
                horizontalPadding, 14, horizontalPadding, 30),
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.0),
                topRight: Radius.circular(12.0),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Container(
                    height: 5,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: adjustSizeOnOpenKeyboard
                      ? MediaQuery.of(context).viewInsets.bottom != 0
                          ? 400
                          : null
                      : null,
                  child: child,
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
