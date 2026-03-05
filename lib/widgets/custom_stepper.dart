import 'package:ezymember_backend/constants/app_colors.dart';
import 'package:ezymember_backend/language/globalization.dart';
import 'package:ezymember_backend/widgets/custom_button.dart';
import 'package:ezymember_backend/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomStepper extends StatefulWidget {
  final List<Step> steps;
  final String title;
  final VoidCallback onSubmit;

  const CustomStepper({super.key, required this.steps, required this.title, required this.onSubmit});

  @override
  State<CustomStepper> createState() => _CustomStepperState();
}

class _CustomStepperState extends State<CustomStepper> {
  int _currentStep = 0;

  void _onStepContinue() {
    if (_currentStep < widget.steps.length - 1) {
      setState(() => _currentStep += 1);
    } else {
      widget.onSubmit.call();
    }
  }

  void _onStepCancel() {
    if (_currentStep > 0) setState(() => _currentStep -= 1);
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    constraints: BoxConstraints(maxHeight: 720.0, maxWidth: 1280.0),
    backgroundColor: AppColors.defaultWhite,
    surfaceTintColor: AppColors.defaultWhite,
    actions: <Widget>[
      Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: CustomFilledButton(backgroundColor: AppColors.defaultRed, label: Globalization.cancel.tr, onTap: () => Get.back()),
      ),
    ],
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
    content: SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Stepper(
        currentStep: _currentStep,
        steps: widget.steps,
        type: StepperType.horizontal,
        onStepCancel: _onStepCancel,
        onStepContinue: _onStepContinue,
        onStepTapped: (step) => setState(() => _currentStep = step),
        controlsBuilder: (context, details) => Padding(
          padding: const EdgeInsets.only(top: 32.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            spacing: 8.0,
            children: <Widget>[
              if (_currentStep > 0)
                CustomFilledButton(
                  isLarge: false,
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black87,
                  label: Globalization.back.tr,
                  onTap: details.onStepCancel!,
                ),
              CustomFilledButton(
                isLarge: false,
                label: _currentStep == widget.steps.length - 1 ? Globalization.submit.tr : Globalization.next.tr,
                onTap: details.onStepContinue!,
              ),
            ],
          ),
        ),
        stepIconBuilder: (stepIndex, stepState) => Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.0),
            color: stepIndex == _currentStep ? Colors.green : Theme.of(context).colorScheme.primary,
          ),
          child: Text(
            (stepIndex + 1).toString(),
            style: TextStyle(color: stepIndex == _currentStep ? Colors.white : Theme.of(context).colorScheme.onPrimary, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    ),
    title: CustomText(widget.title, fontSize: 20.0, fontWeight: FontWeight.bold, maxLines: null, textAlign: TextAlign.center),
  );
}
