import 'package:flutter/material.dart';

class UserProductsItem extends StatelessWidget {
  final String title;
  final String imageUrl;

  UserProductsItem(this.imageUrl, this.title, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        //Não usamos Image.network e sim NetworkImage
        //Temos também AssetImage que seria nosso Image.asset
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.edit,
                color: Theme.of(context).primaryColor,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.delete),
              color: Theme.of(context).errorColor,
            )
          ],
        ),
      ),
    );
  }
}
