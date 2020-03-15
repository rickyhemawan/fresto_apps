// Class for Main Activity invoked method
class TransactionFinished {
  final bool transactionCanceled;
  final String status;
  final String source;
  final String statusMessage;
  final String response;
  TransactionFinished(
    this.transactionCanceled,
    this.status,
    this.source,
    this.statusMessage,
    this.response,
  );

  @override
  String toString() {
    return 'TransactionFinished{transactionCanceled: $transactionCanceled, status: $status, source: $source, statusMessage: $statusMessage, response: $response}';
  }
}
