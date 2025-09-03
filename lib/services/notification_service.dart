import 'package:flutter/material.dart';

class NotificationService extends ChangeNotifier {
  // Notification count
  int _notificationCount = 0;
  
  // List of notifications
  List<Map<String, dynamic>> _notifications = [];
  
  // Get notification count
  int get notificationCount => _notificationCount;
  
  // Get notifications
  List<Map<String, dynamic>> get notifications => _notifications;
  
  // Initialize the notification service
  Future<void> initialize() async {
    // For now, just set default values
    // In a real app, you might load notifications from a database or API
    _notificationCount = 0;
    _notifications = [];
  }
  
  // Add a notification
  void addNotification(Map<String, dynamic> notification) {
    _notifications.add(notification);
    _notificationCount = _notifications.length;
    notifyListeners();
  }
  
  // Clear all notifications
  void clearNotifications() {
    _notifications.clear();
    _notificationCount = 0;
    notifyListeners();
  }
  
  // Mark notification as read
  void markAsRead(int index) {
    if (index >= 0 && index < _notifications.length) {
      _notifications[index]['isRead'] = true;
      notifyListeners();
    }
  }
  
  // Get unread notification count
  int get unreadCount {
    return _notifications.where((notification) => 
        notification['isRead'] == false).length;
  }
}