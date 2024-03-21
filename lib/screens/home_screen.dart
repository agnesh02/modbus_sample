// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:modbus_sample/ak_modbus/ak_modbus_codes.dart';
import 'package:modbus_sample/ak_modbus/ak_modbus_helper.dart';
import 'package:modbus_sample/ak_modbus/ak_pdu_dataframe_helper.dart';
import 'package:modbus_sample/widgets/control_button.dart';

final buttonStyle = ElevatedButton.styleFrom(
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(2),
  ),
);

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _renderWriteSingleCoil(),
            _renderWriteMultipleCoils(),
            const SizedBox(height: 20),
            _renderWriteSingleRegister(),
            _renderWriteMultipleRegisters(),
            const SizedBox(height: 20),
            _renderReadCoils(),
            _renderReadRegisters(),
            const SizedBox(height: 20),
            _renderDecodeCoilResponse(),
            _renderDecodeRegisterResponse(),
          ],
        ),
      ),
    );
  }
}

Widget _renderWriteSingleCoil() {
  return ControlButton(
    title: "Write single coil",
    onClick: () {
      AkModbusHelper().performWriteOperation(
        slaveAddress: 0xA,
        fnCode: ModbusFunctionCode.writeSingleCoil.code,
        registerAddress: [0x00, 0x02],
        data: [0xFF, 0x00],
      );
    },
  );
}

Widget _renderWriteMultipleCoils() {
  return ControlButton(
    title: "Write multiple coils",
    onClick: () {
      var dFrame = AkPduDataFrameHelper().generateWriteMultipleCoilsFrame([
        true,
        false,
        false,
        false,
        true,
        true,
        true,
        true,
        true,
        true,
        true,
        false,
        true,
        true,
        true,
        true,
        true,
        true,
        true,
        true
      ]);
      print("-------------------------------");
      print("Write multiple coils | dFrame: $dFrame");
      print("quantity: [${dFrame[0]}, ${dFrame[1]}]");
      print("byteCount: [${dFrame[2]}]");

      AkModbusHelper().performWriteOperation(
        slaveAddress: 0xA,
        fnCode: ModbusFunctionCode.writeMultipleCoils.code,
        registerAddress: [0x00, 0x03],
        // quantity: [dFrame[0], dFrame[1]],
        // byteCount: dFrame[2],
        data: dFrame,
      );
    },
  );
}

Widget _renderWriteSingleRegister() {
  return ControlButton(
    title: "Write single register",
    onClick: () {
      AkModbusHelper().performWriteOperation(
        slaveAddress: 0xA,
        fnCode: ModbusFunctionCode.writeSingleHoldingRegister.code,
        registerAddress: [0x00, 0x02],
        data: [12345],
      );
    },
  );
}

Widget _renderWriteMultipleRegisters() {
  return ControlButton(
    title: "Write multiple registers",
    onClick: () {
      List<int> dataToBeWritten = [1947, 1968, 1970, 2000];
      AkModbusHelper().performWriteOperation(
        slaveAddress: 0xA,
        fnCode: ModbusFunctionCode.writeMultipleHoldingRegisters.code,
        registerAddress: [0x00, 0x02],
        quantity: [0x0, 0x04],
        byteCount: dataToBeWritten.length * 2,
        data: [1947, 1968, 1970, 2000],
      );
    },
  );
}

Widget _renderReadCoils() {
  return ControlButton(
    title: "Read Coils",
    onClick: () {
      AkModbusHelper().performReadOperation(
        slaveAddress: 0xB,
        fnCode: ModbusFunctionCode.readCoils.code,
        registerAddress: [0x00, 0x1D],
        quantity: [0x0, 0x1F],
      );
    },
  );
}

Widget _renderReadRegisters() {
  return ControlButton(
    title: "Read Registers",
    onClick: () {
      AkModbusHelper().performReadOperation(
        slaveAddress: 0xB,
        fnCode: ModbusFunctionCode.readHoldingRegisters.code,
        registerAddress: [0x00, 0x6F],
        quantity: [0x0, 0x03],
      );
    },
  );
}

Widget _renderDecodeCoilResponse() {
  return ControlButton(
    title: "Decode Coils",
    onClick: () {
      AkPduDataFrameHelper().decodeResponse(
        [0x0B, 0x01, 0x04, 0xCD, 0x6B, 0xB2, 0x7F, 0x2B, 0xE1, 0xCD],
      );
    },
  );
}

Widget _renderDecodeRegisterResponse() {
  return ControlButton(
    title: "Decode Registers",
    onClick: () {
      AkPduDataFrameHelper().decodeResponse(
        [0x0B, 0x03, 0x06, 0xAE, 0x41, 0x56, 0x52, 0x43, 0x40, 0xFA, 0xCD],
      );
      // AkPduDataFrameHelper().decodeResponse(
      //   [0x0B, 0x03, 0x02, 0xAE, 0x41, 0x9C, 0x15],
      // );
    },
  );
}
