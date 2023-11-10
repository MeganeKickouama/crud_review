import 'package:crud_review/DatabaseHelper.dart';
import 'package:flutter/material.dart';
import 'DatabaseHelper.dart';
import 'package:crud_review/User.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List<Map<String, dynamic>> _users = [];

  TextEditingController _fnameController = TextEditingController();
  TextEditingController _lnameController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  void loadUsers() async
  {
    final data = await DatabaseHelper.fetchUsers();
    setState( ()
    {
      _users = data;
    });
  }

  @override
  void initState()
  {
    super.initState();
    loadUsers();
    print('number of items: ${_users.length}');
    //print(DatabaseHelper.fetchUsers());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: ()
        => showDialog(
            context: context,
            builder: (context)
          => AlertDialog(
            title: Text('Add a user'),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  TextField(
                    controller: _fnameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'First Name *',
                    ),
                  ),
                  SizedBox(height: 10,),
                  TextField(
                    controller: _lnameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Last Name *',
                    ),
                  ),
                  SizedBox(height: 10,),
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Username *',
                    ),
                  ),
                  SizedBox(height: 10,),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password *',
                    ),
                  ),
                  ElevatedButton(
                      onPressed: ()
                      {
                        var fname = _fnameController.text;
                        var lname = _lnameController.text;
                        var user = _usernameController.text;
                        var pass = _passwordController.text;

                        if (fname != "" && lname != "" &&
                        user != "" && pass != "")
                        {
                            User temp = User(fname: fname, lname: lname, username: user, password: pass);
                            DatabaseHelper.registerUser(temp);
                            Navigator.of(context, rootNavigator: true).pop();
                            loadUsers();
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('New User Added!')));
                            print('number of items: ${_users.length}');
                            _fnameController.clear();
                            _lnameController.clear();
                            _usernameController.clear();
                            _passwordController.clear();
                        }
                        else
                        {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please Fill Every Field')));
                        }
                      },
                      child: Text('Add')),
                ],
              ),
            ),
          ),
        ),
      ),
      appBar: AppBar(title: Text('Users Database'),),
      body: Container(
        child: ListView.builder(
          itemCount: _users.length,
          itemBuilder: (context, index)
          => Card(
            //margin: EdgeInsets.all(15),
            child: ListTile(
              leading: Container(
                alignment: Alignment.center,
                child: Text(_users[index]['id'].toString(), style: TextStyle(color: Colors.white),),
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(20)),
                height: 30,
                width: 30,
              ),
              title: Text(_users[index]['username']),
              subtitle: Text(_users[index]['fname'] + " " + _users[index]['lname']),
              trailing:
              SizedBox(
                width: 100,
                child: Row(
                  children: [
                    IconButton(onPressed: () async
                    {
                      _fnameController.text = _users[index]['fname'];
                      _lnameController.text = _users[index]['lname'];
                      _usernameController.text = _users[index]['username'];
                      _passwordController.text = _users[index]['password'];

                      showDialog(
                        context: context,
                        builder: (context)
                        => AlertDialog(
                          title: Text('Add a user'),
                          content: SingleChildScrollView(
                            child: ListBody(
                              children: [
                                TextField(
                                  controller: _fnameController,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'First Name *',
                                  ),
                                ),
                                SizedBox(height: 10,),
                                TextField(
                                  controller: _lnameController,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Last Name *',
                                  ),
                                ),
                                SizedBox(height: 10,),
                                TextField(
                                  controller: _usernameController,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Username *',
                                  ),
                                ),
                                SizedBox(height: 10,),
                                TextField(
                                  controller: _passwordController,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Password *',
                                  ),
                                ),
                                ElevatedButton(
                                    onPressed: ()
                                    {
                                      var fname = _fnameController.text;
                                      var lname = _lnameController.text;
                                      var user = _usernameController.text;
                                      var pass = _passwordController.text;

                                      if (fname != "" && lname != "" &&
                                          user != "" && pass != "")
                                      {
                                        DatabaseHelper.updateUser(_users[index]['id'], fname, lname, user, pass);
                                        Navigator.of(context, rootNavigator: true).pop();
                                        loadUsers();
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User Successfully Updated!')));
                                        print('number of items: ${_users.length}');
                                        _fnameController.clear();
                                        _lnameController.clear();
                                        _usernameController.clear();
                                        _passwordController.clear();
                                      }
                                      else
                                      {
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please Fill Every Field')));
                                      }
                                    },
                                    child: Text('Update')),
                              ],
                            ),
                          ),
                        ),
                      );
                    }, icon: Icon(Icons.edit)),
                    IconButton(
                        onPressed: () async
                        {
                          await DatabaseHelper.deleteUser(_users[index]['id'], context);
                          _users.remove(_users[index]);
                          loadUsers();
                        },
                        icon: Icon(Icons.delete)
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

