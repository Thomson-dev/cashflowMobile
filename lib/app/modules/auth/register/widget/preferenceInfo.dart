import 'package:cashflow/app/modules/auth/register/register_controller.dart';
import 'package:cashflow/app/modules/auth/register/widget/navigation_buttons.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

Widget buildPreferencesForm(RegisterController controller) {
    return Form(
      key: controller.preferencesFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Goals & Preferences',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Customize your experience',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 32),
          
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Primary Goal',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: controller.selectedPrimaryGoal.value.isEmpty 
                    ? null 
                    : controller.selectedPrimaryGoal.value,
                decoration: const InputDecoration(
                  hintText: 'What\'s your main goal?',
                  hintStyle: TextStyle(fontSize: 13),
                  border: UnderlineInputBorder(),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                ),
                items: controller.primaryGoals.map((goal) {
                  return DropdownMenuItem(
                    value: goal,
                    child: Text(
                      goal,
                      style: const TextStyle(fontSize: 13),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    controller.selectedPrimaryGoal.value = value;
                  }
                },
                icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Target Growth (%)',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: controller.targetGrowthController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'e.g., 20 for 20%',
                  hintStyle: TextStyle(fontSize: 13),
                  border: UnderlineInputBorder(),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                  suffixText: '%',
                ),
                validator: (value) => controller.validateNumeric(
                  value, 
                  'Target Growth',
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          const Text(
            'Notification Preferences',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          
          Obx(
            () => Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: controller.whatsappAlerts.value ? Colors.green[50] : Colors.grey[50],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: controller.whatsappAlerts.value ? Colors.green[300]! : Colors.grey[200]!,
                  width: 1,
                ),
              ),
              child: SwitchListTile(
                title: const Text(
                  'WhatsApp Alerts',
                  style: TextStyle(fontSize: 14),
                ),
                subtitle: const Text(
                  'Receive transaction alerts via WhatsApp',
                  style: TextStyle(fontSize: 13),
                ),
                value: controller.whatsappAlerts.value,
                onChanged: controller.whatsappEnabled.value
                    ? (value) {
                        controller.whatsappAlerts.value = value;
                      }
                    : null,
                contentPadding: EdgeInsets.zero,
                activeColor: Colors.green,
              ),
            ),
          ),
          const SizedBox(height: 12),
          
          Obx(
            () => Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: controller.emailReports.value ? Colors.blue[50] : Colors.grey[50],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: controller.emailReports.value ? Colors.blue[300]! : Colors.grey[200]!,
                  width: 1,
                ),
              ),
              child: SwitchListTile(
                title: const Text(
                  'Email Reports',
                  style: TextStyle(fontSize: 14),
                ),
                subtitle: const Text(
                  'Receive weekly financial reports via email',
                  style: TextStyle(fontSize: 13),
                ),
                value: controller.emailReports.value,
                onChanged: (value) {
                  controller.emailReports.value = value;
                },
                contentPadding: EdgeInsets.zero,
                activeColor: Colors.blue,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue[200]!, width: 1),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue[700], size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'You can change these preferences anytime in your profile settings.',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.blue[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          buildNavigationButtons(controller),
        ],
      ),
    );
  }