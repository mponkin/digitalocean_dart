import '../client.dart';
import '../models/domain.dart';
import '../models/domains.dart';
import '../utils.dart';
import 'doService.dart';
import '../models/listOptions.dart';

class DomainService extends DOService {
  final String _FIELD_NAME = 'domain';
  DomainService(Client client) : super(client, "/v2/domains");

  /// List all Domains
  Future<Domains> list({ListOptions ops}) async {
    String path = basePath;

    if (ops != null) path = Utils.getPathFromListOptions(ops, basePath);

    dynamic r = await client.execute('GET', path);

    List<Domain> _ = _toList(r['domains']);
    Map<String, dynamic> collectionData = client.getDOCollectionData(r);

    return Domains(_, collectionData['links'], collectionData['meta']);
  }

  /// Create a new Domain
  ///
  Future<Domain> create(String name, {String ip_address}) async {
    Map<String, dynamic> json = {"name": name};
    if (ip_address != null) json['ip_address'] = ip_address;
    dynamic data = await client.execute('POST', basePath, json: json);

    return Domain.fromJson(data[_FIELD_NAME]);
  }

  /// Retrieve an existing domain
  Future<Domain> get(String name) async {
    String path = basePath + "/" + name;

    dynamic data = await client.execute('GET', path);

    return Domain.fromJson(data[_FIELD_NAME]);
  }

  /// Delete a domain
  Future<void> delete(String name) async {
    String path = basePath + "/" + name;

    await client.execute('DELETE', path);
  }

  List<Domain> _toList(List<dynamic> data) {
    List<Domain> domains = List();
    for (dynamic item in data) {
      domains.add(Domain.fromJson(item));
    }
    return domains;
  }
}
