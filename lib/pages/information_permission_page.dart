import 'package:flutter/material.dart';
import 'package:panic_app/utils/preferencias_app.dart';

import 'package:permission_handler/permission_handler.dart';

class InformationPermissionPage extends StatefulWidget {
   
  const InformationPermissionPage({Key? key}) : super(key: key);

  @override
  State<InformationPermissionPage> createState() => _InformationPermissionPageState();
}

class _InformationPermissionPageState extends State<InformationPermissionPage> {
  
  @override
  Widget build(BuildContext context) {

    final List<dynamic> infoCamera = ModalRoute.of(context)!.settings.arguments as List<dynamic>;
    final Size size = MediaQuery.of(context).size;
    final PreferenciasUsuario prefs = PreferenciasUsuario();
    final ValueNotifier statusCamera = ValueNotifier(infoCamera[0]);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),

      body: Container(
        width: double.infinity ,
        height: size.height,
        color: Colors.white,
        padding: const EdgeInsets.all(15),
        child: Column(
          
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            _informationPermission(),

            ValueListenableBuilder(
              valueListenable: statusCamera, 
              builder: (context, _, __) {
              return  ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColorDark,
                    shape: const StadiumBorder(),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),     

                  child: SizedBox(
                    width: double.infinity,
                    child: Center(
                      child: Text(
                        statusCamera.value, 
                        style: const TextStyle(color: Colors.white),
                      )
                    )
                  ),

                  onPressed: () async {
                    await checkPermission(prefs).then((hasGranted) {
                      if(hasGranted == PermissionStatus.granted){
                        Navigator.pushReplacementNamed(context, 'camera', arguments: infoCamera[1]);
                      } else if (hasGranted == PermissionStatus.permanentlyDenied) {
                        statusCamera.value = 'Ir a configuración';
                      }
                    });  
                  } 
                );
              }
            ),
          ],
        ),
      )
    );
  }

  Future<PermissionStatus> checkPermission(PreferenciasUsuario prefs) async {
    final PermissionStatus status = await Permission.camera.request();
    status.isPermanentlyDenied ? prefs.permissionDeniedCamera = true : prefs.permissionDeniedCamera = false;
    return status;
  }

  Widget _informationPermission() {
    return Column(
      children:  [
        Text('Permite que Botón de Pánico acceda a tu cámara y micrófono', style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColorDark, fontSize: 30)),
        const SizedBox(height: 10,),
        const Text('El acceso a la cámara te permite tomar fotos y grabar videos. El acceso al micrófono te permite grabar videos y usar la función de describir un evento por voz. \nPuedes cambiar este acceso más tarde en la configuración del sistema.', style: TextStyle(color: Colors.grey),),
        const SizedBox(height: 30,),
      ],
    );
  }

}