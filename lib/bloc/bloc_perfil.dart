import '../models/profile_model.dart';
import '../services/user_service.dart';

class BlocPerfil {
  UsuarioService usuarioService = UsuarioService();
  late ProfileModel profile;

  getPerfil() async {
    final perfilJson = await usuarioService.profileUser();
    Future.delayed(const Duration(seconds: 2),
        () => profile = ProfileModel.fromJson(perfilJson));
    print(profile);
  }
}

final blocPerfil = BlocPerfil();
