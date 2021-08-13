import 'package:flutter/material.dart';

import '../providers/product.dart';

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

  //key para o Form
  final _form = GlobalKey<FormState>();

  //para salvar o conteudo do Form, precisamos de um objeto Product
  var _editedProduct = Product(
    id: '',
    title: '',
    description: '',
    price: 0,
    imageUrl: '',
  );

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
    //perceba o r antes das quotes, representa um regular expression pattern
    var urlPattern =
        r"(https?|ftp)://([-A-Z0-9.]+)(/[-A-Z0-9+&@#/%=~_|!:,.;]*)?(\?[A-Z0-9+&@#/%=~_|!:‌​,.;]*)?";
    //uso da classe regex
    var result = new RegExp(urlPattern, caseSensitive: false)
        .firstMatch(_imageUrlController.text);
    if (result == null) {
      print('URL inválida');
      return;
    }
    setState(() {});
    //se a imagem perdeu o foco
    // if (!_imageUrlFocusNode.hasFocus) {
    //   if ((!_imageUrlController.text.startsWith('http') ||
    //           !_imageUrlController.text.startsWith('https')) ||
    //       (!_imageUrlController.text.endsWith('.jpg') &&
    //           !_imageUrlController.text.endsWith('.png') &&
    //           !_imageUrlController.text.endsWith('jpeg'))) {
    //     return;
    //   }
  }

  //definimos esse método para capturar as informações do form

  //para capturar as informações do form, vamos usar uma globalkey
  //e atrela-la ao form.
  void _saveForm() {
    //executa o validator de todos os campos do form
    var isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    //o método save é fornecido pelo state object da widget
    //ele irá executar um método em cada textformfield
    _form.currentState!.save();
    print('${_editedProduct.title}');
    print('${_editedProduct.description}');
    print('${_editedProduct.price}');
    print('${_editedProduct.imageUrl}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [
          IconButton(
            onPressed: _saveForm,
            icon: Icon(Icons.save),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _form,
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
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Digite um título';
                  }
                  return null;
                },
                //atualizamos o produto, com um novo produto e o valor do campo
                onSaved: (value) {
                  _editedProduct = Product(
                    id: '',
                    title: value as String,
                    description: _editedProduct.description,
                    price: _editedProduct.price,
                    imageUrl: _editedProduct.imageUrl,
                  );
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
                onSaved: (value) {
                  _editedProduct = Product(
                    id: '',
                    title: _editedProduct.title,
                    description: _editedProduct.description,
                    price: double.parse(value!),
                    imageUrl: _editedProduct.imageUrl,
                  );
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Insira um número';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Digite um número válido';
                  }
                  if (double.parse(value) <= 0) {
                    return 'Digite um valor maior que zero.';
                  }
                  return null;
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
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Insira uma descrição';
                  }
                  if (value.length < 10) {
                    return 'Insira uma descrição com mais de 10 caracteres';
                  }
                  return null;
                },
                onSaved: (value) {
                  _editedProduct = Product(
                    id: '',
                    title: _editedProduct.title,
                    description: value as String,
                    price: _editedProduct.price,
                    imageUrl: _editedProduct.imageUrl,
                  );
                },
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

                      onSaved: (value) {
                        _editedProduct = Product(
                          id: '',
                          title: _editedProduct.title,
                          description: _editedProduct.description,
                          price: _editedProduct.price,
                          imageUrl: value as String,
                        );
                      },
                      onFieldSubmitted: (_) => _saveForm(),
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
