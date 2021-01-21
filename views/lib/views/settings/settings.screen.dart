import 'package:comies/services/settings.service.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  final service = new SettingsService();

  SettingsScreen({Key key}) : super(key: key);

  @override
  Settings createState() => Settings();
}

class Settings extends State<SettingsScreen> {
  String serverURL = "";

  @override
  void initState() {
    widget.service
        .getSetting<String>('url')
        .then((value) => setState(() => serverURL = value));
    super.initState();
  }

  PreferredSizeWidget appBar() {
    return AppBar(
      title: Text('Ajustes'),
      elevation: 8,
    );
  }

  Container serverURLForm() {
    TextEditingController controller = TextEditingController(text: serverURL);
    return Container(
      padding: EdgeInsets.only(right: 20, left: 70, bottom: 20),
      child: TextFormField(
        controller: controller,
        onFieldSubmitted: (value) => widget.service.addSetting('url', value),
        keyboardType: TextInputType.url,
        decoration: InputDecoration(
          labelText: "URL de acesso",
          suffix: IconButton(
              icon: Icon(Icons.check),
              onPressed: () =>
                  widget.service.addSetting('url', controller.text)),
        ),
        maxLines: 1,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                ListBody(
                  children: [
                    SettingTile(
                      title: 'URL de acesso',
                      subtitle: "O endereço do servidor local",
                      prefixIcon: Icon(Icons.link),
                      children: [serverURLForm()],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SettingTile extends StatefulWidget {
  final Icon prefixIcon;
  final Widget suffix;
  final String title;
  final String subtitle;
  final Function onTap;
  final List<Widget> children;

  SettingTile(
      {Key key,
      this.prefixIcon,
      this.suffix,
      this.title,
      this.subtitle,
      this.onTap,
      this.children})
      : super(key: key);

  @override
  Setting createState() => Setting();
}

class Setting extends State<SettingTile> {
  ListTile listTile() {
    return ListTile(
      leading: widget.prefixIcon,
      trailing: widget.suffix,
      title: Text(widget.title),
      subtitle: widget.subtitle != null ? Text(widget.subtitle) : null,
      onTap: widget.onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [];
    widgets.add(listTile());
    if (widget.children != null) {
      widget.children.forEach((ch) => widgets.add(ch));
    }
    widgets.add(Divider(thickness: 1.2, height: 1.2));
    return Container(
      child: Column(
        children: widgets,
      ),
    );
  }
}
