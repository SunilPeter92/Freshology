import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freshology/constants/styles.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class Notify extends StatefulWidget {
  @override
  _NotifyState createState() => _NotifyState();
}

class _NotifyState extends State<Notify> {
  bool _isLoading = false;
  List<NotificationModel> notification = [];

  Future<void> fetchNotifications() async {
    setState(() {
      _isLoading = true;
    });
    Firestore _db = Firestore.instance;
    var data = await _db.collection('notifications').getDocuments();
    for (var d in data.documents) {
      notification.add(NotificationModel(
        title: d.data['title'],
        image: d.data['image'],
        text: d.data['text'],
        time: d.data['time'],
      ));
    }
    notification.sort((b, a) {
      return a.time.compareTo(b.time);
    });
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      fetchNotifications();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        backgroundColor: kLightGreen,
      ),
      body: ModalProgressHUD(
        inAsyncCall: _isLoading,
        child: Container(
          width: size.width,
          height: size.height,
          padding: EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          child: ListView.builder(
            itemBuilder: (context, index) {
              final notify = notification[index];
              return Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 0,
                  vertical: 10,
                ),
                child: Card(
                  elevation: 5,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        notify.image.length > 5
                            ? Image(
                                image: NetworkImage(notify.image),
                              )
                            : Container(),
                        SizedBox(height: 10),
                        Text(
                          notify.title,
                          style: kCartGrandTotalTextStyle,
                        ),
                        SizedBox(height: 10),
                        Text(
                          notify.text,
                          style: kProductNameTextStyle,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            itemCount: notification == null ? 0 : notification.length,
          ),
        ),
      ),
    );
  }
}

class NotificationModel {
  String title;
  String text;
  String image;
  Timestamp time;

  NotificationModel({
    this.image,
    this.text,
    this.time,
    this.title,
  });
}
