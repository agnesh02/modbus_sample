// ignore_for_file: avoid_print

import 'package:crclib/catalog.dart';

class AkModbusPacket {
  AkModbusPacket._();

  static final _instance = AkModbusPacket._();

  factory AkModbusPacket({
    required int slaveAddress,
    required int fnCode,
    required int registerAddress,
    required List<int> dataFrame,
    required List<int> crcChecksum,
  }) {
    AkModbusPacket.slaveAddress = slaveAddress;
    AkModbusPacket.fnCode = fnCode;
    AkModbusPacket.registerAddress = registerAddress;
    AkModbusPacket.dataFrame = dataFrame;
    AkModbusPacket.crcChecksum = crcChecksum;

    return _instance;
  }

  static int slaveAddress = 0x00;
  static int fnCode = 0x00;
  static int registerAddress = 0x00;
  static List<int> dataFrame = [];
  static List<int> crcChecksum = [];

  static void printAllProperties() {
    print('-------------------------------------------------');
    print(
      'Slave Address: $slaveAddress  | 0x${slaveAddress.toRadixString(16)}',
    );
    print(
      'Function Code: $fnCode | 0x${fnCode.toRadixString(16)}',
    );
    print(
      'Register Address: $registerAddress | 0x${registerAddress.toRadixString(16)}',
    );
    print(
      'Data Frame: $dataFrame | ${dataFrame.map((e) => "0x${e.toRadixString(16)}").toList()}',
    );
    print(
        'CRC Checksum: $crcChecksum | ${crcChecksum.map((e) => "0x${e.toRadixString(16)}").toList()}');
    print('-------------------------------------------------');
  }
}

class PduDataFrameHelper {
  List<int> generateWriteSingleRegisterFrame(int data) {
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

  void generateWriteMultipleRegisterFrame(List<int> arrayOfData) {
    List arrayOfBytes = [];
    List arrayOfHexData = [];

    for (int data in arrayOfData) {
      List<int> bytes = [];
      int d = data;

      while (data > 0) {
        bytes.insert(0, data & 0xFF);
        data >>= 8;
      }
      arrayOfBytes.add(bytes);
      print("Data as byte array: $d -> $bytes");
    }

    for (var bytes in arrayOfBytes) {
      String bytesAsHex =
          bytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join(' ');
      arrayOfHexData.add(bytesAsHex);
    }

    print('List of data as hex: $arrayOfData -> $arrayOfHexData');
  }

  List<int> generateCheckSum(List<int> dataFrame) {
    // var crc = Crc16Modbus().convert(dataFrame);
    var crc = Crc16Modbus().convert([0x0A, 0x06, 0x00, 0x02, 0x30, 0x39]);
    // var crc = Crc16Modbus().convert([0x0A, 0x06, 0x00, 0x02, 48, 57]);
    // print(crc);

    print("------GENERATING CHECKSUM-------");
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

    print([0x0A, 0x06, 0x00, 0x02, 0x30, 0x39]);
    print("Checksum frame: $arrayOfChecksumBytes");

    return arrayOfChecksumBytes;
  }
}
