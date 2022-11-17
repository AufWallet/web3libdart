part of 'package:web3libdart/web3libdart.dart';

class TransactionInformation {
  TransactionInformation.fromMap(Map<String, dynamic> map)
      : blockHash = map['blockHash'] != null ? map['blockHash'] as String : null,
        blockNumber = map['blockNumber'] != null
            ? BlockNum.exact(int.parse(map['blockNumber'] as String))
            : const BlockNum.pending(),
        from = EthereumAddress.fromHex(map['from'] as String),
        gas = int.parse(map['gas'] as String),
        gasPrice = EtherAmount.inWei(BigInt.parse(map['gasPrice'] as String)),
        hash = map['hash'] as String,
        input = hexToBytes(map['input'] as String),
        nonce = int.parse(map['nonce'] as String),
        to = map['to'] != null
            ? EthereumAddress.fromHex(map['to'] as String)
            : null,
        transactionIndex = map['transactionIndex'] != null
            ? int.parse(map['transactionIndex'] as String)
            : null,
        value = EtherAmount.inWei(BigInt.parse(map['value'] as String)),
        v = int.parse(map['v'] as String),
        r = hexToInt(map['r'] as String),
        s = hexToInt(map['s'] as String);

  Map<String, dynamic> toJson() {
    return {
      "blockHash": blockHash,
      "blockNumber": blockNumber.useAbsolute ? blockNumber.toString() : null,
      "from": from.hexEip55,
      "gas": "0x${gas.toRadixString(16)}",
      "gasPrice": "0x${gasPrice.getInWei.toRadixString(16)}",
      "hash": hash,
      "input": "0x${bytesToHex(input)}",
      "nonce": "0x${nonce.toRadixString(16)}",
      "to": to?.hexEip55,
      "transactionIndex": transactionIndex != null ? "0x${transactionIndex!.toRadixString(16)}" : null,
      "value": "0x${value.getInEther.toRadixString(16)}",
      "v": "0x${v.toRadixString(16)}",
      "r": "0x${r.toRadixString(16)}",
      "s": "0x${s.toRadixString(16)}"
    };
  }

  /// The hash of the block containing this transaction. If this transaction has
  /// not been mined yet and is thus in no block, it will be `null`
  final String? blockHash;

  /// [BlockNum] of the block containing this transaction, or [BlockNum.pending]
  /// when the transaction is not part of any block yet.
  final BlockNum blockNumber;

  /// The sender of this transaction.
  final EthereumAddress from;

  /// How many units of gas have been used in this transaction.
  final int gas;

  /// The amount of Ether that was used to pay for one unit of gas.
  final EtherAmount gasPrice;

  /// A hash of this transaction, in hexadecimal representation.
  final String hash;

  /// The data sent with this transaction.
  final Uint8List input;

  /// The nonce of this transaction. A nonce is incremented per sender and
  /// transaction to make sure the same transaction can't be sent more than
  /// once.
  final int nonce;

  /// Address of the receiver. `null` when its a contract creation transaction
  final EthereumAddress? to;

  /// Integer of the transaction's index position in the block. `null` when it's
  /// pending.
  int? transactionIndex;

  /// The amount of Ether sent with this transaction.
  final EtherAmount value;

  /// A cryptographic recovery id which can be used to verify the authenticity
  /// of this transaction together with the signature [r] and [s]
  final int v;

  /// ECDSA signature r
  final BigInt r;

  /// ECDSA signature s
  final BigInt s;

  /// The ECDSA full signature used to sign this transaction.
  MsgSignature get signature => MsgSignature(r, s, v);
}

class TransactionReceipt {
  TransactionReceipt(
      {required this.transactionHash,
      required this.transactionIndex,
      required this.blockHash,
      required this.cumulativeGasUsed,
      this.blockNumber = const BlockNum.pending(),
      this.contractAddress,
      this.status,
      this.from,
      this.to,
      this.gasUsed,
      this.effectiveGasPrice,
      this.logs = const []});

  TransactionReceipt.fromMap(Map<String, dynamic> map)
      : transactionHash = hexToBytes(map['transactionHash'] as String),
        transactionIndex = hexToDartInt(map['transactionIndex'] as String),
        blockHash = hexToBytes(map['blockHash'] as String),
        blockNumber = map['blockNumber'] != null
            ? BlockNum.exact(int.parse(map['blockNumber'] as String))
            : const BlockNum.pending(),
        from = map['from'] != null
            ? EthereumAddress.fromHex(map['from'] as String)
            : null,
        to = map['to'] != null
            ? EthereumAddress.fromHex(map['to'] as String)
            : null,
        cumulativeGasUsed = hexToInt(map['cumulativeGasUsed'] as String),
        gasUsed =
            map['gasUsed'] != null ? hexToInt(map['gasUsed'] as String) : null,
        effectiveGasPrice = map['effectiveGasPrice'] != null
            ? EtherAmount.inWei(
                BigInt.parse(map['effectiveGasPrice'] as String))
            : null,
        contractAddress = map['contractAddress'] != null
            ? EthereumAddress.fromHex(map['contractAddress'] as String)
            : null,
        status = map['status'] != null
            ? (hexToDartInt(map['status'] as String) == 1)
            : null,
        logs = map['logs'] != null
            ? (map['logs'] as List<dynamic>)
                .map((log) => FilterEvent.fromMap(log as Map<String, dynamic>))
                .toList()
            : [];

