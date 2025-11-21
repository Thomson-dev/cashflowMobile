import 'package:cashflow/app/modules/auth/register/widget/businessInfo.dart';

import 'package:cashflow/app/modules/auth/register/widget/preferenceInfo.dart';

import 'package:cashflow/app/modules/auth/register/widget/registerInfo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cashflow/app/modules/auth/register/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final RegisterController controller = Get.put(RegisterController());
    
    return Scaffold(
       backgroundColor: Colors.white,
   
      body: SafeArea(
        child: Obx(
         
          () => Column(
            children: [
              // Progress Indicator
              _buildProgressIndicator(),
              // Form Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: _buildStepContent(controller),
                ),
              ),
              
          
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    final stepLabels = ['Personal Details', 'Business Info', 'Preferences'];
    
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                  '${((controller.currentStep.value + 1) / 3 * 100).toStringAsFixed(0)}% completed',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                  Text(
                    'Step ${controller.currentStep.value + 1} of 3',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    stepLabels[controller.currentStep.value],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: List.generate(
              3,
              (index) => Expanded(
                child: Container(
                  height: 6,
                  margin: EdgeInsets.only(
                    right: index < 2 ? 8 : 0,
                  ),
                  decoration: BoxDecoration(
                    color: index <= controller.currentStep.value
                        ? Colors.green
                        : Colors.grey[200],
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepContent(RegisterController controller) {
    switch (controller.currentStep.value) {
      case 0:
        return buildPersonalInfoForm(controller);
      case 1:
        return buildBusinessInfoForm(controller);
      case 2:
        return buildPreferencesForm(controller);
      default:
        return const SizedBox();
    }
  }

 




}
