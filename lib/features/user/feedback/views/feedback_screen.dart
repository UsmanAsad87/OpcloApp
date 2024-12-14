import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:opclo/commons/common_functions/padding.dart';
import 'package:opclo/commons/common_widgets/custom_button.dart';
import 'package:opclo/commons/common_widgets/show_toast.dart';
import 'package:opclo/core/extensions/color_extension.dart';
import 'package:opclo/features/auth/controller/auth_controller.dart';
import 'package:opclo/features/auth/controller/auth_notifier_controller.dart';
import 'package:opclo/features/user/feedback/controller/feedback_controller.dart';
import 'package:opclo/features/user/feedback/widgets/custom_feedback_textfield.dart';
import 'package:opclo/models/feedback_model.dart';
import 'package:opclo/utils/constants/app_constants.dart';
import 'package:opclo/utils/constants/font_manager.dart';
import 'package:uuid/uuid.dart';
import '../../../../commons/common_imports/common_libs.dart';
import '../../../../commons/common_providers/shared_pref_helper.dart';
import '../widgets/custom_feedback_progress_bar.dart';
import 'package:http/http.dart' as http;
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class FeedBackScreen extends ConsumerStatefulWidget {
  const FeedBackScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<FeedBackScreen> createState() => _FeedBackScreenState();
}

class _FeedBackScreenState extends ConsumerState<FeedBackScreen> {
  int easyIndex = 3;
  int fastIndex = 3;
  int reliableIndex = 3;
  int recommendIndex = 3;
  TextEditingController responseController = TextEditingController();

  @override
  void dispose() {
    responseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=>FocusManager.instance.primaryFocus!.unfocus(),
      child: Scaffold(
        backgroundColor: context.whiteColor,
        body: SingleChildScrollView(
            child: Padding(
          padding: EdgeInsets.all(AppConstants.padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SafeArea(
                child: Row(
                  children: [
                    InkWell(
                      overlayColor: MaterialStateProperty.all(Colors.transparent),
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Icon(
                        Icons.close,
                        color: context.titleColor,
                      ),
                    ),
                    Text(
                      'We welcome your feedback!',
                      style: getSemiBoldStyle(
                        color: context.titleColor,
                        fontSize: MyFonts.size15,
                      ),
                    ),
                  ],
                ),
              ),
              padding8,
              Text(
                'Tell us which places you love, and we’ll help you get set up',
                style: getMediumStyle(
                  color: context.titleColor.withOpacity(.5),
                  fontSize: MyFonts.size15,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                child: Divider(
                  color: context.titleColor.withOpacity(.15),
                ),
              ),
              Text(
                '1. Is easy to use?',
                style: getMediumStyle(
                  color: context.titleColor,
                  fontSize: MyFonts.size15,
                ),
              ),
              padding8,
              CustomFeedbackProgressBar(
                selectedStep: easyIndex,
                onValueChanged: (newValue) {
                  setState(() {
                    easyIndex = newValue;
                  });
                },
              ),
              padding24,
              Text(
                '2. Feels fast and responsive',
                style: getMediumStyle(
                  color: context.titleColor,
                  fontSize: MyFonts.size15,
                ),
              ),
              padding8,
              CustomFeedbackProgressBar(
                selectedStep: fastIndex,
                onValueChanged: (newValue) {
                  setState(() {
                    fastIndex = newValue;
                  });
                },
              ),
              padding24,
              Text(
                '3. Is reliable',
                style: getMediumStyle(
                  color: context.titleColor,
                  fontSize: MyFonts.size15,
                ),
              ),
              padding8,
              CustomFeedbackProgressBar(
                selectedStep: reliableIndex,
                onValueChanged: (newValue) {
                  setState(() {
                    reliableIndex = newValue;
                  });
                },
              ),
              padding24,
              Text(
                '4. How likely is it that you would recommend opclo to a friend or colleague?',
                style: getMediumStyle(
                  color: context.titleColor,
                  fontSize: MyFonts.size15,
                ),
              ),
              padding8,
              CustomFeedbackProgressBar(
                selectedStep: recommendIndex,
                onValueChanged: (newValue) {
                  setState(() {
                    recommendIndex = newValue;
                  });
                },
              ),
              padding24,
              Text(
                '5. What can we do to improve?',
                style: getMediumStyle(
                  color: context.titleColor,
                  fontSize: MyFonts.size15,
                ),
              ),
              padding8,
              CustomFeedbackTextfield(responseController: responseController),
              padding16,
              Consumer(
                  builder: (context, ref, child) {
                return CustomButton(
                  onPressed: () async {
                    if (easyIndex == -1) {
                      showSnackBar(context, 'easy to use is null');
                      return;
                    }
                    if (fastIndex == -1) {
                      showSnackBar(context, 'fast & responsive is null');
                      return;
                    }
                    if (reliableIndex == -1) {
                      showSnackBar(context, 'reliable is null');
                      return;
                    }
                    if (recommendIndex == -1) {
                      showSnackBar(context, 'recommend friend is null');
                      return;
                    }
                    FeedbackModel feedback = FeedbackModel(
                        id: Uuid().v4(),
                        userId: '',
                        easy: easyIndex,
                        fastAndResponsive: fastIndex,
                        reliable: reliableIndex,
                        recommend: recommendIndex,
                        comment: responseController.text,
                        date: DateTime.now()
                    );
                    ref.read(feedbackControllerProvider.notifier)
                        .addFeedback(context, feedback);
                    sendEmail();
                    SharedPrefHelper.setReviewDone(true);
                  },
                  isLoading: ref.watch(feedbackControllerProvider),
                  buttonText: 'Submit',
                );
              })
            ],
          ),
        )),
      ),
    );
  }

  Future<void> sendEmail() async {
    final smtpServer = SmtpServer(
      'smtp-pulse.com',
      username: 'Opcloapp@gmail.com',
      password: 'rAptfKRfCX',
      port: 465,
      ssl: true,
    );

    final recipientEmail = await ref.read(authControllerProvider.notifier).getEmailForFeedback();
    final message = Message()
      ..from = Address('support@opclo.app', 'Opclo')
      // ..recipients.add('usmanasad0324@gmail.com')
      // ..recipients.add('support@opclo.app')
      ..recipients.add(recipientEmail)
      ..subject = 'Feedback For Opclo  :: 😀 :: ${DateTime.now()}'
      ..text = 'This is a Feedback by From Opclo User.'
      ..html = "<h1>Feedback out of 5</h1><h3>Easy to Use = ${easyIndex}</h3><h3>Responsive = ${fastIndex}</h3><h3>Reliable = ${reliableIndex}</h3><h3>Will you recommend = ${easyIndex}</h3><h3>What we can improve</h3><p>${responseController.text}</p>";

    try {
      final sendReport = await send(message, smtpServer);
      print(recipientEmail);
      print('Message sent: ' + sendReport.toString());
    } on MailerException catch (e) {
      print('Message not sent.$e');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }
  }
}
