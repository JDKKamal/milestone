/* Firestore read database
  Widget buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream:Firestore.instance.collection('book').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error ${snapshot.error}');
        }
        if (snapshot.hasData) {
          return new ListView(
            children: snapshot.data.documents.map((DocumentSnapshot document) {
              return new ListTile(
                title: new Text(document['username']),
                subtitle: new Text('Good'),
              );
            }).toList(),
          );
        }
        return CircularProgressIndicator();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomPadding: false,
        body: Container(
            padding: EdgeInsets.all(20.0), child: buildBody(context)));
  }
*/