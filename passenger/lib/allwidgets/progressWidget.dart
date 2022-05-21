import 'package:flutter/material.dart';

// ignore: must_be_immutable
class progressBar extends StatefulWidget {
  String message;
  progressBar(this.message);

  @override
  State<progressBar> createState() => _progressBarState();
}

class _progressBarState extends State<progressBar> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.black,
      child: Container(
        margin: EdgeInsets.all(15.0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 10, 7, 7),
          borderRadius: BorderRadius.circular(6.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            children: [
              SizedBox(
                width: 6.0,
              ),
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
              SizedBox(width: 26.0),
              Expanded(
                child: Text(
                  widget.message,
                  style: TextStyle(color: Colors.white),
                  overflow: TextOverflow.ellipsis,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
