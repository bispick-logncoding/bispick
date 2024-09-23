import 'package:bispick/enums/found_status.dart';
import 'package:bispick/lostitemCRUD/CRUD.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FoundStatusBox extends StatefulWidget {
  final bool isEditable;
  final FoundStatus status;
  final String id;

  FoundStatusBox({this.isEditable = false, required this.status, required this.id});

  @override
  _FoundStatusBoxState createState() => _FoundStatusBoxState();
}

class _FoundStatusBoxState extends State<FoundStatusBox> {
  late FoundStatus currentStatus;
  final CRUD crud = CRUD();
  @override
  void initState() {
    super.initState();
    currentStatus = widget.status;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 9),
      decoration: BoxDecoration(
          color: getBackgroundColor(currentStatus),
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: Colors.black,
            width: 1.5,
          )),
      child: widget.isEditable ? buildDropdown() : buildText(),
    );
  }

  Widget buildDropdown() {
    return SizedBox.expand(
        child: Center(
          child: DropdownButton<FoundStatus>(
            isExpanded: true,
            value: currentStatus,
            onChanged: (FoundStatus? newValue) {
              setState(() {
                if (newValue != null) {
                  currentStatus = newValue;
                  crud.updateFoundStatus(widget.id, newValue.value);
                }
              });
            },
            items: FoundStatus.values.map((FoundStatus status) {
              return DropdownMenuItem<FoundStatus>(
                value: status,
                child: Text(
                  status.value,
                  style: TextStyle(
                    color: Colors.black,
                    letterSpacing: -1,
                    fontSize: 12
                  ),
                ),
              );
            }).toList(),
            underline: Container(),
          ),
        )
    );
  }

  Widget buildText() {
    return Align(
      alignment: Alignment.center,
      child: Text(
        currentStatus.value,
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
        ),
      ),
    );
  }

  Color getBackgroundColor(FoundStatus status) {
    switch (status) {
      case FoundStatus.Pending:
        return Colors.grey;
      case FoundStatus.Approved:
        return Colors.green;
      case FoundStatus.Rejected:
        return Colors.red;
      default:
        return Colors.white;
    }
  }
}