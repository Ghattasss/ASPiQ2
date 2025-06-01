import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProgressBarCard extends StatefulWidget {
  final String title;
  final String description;
  final String endpoint;

  const ProgressBarCard({
    Key? key,
    required this.title,
    required this.description,
    required this.endpoint,
  }) : super(key: key);

  @override
  _ProgressBarCardState createState() => _ProgressBarCardState();
}

class _ProgressBarCardState extends State<ProgressBarCard> {
  double _progress = 0.0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProgress();
  }

  Future<void> _fetchProgress() async {
    try {
      final response = await http.get(Uri.parse(widget.endpoint));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _progress = (data['progress'] as num).toDouble() / 100.0;
          _isLoading = false;
        });
      } else {
        // Handle error or show a default state
        setState(() {
          _isLoading = false;
        });
        print('Failed to load progress: ${response.statusCode}');
      }
    } catch (e) {
      // Handle network or parsing errors
      setState(() {
        _isLoading = false;
      });
      print('Error fetching progress: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              widget.description,
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 16.0),
            _isLoading
                ? CircularProgressIndicator()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LinearProgressIndicator(
                        value: _progress,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).primaryColor),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        'اكتمل بنسبة ${(_progress * 100).toInt()}%',
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
