import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:bucketo/screens/home.dart';

class BucketDetailsPage extends StatefulWidget {
  final Map<String, dynamic> bucketItemDetails;

  const BucketDetailsPage({super.key, required this.bucketItemDetails});

  @override
  // ignore: library_private_types_in_public_api
  _BucketDetailsPageState createState() => _BucketDetailsPageState();
}

class _BucketDetailsPageState extends State<BucketDetailsPage> {
  late bool isDone;
  late bool isStarred;
  late bool isUpdated = false;

  @override
  void initState() {
    super.initState();
    isDone = widget.bucketItemDetails['isDone'];
    isStarred = widget.bucketItemDetails['isStarred'];
  }

  void updateTask(String documentId, bool isDone, bool isStarred) async {
    try {
      final CollectionReference tasks =
          FirebaseFirestore.instance.collection('tasks');

      // Assuming 'documentId' is the ID of the document you want to update
      DocumentReference documentReference = tasks.doc(documentId);

      // Update the document with new data
      await documentReference.update({
        'isStarred': isStarred,
        'isDone': isDone,
      });

      print('Document updated successfully');
    } catch (e) {
      print('Error updating document: $e');
    }
  }

  Future<void> _deleteTask(String documentId) async {
    try {
      bool confirmDelete = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Confirm Delete'),
            content: const Text('Are you sure you want to delete this task?'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: const Text('Delete'),
              ),
            ],
          );
        },
      );

      if (confirmDelete == true) {
        final CollectionReference tasks =
            FirebaseFirestore.instance.collection('tasks');

        await tasks.doc(documentId).delete();

        // ignore: use_build_context_synchronously
        Navigator.pushNamed(context, Home.id);
      }
    } catch (e) {
      print('Error deleting document: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Bucket List Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.bucketItemDetails['title'],
                    style: const TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'In your ${widget.bucketItemDetails['category']} List',
                    style: const TextStyle(fontSize: 16.0),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    widget.bucketItemDetails['description'],
                    style: const TextStyle(fontSize: 16.0),
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    'To be achieved by ${DateFormat('dd/MM/yy').format(widget.bucketItemDetails['date'].toDate())}',
                    style: const TextStyle(fontSize: 16.0),
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    'Link: ${widget.bucketItemDetails['link']}',
                    style: const TextStyle(fontSize: 16.0, color: Colors.blue),
                  ),
                  const SizedBox(height: 20.0),
                  widget.bucketItemDetails['imageURL'] != null
                      ? Image.network(
                          '${widget.bucketItemDetails['imageURL']}',
                          height: 200.0,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        )
                      : const SizedBox(height: 4.0),
                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          updateTask(widget.bucketItemDetails['Id'], !isDone,
                              isStarred);
                          setState(() {
                            isDone = !isDone;
                            isUpdated = true;
                          });
                        },
                        icon: Icon(
                          isDone
                              ? Icons.check_box
                              : Icons.check_box_outline_blank,
                          size: 30.0,
                        ),
                        label: const Text('Mark as Done'),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          updateTask(widget.bucketItemDetails['Id'], isDone,
                              !isStarred);
                          setState(() {
                            isStarred = !isStarred;
                            isUpdated = true;
                          });
                        },
                        icon: Icon(
                          isStarred ? Icons.star : Icons.star_outline,
                          size: 30.0,
                        ),
                        label: const Text('Star this Item'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Center(
              child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: isUpdated
                      ? ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, Home.id);
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.blue,
                          ),
                          child: const Text('Update'),
                        )
                      : ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Go Back'),
                        )),
            ),
            Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  onPressed: () async {
                    await _deleteTask(widget.bucketItemDetails['Id']);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[100],
                  ),
                  child: const Text('Delete Task'),
                ),
              ),
            ),
            const SizedBox(height: 50.0),
          ],
        ),
      ),
    );
  }
}
