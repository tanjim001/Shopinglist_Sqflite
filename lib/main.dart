import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sqlcrud/database.dart';
import 'package:sqlcrud/model.dart';
import 'package:sqlcrud/readalldata.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        canvasColor: Colors.cyan[600],
        brightness: Brightness.dark,
        primaryColor: Colors.lightBlue[800],
      ),
      home: const MyHompage(),
    );
  }
}

class MyHompage extends StatefulWidget {
  const MyHompage({super.key});

  @override
  State<MyHompage> createState() => _MyHompageState();
}

class _MyHompageState extends State<MyHompage> {
  late String name;
  late String description;
  double? price;

  getname(name) {
    this.name = name;
    if (kDebugMode) {
      print(this.name);
    }
  }

  getdiscription(description) {
    this.description = description;
    if (kDebugMode) {
      print(description);
    }
  }

  getprice(price) {
    try {
      this.price = double.parse(price);
      if (kDebugMode) {
        print(price);
      }
    } catch (e) {
      // Handle parsing error
      if (kDebugMode) {
        print("Error parsing price: $e");
      }
    }
  }

  createdata() {
    var dbhelper = DataClass();
    var model = Crudmodel(name: name, description: description, price: price);
    dbhelper.create(model);
    if (kDebugMode) {
      print("created");
    }
    setState(() {});
  }

  readdata() {
    var dbhelper = DataClass();
    Future<Crudmodel?> model = dbhelper.read(name);
    model.then((value) {
      if (value != null) {
        if (kDebugMode) {
          print("Read");
          print(value.price);
        }
      }
    });
  }

  updatedata() {
    var dbhelper = DataClass();
    var model = Crudmodel(name: name, description: description, price: price);
    dbhelper.update(model);
    setState(() {});
  }

  Future<ReadAllResult> getdata() async {
    var dbhelper = DataClass();
    Future<ReadAllResult> db = dbhelper.readAll();
    return db;
  }

  deletedata(String name) {
    var dbhelper = DataClass();
    dbhelper.delete(name);
    setState(() {});
  }

  Stream<ReadAllResult> getDataStream() async* {
    while (true) {
      // Fetch data from the database and yield it
      yield await getdata();
      // Add a delay before fetching data again
      await Future.delayed(
          const Duration(seconds: 1)); // Adjust the delay as needed
    }
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  Future init() async {
    await DataClass().initdb();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        top: false,
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Shopping List"),
            centerTitle: true,
            backgroundColor: Colors.cyan[800],
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      children: [
                        TextField(
                          decoration: const InputDecoration(hintText: "Name"),
                          onChanged: (name) {
                            getname(name);
                            print(name);
                          },
                        ),
                        TextField(
                          decoration:
                              const InputDecoration(hintText: "description"),
                          onChanged: (description) {
                            getdiscription(description);
                            if (kDebugMode) {
                              print(description);
                            }
                          },
                        ),
                        TextField(
                          decoration: const InputDecoration(hintText: "price"),
                          onChanged: (price) {
                            getprice(price);
                            if (kDebugMode) {
                              print(price);
                            }
                          },
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green),
                                onPressed: () {
                                  createdata();
                                },
                                child: const Text("create",
                                    style: TextStyle(color: Colors.white))),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orange),
                                onPressed: () {
                                  updatedata();
                                },
                                child: const Text(
                                  "Update",
                                  style: TextStyle(color: Colors.white),
                                ))
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10,),
                  Column(
                    children: [
                      StreamBuilder<Object>(
                          stream: getDataStream(),
                          builder: (context, snapshot) {
                            return FutureBuilder(
                                future: getdata(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return Column(
                                      children: [
                                        Card(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                const Text(
                                                  "Total Price",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20),
                                                ),
                                                Text(
                                                    snapshot.data!.total
                                                        .toString(),
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 20))
                                              ],
                                            ),
                                          ),
                                        ),
                                        //i want to this part scrollable
                                        Column(
                                          children: [
                                            ListView.builder(
                                                itemCount:(snapshot.data!.data.length<=5)?snapshot.data!.data.length:5,
                                                shrinkWrap: true,
                                                itemBuilder:
                                                    (context, index) {
                                                  return Card(
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets
                                                              .only(
                                                              top: 15,
                                                              left: 20,
                                                              right: 25),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                snapshot
                                                                    .data!
                                                                    .data[
                                                                        index]
                                                                    .name!,
                                                                style:
                                                                    const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize:
                                                                      20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                              Text(
                                                                  snapshot
                                                                      .data!
                                                                      .data[
                                                                          index]
                                                                      .description!,
                                                                  style: const TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          14))
                                                            ],
                                                          ),
                                                          Column(
                                                            children: [
                                                              Text("Price: ${snapshot.data!.data[index].price!}"
                                                                  .toString()),
                                                              IconButton(
                                                                  onPressed: () => deletedata(snapshot
                                                                      .data!
                                                                      .data[
                                                                          index]
                                                                      .name!),
                                                                  icon:
                                                                      const Icon(
                                                                    Icons
                                                                        .delete,
                                                                    size: 20,
                                                                  ))
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                }),
                                          ],
                                        )
                                      ],
                                    );
                                  } else {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                });
                          }),
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
