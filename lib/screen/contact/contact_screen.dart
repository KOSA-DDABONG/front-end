// import 'package:flutter/material.dart';
//
// class ContactScreen extends StatefulWidget {
//   const ContactScreen({Key? key}) : super(key: key);
//
//   @override
//   _ContactScreenState createState() => _ContactScreenState();
// }
//
// class _ContactScreenState extends State<ContactScreen> {
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Text('컨텍트 페이지');
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../component/header.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({Key? key}) : super(key: key);

  @override
  _ContactScreenState createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: afterLoginHeader(
        automaticallyImplyLeading: false,
        context: context,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'CONTACT US',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ContactInfo(
                    city: 'Los Angeles',
                    address: '22 East 49th Street, New York, Los Angeles, CA 90001, USA',
                    phone: '+22 1234 5678 9813',
                    email: 'infoLA@designagency.com',
                  ),
                  ContactInfo(
                    city: 'San Francisco',
                    address: '22 East 49th Street, San Francisco, CA 94061, USA',
                    phone: '+22 1234 5678 9814',
                    email: 'infoSF@designagency.com',
                  ),
                  ContactInfo(
                    city: 'New York',
                    address: '22 East 49th Street, New York, NY 10016, USA',
                    phone: '+22 1234 5678 9815',
                    email: 'infoNY@designagency.com',
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Image.asset(
                '/mnt/data/스크린샷 2024-07-20 오후 11.33.50.png', // Update with your map image path
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'GET IN TOUCH.',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit laborum. Sed ut perspiciatis unde omnis.',
                style: TextStyle(fontSize: 16),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  ContactFormField(hintText: 'Name'),
                  ContactFormField(hintText: 'Email Address'),
                  ContactFormField(hintText: 'Approximate Budget'),
                  ContactFormField(hintText: 'Message', maxLines: 5),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text('SEND'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ContactInfo extends StatelessWidget {
  final String city;
  final String address;
  final String phone;
  final String email;

  const ContactInfo({
    Key? key,
    required this.city,
    required this.address,
    required this.phone,
    required this.email,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          city,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Text(address),
        SizedBox(height: 8),
        Text(phone),
        SizedBox(height: 8),
        Text(email, style: TextStyle(color: Colors.blue)),
      ],
    );
  }
}

class ContactFormField extends StatelessWidget {
  final String hintText;
  final int maxLines;

  const ContactFormField({
    Key? key,
    required this.hintText,
    this.maxLines = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}

