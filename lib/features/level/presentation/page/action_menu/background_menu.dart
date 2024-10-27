import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/progress/action/entity_case_color.dart';
import '../../state_management/bloc/functions/bloc_functions.dart';
import '../../state_management/bloc/functions/state_functions.dart';
import 'drop_zone_menu.dart';

class BackgroundMenu extends StatelessWidget {
  final Size size;
  final VoidCallback outsideChildTap;
  final double halfWidth;
  final double deltaWidth;
  final double deltaHeight;
  final double halfHeight;

  final _red = Colors.red.withOpacity(0.12);
  final _blue = Colors.indigo.withOpacity(0.12);
  final _green = Colors.teal.withOpacity(0.12);
  final _grey = Colors.black54.withOpacity(0.12);


  BackgroundMenu({required this.size, required this.outsideChildTap, super.key})
      : halfHeight = size.height / 2,
        deltaWidth = size.width * 0.08,
        deltaHeight = size.height * 0.08,
        halfWidth = size.width / 2;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FunctionsBloc, FunctionsState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Stack(
          children: [
            GestureDetector(
              onTap: outsideChildTap,
              child: Container(color: Colors.black54.withOpacity(0.3), height: size.height, width: size.width, ),
            ),
            if (state is FunctionsStateMenuDraggingAction && state.mergeWithColor)
              Stack(children: [
                ... _splitColorsMerges(state),
                _splitColorsBackground(state) ],
              )
          ],
        );
      },
    );
  }

  Widget _redPart() => Positioned.fill(
    left: halfWidth + deltaWidth,
    bottom: halfHeight + deltaHeight,
    child: DropZoneMenu(caseColor: CaseColorEntity.red, child: Container(color: _red,),),
  );
  Widget _greenPart() => Positioned.fill(
    right: halfWidth + deltaWidth,
    bottom: halfHeight + deltaHeight,
    child: DropZoneMenu(caseColor: CaseColorEntity.green, child: Container(color: _green,)),
  );
  Widget _bluePart() => Positioned.fill(
    right: halfWidth + deltaWidth,
    // right: halfWidth + deltaHeight,
    top: halfHeight + deltaHeight,
    // top: halfHeight + deltaHeight,
    child: DropZoneMenu(caseColor: CaseColorEntity.blue, child: Container(color: _blue,)),
  );
  Widget _greyPart() => Positioned.fill(
    left: halfWidth + deltaWidth,
    top: halfHeight + deltaHeight,
    child: DropZoneMenu(caseColor: CaseColorEntity.grey, child: Container(color: _grey,)),
  );

  Widget _splitColorsBackground(FunctionsStateMenuDraggingAction state) {
    return Stack(
      children: [
        _greenPart(),
        _redPart(),
        _bluePart(),
        _greyPart(),
        if (state is FunctionStateMenuDraggingActionAboveDropZone ) switch(state.actionToMergeWith.color) {
          CaseColorEntity.red => _redPart(),
          CaseColorEntity.green => _greenPart(),
          CaseColorEntity.blue => _bluePart(),
          CaseColorEntity.grey => _greyPart(),
          _ => throw UnimplementedError(),
        }
      ],
    );
  }

  // transition between green(top left part) and blue(bottom left part)
  Widget _topLeftBotLeftColorMerge({bool? topLeftHL, bool? botLeftHL}) => Positioned.fill(
    left: 0,
    right: halfWidth,
    top: halfHeight - deltaHeight,
    bottom: halfHeight - deltaHeight,
    child: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            botLeftHL != null ? Colors.transparent : _green,
            topLeftHL != null ? Colors.transparent : _blue,
          ],
        ),
      ),
    ),
  );

  //transition between red(top right part) and grey(bottom right part)
  Widget _topRightBotRightColorMerge({bool? topRightHL, bool? botRightHL}) => Positioned.fill(
    left: halfWidth,
    top: halfHeight - deltaHeight,
    bottom: halfHeight - deltaHeight,
    child: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            botRightHL != null ? Colors.transparent : _red,
            topRightHL != null ? Colors.transparent : _grey,
          ],
        ),
      ),
    ),
  );

  //transition between green(top left) and red(top right part)
  Widget _topLeftTopRightColorMerge({bool? topLeftHL, bool? topRightHL}) => Positioned.fill(
    bottom: halfHeight,
    left: halfWidth - deltaWidth,
    right: halfWidth - deltaWidth,
    child: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            topRightHL != null ? Colors.transparent : _green,
            topLeftHL != null ? Colors.transparent : _red,
          ],
        ),
      ),
      // color: Colors.orange.withOpacity(0.2)
    ),
  );

  //transition between blue(bot left) and grey(bot right part)
  Widget _botLeftBotRightColorMerge({bool? botLeftHL, bool? botRightHL}) => Positioned.fill(
    top: halfHeight,
    left: halfWidth - deltaWidth,
    right: halfWidth - deltaWidth,
    child: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            botRightHL != null ? Colors.transparent : _blue,
            botLeftHL != null ? Colors.transparent : _grey,
          ],
        ),
      ),
      // color: Colors.orange.withOpacity(0.2)
    ),
  );

  List<Widget> _splitColorsMerges(FunctionsStateMenuDraggingAction state) {
    List<Widget> highlightedMerge = state is FunctionStateMenuDraggingActionAboveDropZone ? switch(state.actionToMergeWith.color) {
      CaseColorEntity.red => [
        _topLeftTopRightColorMerge(topRightHL: true),
        _topRightBotRightColorMerge(topRightHL: true),
      ],
      CaseColorEntity.blue => [
        _botLeftBotRightColorMerge(botLeftHL: true),
        _topLeftBotLeftColorMerge(botLeftHL: true),
      ],
      CaseColorEntity.green => [
        _topLeftBotLeftColorMerge(topLeftHL: true),
        _topLeftTopRightColorMerge(topLeftHL: true),
      ],
      CaseColorEntity.grey => [
        _topRightBotRightColorMerge(botRightHL: true),
        _botLeftBotRightColorMerge(botRightHL: true),
      ],
      _ => throw Exception('SplitBackgroundPopup._splitColorsMerges no widget for ${state.actionToMergeWith.color.name}'),
    } : [];

    return [
      _topLeftBotLeftColorMerge(),
      _topRightBotRightColorMerge(),
      _topLeftTopRightColorMerge(),
      _botLeftBotRightColorMerge(),
      ...highlightedMerge,
    ];
  }
}