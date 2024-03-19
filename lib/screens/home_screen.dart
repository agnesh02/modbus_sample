// ignore_for_file: avoid_print

import 'dart:typed_data';

import 'package:crclib/catalog.dart';
import 'package:flutter/material.dart';
import 'package:modbus_sample/ak_modbus/ak_modbus_functions.dart';
import 'package:modbus_sample/ak_modbus/ak_modbus_operations.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // List<int> createMessage1(int regOffset, int numberofReg) {
  //   List<int> newList = [];
  //   newList.add(10);
  //   newList.add(6);

  //   newList.add(int.parse(
  //       regOffset.toRadixString(16).padLeft(4, '0').toString().substring(0, 2),
  //       radix: 16));
  //   newList.add(int.parse(
  //       regOffset.toRadixString(16).padLeft(4, '0').toString().substring(2, 4),
  //       radix: 16));

  //   // newList.add(int.parse(
  //   //     numberofReg
  //   //         .toRadixString(16)
  //   //         .padLeft(4, '0')
  //   //         .toString()
  //   //         .substring(0, 2),
  //   //     radix: 16));
  //   // newList.add(int.parse(
  //   //     numberofReg
  //   //         .toRadixString(16)
  //   //         .padLeft(4, '0')
  //   //         .toString()
  //   //         .substring(2, 4),
  //   //     radix: 16));

  //   newList.add(0x30);
  //   newList.add(0x39);

  //   var crc = Crc16Modbus().convert(Uint8List.fromList(newList));
  //   final checksum =
  //       int.parse(crc.toString()).toRadixString(16).padLeft(4, '0');

  //   print("Checksum SIBY $checksum");

  //   newList.add(int.parse(checksum.toString().substring(2, 4).toUpperCase(),
  //       radix: 16));
  //   newList.add(int.parse(checksum.toString().substring(0, 2).toUpperCase(),
  //       radix: 16));
  //   print("input");
  //   print(newList);
  //   return newList;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            var dFrame =
                PduDataFrameHelper().generateWriteSingleRegisterFrame(12345);

            AkModbusPacket(
              slaveAddress: 0xA,
              fnCode: ModbusFunctionCode.writeSingleHoldingRegister.code,
              registerAddress: 0x002,
              dataFrame: dFrame,
              crcChecksum: PduDataFrameHelper().generateCheckSum(dFrame),
            );

            AkModbusPacket.printAllProperties();

            // print(createMessage1(2, 1));

            // PduDataFrameGenerator()
            //     .generateWriteMultipleRegisterFrame([1947, 1968, 1970]);
          },
          child: const Text("Click me"),
        ),
      ),
    );
  }
}
