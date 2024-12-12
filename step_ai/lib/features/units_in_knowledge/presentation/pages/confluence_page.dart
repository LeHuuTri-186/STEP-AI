import 'package:flutter/material.dart';
import 'package:step_ai/config/constants.dart';

class ConfluencePage extends StatelessWidget {
  const ConfluencePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Local Files'),
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.75,
          height: MediaQuery.of(context).size.height * 0.5,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(Constant.confluenceImagePath,
                      width: 50, height: 50),
                  const SizedBox(width: 10),
                  const Text('Local Files'),
                ],
              ),
              const SizedBox(height: 4),
              const Divider(),
              const SizedBox(height: 10),
              Container(
                height: MediaQuery.of(context).size.height * 0.25,
                width: MediaQuery.of(context).size.width * 0.6,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    style: BorderStyle.solid,
                    color: Colors.grey,
                    width: 1.0,
                  ),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.cloud_upload,
                      size: 50,
                      color: Colors.blue,
                    ),
                    SizedBox(height: 10),
                    Text("Click here to upload files",
                        style: TextStyle(color: Colors.blue)),
                    SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Support for a single or bulk. Strictly prohibit from uploading company data or other band files",
                        style: TextStyle(color: Colors.grey, fontSize: 10),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Connect',
                    style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
