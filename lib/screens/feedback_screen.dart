import 'package:flutter/material.dart';
import '../services/static_info.dart';

class FeedbackScreen extends StatefulWidget {
  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final TextEditingController feedbackController = TextEditingController();
  final StaticInfoService feedbackService = StaticInfoService();
  bool isLoading = false; // Para mostrar un indicador de carga

  Future<void> _sendFeedback() async {
    final String feedback = feedbackController.text.trim();

    if (feedback.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, ingresa un mensaje válido.')),
      );
      return;
    }

    setState(() => isLoading = true); // Inicia el estado de carga

    try {
      await feedbackService.sendFeedback(feedback);
      feedbackController.clear(); // Limpiar el campo tras enviar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gracias por tu retroalimentación.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Error al enviar la retroalimentación. Inténtalo nuevamente.')),
      );
    } finally {
      setState(() => isLoading = false); // Finaliza el estado de carga
    }
  }

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
            isLoading
                ? Center(
                    child: CircularProgressIndicator()) // Indicador de carga
                : ElevatedButton(
                    onPressed: _sendFeedback,
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
