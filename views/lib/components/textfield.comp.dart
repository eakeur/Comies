import 'package:comies/utils/declarations/environment.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TextFieldComponent extends StatefulWidget {

  final Widget icon;
  final String fieldName;
  final String helperName;
  final String value;
  final Function(String) onFieldChange;
  final TextInputType textInputType;

  TextFieldComponent({this.icon, this.fieldName, this.helperName, this.value, this.onFieldChange, this.textInputType = TextInputType.text});

  @override
  TextFieldComponentState createState() => TextFieldComponentState();
}

class TextFieldComponentState extends State<TextFieldComponent> {

  TextEditingController controller;

  @override
  Widget build(BuildContext context){
    controller = new TextEditingController(text: widget.value);
    controller.addListener((){widget.onFieldChange(controller.text);});
    return TextFormField(
      controller: controller,
      keyboardType: widget.textInputType,
      decoration: InputDecoration(
        border: UnderlineInputBorder(),
        labelText: widget.fieldName,
        suffixIcon: widget.icon 
      ),
    );
  }

  @override
  void dispose(){
    controller.dispose();
    super.dispose();
  }

  // @override
  // void didUpdateWidget(TextFieldComponent c){
  //   controller.removeListener((){widget.onFieldChange(controller.text);});
  //   controller.text = widget.value;
  //   controller.addListener((){widget.onFieldChange(controller.text);});
  //   super.didUpdateWidget(c);
  // }
}

class FormGroup extends StatefulWidget {
  final Map<int, Map<String, List<dynamic>>> build;
  final Widget title;
  FormGroup({this.title, this.build});
  @override
  _FormGroupState createState() => _FormGroupState();
}

class _FormGroupState extends State<FormGroup> {

  bool get isBigScreen => MediaQuery.of(context).size.width > widthDivisor - 150;

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          widget.title,
          for (var row in widget.build.keys) isBigScreen 
           ? Row(children: [
            for (var field in widget.build[row]['fields']) 
              Expanded(flex: widget.build[row]['spaces'][widget.build[row]['fields'].indexOf(field)??0] ?? 100,
              child: Container(child: field, margin: EdgeInsets.only(left: 5, right: 5, bottom: 5)),
            ),
          ])
          : Column(children: [
            for (var field in widget.build[row]['fields']) 
              Container(child: field, margin: EdgeInsets.only(left: 5, right: 5, bottom: 5))
          ])
        ]
      )
    );
  }
}

class SearchBarComponent extends StatefulWidget {

  final Function onSearchTap;
  final List<SearchFilter> filters;
  
  SearchBarComponent({this.onSearchTap, this.filters});
  
  @override
  SearchBarState createState() => SearchBarState();

}

class SearchBarState extends State<SearchBarComponent> {


  Map<String, TextEditingController> controllers = {};
  bool showFilters = false;


  TextFormField generateTextField(SearchFilter filter){
    if (controllers[filter.fieldName] == null) {
      controllers[filter.fieldName] = new TextEditingController(text: filter.initialValue);
      controllers[filter.fieldName].addListener(() { setState(() {}); filter.onFieldChange(controllers[filter.fieldName].text);});
    }
    return TextFormField(
      controller: controllers[filter.fieldName],
      onFieldSubmitted: (s) => widget.onSearchTap(),
      decoration: InputDecoration(
        border: UnderlineInputBorder(),
        prefixIcon: filter.icon == null ? null : Icon(filter.icon),
        labelText: filter.fieldName,
        filled: false,
        suffixIcon: controllers[filter.fieldName].text != "" 
          ? IconButton(onPressed: (){controllers[filter.fieldName].clear(); setState(() {});}, icon: Icon(Icons.close)) 
          : null 
      ),
    );
  }

  TextFormField generateMainTextField(){
    var params = widget.filters[0];
    if (controllers[params.fieldName] == null){
       controllers[params.fieldName] = new TextEditingController(text: params.initialValue);
        controllers[params.fieldName].addListener(() { setState(() {}); params.onFieldChange(controllers[params.fieldName].text);});
    }
    return TextFormField(
      controller: controllers[params.fieldName],
      onFieldSubmitted: (s) => widget.onSearchTap(),
      decoration: InputDecoration(
        border: UnderlineInputBorder(),
        filled: false,
        prefixIcon: params.icon == null ? null : Icon(params.icon),
        labelText: params.fieldName,
        suffixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (controllers[params.fieldName].text != "")IconButton(onPressed: (){controllers[params.fieldName].clear(); setState(() {});}, icon: Icon(Icons.close)),
            IconButton(icon: Icon(Icons.filter_alt), onPressed: widget.filters.length <= 1 ? null : () => setState(() => showFilters = !showFilters)),
            IconButton(icon: Icon(Icons.search), onPressed: widget.onSearchTap),
            
          ]
        ) 
      ),
    );
  }



  void clearFilters() => controllers.forEach((k, v) => v.clear());

  @override
  Widget build(BuildContext context){
    return Container(
      padding: EdgeInsets.all(5),
      child: !showFilters 
        ? generateMainTextField()
        : Column(
          children: [
            for(var filter in widget.filters) generateTextField(filter)
          ],
        )
    );
  }

  @override 
  void dispose(){controllers.forEach((k, v) => v.dispose()); super.dispose();}

}

class SearchFilter {
  IconData icon;
  String fieldName;
  String helperName;
  String initialValue;
  Function(String) onFieldChange;
  SearchFilter(this.icon, this.fieldName, this.onFieldChange, {this.helperName});
}