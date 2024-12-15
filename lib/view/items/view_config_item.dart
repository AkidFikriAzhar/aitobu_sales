import 'package:aitobu_sales/component/caption_title.dart';
import 'package:aitobu_sales/controller/controller_add_items.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ViewConfigItem extends StatefulWidget {
  const ViewConfigItem({super.key});

  @override
  State<ViewConfigItem> createState() => _ViewConfigItemState();
}

class _ViewConfigItemState extends State<ViewConfigItem> {
  final _controllerAddItem = ControllerConfigItems();
  int _selectedColor = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          _controllerAddItem.priceFocus.unfocus();
          _controllerAddItem.nameFocus.unfocus();
          if (_controllerAddItem.frmKey.currentState!.validate()) {
            // ScaffoldMessenger.of(context).showSnackBar(
            //   const SnackBar(content: Text('Processing Data')),
            // );
            final bool? isSubmit = await showDialog<bool>(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    icon: const Icon(Icons.save),
                    title: const Text('Save Product'),
                    content: const Text('Make sure your product information are correct'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          context.pop(false);
                        },
                        child: const Text('Cancel'),
                      ),
                      FilledButton(
                        onPressed: () {
                          context.pop(true);
                        },
                        child: const Text('Save'),
                      ),
                    ],
                  );
                });
            if (context.mounted) {
              if (isSubmit == true) {
                await _controllerAddItem.submitToFirebase(_controllerAddItem.posColor[_selectedColor], context);
              }
            }
          }
        },
        heroTag: 'item',
        label: const Text('Save'),
        icon: const Icon(Icons.save),
      ),
      appBar: AppBar(
        title: const Text('Add Items'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Form(
          key: _controllerAddItem.frmKey,
          child: ListView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            children: [
              const SizedBox(height: 30),
              const Align(
                alignment: Alignment.centerLeft,
                child: CaptionTitle(title: 'Product Information'),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _controllerAddItem.inputName,
                focusNode: _controllerAddItem.nameFocus,
                keyboardType: TextInputType.name,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter product name!';
                  }
                  return null;
                },
                decoration: const InputDecoration(labelText: 'Name', hintText: 'Tobu'),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _controllerAddItem.inputPrice,
                focusNode: _controllerAddItem.priceFocus,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter product price!';
                  }
                  return null;
                },
                decoration: const InputDecoration(labelText: 'Price (RM)', hintText: '10'),
              ),
              const SizedBox(height: 30),
              const Align(
                alignment: Alignment.centerLeft,
                child: CaptionTitle(title: 'Representation on POS'),
              ),
              const SizedBox(height: 20),
              Wrap(
                runAlignment: WrapAlignment.center,
                alignment: WrapAlignment.center,
                spacing: 10,
                runSpacing: 10,
                children: List.generate(_controllerAddItem.posColor.length, (index) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        _selectedColor = index;
                      });
                    },
                    child: AnimatedContainer(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                          color: _selectedColor == index ? _controllerAddItem.posColor[index].withAlpha(-100) : _controllerAddItem.posColor[index],
                          borderRadius: BorderRadius.circular(_selectedColor == index ? 15 : 0)),
                      duration: const Duration(milliseconds: 200),
                      child: _selectedColor == index ? const Icon(Icons.done) : const SizedBox(),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
