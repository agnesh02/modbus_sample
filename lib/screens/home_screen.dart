// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:modbus_sample/ak_modbus/ak_modbus_codes.dart';
import 'package:modbus_sample/ak_modbus/ak_modbus_helper.dart';
import 'package:modbus_sample/ak_modbus/ak_modbus_packet.dart';
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            ControlButton(
              title: "Write single coil",
              onClick: () {
                AkModbusHelper().performWriteOperation(
                  slaveAddress: 0xA,
                  fnCode: ModbusFunctionCode.writeSingleCoil.code,
                  registerAddress: [0x00, 0x02],
                  data: [0xFF, 0x00],
                );
              },
            ),
            ControlButton(
              title: "Write multiple coils",
              onClick: () {
                var dFrame =
                    AkPduDataFrameHelper().generateWriteMultipleCoilsFrame([
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
            ),
            ControlButton(
              title: "Write single register",
              onClick: () {
                AkModbusHelper().performWriteOperation(
                  slaveAddress: 0xA,
                  fnCode: ModbusFunctionCode.writeSingleHoldingRegister.code,
                  registerAddress: [0x00, 0x02],
                  data: [12345],
                );
              },
            ),
            ControlButton(
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
            ),
          ],
        ),
      ),
    );
  }
}

Widget _renderWriteSingleRegister() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      ElevatedButton(
        style: buttonStyle,
        onPressed: () {
          AkModbusHelper().performWriteOperation(
            slaveAddress: 0xA,
            fnCode: ModbusFunctionCode.writeSingleHoldingRegister.code,
            registerAddress: [0x00, 0x02],
            data: [12345],
          );
        },
        child: const Text("Write single register"),
      ),
      ElevatedButton(
        onPressed: () {
          var dFrame =
              AkPduDataFrameHelper().generateWriteSingleRegisterFrame(12345);
          AkModbusPacket.createAndPrintMessage(
            slaveAddress: 0xA,
            fnCode: ModbusFunctionCode.writeSingleHoldingRegister.code,
            regOffset: 0x2,
            dataFrame: dFrame,
            numberOfReg: 1,
          );
        },
        child: const Text("S: Write single register"),
      ),
    ],
  );
}

Widget _renderWriteMultipleRegisters() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      ElevatedButton(
        onPressed: () {
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
        child: const Text("Write multiple registers"),
      ),
      Expanded(
        child: ElevatedButton(
          onPressed: () {
            var dFrame = AkPduDataFrameHelper()
                .generateWriteMultipleRegisterFrame([1947, 1968, 1970, 2000]);
            AkModbusPacket.createAndPrintMessage(
              slaveAddress: 0xA,
              fnCode: ModbusFunctionCode.writeMultipleHoldingRegisters.code,
              regOffset: 0x2,
              dataFrame: dFrame,
              numberOfReg: 4,
            );
          },
          child: const Text("S: Write multiple registers"),
        ),
      ),
    ],
  );
}

Widget _renderWriteSingleCoil() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      ElevatedButton(
        onPressed: () {
          AkModbusHelper().performWriteOperation(
            slaveAddress: 0xA,
            fnCode: ModbusFunctionCode.writeSingleCoil.code,
            registerAddress: [0x00, 0x02],
            data: [0xFF, 0x00],
          );
        },
        child: const Text("Write single coil"),
      ),
      ElevatedButton(
        onPressed: () {
          AkModbusPacket.createAndPrintMessage(
            slaveAddress: 0xA,
            fnCode: ModbusFunctionCode.writeSingleCoil.code,
            regOffset: 0x2,
            dataFrame: [0xFF],
            numberOfReg: 1,
          );
        },
        child: const Text("S: Write single coil"),
      ),
    ],
  );
}

Widget _renderWriteMultipleCoils() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      ElevatedButton(
        onPressed: () {
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
        child: const Text("Write multiple coils"),
      ),
    ],
  );
}
