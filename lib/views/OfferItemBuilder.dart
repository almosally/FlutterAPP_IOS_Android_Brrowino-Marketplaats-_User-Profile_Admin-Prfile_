import 'package:borrowinomobileapp/models/SearchOffer.dart';
import 'package:flutter/material.dart';

class OfferItemBuilder extends StatelessWidget {
  final SearchOffer repo;
  OfferItemBuilder(this.repo);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
          onTap: () {
            //_launchURL(repo.htmlUrl);
          },
          highlightColor: Color.fromRGBO(64, 75, 96, .9),
          splashColor: Colors.red,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text((repo.title != null) ? repo.title : '-',
                      style: Theme.of(context).textTheme.subhead),
                  Padding(
                    padding: EdgeInsets.only(top: 4.0),
                    child: Text(
                        repo.description != null
                            ? repo.description
                            : 'No desription',
                        style: Theme.of(context).textTheme.body1),
                  ),
                ]),
          )),
    );
  }

}
