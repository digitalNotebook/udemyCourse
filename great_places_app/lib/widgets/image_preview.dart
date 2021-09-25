import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;

class ImagePreview extends StatefulWidget {
  //referencia para o método de add_place_screen
  final Function onSelectedImage;

  const ImagePreview({
    Key? key,
    required this.onSelectedImage,
  }) : super(key: key);

  @override
  _ImagePreviewState createState() => _ImagePreviewState();
}

class _ImagePreviewState extends State<ImagePreview> {
  //vamos gerenciar a imagem com essa variavel
  File? _storedImage;

  //atualizamos a tela e exibimos essa imagem no preview
  Future<void> _takePicture() async {
    //criamos uma instancia de ImagePicker
    var imagePicker = ImagePicker();
    //acessamos a camera e capturamos uma imagem de tamanho maximo 600
    var pickImage = await imagePicker.pickImage(
      source: ImageSource.camera,
      maxWidth: 600,
    );
    setState(() {
      _storedImage = File(pickImage!.path);
    });
    //capturamos o caminho do diretorio onde podemos armazenar essa imagem
    var appDir = await syspaths.getApplicationDocumentsDirectory();
    //capturamos o nome gerado para a imagem
    var fileName = path.basename(pickImage!.path);
    //salvamos a imagem no diretorio com o nome dado pelo sistema.
    await pickImage.saveTo('${appDir.path}/$fileName');

    print(fileName);
    //executamos a referencia da função de addPlaceScreen
    if (_storedImage != null) widget.onSelectedImage(_storedImage);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 150,
          height: 100,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Colors.grey,
            ),
          ),
          child: _storedImage != null
              ? Image.file(
                  _storedImage!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                )
              : Text(
                  "No image taken",
                  textAlign: TextAlign.center,
                ),
          //alinhamos o texto verticalmente e horizontalmente
          alignment: Alignment.center,
        ),
        SizedBox(
          height: 10,
        ),
        //ocupa todo o espaço restante da linha
        Expanded(
          child: TextButton.icon(
            onPressed: _takePicture,
            icon: Icon(Icons.camera),
            label: Text('Taken Picture'),
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all(Theme.of(context).accentColor),
            ),
          ),
        ),
      ],
    );
  }
}
