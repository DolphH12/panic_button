import 'package:flutter/material.dart';
import 'package:panic_app/models/contacts_model.dart';
import 'package:panic_app/models/user_general_model.dart';
import 'package:panic_app/services/contact_service.dart';
import 'package:panic_app/widgets/btn_casual.dart';
import 'package:panic_app/widgets/contact_widget.dart';
import 'package:panic_app/widgets/message_card.dart';

class SeeContactPage extends StatelessWidget {
  const SeeContactPage({Key? key}) : super(key: key);

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
      body: const ContainContacts(),
      floatingActionButton: BtnCasual(
          textobutton: "Añadir contacto",
          onPressed: () => Navigator.pushNamed(context, "add"),
          width: 100,
          colorBtn: Theme.of(context).primaryColorDark),
    );
  }
}

class ContainContacts extends StatefulWidget {
  const ContainContacts({
    Key? key,
  }) : super(key: key);

  @override
  State<ContainContacts> createState() => _ContainContactsState();
}

class _ContainContactsState extends State<ContainContacts> {
  ContactService contactService = ContactService();
  List<ContactModel> contacts = [];
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          Text(
            "Contactos",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 30,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 10,
          ),
          FutureBuilder(
            future: contactService.getContacts(),
            builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.isEmpty) {
                  return const Center(
                    child: MessageCardWidget(
                        title: "Aún no tienes contactos de emergencia.",
                        message:
                            'Agrégalos en "Añadir contactos"'),
                  );
                } else {
                  for (var map in snapshot.data!) {
                    contacts.add(ContactModel.fromJson(map));
                  }
                  return Expanded(
                    child: ListView.builder(
                      itemCount: contacts.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ContactWidget(
                            name:
                                "${contacts[index].name} ${contacts[index].lastName}",
                            email: contacts[index].email,
                            cellPhone: contacts[index].cellPhone);
                      },
                    ),
                  );
                }
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
          //const ImageAvatar(),
          const SizedBox(
            height: 20,
          ),
          //const CamposPerfilWidget()
        ],
      ),
    );
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
          width: 150,
          height: 150,
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColorDark,
              borderRadius: BorderRadius.circular(100)),
        ),
        
        const CircleAvatar(
          backgroundImage: AssetImage("assets/alert.png"),
          radius: 65,
          backgroundColor: Colors.white,
        ),
      ],
    );
  }
}
