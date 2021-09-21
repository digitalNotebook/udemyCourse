import 'package:flutter/material.dart';

import '../widgets/image_preview.dart';

class AddPlacesScreen extends StatefulWidget {
  const AddPlacesScreen({Key? key}) : super(key: key);

  static const routeName = '/app-places';

  @override
  _AddPlacesScreenState createState() => _AddPlacesScreenState();
}

class _AddPlacesScreenState extends State<AddPlacesScreen> {
  final _titleController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
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
                    ImagePreview(),
                  ],
                ),
              ),
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {},
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
          )
        ],
      ),
    );
  }
}
