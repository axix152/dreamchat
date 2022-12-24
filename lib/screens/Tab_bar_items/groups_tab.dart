import 'package:dreamchat/common/widget/group_contactList.dart';
import 'package:flutter/material.dart';

class GroupTab extends StatelessWidget {
  const GroupTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GroupContactsList(),
    );
  }
}
