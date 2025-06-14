class Config {
  static String get hostIP {
    return '10.31.58.207'; // Replace with current IP from ipconfig
  }

  static String get baseURL {
    return 'http://$hostIP:8000';
  }
  
  // Fix: Use plural 'users' for login endpoint to match backend
  static String get loginURL {
    return '$baseURL/users/login';
  }

  static String get predictURL {
    return '$baseURL/predict';  // No trailing slash
  }

  static String get documentsURL {
    return '$baseURL/documents';
  }

  static String documentsUserURL(int userId) {
    return '$baseURL/documents/user/$userId';
  }

  static String documentURL(int documentId) {
    return '$baseURL/documents/$documentId';
  }
}