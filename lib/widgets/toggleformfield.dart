import 'package:birdseye/widgets/formfieldtitle.dart';
import 'package:flutter/material.dart';

class ToggleFormField extends FormField<bool> {
  ToggleFormField(
      {super.key,
      super.onSaved,
      super.initialValue = false,
      String labelText = ""})
      : super(
            builder: (FormFieldState<bool> state) => Material(
                elevation: 2,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4))),
                animationDuration: const Duration(milliseconds: 500),
                color: state.value!
                    ? Theme.of(state.context).colorScheme.secondaryContainer
                    : Theme.of(state.context).colorScheme.tertiaryContainer,
                textStyle: Theme.of(state.context).textTheme.labelLarge,
                child: InkWell(
                    onTap: () => state.didChange(!state.value!),
                    child: Stack(
                        alignment: Alignment.center,
                        fit: StackFit.passthrough,
                        children: [
                          Center(
                              child: Text(
                            Theme.of(state.context).brightness ==
                                    Brightness.light
                                ? (state.value! ? "Yes" : "No")
                                : state.value.toString(),
                            textScaleFactor:
                                MediaQuery.of(state.context).size.width < 750
                                    ? 1.7
                                    : 2,
                          )),
                          FormFieldTitle(labelText),
                        ]))));
}
