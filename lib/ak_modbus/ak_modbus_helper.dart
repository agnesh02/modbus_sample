// ignore_for_file: avoid_print

import 'package:modbus_sample/ak_modbus/ak_modbus_codes.dart';
import 'package:modbus_sample/ak_modbus/ak_modbus_packet.dart';
import 'package:modbus_sample/ak_modbus/ak_pdu_dataframe_helper.dart';

class AkModbusHelper {
  AkModbusHelper._();

  static final _instance = AkModbusHelper._();

  factory AkModbusHelper() {
    return _instance;
  }

  void performWriteOperation({
    required int slaveAddress,
    required int fnCode,
    required List<int> registerAddress,
    List<int>? quantity,
    int? byteCount,
    required List<int> data,
  }) {
    // Generating the Modbus packet
    List<int> dFrame = [];

    if (fnCode == ModbusFunctionCode.writeSingleHoldingRegister.code) {
      dFrame = AkPduDataFrameHelper().generateWriteSingleRegisterFrame(data[0]);
    } else if (fnCode ==
        ModbusFunctionCode.writeMultipleHoldingRegisters.code) {
      dFrame = AkPduDataFrameHelper().generateWriteMultipleRegisterFrame(data);
    } else if (fnCode == ModbusFunctionCode.writeSingleCoil.code) {
      dFrame = data;
    } else if (fnCode == ModbusFunctionCode.writeMultipleCoils.code) {
      dFrame = data;
    }

    var packet = AkModbusPacket(
      slaveAddress: slaveAddress,
      fnCode: fnCode,
      registerAddress: registerAddress,
      quantity: quantity ?? [],
      byteCount: byteCount ?? 0,
      dataFrame: dFrame,
      crcChecksum: [],
    );

    // Set CRC checksum
    packet.crcChecksum = AkPduDataFrameHelper().generateCheckSum(
      packet.getPduWithSlaveAddress(),
    );

    // Print properties
    packet.printAllProperties();

    // Print final packet
    print("-----Printing final packet-------");
    print(packet.getPacket());
    print("---------------------------------");
  }
}
