import 'package:flutter/scheduler.dart';

enum Priority { URGENT, IMPORTANT, A_FAIRE }

String getStringFromPriority(Priority priority) {
  switch (priority) {
    case Priority.URGENT:
      return "URGENT";
    case Priority.IMPORTANT:
      return "IMPORTANT";
    case Priority.A_FAIRE:
      return "A_FAIRE";
  }
}

Priority getPriorityFromString(String priority) {
  if (priority == getStringFromPriority(Priority.URGENT)) {
    return Priority.URGENT;
  } else if (priority == getStringFromPriority(Priority.IMPORTANT)) {
    return Priority.IMPORTANT;
  }
  return Priority.A_FAIRE;
}
