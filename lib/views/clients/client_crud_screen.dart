import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pos/controllers/clients/clients_controller.dart';
import 'package:flutter_pos/models/client.dart';
import 'package:flutter_pos/utils/const.dart';
import 'package:flutter_pos/widgets/buttons/custom_elevated_button.dart';
import 'package:flutter_pos/widgets/custom_text_field.dart';
import 'package:form_validator/form_validator.dart';
import 'package:get/get.dart';

class ClientCrudScreen extends StatefulWidget {
  final Client? client;
  const ClientCrudScreen({this.client, super.key});

  @override
  State<ClientCrudScreen> createState() => _ClientCrudScreenState();
}

class _ClientCrudScreenState extends State<ClientCrudScreen> {
  final ClientController _clientController = Get.find();
  TextEditingController? clientNameController;
  TextEditingController? clientEmailController;
  TextEditingController? clientAddressController;
  TextEditingController? clientPhoneController;
  var formKey = GlobalKey<FormState>();
  @override
  void initState() {
    clientNameController =
        TextEditingController(text: widget.client?.clientName ?? '');
    clientEmailController =
        TextEditingController(text: widget.client?.clientEmail ?? '');
    clientAddressController =
        TextEditingController(text: widget.client?.clientAddress ?? '');
    clientPhoneController =
        TextEditingController(text: widget.client?.clientPhone ?? '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        title: Text(
          widget.client == null ? 'New Client' : 'Edit Client',
          style: const TextStyle(
            color: primaryUltraLightColor,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 30),
              SizedBox(
                child: Form(
                  key: formKey,
                  child: Wrap(
                    runSpacing: 20,
                    children: [
                      CustomTextField(
                          labelText: 'Name',
                          controller: clientNameController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Name is required';
                            }
                            return null;
                          }),
                      CustomTextField(
                          labelText: 'Phone',
                          controller: clientPhoneController,
                          keyboardType: TextInputType.phone,
                          validator: ValidationBuilder().phone().build()),
                      CustomTextField(
                          labelText: 'Email',
                          controller: clientEmailController,
                          validator: ValidationBuilder().email().build()),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                                labelText: 'Address',
                                controller: clientAddressController,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'address is required';
                                  }
                                  return null;
                                }),
                          ),
                        ],
                      ),
                      CustomElevatedButton(
                          label: widget.client == null ? 'Submit' : 'Edit',
                          onPressed: () async {
                            await onSubmit();
                          })
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> onSubmit() async {
    try {
      if (formKey.currentState!.validate()) {
        final client = Client.fromJson({
          'clientName': clientNameController?.text,
          'clientEmail': clientEmailController?.text,
          'clientPhone': clientPhoneController?.text,
          'clientAddress': clientAddressController?.text
        });
        if (widget.client == null) {
          // add client logic
          await _clientController.addClient(client);
        }
        //update client logic
        else {
          await _clientController.updateClient(client, widget.client?.clientId);

          //Navigator.pop(context, true);
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              widget.client == null
                  ? 'Client added Successfully'
                  : 'Client Updated Successfully',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        );
        Navigator.popAndPushNamed(context, '/clients');
        //  Navigator.popAndPushNamed(context, '/clients', result: true);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            'Exception on Editing or Updating Client: $e',
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );
      print('Exception Error In Adding Or Updating Client :: =>$e');
    }
  }
}
