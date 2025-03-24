import 'package:flutter/material.dart';

import '../services/static_info.dart';

class FeedbackScreen extends StatelessWidget {
  final TextEditingController feedbackController = TextEditingController();
  final StaticInfoService feedbackService = StaticInfoService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enviar Retroalimentación'),
        backgroundColor: Color(0xFF83B56A),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: feedbackController,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: 'Tu comentario',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                String feedback = feedbackController.text;
                if (feedback.isNotEmpty) {
                  await feedbackService.sendFeedback(feedback);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Gracias por tu retroalimentación.'),
                  ));
                }
              },
              child: Text('Enviar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF83B56A),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
