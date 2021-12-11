import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dankon/models/the_user.dart';
import 'package:dankon/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String name = "";



  @override
  Widget build(BuildContext context) {

    final myUid = context.read<User?>()!.uid;
    const snackBar = SnackBar(content: Text('Created a chat!'));
    DatabaseService databaseService = DatabaseService(uid: myUid);

    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  onChanged: (val) => initiateSearch(val),
                  autofocus: true,
                  decoration: InputDecoration(
                      prefixIcon: IconButton(
                        color: Colors.black,
                        icon: Icon(Icons.arrow_back),
                        iconSize: 20.0,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      contentPadding: EdgeInsets.only(left: 25.0),
                      hintText: 'Search by name',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4.0))),
                ),
                const SizedBox(height: 20,),

                name == "" ?

                Column(
                  children: const [
                    Icon(Icons.search, size: 56,),
                    SizedBox(height: 10,),
                    Text('Start searching', style: TextStyle(fontSize: 16),),
                  ],
                ) :

                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                            .collection('users')
                            .where("search", arrayContains: name)
                            .limit(5)
                            .snapshots(),
                    builder:
                        (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) return Text('Error: ${snapshot.error}');
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return const Center(child: CircularProgressIndicator(),);
                        default:
                          return ListView(
                            children:
                                snapshot.data!.docs.map((DocumentSnapshot document) {
                              return Card(
                                child: ListTile(
                                  title: Text(document['name']),
                                  leading: CircleAvatar(backgroundImage: NetworkImage(document["urlAvatar"]),),
                                  trailing: IconButton(icon: Icon(Icons.person_add, color: Theme.of(context).primaryColor,), onPressed: () async {
                                    await databaseService.createChat(TheUser(uid: document['uid'], name: document['name'], urlAvatar: document['urlAvatar'], bio: document['bio']));
                                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                    },),
                                ),
                              );
                            }).toList(),
                          );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void initiateSearch(String val) {
    setState(() {
      name = val.toLowerCase().trim();
    });
  }
}
