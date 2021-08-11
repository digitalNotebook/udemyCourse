import 'package:flutter/material.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({Key? key}) : super(key: key);
  static const routeName = '/edit-products';
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  //precisamos limpar esses objetos focus ao sair da tela
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();

  //criamos um controller para o input da image para exibi-la antes do submit
  final _imageUrlController = TextEditingController();

  final _imageUrlFocusNode = FocusNode();

  @override
  void initState() {
    _imageUrlController.addListener(_imageUpdateUrl);
    super.initState();
  }

  //removemos os FocusNode, o controller e o listener da memória
  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlController.removeListener(_imageUpdateUrl);

    super.dispose();
  }

  void _imageUpdateUrl() {
    //se a imagem perdeu o foco
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: ListView(
            children: [
              //não precisa definir um controller, pois este text
              //está ligado ao Form
              TextFormField(
                decoration: InputDecoration(labelText: 'Title'),
                //ao apertar o botão done do softkeyboard, iremos para o próximo campo
                //devemos controlar qual o próximo campo
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  //aponta para o próximo focus, quando o softkeyboard for pressionado
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Price'),
                textInputAction: TextInputAction.next,
                //teclado númerico
                keyboardType: TextInputType.number,
                //atrelamos o focusNode criado acima
                focusNode: _priceFocusNode,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
                //ao apertar enter uma nova linha é criada
                keyboardType: TextInputType.multiline,
                //aqui não teremos a troca de foco, pois não sabemos quando o usuário
                //irá trocar de campo
                focusNode: _descriptionFocusNode,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  //image preview container
                  Container(
                    width: 100,
                    height: 100,
                    margin: EdgeInsets.only(top: 8, right: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1),
                    ),
                    child: _imageUrlController.text.isEmpty
                        ? Text('Enter a URL')
                        : FittedBox(
                            child: Image.network(_imageUrlController.text),
                            fit: BoxFit.cover,
                          ),
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Image URL'),
                      keyboardType: TextInputType.url,
                      //vamos submeter esse form
                      textInputAction: TextInputAction.done,
                      controller: _imageUrlController,
                      focusNode: _imageUrlFocusNode,
                      onEditingComplete: () {
                        setState(() {});
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
