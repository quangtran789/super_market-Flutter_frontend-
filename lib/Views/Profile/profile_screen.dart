import 'package:app_supermarket/Services/auth_service.dart';
import 'package:app_supermarket/Views/Login/Screens/login_screens.dart';
import 'package:app_supermarket/Views/Profile/Widgets/update_user_info_screen.dart';
import 'package:app_supermarket/Views/homepage.dart';
import 'package:app_supermarket/main.dart';
import 'package:app_supermarket/utils/app_localizations.dart';
import 'package:app_supermarket/utils/themeNotifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? name;
  String? email;
  String? role;
  String? address;
  String? languageCode;
  final AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name');
      email = prefs.getString('email');
      role = prefs.getString('role');
      address = prefs.getString('address') ?? 'Chưa có địa chỉ';
      languageCode =
          prefs.getString('languageCode') ?? 'vi'; // Lấy ngôn ngữ mặc định
    });
  }

  Future<void> changeLanguage(String langCode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', langCode);

    // Reload ứng dụng với ngôn ngữ mới
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
            MainApp(isLoggedIn: true, role: role, languageCode: langCode),
      ),
    );
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreens()),
    );
  }

  Future<void> deleteAccount() async {
    final confirmDelete = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
              AppLocalizations.of(context)?.get('confirmDelete') ?? "Xác nhận"),
          content: Text(
              AppLocalizations.of(context)?.get('areYouSureDeleteAccount') ??
                  "Bạn có chắc muốn xóa tài khoản?"),
          actions: [
            TextButton(
              child: Text(AppLocalizations.of(context)?.get('cancel') ?? "Hủy"),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: Text(AppLocalizations.of(context)?.get('yes') ?? "Có"),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );

    if (confirmDelete == true) {
      bool isDeleted = await authService.deleteAccount();
      if (isDeleted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreens()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Xóa tài khoản không thành công')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)?.get('userProfile') ??
            'Hồ Sơ Người Dùng'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.green,
                    backgroundImage:
                        AssetImage('assets/images/ww.png'), // Thay đổi màu nền
                    // Thêm hình nền nếu muốn
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  '${AppLocalizations.of(context)?.get('name')}: ${name ?? 'Chưa có tên'}',
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                Text(
                  '${AppLocalizations.of(context)?.get('email')}: ${email ?? 'Chưa có email'}',
                  style: const TextStyle(fontSize: 18, color: Colors.grey),
                ),
                const SizedBox(height: 5),
                Text(
                  '${AppLocalizations.of(context)?.get('address')}: ${address ?? 'Chưa có địa chỉ'}',
                  style: const TextStyle(fontSize: 18, color: Colors.grey),
                ),
                const SizedBox(height: 5),
                Text(
                  '${AppLocalizations.of(context)?.get('role')}: ${role ?? 'Chưa có vai trò'}',
                  style: const TextStyle(fontSize: 18, color: Colors.grey),
                ),
                ListTile(
                  leading: const Icon(Icons.language, color: Colors.blue),
                  title: Text(
                      AppLocalizations.of(context)?.get('chooseLanguage') ??
                          'Chọn Ngôn Ngữ'),
                  onTap: () {
                    _showLanguageDialog(
                        context); // Hàm này sẽ hiển thị các lựa chọn ngôn ngữ
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.settings, color: Colors.blue),
                  title: Text(AppLocalizations.of(context)?.get('updateInfo') ??
                      'Cập nhật thông tin'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            UpdateUserInfoScreen(), // Chuyển đến màn hình cập nhật
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.brightness_6, color: Colors.blue),
                  title: Text(
                      AppLocalizations.of(context)?.get('changeLayout') ??
                          'Thay đổi giao diện'),
                  onTap: () {
                    Provider.of<ThemeProvider>(context, listen: false)
                        .toggleTheme();
                  },
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff0091E5),
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: logout,
                  child: Text(
                    AppLocalizations.of(context)?.get('logout') ?? 'Đăng xuất',
                    style: const TextStyle(fontSize: 22, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: deleteAccount,
                  child: Text(
                    AppLocalizations.of(context)?.get('deleteAccount') ??
                        'Xóa Tài Khoản',
                    style: const TextStyle(fontSize: 22, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showLanguageDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Choose Language'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Image.asset('assets/images/vn.png', width: 30),
                title: const Text('Tiếng Việt'),
                onTap: () {
                  changeLanguage('vi');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Image.asset('assets/images/us.png', width: 30),
                title: const Text('English'),
                onTap: () {
                  changeLanguage('en');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Image.asset('assets/images/japan.png', width: 30),
                title: const Text('日本語 (Japanese)'),
                onTap: () {
                  changeLanguage('ja');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Image.asset('assets/images/thailand.png', width: 30),
                title: const Text('ไทย (Thai)'),
                onTap: () {
                  changeLanguage('th');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Image.asset('assets/images/china.png', width: 30),
                title: const Text('中文 (Chinese)'),
                onTap: () {
                  changeLanguage('zh');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Image.asset('assets/images/portugal.png', width: 30),
                title: const Text('Português (Portuguese)'),
                onTap: () {
                  changeLanguage('pt');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Image.asset('assets/images/korea.png', width: 30),
                title: const Text('한국어 (Korean)'),
                onTap: () {
                  changeLanguage('ko');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Image.asset('assets/images/france.png', width: 30),
                title: const Text('Français (French)'),
                onTap: () {
                  changeLanguage('fr');
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
