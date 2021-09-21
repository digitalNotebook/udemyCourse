import 'dart:io';

import 'package:flutter/material.dart';

class ImagePreview extends StatefulWidget {
  const ImagePreview({Key? key}) : super(key: key);

  @override
  _ImagePreviewState createState() => _ImagePreviewState();
}

class _ImagePreviewState extends State<ImagePreview> {
  //vamos gerenciar a imagem com essa variavel
  File? _storedImage;

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
            onPressed: () {},
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
