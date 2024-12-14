import 'package:opclo/core/extensions/color_extension.dart';

import '../../../../commons/common_imports/common_libs.dart';
import '../../../../utils/constants/app_constants.dart';
import '../../../../utils/constants/font_manager.dart';
import 'faq_dropdown.dart';

class FAQsection extends StatelessWidget {
  const FAQsection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: AppConstants.horizontalPadding),
          child: Row(
            children: [
              Text(
                'Frequently Asked Questions',
                style: getSemiBoldStyle(
                    color: context.titleColor, fontSize: MyFonts.size16),
              ),
            ],
          ),
        ),
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: const Column(
              children: [
                FAQDropdown(
                  title: '1.  How do I cancel my subscription?',
                  desc:
                      '    To cancel, go to Settings > [Your Name] > Subscriptions, select Opclo, and tap Cancel Subscription. Your subscription will remain active until the end of the current billing period.',
                ),
                FAQDropdown(
                  title:
                      '2.  What should I do if I encounter issues with my subscription?',
                  desc:
                      '    If you have issues, contact us at support@opclo.app.',
                ),
                FAQDropdown(
                  title: '3.  Is my subscription auto-renewed?',
                  desc:
                      '    Yes, your subscription automatically renews unless you cancel it before the end of the billing period.',
                ),
              ],
            )),
      ],
    );
  }
}
