import 'package:flutter/material.dart';
import 'package:meals_app/widgets/main_drawer.dart';

class FiltersScreen extends StatefulWidget {
  const FiltersScreen({Key? key}) : super(key: key);

  static const routeName = '/filters';

  @override
  _FiltersScreenState createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  var _isGlutenFree = false;
  var _isVegan = false;
  var _isVegetarian = false;
  var _isLactoseFree = false;

  @override
  void initState() {
    super.initState();
  }

  Widget _buildSwitchListTile(
    String title,
    String description,
    bool currentValue,
    Function updateValue,
  ) {
    return SwitchListTile(
      title: Text(title),
      subtitle: Text(description),
      value: currentValue,
      onChanged: updateValue as void Function(
          bool), //feita essa conversão para o dart reconhecer a referencia
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Filters'),
      ),
      drawer: MainDrawer(),
      body: Column(
        children: [
          Container(
            child: Text(
              'Adjust your meal selection',
              style: Theme.of(context).textTheme.headline6,
            ),
            padding: EdgeInsets.all(20),
          ),
          Expanded(
            child: ListView(
              children: [
                // SwitchListTile(
                //   title: Text('Gluten-Free'),
                //   subtitle: Text('Only include gluten-free meals.'),
                //   value: _isGlutenFree,
                //   onChanged: (newValue) {
                //     setState(() {
                //       _isGlutenFree = newValue;
                //     });
                //   },
                // ),
                _buildSwitchListTile(
                  'Gluten-Free',
                  'Only include gluten-free meals.',
                  _isGlutenFree,
                  (value) {
                    setState(
                      () {
                        _isGlutenFree = value;
                      },
                    );
                  },
                ),
                _buildSwitchListTile(
                  'Lactose-Free',
                  'Only include lactose-free meals.',
                  _isLactoseFree,
                  (newValue) {
                    setState(
                      () {
                        _isLactoseFree = newValue;
                      },
                    );
                  },
                ),
                _buildSwitchListTile(
                  'Vegan-Free',
                  'Only include vegan-free meals.',
                  _isVegan,
                  (newValue) {
                    setState(
                      () {
                        _isVegan = newValue;
                      },
                    );
                  },
                ),
                _buildSwitchListTile(
                  'Vegetarian-Free',
                  'Only include vegetarian-free meals.',
                  _isVegetarian,
                  (newValue) {
                    setState(
                      () {
                        _isVegetarian = newValue;
                      },
                    );
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
