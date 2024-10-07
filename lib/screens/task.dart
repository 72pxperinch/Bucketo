import 'package:bucketo/screens/categoryScreen.dart';
import 'package:bucketo/screens/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bucketo/components/bottomNavigation.dart';
import 'package:bucketo/components/fab.dart';
import 'package:bucketo/util.dart';

class Task extends StatefulWidget {
  const Task({super.key});

  @override
  _TaskState createState() => _TaskState();
}

class _TaskState extends State<Task> {
  final bottomNavigationBarIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Your Bucket List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: _logout,
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        width: MediaQuery.of(context).size.width,
        child: CustomScrollView(
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) => Container(
                  margin: const EdgeInsets.only(left: 10, top: 15, bottom: 0),
                  child: const Text(
                    'Projects',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: CustomColors.TextSubHeader,
                    ),
                  ),
                ),
                childCount: 1,
              ),
            ),
            SliverGrid.count(
              crossAxisCount: 2,
              children: [
                GestureDetector(
                  onTap: () {
                    _navigateToCategory('Personal');
                  },
                  child: const BucketItemCategory(
                    title: 'Personal',
                    imageAsset: 'assets/images/icon-user.png',
                    backgroundColor: CustomColors.YellowBackground,
                    taskCount: '24',
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _navigateToCategory('Travel');
                  },
                  child: const BucketItemCategory(
                    title: 'Travel',
                    imageAsset: 'assets/images/icon-briefcase.png',
                    backgroundColor: CustomColors.GreenBackground,
                    taskCount: '44',
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _navigateToCategory('Skills');
                  },
                  child: const BucketItemCategory(
                    title: 'Skills',
                    imageAsset: 'assets/images/icon-presentation.png',
                    backgroundColor: CustomColors.PurpleBackground,
                    taskCount: '45',
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _navigateToCategory('Shopping');
                  },
                  child: const BucketItemCategory(
                    title: 'Shopping',
                    imageAsset: 'assets/images/icon-shopping-basket.png',
                    backgroundColor: CustomColors.OrangeBackground,
                    taskCount: '54',
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _navigateToCategory('Adventure');
                  },
                  child: const BucketItemCategory(
                    title: 'Adventure',
                    imageAsset: 'assets/images/icon-confetti.png',
                    backgroundColor: CustomColors.BlueBackground,
                    taskCount: '24',
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _navigateToCategory('Other');
                  },
                  child: const BucketItemCategory(
                    title: 'Other',
                    imageAsset: 'assets/images/icon-molecule.png',
                    backgroundColor: Color.fromRGBO(0, 0, 0, 0.1),
                    taskCount: '24',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: customFab(context),
      bottomNavigationBar:
          BottomNavigationBarApp(context, bottomNavigationBarIndex),
    );
  }

  Future<void> _logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(context, WelcomeScreen.id);
    } catch (e) {
      print('Error during logout: $e');
    }
  }

  void _navigateToCategory(String category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Category(cat: category),
      ),
    );
  }
}

class BucketItemCategory extends StatelessWidget {
  final String title;
  final String imageAsset;
  final Color backgroundColor;
  final String taskCount;

  const BucketItemCategory({
    super.key,
    required this.title,
    required this.imageAsset,
    required this.backgroundColor,
    required this.taskCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(20.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(255, 225, 225, 225),
            blurRadius: 10.0,
            spreadRadius: 5.0,
            offset: Offset(0.0, 0.0),
          ),
        ],
        color: Colors.white,
      ),
      margin: const EdgeInsets.all(10),
      height: 150.0,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 65,
              height: 65,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: const BorderRadius.all(
                  Radius.circular(50.0),
                ),
              ),
              child: Image.asset(imageAsset),
            ),
            const SizedBox(height: 5),
            Text(
              title,
              style: const TextStyle(
                fontSize: 17,
                color: CustomColors.TextHeaderGrey,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '$taskCount Tasks',
              style: const TextStyle(
                fontSize: 9,
                color: CustomColors.TextSubHeaderGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
