class TMUrls {
  static String baseURL = 'http://task-manager-api.ostad.live/api/v1';

  static String signUpURL = '$baseURL/Registration';

  static String loginURL = '$baseURL/Login';

  static String taskStatusCountURL = '$baseURL/taskStatusCount';

  static String addNewTaskURL = '$baseURL/createTask';

  static String updateTaskURL = '$baseURL/updateTask';
  static String updateTaskStatusURL(String ID,String status)=>'$baseURL/updateTaskStatus/$ID/$status';

  // Task List By Status
  static String taskListByStatusURL(String status) =>
      '$baseURL/listTaskByStatus/$status';

  static String deleteTaskURL(String id) => '$baseURL/deleteTask/$id';

  // Update Profile
  static String updateProfileURL = '$baseURL/ProfileUpdate';

  static String recoverVerifyEmailURL = '$baseURL/RecoverVerifyEmail';

  static String verifyOTPURL = '$baseURL/VerifyOTP';

  static String listTaskByStatus = '$baseURL/listTaskByStatus/Completed';
}
