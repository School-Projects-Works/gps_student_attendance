class RouterInfo {
  String name;
  String path;

  RouterInfo({required this.name, required this.path});

  static RouterInfo loginRoute = RouterInfo(name: 'login', path: '/login');
  static RouterInfo registerRoute =
      RouterInfo(name: 'register', path: '/register');
  static RouterInfo forgetPasswordRoute =
      RouterInfo(name: 'forget-password', path: '/forget-password');
  static RouterInfo studentHomeRoute =
      RouterInfo(name: 'student-home', path: '/student/home');
  static RouterInfo lecturerHomeRoute =
      RouterInfo(name: 'lecturer-home', path: '/lecturer/home');
}
