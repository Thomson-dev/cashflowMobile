import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cashflow/app/modules/auth/register/register_controller.dart';

Widget buildNavigationButtons(RegisterController controller) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 20),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border(
        top: BorderSide(color: Colors.grey[200]!, width: 1),
      ),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Back Button
        if (controller.currentStep.value > 0)
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: controller.isLoading.value 
                  ? null 
                  : controller.previousStep,
              borderRadius: BorderRadius.circular(12),
              splashColor: Colors.grey[200],
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: controller.isLoading.value
                      ? Colors.grey[100]
                      : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.grey[300]!,
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.arrow_back,
                  color: controller.isLoading.value
                      ? Colors.grey[400]
                      : Colors.black87,
                  size: 24,
                ),
              ),
            ),
          )
        else
          const SizedBox(width: 56),
        
        // Forward/Next Button
        Obx(
          () => Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: controller.isLoading.value 
                  ? null 
                  : controller.nextStep,
              borderRadius: BorderRadius.circular(12),
              splashColor: Colors.green[200],
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: controller.isLoading.value
                      ? Colors.grey[400]
                      : Colors.green[600],
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: (controller.isLoading.value
                              ? Colors.grey[400]!
                              : Colors.green[600]!)
                          .withOpacity(0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: controller.isLoading.value
                    ? const Center(
                        child: SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                      )
                    : Icon(
                        controller.currentStep.value == 2
                            ? Icons.check
                            : Icons.arrow_forward,
                        color: Colors.white,
                        size: 26,
                      ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
