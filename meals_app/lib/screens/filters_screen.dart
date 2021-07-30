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
  var _isVegatarian = false;
  var _isLactoseFree = false;

  @override
  void initState() {
    super.initState();
  }

  // Widget _buildSwitchListTile(
  //   String title,
  //   String description,
  //   bool currentValue,
  //   Function updateValue,
  // ) {
  //   print('Estou aqui');
  //   return SwitchListTile(
  //     title: Text(title),
  //     subtitle: Text(description),
  //     value: currentValue,
  //     onChanged: updateValue,
  //   );
  // }

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
                SwitchListTile(
                  title: Text('Gluten-Free'),
                  subtitle: Text('Only include gluten-free meals.'),
                  value: _isGlutenFree,
                  onChanged: (newValue) {
                    setState(() {
                      _isGlutenFree = newValue;
                    });
                  },
                ),
                // _buildSwitchListTile('Gluten-Free',
                //     'Only include gluten-free meals.', _isGlutenFree, (value) {
                //   setState(() {
                //     _isGlutenFree = value;
                //   });
                // })
              ],
            ),
          )
        ],
      ),
    );
  }
}
