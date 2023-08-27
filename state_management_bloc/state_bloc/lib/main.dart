import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:state_bloc/cubits/cubit/counter_cubit.dart';
import 'package:state_bloc/other_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CounterCubit>(
      create: (context) => CounterCubit(),
      child: MaterialApp(
        title: 'Mycount cubit',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.blue,
        ),
        home: MyHomepage(),
      ),
    );
  }
}

class MyHomepage extends StatelessWidget {
  const MyHomepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<CounterCubit, CounterState>(
        listener: (context, state) {
          if (state.counter == 3) {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Text('counter is ${state.counter}'),
                );
              },
            );
          } else {
            if (state.counter == -1) {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return OtherPage();
              }));
            }
          }
        },
        child: BlocBuilder<CounterCubit, CounterState>(
          //제너릭에 부여할 함수 class를 기입합니다. 이후 state를 쉽게 접근이 가능함
          builder: (context, state) {
            return Center(
              child: Text(
                '${state.counter}',
                style: TextStyle(fontSize: 51.0),
              ),
            );
          },
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              BlocProvider.of<CounterCubit>(context).increment();
            },
            child: Icon(Icons.add),
            heroTag: 'increment',
          ),
          SizedBox(
            width: 10.0,
          ),
          FloatingActionButton(
            onPressed: () {
              BlocProvider.of<CounterCubit>(context).decrement();
            },
            child: Icon(Icons.remove),
            heroTag: 'derement',
          )
        ],
      ),
    );
  }
}
