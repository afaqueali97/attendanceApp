import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rename_me/controllers/attendance_app_screen_controllers/view_attendance_records_screen_controller.dart';
import 'package:rename_me/ui/custom_widgets/custom_scaffold.dart';

class ViewAttendanceRecordsScreen extends GetView<ViewAttendanceRecordsScreenController> {
  const ViewAttendanceRecordsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      key: const Key("attendanceRecordsWidget"),
      className: runtimeType.toString(),
      screenName: 'Attendance Records',
      onWillPop: controller.onBackPressed,
      onBackButtonPressed: controller.onBackPressed,
      scaffoldKey: controller.scaffoldKey,
      body: _getBody(),
    );
  }

  Widget _getBody() {
    return Column(
      children: [
        // Filter Controls
        _buildFilterControls(),

        // Statistics
        _buildStatistics(),

        // Records List
        Container(
          height: Get.height*.5,
          child: _buildRecordsList(),
        ),
      ],
    );
  }

  Widget _buildFilterControls() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey[100],
      child: Row(
        children: [
          Expanded(
            child: Obx(() => DropdownButtonFormField<String>(
              value: controller.selectedFilter.value,
              items: ['All', 'Today', 'This Week', 'This Month']
                  .map((filter) => DropdownMenuItem(
                value: filter,
                child: Text(filter),
              ))
                  .toList(),
              onChanged: controller.onFilterChanged,
              decoration: InputDecoration(
                labelText: 'Filter by',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            )),
          ),
          const SizedBox(width: 10),
          Obx(() => IconButton(
            icon: Icon(
              controller.sortAscending.value
                  ? Icons.arrow_upward
                  : Icons.arrow_downward,
            ),
            onPressed: controller.toggleSortOrder,
            tooltip: 'Sort by date',
          )),
        ],
      ),
    );
  }

  Widget _buildStatistics() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const LinearProgressIndicator();
      }

      return Container(
        padding: const EdgeInsets.all(16),
        color: Colors.blue[50],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatCard('Total Records', controller.totalRecords.toString()),
            _buildStatCard('Today', controller.todayRecords.toString()),
            _buildStatCard('This Week', controller.weekRecords.toString()),
          ],
        ),
      );
    });
  }

  Widget _buildStatCard(String title, String value) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
      ],
    );
  }

  Widget _buildRecordsList() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.filteredRecords.isEmpty) {
        return const Center(
          child: Text(
            'No attendance records found',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: controller.loadAttendanceRecords,
        child: ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: controller.filteredRecords.length,
          itemBuilder: (context, index) {
            final record = controller.filteredRecords[index];
            return _buildRecordCard(record);
          },
        ),
      );
    });
  }

  Widget _buildRecordCard(AttendanceRecord record) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue[100],
          child: const Icon(Icons.person, color: Colors.blue),
        ),
        title: Text(
          record.employeeName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Date: ${DateFormat('MMM dd, yyyy').format(record.date)}'),
            Text('Time: ${DateFormat('HH:mm:ss').format(record.date)}'),
            Text('Day: ${DateFormat('EEEE').format(record.date)}'),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () => _showDeleteDialog(record),
        ),
        onTap: () => _showRecordDetails(record),
      ),
    );
  }

  void _showRecordDetails(AttendanceRecord record) {
    Get.dialog(
      AlertDialog(
        title: const Text('Attendance Details'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Employee: ${record.employeeName}'),
              const SizedBox(height: 8),
              Text('Date: ${DateFormat.yMMMEd().format(record.date)}'),
              Text('Time: ${DateFormat.Hms().format(record.date)}'),
              Text('Day: ${DateFormat.EEEE().format(record.date)}'),
              const SizedBox(height: 8),
              Text('Record ID: ${record.id}'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(AttendanceRecord record) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Record'),
        content: Text('Are you sure you want to delete attendance record for ${record.employeeName} on ${DateFormat.yMMMd().format(record.date)}?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.deleteRecord(record);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
