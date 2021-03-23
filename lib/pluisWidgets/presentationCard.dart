
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PresentationCard extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(
            'EN VENTA',
          style: TextStyle(
          fontSize: 34
      ),
          ),
          Text(
            'EN LÍNEA Y EN TIENDAS',
              style: TextStyle(
                  fontSize: 24,
              )
          ),
          RaisedButton(color: Colors.transparent,child: Text('VER'),onPressed: () async {
            return await btnAction();
          })
        ],
      )
    );
  }

  Future<void> btnAction()async {

  }

}