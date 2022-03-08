import 'package:flutter/material.dart';
import 'package:hamosad_scouting_app/misc/data_container.dart';
import 'package:hamosad_scouting_app/pages/pages.dart';

class OptionsSlider extends StatefulWidget {
  final double min, max;
  final double intervals;
  final String title;
  final String? leftTitle, rightTitle;
  final DataContainer<double> valueData;

  const OptionsSlider({
    Key? key,
    required this.title,
    required DataContainer<double> container,
    this.min = 0,
    this.max = 1,
    this.intervals = 1,
    this.leftTitle,
    this.rightTitle,
  })  : valueData = container,
        super(key: key);

  @override
  _OptionsSliderState createState() => _OptionsSliderState();
}

class _OptionsSliderState extends State<OptionsSlider> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          widget.title,
          style: AppFont(size: 22.5).getFont(),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Slider(
            label:
                widget.valueData.value == widget.valueData.value.roundToDouble()
                    ? widget.valueData.value.round().toString()
                    : widget.valueData.value.toString(),
            value: widget.valueData.value,
            min: widget.min,
            max: widget.max,
            divisions: (widget.max - widget.min) ~/ widget.intervals,
            onChanged: (newValue) =>
                setState(() => widget.valueData.value = newValue),
          ),
        ),
        widget.rightTitle != null || widget.leftTitle != null
            ? Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                if (widget.leftTitle != null)
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text(widget.leftTitle!,
                          style: AppFont(size: 20).getFont()))
                else
                  Container(),
                const SizedBox(
                  width: 125,
                ),
                if (widget.rightTitle != null)
                  Align(
                      alignment: Alignment.centerRight,
                      child: Text(widget.rightTitle!,
                          style: AppFont(size: 20).getFont()))
                else
                  Container(),
              ])
            : Container(),
      ],
    );
  }
}
