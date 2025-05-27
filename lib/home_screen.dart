import 'package:flutter/material.dart';
import 'package:sqflight_app/db_handler.dart';
import 'package:sqflight_app/notes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DBHandler? dbHandler;
  late Future<List<NotesModel>> notesModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dbHandler = DBHandler();
    loadData();
  }

  loadData()async{
    notesModel = dbHandler!.getNotesList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes SQL'),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: Column(
        children: [
         FutureBuilder(
             future: notesModel,
             builder: (context,AsyncSnapshot<List<NotesModel>> snapshot){

               if(snapshot.hasData){
                 return Expanded(
                   child: ListView.builder(
                       reverse: false,
                       shrinkWrap: true,
                       itemCount: snapshot.data!.length,
                       itemBuilder: (context,index){
                         return Dismissible(
                           direction: DismissDirection.endToStart,
                           background: Container(
                             color: Colors.red,
                             child: Icon(Icons.delete_forever),
                           ),
                           onDismissed: (DismissDirection direction){
                             setState(() {
                               dbHandler!.delete(snapshot.data![index].id!);
                               notesModel = dbHandler!.getNotesList();
                               snapshot.data!.remove(snapshot.data![index]);
                             });
                           },
                           key: ValueKey<int>(snapshot.data![index].id!),
                           child: Card(
                             child: ListTile(
                               title: Text(snapshot.data![index].title.toString()),
                               subtitle: Text(snapshot.data![index].description.toString()),
                               trailing: Text(snapshot.data![index].age.toString()),
                             ),
                           ),
                         );
                       }
                   ),
                 );
               }else{
                 return CircularProgressIndicator();
               }

             }
         )
        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: (){
            dbHandler!.insert(
              NotesModel(
                  title: 'Notes',
                  age: 22,
                  description: 'THIS IS MY FIRST APP',
                  email: 'walker0101walker@gmail.com',
              )).then((value){
                print('data Added');
                setState(() {
                  notesModel = dbHandler!.getNotesList();
                });
            }).onError((error,stackTrace){
              print(error.toString());
            });
            // try{
            //  await dbHandler!.insert(
            //       NotesModel(
            //           title: 'HELLO',
            //           age: 22,
            //           description: 'THIS IS MY FIRST APP NOTE',
            //           email: 'walker0101walker@gmail.com',
            //       ));
            //  print('DATA ADDED');
            // }catch(error){
            //   print('$error');
            // }
          },
        child: Icon(Icons.add),
      ),
    );
    
  }
}
