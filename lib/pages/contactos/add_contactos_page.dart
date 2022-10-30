import 'package:flutter/material.dart';
import 'package:panic_app/models/contacts_model.dart';
import 'package:panic_app/services/contact_service.dart';

import '../../widgets/btn_ppal.dart';
import '../../widgets/custom_input.dart';

class AddContactPage extends StatefulWidget {
  const AddContactPage({Key? key}) : super(key: key);

  @override
  State<AddContactPage> createState() => _AddContactPageState();
}

class _AddContactPageState extends State<AddContactPage> {
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
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const ImageAvatar(),
                  const SizedBox(
                    height: 15,
                  ),
                  _tituloPage(),
                  const _Form(),
                ],
              ),
            ),
          ),
        ));
  }

  Widget _tituloPage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Agregar Contacto',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 25,
              fontWeight: FontWeight.bold),
        ),
        const Text(
          'Ingresa la información',
          style: TextStyle(
              color: Colors.black54, fontSize: 25, fontWeight: FontWeight.bold),
        )
      ],
    );
  }
}

class _Form extends StatefulWidget {
  const _Form({Key? key}) : super(key: key);

  @override
  State<_Form> createState() => __FormState();
}

class __FormState extends State<_Form> {
  final nameCtrl = TextEditingController();
  final lastCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final cellCtrl = TextEditingController();
  ContactService contactService = ContactService();
  // final PreferenciasUsuario _prefs = PreferenciasUsuario();
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 40),
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          CustomInput(
            icon: Icons.person,
            placehoder: 'Nombre',
            keyboardType: TextInputType.text,
            textController: nameCtrl,
          ),
          CustomInput(
            icon: Icons.person_add_alt_sharp,
            placehoder: 'Apellido',
            keyboardType: TextInputType.text,
            textController: lastCtrl,
          ),
          CustomInput(
            icon: Icons.email,
            placehoder: 'Correo',
            keyboardType: TextInputType.emailAddress,
            textController: emailCtrl,
          ),
          CustomInput(
              icon: Icons.phone_android,
              placehoder: 'Celular',
              textController: cellCtrl,
              keyboardType: TextInputType.text),
          const SizedBox(
            height: 20,
          ),
          BtnPpal(
            textobutton: 'Registrar Contacto',
            onPressed: () {
              _onSubmit();
              Navigator.popAndPushNamed(context, 'contacts');
            },
          )
        ],
      ),
    );
  }

  void _onSubmit() async {
    final contact = ContactModel(
        name: nameCtrl.text,
        lastName: lastCtrl.text,
        email: emailCtrl.text,
        cellPhone: cellCtrl.text);
    await contactService.addContact(contact);
    // if (passCtrl.text == pass2Ctrl.text) {
    //   if (userCtrl.text.contains(' ')) {
    //     if (!mounted) return;
    //     mostrarAlerta(context, 'Verifica que no tengas espacios en tu usuario');
    //   } else if (isChecked) {
    // registro = UserGeneralModel(
    //     username: userCtrl.text,
    //     password: passCtrl.text,
    //     email: emailCtrl.text,
    //     cellPhone: cellCtrl.text);
    //     final Map info = await usuarioService.nuevoUsuario(registro);
    //     if (info['ok']) {
    //       if (!mounted) {}
    //       Navigator.pushNamed(context, 'otp', arguments: registro.email);
    //     } else {
    //       if (!mounted) {}
    //       mostrarAlerta(context, info['mensaje']);
    //     }
    //   } else {
    //     mostrarAlerta(context, "Recuerde aceptar los terminos y condiciones.");
    //   }
    // } else {
    //   mostrarAlerta(context, "Las contraseñas no coinciden");
    // }
  }
}

class ImageAvatar extends StatelessWidget {
  const ImageAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        Container(
          width: 110,
          height: 110,
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColorDark,
              borderRadius: BorderRadius.circular(100)),
        ),
        const CircleAvatar(
          backgroundImage: AssetImage("assets/alert.png"),
          radius: 50,
          backgroundColor: Colors.white,
        ),
      ],
    );
  }
}
