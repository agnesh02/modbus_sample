// ignore_for_file: avoid_print

import 'dart:typed_data';

import 'package:crclib/catalog.dart';

class AkPduDataFrameHelper {
  AkPduDataFrameHelper._();

  static final _instance = AkPduDataFrameHelper._();

  factory AkPduDataFrameHelper() {
    return _instance;
  }

  List<int> generateWriteSingleRegisterFrame(int data) {
    print("------GENERATING DATA AS ARRAY-------");
    List<int> bytes = [];
    while (data > 0) {
      bytes.insert(0, data & 0xFF);
      data >>= 8;
    }
    // Pad the byte array to ensure it has at least 2 bytes
    while (bytes.length < 2) {
      bytes.insert(0, 00);
    }
    print("Data as array of integers: $bytes");

    String bytesAsHex =
        bytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join(',');
    print('Data Bytes as hex: $bytesAsHex');

    return bytes;
  }

  List<int> generateWriteMultipleRegisterFrame(List<int> arrayOfData) {
    List<int> arrayOfBytes = [];
    List arrayOfHexData = [];

    for (int data in arrayOfData) {
      List<int> bytes = [];
      int d = data;
      while (data > 0) {
        bytes.insert(0, data & 0xFF);
        data >>= 8;
      }
      arrayOfBytes.addAll(bytes);
      print("Data as byte array: $d -> $bytes");
    }

    for (var byte in arrayOfBytes) {
      String byteAsHex = "0x$byte";
      arrayOfHexData.add(byteAsHex);
    }

    print('List of data as hex: $arrayOfData -> $arrayOfHexData');
    return arrayOfBytes;
  }

  List<int> generateWriteSingleCoilFrame(bool boolData) {
    print("------GENERATING COIL DATA-------");
    var data = Uint8List(4);
    ByteData.view(data.buffer)
      ..setUint16(0, 0x00)
      ..setUint16(2, boolData ? 0xff00 : 0x0000);

    return data;
  }

  List<int> uint8ListToIntList(Uint8List uint8List) {
    List<int> intList = [];
    for (int i = 0; i < uint8List.length; i++) {
      intList.add(uint8List[i]);
    }
    return intList;
  }

  List<int> generateWriteMultipleCoilsFrame(List<bool> values) {
    int amount = values.length;
    int numberOfBytes = (amount / 8).ceil();

    var data = Uint8List(4 + 1 + numberOfBytes);
    var dataView = ByteData.view(data.buffer)
      ..setUint16(0, 0x00) // Slave Address
      ..setUint16(2, amount)
      ..setUint8(4, numberOfBytes);

    // Make list with full bytes
    if (amount % 8 != 0) {
      values.addAll(Iterable.generate(8 - (amount % 8), (i) => false));
    }

    for (int i = 0; i < numberOfBytes; i++) {
      var v = 0;
      for (int j = 0; j < 8; j++) {
        v |= (values.elementAt(i * 8 + j) ? 1 : 0) << j;
      }
      dataView.setUint8(5 + i, v);
    }

    List<int> dataFrame = uint8ListToIntList(data);

    dataFrame.removeAt(0); // 0 index of OG list
    dataFrame.removeAt(0); // 1 index of OG list
    // eg: [0, 20, 3, 241, 247, 15]
    // print(dataFrame);

    return dataFrame;
  }

  // int calculateCrc16(List<int> data) {
  //   const int polynomial = 0xA001;
  //   int crc = 0xFFFF;

  //   for (var byte in data) {
  //     crc ^= byte;
  //     for (int i = 0; i < 8; ++i) {
  //       if ((crc & 0x0001) != 0) {
  //         crc >>= 1;
  //         crc ^= polynomial;
  //       } else {
  //         crc >>= 1;
  //       }
  //     }
  //   }

  //   return crc & 0xFFFF;
  // }

  List<int> generateCheckSum(List<int> pduWithSlaveAddress) {
    // var crc = Crc16Modbus().convert(dataFrame);
    // var crc = Crc16Modbus().convert([0x0A, 0x06, 0x00, 0x02, 0x30, 0x39]);
    // var crc = Crc16Modbus().convert([0x0A, 0x06, 0x00, 0x02, 48, 57]);
    // print(crc);
    var crc = Crc16Modbus().convert(pduWithSlaveAddress);

    print("------GENERATING CHECKSUM-------");
    // print(calculateCrc16(pduWithSlaveAddress));

    final checksumBytes =
        int.parse(crc.toString()).toRadixString(16).padLeft(4, '0');
    print("Checksum bytes: $checksumBytes");

    final checksumBigEndian = int.parse(
        checksumBytes.substring(2, 4) + checksumBytes.substring(0, 2),
        radix: 16);
    print(
      "Checksum as Hex (big endian): 0x${checksumBigEndian.toRadixString(16).padLeft(4, '0')}",
    );

    List<int> arrayOfChecksumBytes = [];
    // Need to reverse it
    int byte1 = int.parse(
        checksumBytes.toString().substring(2, 4).toUpperCase(),
        radix: 16);
    int byte2 = int.parse(
        checksumBytes.toString().substring(0, 2).toUpperCase(),
        radix: 16);

    arrayOfChecksumBytes.add(byte1);
    arrayOfChecksumBytes.add(byte2);
    print("Checksum frame: $arrayOfChecksumBytes");

    return arrayOfChecksumBytes;
  }
}
