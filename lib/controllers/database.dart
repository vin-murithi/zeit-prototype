import 'package:path_provider/path_provider.dart'; //provide App Data directory
import 'dart:io'; //Used by File class
import 'dart:convert'; //Used by json

class Database {
//Get local Path
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

//Create a reference of files location
  Future<File> get _localFile async {
    String fileName = 'zeit_json.json';
    final path = await _localPath;
    return File('$path/$fileName');
  }

//Write to file
  Future<File> writeDatabase(Map sessionData) async {
    final file = await _localFile;
    late String taskName;
    late List taskInfo;
    late List dbList;
    late Map dbData;

    //Get key and value from session data
    sessionData.forEach((key, value) {
      taskName = key;
      taskInfo = value;
      print(taskName);
      print(taskInfo[0].toString());
    });

    //Read database data
    var database = await readDatabase();
    if (database.containsKey(taskName)) {
      dbList = database[taskName];
      dbList.add(taskInfo[0]);
      database[taskName] = dbList;
      print('database value for $taskName is ${database[taskName]}');
    } else {
      database[taskName] = [taskInfo[0]];
      print('database value for $taskName is ${database[taskName]}');
    }

    // Write the file and return it
    return file.writeAsString(jsonEncode(database));
  }

//Read data from file
  Future<Map> readDatabase() async {
    try {
      final file = await _localFile;

      // Read the file
      final contents = await file.readAsString();

      return jsonDecode(contents);
    } catch (e) {
      // If encountering an error, return 0
      return {'No data': e};
    }
  }

//Delete File
  Future<int> deleteFile() async {
    try {
      final file = await _localFile;

      await file.delete().then((value) => {print(value)});
      return 1;
    } catch (e) {
      return 0;
    }
  }
}
