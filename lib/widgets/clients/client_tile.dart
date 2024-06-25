import 'package:flutter/material.dart';
import 'package:flutter_pos/models/client.dart';
import 'package:flutter_pos/utils/const.dart';

// ignore: must_be_immutable
class ClientTile extends StatelessWidget {
  Client? client;
  ClientTile({this.client, super.key});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 8.0, bottom: 16.0),
            child: CircleAvatar(
              backgroundColor: primaryLightColor,
              child: Text('${client?.clientName?[0].toUpperCase() ?? 'C'}'),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(top: 8.0, bottom: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${client?.clientName}',
                    style: bodyText(primaryLightColor),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${client?.clientPhone}',
                    style: bodyText(lightGreyColor),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            width: 4,
          ),
        ],
      ),
      // ],
      //),
    );
  }
}
