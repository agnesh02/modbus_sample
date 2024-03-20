// ignore_for_file: avoid_print

import 'dart:typed_data';

import 'package:crclib/catalog.dart';

class AkModbusPacket {
  AkModbusPacket({
    required this.slaveAddress,
    required this.fnCode,
    required this.registerAddress,
    required this.quantity,
    required this.byteCount,
    required this.dataFrame,
    required this.crcChecksum,
  });

  int slaveAddress = 0x00;
  int fnCode = 0x00;
  List<int> registerAddress = [];
  List<int> quantity = [];
  int byteCount = 0;
  List<int> dataFrame = [];
  List<int> crcChecksum = [];

  void printAllProperties() {
    print('-----------------DETAILS-------------------');
    print(
      'Slave Address: $slaveAddress  | 0x${slaveAddress.toRadixString(16)}',
    );
    print(
      'Function Code: $fnCode | 0x${fnCode.toRadixString(16)}',
    );
    print(
      'Register Address: $registerAddress | ${registerAddress.map((e) => "0x${e.toRadixString(16)}").toList()}',
    );
    if (quantity.isNotEmpty) {
      print(
        'Quantity: $quantity | ${quantity.map((e) => "0x${e.toRadixString(16)}").toList()}',
      );
    }
    if (byteCount != 0) {
      print(
        'Byte count: $byteCount |  0x${byteCount.toRadixString(16)}',
      );
    }
    print(
      'Data Frame: $dataFrame | ${dataFrame.map((e) => "0x${e.toRadixString(16)}").toList()}',
    );
    print(
        'CRC Checksum: $crcChecksum | ${crcChecksum.map((e) => "0x${e.toRadixString(16)}").toList()}');
    print('-------------------------------------------------');
  }

  List<int> getPacket() {
    List<int> packet = [];
    packet.add(slaveAddress);
    packet.add(fnCode);
    packet.addAll(registerAddress);
    if (quantity.isNotEmpty) {
      packet.addAll(quantity);
    }
    if (byteCount != 0) {
      packet.add(byteCount);
    }
    packet.addAll(dataFrame);
    packet.addAll(crcChecksum);
    return packet;
  }

  List<int> getPduWithSlaveAddress() {
    List<int> pduWithSlaveAddress = [];
    pduWithSlaveAddress.add(slaveAddress);
    pduWithSlaveAddress.add(fnCode);
    pduWithSlaveAddress.addAll(registerAddress);
    if (quantity.isNotEmpty) {
      pduWithSlaveAddress.addAll(quantity);
    }
    if (byteCount != 0) {
      pduWithSlaveAddress.add(byteCount);
    }
    pduWithSlaveAddress.addAll(dataFrame);
    return pduWithSlaveAddress;
  }

  static void createAndPrintMessage({
    required int slaveAddress,
    required int fnCode,
    required int regOffset,
    required List<int> dataFrame,
    required int numberOfReg,
  }) {
    List<int> newList = [];
    newList.add(slaveAddress);
    newList.add(fnCode);

    newList.add(int.parse(
        regOffset.toRadixString(16).padLeft(4, '0').toString().substring(0, 2),
        radix: 16));
    newList.add(int.parse(
        regOffset.toRadixString(16).padLeft(4, '0').toString().substring(2, 4),
        radix: 16));

    newList.add(int.parse(
        numberOfReg
            .toRadixString(16)
            .padLeft(4, '0')
            .toString()
            .substring(0, 2),
        radix: 16));
    newList.add(int.parse(
        numberOfReg
            .toRadixString(16)
            .padLeft(4, '0')
            .toString()
            .substring(2, 4),
        radix: 16));

    newList.addAll(dataFrame);

    var crc = Crc16Modbus().convert(Uint8List.fromList(newList));
    final checksum =
        int.parse(crc.toString()).toRadixString(16).padLeft(4, '0');

    print("Checksum SIBY $checksum");

    newList.add(int.parse(checksum.toString().substring(2, 4).toUpperCase(),
        radix: 16));
    newList.add(int.parse(checksum.toString().substring(0, 2).toUpperCase(),
        radix: 16));

    print("SIBY: $newList");
  }
}
