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
      print(dFrame);
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
