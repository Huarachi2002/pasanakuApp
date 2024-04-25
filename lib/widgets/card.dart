import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CustomCard extends StatefulWidget {
  final bool? state;
  final String? text;
  final String? ganador;
  final String? montoGanador;
  final int? montoPujado;
  bool? pujar;
  final Function(int) changedPujar;

  final int minValue;
  final int maxValue;
  final int initialValue;
  CustomCard({
    super.key, 
    this.state, 
    this.text,
    this.ganador,
    this.montoGanador,
    this.pujar,
    this.montoPujado,
    required this.minValue,
    required this.maxValue,
    required this.initialValue,
    required this.changedPujar
  });

  @override
  State<CustomCard> createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  int _currentValue = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _currentValue = widget.montoPujado!;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: (widget.state!) ? const Color(0xFF318CE7) : const Color(0xFFA3A8B7),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            Text(
            widget.text!,
            style: const TextStyle(
              color: Colors.white,
              decoration: TextDecoration.none,
              fontSize: 20
              ),
            ),
            const SizedBox(width: 10,),
            widget.pujar!
            ?
              widget.state!
              ?
                Row(
                  children: [
                    const SizedBox(width: 50,),
                    CupertinoButton.filled(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      borderRadius: BorderRadius.circular(10),
                      child: Text('$_currentValue Bs'), 
                      onPressed: () => showCupertinoModalPopup(
                        context: context,
                        builder: (_) => SizedBox(
                          width: double.infinity,
                          height: 250,
                          child: CupertinoPicker(
                            backgroundColor: Colors.white,
                            itemExtent: 30,
                            scrollController: FixedExtentScrollController(
                              initialItem: _currentValue-widget.minValue
                            ),
                            onSelectedItemChanged: (int value) {
                              setState(() {
                                _currentValue=value+widget.minValue;
                              });
                            },
                            children: 
                              List<Widget>.generate(widget.maxValue - widget.minValue+1, (int index) {
                                return Center(child: Text('${index+widget.minValue}'));
                              }
                            ),
                          ),
                        )
                      )
                    ),
                    const SizedBox(width: 45,),
                    ElevatedButton.icon(
                      onPressed: (){
                        setState(() {
                          widget.pujar = false;
                        });
                        widget.changedPujar(_currentValue);
                      }, 
                      icon: const Icon(Icons.monetization_on_rounded), 
                      label: const Text('Pujar')
                    )
                  ],
                )
              :
                Text(
                  widget.ganador == '' ? 'Puja no disponible': '${widget.ganador} (${widget.montoGanador} Bs)',
                  style: const TextStyle(
                    color: Colors.white,
                    // fontWeight: FontWeight.bold,
                    decoration: TextDecoration.none,
                    fontSize: 20
                  ),
                )
            :
              Text(
                  'Pujaste con $_currentValue Bs',
                  style: const TextStyle(
                    color: Colors.white,
                    // fontWeight: FontWeight.bold,
                    decoration: TextDecoration.none,
                    fontSize: 20
                  ),
                ),
          ]   
        ),
      ),
    );
  }
}
