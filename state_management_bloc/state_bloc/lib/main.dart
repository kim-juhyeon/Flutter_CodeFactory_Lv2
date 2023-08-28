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
      body: BlocConsumer<CounterCubit, CounterState>(
        // BlocConsumer는 Listener와 build를 제공해줍니다.
        //buildcallback을 이용할때 쓰면 좋음
        // blocbuild을 이용하게 되면 동작이 여러가지일경우에는 오류가 발생합니다. 이유는 state를 계속 읽어들이고 있지 않기 때문입니다.
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
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              context.read<CounterCubit>().increment();
            },
            child: Icon(Icons.add),
            heroTag: 'increment',
          ),
          SizedBox(
            width: 10.0,
          ),
          FloatingActionButton(
            onPressed: () {
              context.read<CounterCubit>().decrement();
            },
            child: Icon(Icons.remove),
            heroTag: 'derement',
          )
        ],
      ),
    );
  }
}
