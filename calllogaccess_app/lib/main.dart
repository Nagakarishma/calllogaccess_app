import 'package:flutter/material.dart';
import 'package:call_log/call_log.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const CallLogApp());
}

class CallLogApp extends StatelessWidget {
  const CallLogApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Call Log App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color.fromARGB(255, 33, 117, 243),
      ),
      home: CallLogScreen(key: UniqueKey()), // Add a UniqueKey here
    );
  }
}

class CallLogScreen extends StatelessWidget {
  const CallLogScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Call Log Access',
          style: TextStyle(
            color: Color.fromARGB(255, 79, 175, 76),
            fontWeight: FontWeight.bold,
            fontSize: 21,
          ),
        ),
      ),
      body: FutureBuilder<Iterable<CallLogEntry>>(
        future: CallLog.get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                CallLogEntry entry = snapshot.data!.elementAt(index);

                DateTime? timestamp = entry.timestamp != null
                    ? DateTime.fromMillisecondsSinceEpoch(entry.timestamp!)
                    : null;

                String formattedDateTime = timestamp != null
                    ? DateFormat.yMd().add_Hms().format(timestamp)
                    : 'N/A';

                return Card(
                  child: ListTile(
                    leading:const Icon(Icons.call, color: Colors.blue),
                    title: Text(
                      '${entry.name ?? 'Unknown'}: ${entry.number}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      '$formattedDateTime | ${entry.duration} seconds',
                      style:const TextStyle(
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
