import 'package:flutter/material.dart';

import '../../component/header.dart';

class AllReviewScreen extends StatefulWidget {
  const AllReviewScreen({Key? key}) : super(key: key);

  @override
  _AllReviewScreenState createState() => _AllReviewScreenState();
}

class _AllReviewScreenState extends State<AllReviewScreen> {
  List<String> rankingReviews = [
    '../assets/images/noImg.jpg', // Replace with your image URLs or asset paths
    '../assets/images/noImg.jpg',
  ];

  List<String> allReviews = [
    '../assets/images/noImg.jpg', // Replace with your image URLs or asset paths
    '../assets/images/noImg.jpg',
    '../assets/images/noImg.jpg', // Replace with your image URLs or asset paths
    '../assets/images/noImg.jpg',
    // Add more image URLs or asset paths
  ];

  final TextEditingController _searchController = TextEditingController();

  void _showImageModal(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.8,
            child: Column(
              children: [
                Image.network(imageUrl), // Replace with Image.asset if using local assets
                SizedBox(height: 10),
                Text("Frame 79413"),
                SizedBox(height: 10),
                Text("여름 휴가로 부산에 놀러 왔습니다. 재미지네요."),
                SizedBox(height: 10),
                Expanded(
                  child: ListView(
                    children: List.generate(100, (index) {
                      return ListTile(
                        title: Text('Comment $index'),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _onSearch() {
    // Implement your search functionality here
    print("Searching for: ${_searchController.text}");
    // For now, just print the search value. Replace this with your actual search logic.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: afterLoginHeader(
        automaticallyImplyLeading: false,
        context: context,
      ),
      body: Row(
        children: [
          // Left Column
          Expanded(
            flex: 1,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    child: Text('후기 작성하기'),
                  ),
                  SizedBox(height: 20),
                  Text('후기 콘테스트'),
                  SizedBox(height: 10),
                  Column(
                    children: rankingReviews.map((imageUrl) {
                      return GestureDetector(
                        onTap: () {
                          _showImageModal(context, imageUrl);
                        },
                        child: Image.network(imageUrl, fit: BoxFit.cover),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 20),
                  Text('주간 콘테스트'),
                  // Add more ranking reviews for weekly contest
                  SizedBox(height: 20),
                  Text('월간 콘테스트'),
                  // Add more ranking reviews for monthly contest
                  SizedBox(height: 20),
                  Text('시즌 콘테스트'),
                  // Add more ranking reviews for seasonal contest
                ],
              ),
            ),
          ),
          // Right Column
          Expanded(
            flex: 2,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Value',
                      suffixIcon: IconButton(
                        icon: Icon(Icons.search),
                        onPressed: _onSearch,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      childAspectRatio: 1,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                    ),
                    itemCount: allReviews.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          _showImageModal(context, allReviews[index]);
                        },
                        child: Image.network(allReviews[index], fit: BoxFit.cover),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
