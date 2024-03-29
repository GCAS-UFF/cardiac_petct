import 'package:cardiac_petct/features/auth/auth_page.dart';
import 'package:cardiac_petct/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:cardiac_petct/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:cardiac_petct/features/auth/submodules/email_verify/email_verify_module.dart';
import 'package:cardiac_petct/features/auth/submodules/login/login_module.dart';
import 'package:cardiac_petct/features/auth/submodules/registration/registration_module.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AuthModule extends Module {
  @override
  List<Bind<Object>> get binds => [
        Bind.lazySingleton((i) => AuthLocalDatasourceImp()),
        Bind.lazySingleton((i) => AuthRemoteDatasourceImp()),
      ];

  @override
  List<ModularRoute> get routes => [
        ChildRoute('/', child: (context, args) => const AuthPage()),
        ModuleRoute('/login', module: LoginModule()),
        ModuleRoute('/registration', module: RegistrationModule()),
        ModuleRoute('/email-verify', module: EmailVerifyModule()),
      ];
}
