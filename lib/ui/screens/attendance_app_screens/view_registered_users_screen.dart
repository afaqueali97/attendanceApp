import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rename_me/controllers/attendance_app_screen_controllers/view_registered_users_screen_controller.dart';
import 'package:rename_me/ui/custom_widgets/custom_scaffold.dart';

class ViewRegisteredUsersScreen extends GetView<ViewRegisteredUsersScreenController> {
  const ViewRegisteredUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      key: const Key("scanResultWidget"),
      className: runtimeType.toString(),
      screenName: 'Registered Users',
      onWillPop: controller.onBackPressed,
      onBackButtonPressed: controller.onBackPressed,
      scaffoldKey: controller.scaffoldKey,
      floatingActionButton: Obx(() => FloatingActionButton(
        onPressed: controller.isSyncing.value ? null : () => controller.syncWithFirestore(),
        child: controller.isSyncing.value
            ? const CircularProgressIndicator(color: Colors.white)
            : const Icon(Icons.cloud_sync),
      )),
      body: _getBody(),
    );
  }

  Widget _getBody() {
    return SizedBox(
      height: Get.height,
      width: Get.width,
      child: Obx(() {
        if (controller.users.isEmpty) {
          return const Center(
            child: Text('No users stored yet'),
          );
        }

        return Stack(
          children: [
            GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 3,
                mainAxisSpacing: 3,
                childAspectRatio: 0.8,
              ),
              itemCount: controller.users.length,
              itemBuilder: (context, index) {
                final user = controller.users[index];
                return _buildUserCard(user.key, user.value);
              },
            ),
            if (controller.isSyncing.value)
              const Center(
                child: CircularProgressIndicator(),
              ),
          ],
        );
      }),
    );
  }

  Widget _buildUserCard(String name, Uint8List imageBytes) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.memory(
                imageBytes,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // Cloud status indicator
                Obx(() {
                  final hasCloudImage = controller.cloudImages.containsKey(name);
                  return Icon(
                    hasCloudImage ? Icons.cloud_done : Icons.cloud_off,
                    color: hasCloudImage ? Colors.green : Colors.grey,
                    size: 20,
                  );
                }),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _showDeleteDialog(name),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(String name) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete User'),
        content: Text('Are you sure you want to delete $name? This will remove them from both local and cloud storage.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.deleteUser(name);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}