import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products.dart';

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
  final _imageUrlFocusNode = FocusNode();

  //criamos um controller para o input da image para exibi-la antes do submit
  final _imageUrlController = TextEditingController();

  //key para o Form para usar no método _saveForm
  final _form = GlobalKey<FormState>();

  //para utilizar no método didChangeDependencies()
  var _isInit = true;

  //para uso do loadingSpinner
  var _isLoading = false;

  //para salvar o conteudo do Form, precisamos de um objeto Product
  var _editedProduct = Product(
    id: '',
    title: '',
    description: '',
    price: 0,
    imageUrl: '',
  );

  //mapa para o Produto que será editado
  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };

  //adicionamos um listener para o campo da imagemUrl
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
    _imageUrlController.removeListener(_imageUpdateUrl);
    _imageUrlController.dispose();

    super.dispose();
  }

  @override
  void didChangeDependencies() {
    //utilizado para não reinicializar o form
    if (_isInit) {
      //extraimos o id, antes da execucao do build
      var productId = ModalRoute.of(context)!.settings.arguments;
      print('ProductID: $productId');
      //checamos se existe produto para editar ou se é novo produto
      if (productId != null) {
        //consultamos o produto na lista de produtos do Provider
        _editedProduct = Provider.of<Products>(context, listen: false)
            .findById(productId.toString());
        //montamos um novo mapa de produtos definido acima
        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          'imageUrl': '',
        };
        //não podemos ter initialValue e controller no mesmo form
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
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
  Future<void> _saveForm() async {
    //executa o validator de todos os campos do form
    var isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    //o método save é fornecido pelo state object da widget
    //ele irá executar um método em cada textformfield
    _form.currentState!.save();
    //setamos para true e o icone de loading passa a ser exibido
    //por conta do setState que irá rebuildar a tela
    setState(() {
      _isLoading = true;
    });

    //testamos se o produto é um novo produto ou é editado
    if (_editedProduct.id.isNotEmpty) {
      //codigo assincrono, envolver com try-catch
      await Provider.of<Products>(context, listen: false)
          .update(_editedProduct.id, _editedProduct);
      //setamos para false para a animação do pop da tela
    } else {
      //feita todas as checagens, adicionamos o produto ao Provider
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editedProduct);
        //usamos o catchError aqui por conta do throw error do provider
        //podemos exibir algo ao usuario, pois estamos na widget
        //   .catchError(
        // (error) {
      } catch (error) {
        await showDialog<Null>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An error ocurred'),
            //podemos usar o error.toString() aqui também
            //porem informações confidenciais podem ser exibidas
            content: Text('Something went wrong'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: Text('Okay'),
              ),
            ],
          ),
        );
      }
      //o then será executado mesmo se tivermos um erro
      //porém precisamos esperar o usuario clicar em ok, por isso
      //usamos o return do showDialog
      // ).then(
      //   (_) {
      //  finally {
      //   //setamos para false para a animação do pop da tela
      //   setState(
      //     () {
      //       _isLoading = false;
      //     },
      //   );
      //   Navigator.of(context).pop();
      // }
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
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
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: [
                    //não precisa definir um controller, pois este text
                    //está ligado ao Form
                    TextFormField(
                      initialValue: _initValues['title'],
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
                          id: _editedProduct.id,
                          title: value as String,
                          description: _editedProduct.description,
                          price: _editedProduct.price,
                          imageUrl: _editedProduct.imageUrl,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['price'],
                      decoration: InputDecoration(labelText: 'Price'),
                      textInputAction: TextInputAction.next,
                      //teclado númerico
                      keyboardType: TextInputType.number,
                      //atrelamos o focusNode criado acima
                      focusNode: _priceFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          title: _editedProduct.title,
                          description: _editedProduct.description,
                          price: double.parse(value!),
                          imageUrl: _editedProduct.imageUrl,
                          isFavorite: _editedProduct.isFavorite,
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
                      initialValue: _initValues['description'],
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
                          id: _editedProduct.id,
                          title: _editedProduct.title,
                          description: value as String,
                          price: _editedProduct.price,
                          imageUrl: _editedProduct.imageUrl,
                          isFavorite: _editedProduct.isFavorite,
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
                                  child:
                                      Image.network(_imageUrlController.text),
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
                                id: _editedProduct.id,
                                title: _editedProduct.title,
                                description: _editedProduct.description,
                                price: _editedProduct.price,
                                imageUrl: value as String,
                                isFavorite: _editedProduct.isFavorite,
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
