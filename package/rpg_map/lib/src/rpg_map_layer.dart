import 'package:xml/xml.dart';

abstract class RpgMapLayer {
  RpgMapLayer(this.group);

  final XmlElement group;
}
