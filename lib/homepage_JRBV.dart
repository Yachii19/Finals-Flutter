import 'package:flutter/material.dart';
import 'aboutus_JRBV.dart';
import 'projects_JRBV.dart';

class HomePage_JRBV extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home Page')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Image.asset('../assets/dota2.png', 
              width: 300,
              height: 300,
            
            ),
            SizedBox(height: 20),
            Text(
              'Welcome to Home Page!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AboutUsPage()),
                    );
                  },
                  child: Text('About Us'),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProjectsPage()),
                    );
                  },
                  child: Text('Projects'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}