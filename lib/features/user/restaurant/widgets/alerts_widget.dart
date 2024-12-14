import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:opclo/commons/common_functions/date_time_format.dart';
import 'package:opclo/commons/common_widgets/CustomTextFields.dart';
import 'package:opclo/commons/common_widgets/cached_circular_network_image.dart';
import 'package:opclo/core/extensions/color_extension.dart';
import 'package:opclo/features/auth/controller/auth_notifier_controller.dart';
import 'package:opclo/models/alert_comment_model/alert_comment_model.dart';
import 'package:uuid/uuid.dart';

import '../../../../commons/common_functions/get_alert_icon.dart';
import '../../../../commons/common_functions/is_alert_exprire.dart';
import '../../../../commons/common_functions/padding.dart';
import '../../../../commons/common_imports/common_libs.dart';
import '../../../../models/alert_model.dart';
import '../../../../utils/constants/app_constants.dart';
import '../../../../utils/constants/assets_manager.dart';
import '../../../../utils/constants/font_manager.dart';
import '../../../../utils/loading.dart';
import '../../alert/controller/alert_controller.dart';
import 'alert_container.dart';
import 'comment_widget.dart';

class AlertsWidget extends StatelessWidget {
  const AlertsWidget({
    super.key,
    required this.fsqId,
  });

  final String fsqId;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:
              EdgeInsets.only(left: AppConstants.horizontalPadding, top: 18.h),
          child: Text(
            'Alerts',
            style: getSemiBoldStyle(
                color: context.titleColor,
                fontSize: MyFonts.size16,
            ),
          ),
        ),
        Consumer(builder: (context, ref, child) {
          return ref.watch(getAllAlertsProvider(fsqId)).when(
                data: (alerts) {
                  return alerts.isEmpty
                      ? Center(
                          child: Column(
                            children: [
                              padding8,
                              Image.asset(
                                AppAssets.noAlertsIcon,
                                width: 60.w,
                                height: 60.h,
                              ),
                              padding8,
                              Text(
                                'No alerts',
                                style: getBoldStyle(
                                    color: context.titleColor,
                                    fontSize: MyFonts.size12),
                              ),
                              padding4,
                              Text(
                                'Check back later to view more',
                                style: getRegularStyle(
                                    color: context.bodyTextColor,
                                    fontSize: MyFonts.size10),
                              ),
                            ],
                          ),
                        ) : ListView.builder(
                          itemCount: alerts.length,
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            AlertModel alert = alerts[index];
                            return
                              // isAlertExpired(alert)
                              //   ? SizedBox() :
                            InkWell(
                                    overlayColor: WidgetStateColor.transparent,
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return Center(
                                            child: SingleChildScrollView(
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                  bottom: MediaQuery.of(context)
                                                      .viewInsets
                                                      .bottom,
                                                ),
                                                child: CommentWidget(alert: alert),
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    child: AlertContainer(
                                        icon: getAlertIcon(alert.option),
                                        title: alert.option.type
                                    ),
                                  );
                          });
                },
                error: (error, stackTrace) => SizedBox(),
                loading: () => LoadingWidget(),
              );
        }),
      ],
    );
  }
}