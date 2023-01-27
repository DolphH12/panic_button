import 'package:flutter/material.dart';
import 'package:panic_app/models/profile_model.dart';
import 'package:panic_app/services/user_service.dart';
import 'package:panic_app/utils/preferencias_app.dart';
import 'package:panic_app/widgets/profile_campo_widget.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Theme.of(context).primaryColorDark,
        elevation: 0,
        leadingWidth: 200,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Row(
              children: const [
                Icon(Icons.arrow_back_ios_new),
                Text("Regresar")
              ],
            ),
          ),
        ),
      ),
      body: const ContainProfile(),
    );
  }
}

class ContainProfile extends StatelessWidget {
  const ContainProfile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children:  [
          // Text(
          //   "Perfil del usuario",
          //   textAlign: TextAlign.center,
          //   style: TextStyle(
          //       color: Theme.of(context).primaryColor,
          //       fontSize: 30,
          //       fontWeight: FontWeight.bold),
          // ),
          const SizedBox(
            height: 40,
          ),
          ImageAvatar(),
          const SizedBox(
            height: 40,
          ),
          const CamposPerfilWidget()
        ],
      ),
    );
  }
}

class ImageAvatar extends StatelessWidget {
  ImageAvatar({super.key});
  
  final PreferenciasUsuario prefs = PreferenciasUsuario();

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColorDark,
              borderRadius: BorderRadius.circular(100)),
        ),
        const CircleAvatar(
          backgroundImage: AssetImage("assets/usuario.png"),
          radius: 65,
          backgroundColor: Colors.white,
        ),
      ],
    );
  }
}

class CamposPerfilWidget extends StatelessWidget {
  const CamposPerfilWidget({super.key});

  @override
  Widget build(BuildContext context) {
    UsuarioService usuarioService = UsuarioService();
    return FutureBuilder(
      future: usuarioService.profileUser(),
      builder:
          (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
        if (snapshot.hasData) {
          final ProfileModel profile = ProfileModel.fromJson(snapshot.data!);
          return Column(
            children: [
              ProfileCampoWidget(
                  title: 'Nombre',
                  content: "${profile.name} ${profile.lastName}"),
              ProfileCampoWidget(title: 'Username', content: profile.username),
              ProfileCampoWidget(title: 'Correo', content: profile.email),
              ProfileCampoWidget(title: 'Celular', content: profile.cellPhone),
            ],
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
