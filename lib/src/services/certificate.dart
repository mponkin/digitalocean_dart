import 'package:json_annotation/json_annotation.dart';
import 'doService.dart';
import '../models/certificate.dart';
import '../models/certificates.dart';
import '../client.dart';
import '../models/listOptions.dart';
import '../utils.dart';
part 'certificate.g.dart';

class CertificateService extends DOService {
  final String _FIELD_NAME = 'certificate';
  CertificateService(Client client) : super(client, "/v2/certificates");

  /// Create a new certificate
  Future<Certificate> create(CertificateCreateRequest ccr) async {
    dynamic data = await client.execute('POST', basePath, json: ccr.toJson());

    return Certificate.fromJson(data[_FIELD_NAME]);
  }

  /// Retrieve an existing certificate
  Future<Certificate> get(String certificateId) async {
    String path = basePath + "/" + certificateId;
    dynamic data = await client.execute('GET', path);

    return Certificate.fromJson(data[_FIELD_NAME]);
  }

  /// List all certificates
  Future<Certificates> list({ListOptions ops}) async {
    String path = basePath;

    if (ops != null) path = Utils.getPathFromListOptions(ops, basePath);

    dynamic r = await client.execute('GET', path);

    List<Certificate> certs = _toList(r['certificates']);
    Map<String, dynamic> collectionData = client.getDOCollectionData(r);

    return Certificates(certs, collectionData['links'], collectionData['meta']);
  }

  Future<void> delete(String certificateId) async {
    String path = basePath + "/" + certificateId;

    await client.execute('DELETE', path);
  }

  List<Certificate> _toList(List<dynamic> data) {
    List<Certificate> certs = List();
    for (dynamic item in data) {
      certs.add(Certificate.fromJson(item));
    }
    return certs;
  }
}

@JsonSerializable()
class CertificateCreateRequest {
  String name;
  String private_key;
  String leaf_certificate;
  String certificate_chain;
  List<String> dns_names;
  String type;

  CertificateCreateRequest(this.name, this.type,
      {this.private_key,
      this.leaf_certificate,
      this.certificate_chain,
      this.dns_names});

  factory CertificateCreateRequest.fromJson(Map<String, dynamic> json) =>
      _$CertificateCreateRequestFromJson(json);
  Map<String, dynamic> toJson() => _$CertificateCreateRequestToJson(this);
}
