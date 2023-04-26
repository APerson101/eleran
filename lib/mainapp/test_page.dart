import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TestPage extends ConsumerWidget {
  const TestPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Tax Identification Registration"),
      ),
      body: SizedBox.expand(
        child: SingleChildScrollView(
          child: Column(
            children: const [_PersonalInfoForm(), _BankInfoForm()],
          ),
        ),
      ),
    );
  }
}

class _PersonalInfoForm extends ConsumerWidget {
  const _PersonalInfoForm();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: const [
        Text("Personal Information"),
        SizedBox(
          height: 150,
          child: Placeholder(),
        )
      ],
    );
  }
}

class _BankInfoForm extends ConsumerWidget {
  const _BankInfoForm();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            children: const [
              Expanded(
                  child: Divider(
                color: Colors.red,
              )),
              Expanded(child: Text("Bank Information")),
              Expanded(child: Divider(color: Colors.red)),
            ],
          ),
          TextFormField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                labelText: 'Enter Account Number',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30))),
          ),
          const SizedBox(
            height: 150,
            child: Placeholder(),
          )
        ],
      ),
    );
  }
}
