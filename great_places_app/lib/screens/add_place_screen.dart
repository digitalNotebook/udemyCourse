import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/image_preview.dart';
import '../providers/great_places.dart';
import '../widgets/location_input.dart';

class AddPlacesScreen extends StatefulWidget {
  const AddPlacesScreen({Key? key}) : super(key: key);

  static const routeName = '/app-places';

  @override
  _AddPlacesScreenState createState() => _AddPlacesScreenState();
}

class _AddPlacesScreenState extends State<AddPlacesScreen> {
  final _titleController = TextEditingController();
  File? _pickedImage;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  //passado como referencia para a widget image_preview
  void _selectImage(File pickedImage) {
    _pickedImage = pickedImage;
  }

  void _savePlace() {
    //como usamos o textfield sem o form, não temos o validator e
    //não mostramos nenhuma mensagem de erro
    if (_titleController.text.isEmpty || _pickedImage == null) {
      return;
    }
    //queremos apenas dispatch the action, por isso o listen: false
    Provider.of<GreatPlaces>(context, listen: false).addPlace(
      _titleController.text,
      _pickedImage!,
    );
    //Feita a adição, voltamos para a página inicial
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add a new Place'),
      ),
      body: Column(
        //ocupar toda a linha
        crossAxisAlignment: CrossAxisAlignment.stretch,

        children: [
          //essa inner column ocupa todo o espaço restante - tirando o botão
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    //não usamos o textFormEditing, vamos controlá-lo manualmente
                    //não podemos validá-lo, o autor sugeriu usar o Form
                    TextField(
                      decoration: InputDecoration(labelText: 'Title'),
                      controller: _titleController,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    //Criamos uma widget que representa o imagePreview
                    ImagePreview(onSelectedImage: _selectImage),
                    SizedBox(
                      height: 15,
                    ),
                    LocationInput(),
                  ],
                ),
              ),
            ),
          ),
          ElevatedButton.icon(
            onPressed: _savePlace,
            icon: Icon(Icons.add),
            label: Text('Add'),
            style: ButtonStyle(
              //tira as sombras
              elevation: MaterialStateProperty.all(0),
              backgroundColor: MaterialStateProperty.all<Color>(
                  Theme.of(context).accentColor),
              //remove as margens que são clicaveis
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ],
      ),
    );
  }
}
