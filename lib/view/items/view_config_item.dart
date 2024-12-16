import 'package:aitobu_sales/component/caption_title.dart';
import 'package:aitobu_sales/controller/controller_config_items.dart';
import 'package:aitobu_sales/model/item.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ViewConfigItem extends StatefulWidget {
  final Item? currentItem;

  const ViewConfigItem({super.key, required this.currentItem});

  @override
  State<ViewConfigItem> createState() => _ViewConfigItemState();
}

class _ViewConfigItemState extends State<ViewConfigItem> {
  final _controllerAddItem = ControllerConfigItems();
  int _selectedColor = 0;

  @override
  void initState() {
    if (widget.currentItem != null) {
      _controllerAddItem.id = widget.currentItem!.id;
      _controllerAddItem.inputName.text = widget.currentItem!.name;
      _controllerAddItem.inputPrice.text = widget.currentItem!.price.toString();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          _controllerAddItem.priceFocus.unfocus();
          _controllerAddItem.nameFocus.unfocus();
          if (_controllerAddItem.frmKey.currentState!.validate()) {
            final bool? isSubmit = await showDialog<bool>(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    icon: Icon(widget.currentItem != null ? Icons.edit : Icons.save),
                    title: Text(widget.currentItem != null ? 'Edit Product' : 'Save Product'),
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
        label: Text(widget.currentItem != null ? 'Save Edit' : 'Save'),
        icon: Icon(widget.currentItem != null ? Icons.edit : Icons.save),
      ),
      appBar: AppBar(
        title: widget.currentItem != null ? const Text('Edit Items') : const Text('Add Items'),
        actions: [
          widget.currentItem == null
              ? const SizedBox()
              : IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.delete),
                )
        ],
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
                  return GestureDetector(
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
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}
