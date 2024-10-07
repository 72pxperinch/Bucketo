import 'package:bucketo/screens/empty.dart';
import 'package:flutter/material.dart';
import 'package:bucketo/components/bottomNavigation.dart';
import 'package:bucketo/screens/bucket_item_detail.dart';
import 'package:bucketo/components/fab.dart';
import 'package:bucketo/util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Home extends StatefulWidget {
  static const String id = 'home';
  const Home({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final bottomNavigationBarIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Your Bucket List'),
      ),
      body: FutureBuilder(
        future: fetchDataFromFirestore(),
        builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.data == null || snapshot.data!.isEmpty) {
            // Redirect to 'empty' page
            return const Empty(
              typed: '',
            );
          } else {
            return SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    const SizedBox(height: 50.0),
                    Expanded(
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          var data = snapshot.data![index];
                          return BucketItem(
                            onPress: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BucketDetailsPage(
                                    bucketItemDetails: data,
                                  ),
                                ),
                              );
                            },
                            date: data['date'],
                            title: data['title'],
                            checkedImage: data['isDone']
                                ? 'assets/images/checked.png'
                                : 'assets/images/checked-empty.png',
                            bellImage: data['isStarred']
                                ? 'assets/images/bell-small-yellow.png'
                                : 'assets/images/bell-small.png',
                            gradientColor: getGradientColor(data['category']),
                            textColor: data['isDone']
                                ? CustomColors.TextGrey
                                : CustomColors.TextHeader,
                          );
                        },
                      ),
                    )
                  ],
                ));
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: customFab(context),
      bottomNavigationBar:
          BottomNavigationBarApp(context, bottomNavigationBarIndex),
    );
  }

  Future<List<Map<String, dynamic>>> fetchDataFromFirestore() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return [];
    }

    String currentUserEmail = user
        .email!; // Replace this with the actual method to get the current user's email

    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance.collection('tasks').get();

    List<Map<String, dynamic>> dataList =
        querySnapshot.docs.map((doc) => doc.data()).toList();

    // Filter the dataList based on the 'user' field
    dataList =
        dataList.where((data) => data['user'] == currentUserEmail).toList();

    // Sort the dataList based on the 'date' field
    dataList.sort((a, b) => a['date'].toDate().compareTo(b['date'].toDate()));

    return dataList;
  }

  // Future<List<Map<String, dynamic>>> fetchDataFromFirestore() async {
  //   QuerySnapshot<Map<String, dynamic>> querySnapshot =
  //       await FirebaseFirestore.instance.collection('tasks').get();
  //   List<Map<String, dynamic>> dataList =
  //       querySnapshot.docs.map((doc) => doc.data()).toList();

  //   // Sort the dataList based on the 'date' field
  //   dataList.sort((a, b) => a['date'].toDate().compareTo(b['date'].toDate()));

  //   return dataList;
  // }

  Color getGradientColor(String category) {
    switch (category) {
      case 'Personal':
        return Colors.yellow;
      case 'Adventure':
        return Colors.blue;
      case 'Travel':
        return Colors.green;
      case 'Skills':
        return CustomColors.PurpleIcon;
      case 'Shopping':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  PreferredSizeWidget? fullAppbar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: AppBar(
        title: const Text('Our Bucket List'),
      ),
    );
  }
}

class TextSeperation extends StatelessWidget {
  final String dayText;

  const TextSeperation({super.key, required this.dayText});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20, bottom: 15),
      child: Text(
        dayText,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: CustomColors.TextSubHeader,
        ),
      ),
    );
  }
}

class BucketItem extends StatelessWidget {
  final Timestamp date;
  final String title;
  final String checkedImage;
  final String bellImage;
  final Color gradientColor;
  final Color textColor;
  final VoidCallback? onPress;

  const BucketItem({
    super.key,
    required this.date,
    required this.title,
    required this.checkedImage,
    required this.bellImage,
    required this.gradientColor,
    required this.textColor,
    this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('dd/MM/yy').format(date.toDate());

    return GestureDetector(
      onTap: onPress,
      child: Container(
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 15),
        padding: const EdgeInsets.fromLTRB(5, 13, 5, 13),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            stops: const [0.03, 0.03],
            colors: [
              gradientColor,
              Colors.white,
            ],
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(20.0),
          ),
          boxShadow: const [
            BoxShadow(
              color: Color.fromARGB(255, 225, 225, 225),
              blurRadius: 10.0,
              spreadRadius: 5.0,
              offset: Offset(0.0, 0.0),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Image.asset(checkedImage),
            Text(
              formattedDate,
              style: const TextStyle(color: CustomColors.TextGrey),
            ),
            SizedBox(
              width: 180,
              child: Text(
                title,
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Image.asset(bellImage),
          ],
        ),
      ),
    );
  }
}