  Map<String, dynamic> toJson() {
    return {
      "transactionHash": "0x${bytesToHex(transactionHash)}",
      "transactionIndex": "0x${transactionIndex.toRadixString(16)}",
      "blockHash": "0x${bytesToHex(blockHash)}",
      "blockNumber": blockNumber.toString(),
      "from": from?.hexEip55,
      "to": to?.hexEip55,
      "cumulativeGasUsed": "0x${cumulativeGasUsed.toRadixString(16)}",
      "gasUsed": gasUsed != null ? "0x${gasUsed!.toRadixString(16)}" : null,
      "contractAddress": contractAddress != null ? contractAddress!.hexEip55 : null,
      "logs": logs.map((e) => {
        "removed": e.removed,
        "logIndex": e.logIndex != null ? "0x${e.logIndex?.toRadixString(16)}" : null,
        "transactionIndex": e.transactionIndex != null ? "0x${e.transactionIndex?.toRadixString(16)}" : null,
        "transactionHash": e.transactionHash,
        "blockHash": e.blockHash,
        "blockNumber": e.blockNum,
        "address": e.address != null ? e.address!.hexEip55 : null,
        "data": e.data,
        "topics": e.topics != null ? e.topics?.map((t) => t.toString()).toList(): []
      }).toList(),
      "logsBloom": null,
      "root": null,
      "status": status == true ? "0x1" : "0x0"
    };
  }

  /// Hash of the transaction (32 bytes).
  final Uint8List transactionHash;

  /// Index of the transaction's position in the block.
  final int transactionIndex;

  /// Hash of the block where this transaction is in (32 bytes).
  final Uint8List blockHash;

  /// Block number where this transaction is in.
  final BlockNum blockNumber;

  /// Address of the sender.
  final EthereumAddress? from;

  /// Address of the receiver or `null` if it was a contract creation
  /// transaction.
  final EthereumAddress? to;

  /// The total amount of gas used when this transaction was executed in the
  /// block.
  final BigInt cumulativeGasUsed;

  /// The amount of gas used by this specific transaction alone.
  final BigInt? gasUsed;

  /// The address of the contract created if the transaction was a contract
  /// creation. `null` otherwise.
  final EthereumAddress? contractAddress;

  /// Whether this transaction was executed successfully.
  final bool? status;

  /// Array of logs generated by this transaction.
  final List<FilterEvent> logs;

  final EtherAmount? effectiveGasPrice;

  @override
  String toString() {
    return 'TransactionReceipt{transactionHash: ${bytesToHex(transactionHash)}, '
        'transactionIndex: $transactionIndex, blockHash: ${bytesToHex(blockHash)}, '
        'blockNumber: $blockNumber, from: ${from?.hex}, to: ${to?.hex}, '
        'cumulativeGasUsed: $cumulativeGasUsed, gasUsed: $gasUsed, '
        'contractAddress: ${contractAddress?.hex}, status: $status, '
        'effectiveGasPrice: $effectiveGasPrice, logs: $logs}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionReceipt &&
          runtimeType == other.runtimeType &&
          const ListEquality().equals(transactionHash, other.transactionHash) &&
          transactionIndex == other.transactionIndex &&
          const ListEquality().equals(blockHash, other.blockHash) &&
          blockNumber == other.blockNumber &&
          from == other.from &&
          to == other.to &&
          cumulativeGasUsed == other.cumulativeGasUsed &&
          gasUsed == other.gasUsed &&
          contractAddress == other.contractAddress &&
          status == other.status &&
          effectiveGasPrice == other.effectiveGasPrice &&
          const ListEquality().equals(logs, other.logs);

  @override
  int get hashCode =>
      transactionHash.hashCode ^
      transactionIndex.hashCode ^
      blockHash.hashCode ^
      blockNumber.hashCode ^
      from.hashCode ^
      to.hashCode ^
      cumulativeGasUsed.hashCode ^
      gasUsed.hashCode ^
      contractAddress.hashCode ^
      status.hashCode ^
      effectiveGasPrice.hashCode ^
      logs.hashCode;
}
