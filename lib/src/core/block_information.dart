import 'package:web3libdart/src/crypto/formatting.dart';
import 'package:web3libdart/web3libdart.dart';
import 'dart:typed_data';

class BlockInformation {
  final BlockNum? number;
  final Uint8List? hash;
  final Uint8List? parentHash;
  final int? nonce;
  final String sha3Uncles;
  final String? logsBloom;
  final String transactionsRoot;
  final String stateRoot;
  final String receiptsRoot;
  final EthereumAddress miner;
  final BigInt difficulty;
  final BigInt totalDifficulty;
  final String extraData;
  final int size;
  final BigInt gasLimit;
  final BigInt gasUsed;
  final DateTime timestamp;
  final List<dynamic> transactions;
  final List<String> uncles;
  final String? mixHash;
  final EtherAmount? baseFeePerGas;

  BlockInformation({
    required this.number,
    required this.hash,
    required this.parentHash,
    required this.nonce,
    required this.sha3Uncles,
    required this.logsBloom,
    required this.transactionsRoot,
    required this.stateRoot,
    required this.receiptsRoot,
    required this.miner,
    required this.difficulty,
    required this.totalDifficulty,
    required this.extraData,
    required this.size,
    required this.gasLimit,
    required this.gasUsed,
    required this.timestamp,
    required this.transactions,
    required this.uncles,
    required this.mixHash,
    required this.baseFeePerGas,
  });

  factory BlockInformation.fromJson(Map<String, dynamic> json, {bool isContainFullObj = false}) {
    return BlockInformation(
      number: json.containsKey('number') ? BlockNum.exact(num.parse(json['number'] as String).toInt()) : null,
      hash: json.containsKey('hash') ? hexToBytes(json['hash'] as String) : null,
      parentHash: json.containsKey('parentHash') ? hexToBytes(json['parentHash'] as String) : null,
      nonce: json.containsKey('nonce') ? num.parse(json['nonce'] as String).toInt() : null,
      sha3Uncles: json['sha3Uncles'] as String,
      logsBloom: json.containsKey('logsBloom') ? json['logsBloom'] as String : null,
      transactionsRoot: json['transactionsRoot'] as String,
      stateRoot: json['stateRoot'] as String,
      receiptsRoot: json['receiptsRoot'] as String,
      miner: EthereumAddress.fromHex(json['miner'] as String),
      difficulty: BigInt.parse(json['difficulty'] as String),
      totalDifficulty: BigInt.parse(json['totalDifficulty'] as String),
      extraData: json['extraData'] as String,
      size: num.parse(json['size'] as String).toInt(),
      gasLimit: BigInt.parse(json['gasLimit'] as String),
      gasUsed: BigInt.parse(json['gasUsed'] as String),
      timestamp: DateTime.fromMillisecondsSinceEpoch(
        hexToDartInt(json['timestamp'] as String) * 1000,
        isUtc: true,
      ),
      transactions: (json['transactions'] as List<dynamic>).map((e) {
        if (!isContainFullObj) return e as String;
        return TransactionInformation.fromMap(e as Map<String, dynamic>);
      }).toList(),
      uncles: (json['uncles'] as List<dynamic>).map((e) => e as String).toList(),
      mixHash: json.containsKey('mixHash') ? json['mixHash'] as String : null,
      baseFeePerGas: json.containsKey('baseFeePerGas')
          ? EtherAmount.fromUnitAndValue(
              EtherUnit.wei, hexToInt(json['baseFeePerGas'] as String))
          : null,

    );
  }

  Map<String, dynamic> toJson() {
    return {
      "number": number?.toString(),
      "hash": hash != null ? "0x${bytesToHex(hash!)}" : null,
      "parentHash": parentHash != null ? "0x${bytesToHex(parentHash!)}" : null,
      "nonce": nonce,
      "sha3Uncles": sha3Uncles,
      "logsBloom": logsBloom,
      "transactionsRoot": transactionsRoot,
      "stateRoot": stateRoot,
      "receiptsRoot": receiptsRoot,
      "miner": miner.hexEip55,
      "difficulty": "0x${difficulty.toRadixString(16)}",
      "totalDifficulty": "0x${totalDifficulty.toRadixString(16)}",
      "extraData": extraData,
      "size": size,
      "gasLimit": "0x${gasLimit.toRadixString(16)}",
      "gasUsed": "0x${gasUsed.toRadixString(16)}",
      "timestamp": "0x${timestamp.millisecondsSinceEpoch.toRadixString(16)}",
      "transactions": transactions.map((e) {
        if (e is String) {
          return e;
        } else {
          return {
            "blockHash": e.blockHash,
            "blockNumber": e.blockNumber.toString(),
            "from": e.from.hexEip55,
            "gas": "0x${e.gas.toRadixString(16)}",
            "gasPrice": "0x${e.gasPrice.getInWei.toRadixString(16)}",
            "hash": e.hash,
            "input": "0x${bytesToHex(e.input)}",
            "nonce": "0x${e.nonce.toRadixString(16)}",
            "to": e.to?.hexEip55,
            "transactionIndex": e.transactionIndex != null ? "0x${e.transactionIndex!.toRadixString(16)}" : null,
            "value": "0x${e.value.getInEther.toRadixString(16)}",
            "v": "0x${e.v.toRadixString(16)}",
            "r": "0x${e.r.toRadixString(16)}",
            "s": "0x${e.s.toRadixString(16)}"
          };
        }
      }).toList(),
      "uncles": uncles,
      "mixHash": mixHash,
      "baseFeePerGas": baseFeePerGas != null ? "0x${baseFeePerGas!.getInWei.toRadixString(16)}" : null
    };
  }

  bool get isSupportEIP1559 => baseFeePerGas != null;
}
