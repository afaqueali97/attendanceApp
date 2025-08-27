import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';


class ViewAttendanceRecordsScreenController extends GetxController{
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final RxBool isLoading = false.obs;
  final RxList<AttendanceRecord> allRecords = <AttendanceRecord>[].obs;
  final RxList<AttendanceRecord> filteredRecords = <AttendanceRecord>[].obs;
  final RxString selectedFilter = 'All'.obs;
  final RxBool sortAscending = false.obs;

  // Statistics
  final RxInt totalRecords = 0.obs;
  final RxInt todayRecords = 0.obs;
  final RxInt weekRecords = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadAttendanceRecords();
  }

  Future<void> loadAttendanceRecords() async {
    isLoading.value = true;

    try {
      final box = Hive.box<String>('attendance_db');
      final records = <AttendanceRecord>[];

      // Process all records
      for (final key in box.keys) {
        final value = box.get(key);
        if (value != null) {
          try {
            final record = AttendanceRecord.fromMap(key as String, value);
            records.add(record);
          } catch (e) {
            debugPrint('Error parsing record $key: $e');
          }
        }
      }

      // Sort records by date
      records.sort((a, b) => b.date.compareTo(a.date));
      allRecords.value = records;

      // Update statistics
      _updateStatistics();

      // Apply current filter
      applyFilter();

    } catch (e) {
      debugPrint('Error loading attendance records: $e');
      Get.snackbar('Error', 'Failed to load attendance records');
    } finally {
      isLoading.value = false;
    }
  }

  void _updateStatistics() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final weekStart = today.subtract(Duration(days: today.weekday - 1));

    totalRecords.value = allRecords.length;
    todayRecords.value = allRecords.where((record) {
      final recordDate = DateTime(record.date.year, record.date.month, record.date.day);
      return recordDate == today;
    }).length;

    weekRecords.value = allRecords.where((record) {
      final recordDate = DateTime(record.date.year, record.date.month, record.date.day);
      return recordDate.isAfter(weekStart.subtract(const Duration(days: 1)));
    }).length;
  }

  void applyFilter() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final weekStart = today.subtract(Duration(days: today.weekday - 1));
    final monthStart = DateTime(now.year, now.month, 1);

    List<AttendanceRecord> filtered;

    switch (selectedFilter.value) {
      case 'Today':
        filtered = allRecords.where((record) {
          final recordDate = DateTime(record.date.year, record.date.month, record.date.day);
          return recordDate == today;
        }).toList();
        break;
      case 'This Week':
        filtered = allRecords.where((record) {
          final recordDate = DateTime(record.date.year, record.date.month, record.date.day);
          return recordDate.isAfter(weekStart.subtract(const Duration(days: 1)));
        }).toList();
        break;
      case 'This Month':
        filtered = allRecords.where((record) {
          final recordDate = DateTime(record.date.year, record.date.month, record.date.day);
          return recordDate.isAfter(monthStart.subtract(const Duration(days: 1)));
        }).toList();
        break;
      default:
        filtered = List.from(allRecords);
    }

    // Apply sorting
    if (sortAscending.value) {
      filtered.sort((a, b) => a.date.compareTo(b.date));
    } else {
      filtered.sort((a, b) => b.date.compareTo(a.date));
    }

    filteredRecords.value = filtered;
  }

  void onFilterChanged(String? newFilter) {
    if (newFilter != null) {
      selectedFilter.value = newFilter;
      applyFilter();
    }
  }

  void toggleSortOrder() {
    sortAscending.value = !sortAscending.value;
    applyFilter();
  }

  Future<void> deleteRecord(AttendanceRecord record) async {
    try {
      final box = Hive.box<String>('attendance_db');
      await box.delete(record.id);

      // Remove from lists
      allRecords.removeWhere((r) => r.id == record.id);
      filteredRecords.removeWhere((r) => r.id == record.id);

      // Update statistics
      _updateStatistics();

      Get.snackbar('Success', 'Attendance record deleted');
    } catch (e) {
      debugPrint('Error deleting record: $e');
      Get.snackbar('Error', 'Failed to delete record');
    }
  }

  Future<void> exportRecords() async {
    // Implement export functionality (CSV, PDF, etc.)
    Get.snackbar('Info', 'Export functionality coming soon');
  }

  Future<void> clearAllRecords() async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Clear All Records'),
        content: const Text('Are you sure you want to delete all attendance records? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Clear All', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final box = Hive.box<String>('attendance_db');
        await box.clear();

        allRecords.clear();
        filteredRecords.clear();
        _updateStatistics();

        Get.snackbar('Success', 'All records cleared');
      } catch (e) {
        debugPrint('Error clearing records: $e');
        Get.snackbar('Error', 'Failed to clear records');
      }
    }
  }

  @override
  void onClose() {
    super.onClose();
  }

  void onBackPressed() => Get.back();
}

class AttendanceRecord {
  final String id;
  final String employeeName;
  final DateTime date;

  AttendanceRecord({
    required this.id,
    required this.employeeName,
    required this.date,
  });

  factory AttendanceRecord.fromMap(String key, String value) {
    final date = DateTime.parse(value);
    // Extract employee name from key (format: "name-year-month-day")
    final parts = key.split('-');
    final employeeName = parts.sublist(0, parts.length - 3).join(' ');

    return AttendanceRecord(
      id: key,
      employeeName: employeeName,
      date: date,
    );
  }
}