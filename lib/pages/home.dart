import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/counter_model.dart';
import '../services/api_service.dart';
import "post_detail_page.dart";

class AboutPage extends StatelessWidget {
  const AboutPage({super.key, required this.isVisible});

  final bool isVisible;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('test'),
      ),
      body: Container(
        width: 100,
        height: 100,
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isVisible = true;
  int counter2 = 0;
  List<String> items = [];
  List<dynamic> posts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    try {
      final response =
          await APIService.instance.request('/posts', DioMethod.post);
      setState(() {
        posts = response.data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      //   HANDLING ERROR
      print('Error Fetching Data Posts: $e');
    }
  }

  void _addItem() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Add Item"),
            content: const Text('Do you want to add new item to the list?'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("Cancel")),
              TextButton(
                  onPressed: () {
                    setState(() {
                      items.add('Item ${items.length + 1}');
                    });
                    Navigator.of(context).pop();
                  },
                  child: const Text("Add"))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final counterModel = Provider.of<CounterModel>(context);

    return PopScope(
      onPopInvoked: (dit) {
        final shouldPop = showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Are you sure?'),
            content: const Text('Do you want to leave this page?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Yes'),
              ),
            ],
          ),
        );
        // return shouldPop ?? false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter 101'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Visibility(
                visible: isVisible,
                child: Container(
                  padding: const EdgeInsets.all(32.0),
                  margin: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: const Text(
                    'This text can be shown or hidden using Visibility',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      counterModel.increment();
                    },
                    child: Container(
                      width: 100,
                      height: 100,
                      color: Colors.red,
                      child: Center(
                        child: Text(
                          'Box 1\nTaps: ${counterModel.count}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      counterModel.decrement();
                    },
                    child: Container(
                      width: 100,
                      height: 100,
                      color: Colors.green,
                      child: Center(
                        child: Text(
                          'Box 2\nTaps: ${counterModel.count}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 100,
                    height: 100,
                    color: Colors.orange,
                    child: const Center(
                      child: Text(
                        'Box 3',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Recent Posts',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        itemCount: posts.length,
                        itemBuilder: (context, index) {
                          final post = posts[index];
                          return Card(
                            child: ListTile(
                              title: Text(
                                post['title'],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        PostDetailPage(post: post),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
              ),
              const SizedBox(height: 16),
              const Text(
                'List Items',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        title: Text(items[index]),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 64),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: [
                  SizedBox(
                    width: 110,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isVisible = !isVisible;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(
                        isVisible ? 'Hide Text' : 'Show Text',
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 130,
                    child: ElevatedButton(
                      onPressed: _addItem,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text(
                        'Add item to List',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 120,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/camera');
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text(
                        'Open Camera',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  // const AboutPage(isVisible: true)
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
