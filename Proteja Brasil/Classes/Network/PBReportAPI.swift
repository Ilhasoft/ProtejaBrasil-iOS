//
//  PBReportAPI.swift
//  Proteja Brasil
//
//  Created by Daniel Borges on 20/10/15.
//  Copyright © 2015 IlhaSoft. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper
import AlamofireObjectMapper

class PBReportAPI: PBAPI {
    
    var reportToken: String? {
        if let path = Bundle.main.path(forResource: "APIKeys", ofType: "plist") {
            let dictRoot = NSDictionary(contentsOfFile: path)
            if let dict = dictRoot {
                return dict["PBReportToken"] as? String
            }
        }
        return nil;
    }
    
    func getInternetCrimeTypes(completion: @escaping ([PBInternetCrimeType]?, Error?) -> Void) {
        let url = "http://rs.safernet.org.br/external/report_kit.json"
        let params = ["token": reportToken ?? ""]
        Alamofire.request(url, method: .get, parameters: params)
            .responseArray(completionHandler: { (response: DataResponse<[PBInternetCrimeType]>) in
                let value = response.value
                let error = response.error
                if let error = error {
                    print("Error while retrieving the internet crime types: \(error)")
                }
                completion(value, error)
            })
    }
    
    func postInternetCrime(data: [String: Any], completion: @escaping (String?, Int?) -> Void) {
        let reportKitLastOption = data["report_kit_last_option"] as! Int
        var reportUrl = data["url"] as! String
        let reportDescription = data["description"] as! String
        
        if !reportUrl.contains("http://") && !reportUrl.contains("https://") {
            reportUrl = "http://" + reportUrl
        }
        
        let url = "http://rs.safernet.org.br/external/report_kit.json"
        let params = [
            "token": reportToken ?? "",
            "report": [
                "url": reportUrl,
                "comment": reportDescription
            ],
            "report_kit_last_option": reportKitLastOption
            ] as [String: AnyObject]
        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.methodDependent) //request(.POST, url, parameters: params, encoding: .URLEncodedInURL)
            .validate(statusCode: 200...200)
            .responseJSON { response in
                if let JSON = response.result.value as? NSDictionary,
                    let data = JSON["data"] as? NSDictionary,
                    let key = data["key"] as? String,
                    let statusCode = response.response?.statusCode {
                    
                    completion(key, statusCode)
                    return
                }
                completion(nil, response.response?.statusCode)
        }
    }
    
    func postViolation(data: [String: Any], completion: @escaping (String?, Error?) -> Void) {
        let path = Bundle.main.path(forResource: "ComplaintRequestModel", ofType: "xml")!
        var content: String!
        do {
            content = try String(contentsOfFile: path)
        } catch {
            print("Error while getting the XML model.")
            completion(nil, nil)
            return
        }

        let violacao = data["violacao"] as! Int
        let desViolacao = data["des_violacao"] as! String
        let subtipoviolacao = (data["subtipoviolacao"] == nil) ? "" : data["subtipoviolacao"] as! String
        let desSubtipoViolacao = (data["des_subtipoviolacao"] == nil) ? "" : data["des_subtipoviolacao"] as! String
        
        let frequencia = data["frequencia"] as! String
        
        let nomeVitima = data["nome_vitima"] as! String
        let localizacaoVitima = data["localizacao_vitima"] as! String
        let ufVitima = data["uf_vitima"] as! String
        let cidadeVitima = data["cidade_vitima"] as! String
        let enderecoVitima = data["endereco_vitima"] as! String
        
        let tiposuspeito = data["tiposuspeito"] as! Int
        let nomeSuspeito = data["nome_suspeito"] as! String
        let ufSuspeito = data["uf_suspeito"] as! String
        let cidadeSuspeito = data["cidade_suspeito"] as! String
        let enderecoSuspeito = data["endereco_suspeito"] as! String
        
        let descricao = data["descricao"] as! String
        let local = data["local"] as! String
        
        let instituicaoAcionada = (data["instituicao_acionada"] == nil || data["instituicao_acionada"] as! String == "") ? "Não informado" : data["instituicao_acionada"] as! String
        let sexoBiologicoVitima = data["sexo_biologico_vitima"] as! String
        let opcaoSexualVitima = (data["opcao_sexual_vitima"] == nil || data["opcao_sexual_vitima"] as! String == "") ? "Não informado" : data["opcao_sexual_vitima"] as! String
        let faixaEtariaVitima = (data["faixa_etaria_vitima"] == nil || data["faixa_etaria_vitima"] as! String == "") ? "" : data["faixa_etaria_vitima"] as! String
        let etniaVitima = (data["etnia_vitima"] == nil || data["etnia_vitima"] as! String == "") ? "Não informado" : data["etnia_vitima"] as! String
        
        let sexoBiologicoSuspeito = data["sexo_biologico_suspeito"] as! String
        let opcaoSexualSuspeito = (data["opcao_sexual_suspeito"] == nil || data["opcao_sexual_suspeito"] as! String == "") ? "Não informado" : data["opcao_sexual_suspeito"] as! String
        let faixaEtariaSuspeito = (data["faixa_etaria_suspeito"] == nil || data["faixa_etaria_suspeito"] as! String == "") ? "" : data["faixa_etaria_suspeito"] as! String
        let etniaSuspeito = (data["etnia_suspeito"] == nil || data["etnia_suspeito"] as! String == "") ? "Não informado" : data["etnia_suspeito"] as! String

        let codViolacao: Int! = violacao == 774 ? Int(subtipoviolacao) : violacao

        content = String(format: content,
                         codViolacao, desViolacao, subtipoviolacao, desSubtipoViolacao,
                         frequencia,
                         nomeVitima, localizacaoVitima, ufVitima, cidadeVitima, enderecoVitima,
                         tiposuspeito, nomeSuspeito, ufSuspeito, cidadeSuspeito, enderecoSuspeito,
                         descricao, local,
                         instituicaoAcionada, sexoBiologicoVitima, opcaoSexualVitima, faixaEtariaVitima, etniaVitima,
                         sexoBiologicoSuspeito, opcaoSexualSuspeito, faixaEtariaSuspeito, etniaSuspeito)
        
        print(content)
        print(violacao)
        let url: URL!
        switch PBNetworkConfig.type {
        case .test:
            url = URL(string: "https://sondhateste.sdh.gov.br/disque100/webservice.php")!
        case .production:
          if violacao == 774 {
               url = URL(string: "https://sondha180.mdh.gov.br/disque100/webservice.php")!
          } else {
                url = URL(string: "https://sondha.sdh.gov.br/disque100/webservice.php")!
            }
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = content.data(using: String.Encoding.utf8)
        urlRequest.setValue("text/xml", forHTTPHeaderField: "Content-Type")

        Alamofire.request(urlRequest).responseData { (response) -> Void in
            let error = response.result.error
            let value = response.result.value
            if let error = error {
                print("Error while doing a complaint violation: \(error)")
                completion(nil, error)
                return
            }
            if let value = value, let result = String(data: value, encoding: String.Encoding.utf8) {
                do {
                    let regex1 = try NSRegularExpression(
                        pattern: "<return xsi:type=\"xsd:string\">(.*?)<\\/return>",
                        options: .caseInsensitive
                    )
                    let match1 = regex1.firstMatch(
                        in: result, options: [],
                        range: NSMakeRange(0, result.count)
                    )
                    if match1 == nil {
                        print("Error while matching the result.")
                        completion(nil, nil)
                        return
                    }
                    let range1 = match1!.range(at: 1)
                    if range1.location == NSNotFound {
                        print("Range 1 not found...")
                        completion(nil, nil)
                        return
                    }
                    let returnString = (result as NSString).substring(with: range1)
                    let regex2 = try NSRegularExpression(
                        pattern: "[^\\d]*(\\d*)",
                        options: .caseInsensitive
                    )
                    let match2 = regex2.firstMatch(in: returnString, options: [],
                        range: NSMakeRange(0, returnString.count))
                    if match2 == nil {
                        print("Error while matching the protocol.")
                        completion(nil, nil)
                        return
                    }
                    let range2 = match2!.range(at: 1)
                    if range2.location == NSNotFound {
                        print("Range 2 not found...")
                        completion(nil, nil)
                        return
                    }
                    let complaintProtocol = (returnString as NSString).substring(with: range2)
                    
                    // -------------
                    print("Protocolo: \(complaintProtocol)")
                    print("")
                    print("Parâmetros:")
                    print("\tviolacao: \(violacao)")
                    print("\tdes_violacao: \(desViolacao)")
                    print("\tsubtipoviolacao: \(subtipoviolacao)")
                    print("\tdes_subtipoviolacao: \(desSubtipoViolacao)")
                    
                    print("\tfrequencia: \(frequencia)")
                    
                    print("\tnome_vitima: \(nomeVitima)")
                    print("\tlocalizacao_vitima: \(localizacaoVitima)")
                    print("\tuf_vitima: \(ufVitima)")
                    print("\tcidade_vitima: \(cidadeVitima)")
                    print("\tendereco_vitima: \(enderecoVitima)")
                    
                    print("\ttiposuspeito: \(tiposuspeito)")
                    print("\tnome_suspeito: \(nomeSuspeito)")
                    print("\tuf_suspeito: \(ufSuspeito)")
                    print("\tcidade_suspeito: \(cidadeSuspeito)")
                    print("\tendereco_suspeito: \(enderecoSuspeito)")
                    
                    print("\tdescricao: \(descricao)")
                    print("\tlocal: \(local)")
                    
                    print("\tinstituicao_acionada: \(instituicaoAcionada)")
                    print("\tsexo_biologico_vitima: \(sexoBiologicoVitima)")
                    print("\topcao_sexual_vitima: \(opcaoSexualVitima)")
                    print("\tfaixa_etaria_vitima: \(faixaEtariaVitima)")
                    print("\tetnia_vitima: \(etniaVitima)")
                    
                    print("\tsexo_biologico_suspeito: \(sexoBiologicoSuspeito)")
                    print("\topcao_sexual_suspeito: \(opcaoSexualSuspeito)")
                    print("\tfaixa_etaria_suspeito: \(faixaEtariaSuspeito)")
                    print("\tetnia_suspeito: \(etniaSuspeito)")
                    
                    print("")
                    print("XML enviado para o servidor:")
                    print(content)
                    print("")
                    // -------------
                    
                    completion(complaintProtocol, nil)
                    return
                } catch {
                    completion(nil, nil)
                    return
                }
            }
        }
    }
    
    func postNoAccessibility(data: [String: Any], completion: @escaping (String?, Error?) -> Void) {
        let path = Bundle.main.path(forResource: "NoAccessibilityRequestModel", ofType: "xml")!
        var content: String!
        do {
            content = try String(contentsOfFile: path)
        } catch {
            print("Error while getting the XML model.")
            completion(nil, nil)
            return
        }
        
        var nomeVitima = data["nome_vitima"] as! String
        if nomeVitima == "" {
            nomeVitima = "Não informado"
        }
        let ufVitima = data["uf_vitima"] as! String
        let cidadeVitima = data["cidade_vitima"] as! String
        let enderecoVitima = data["endereco_vitima"] as! String
        let idFaixaEtaria = (data["id_faixa_etaria"] == nil) ? "" : data["id_faixa_etaria"] as! String
        let idCorRaca = (data["id_cor_raca"] == nil) ? 0 : data["id_cor_raca"] as! Int
        let idSexo = (data["id_sexo"] == nil) ? 0 : data["id_sexo"] as! Int
        let idOrientacaoSexual = (data["id_orientacao_sexual"] == nil) ? 0 : data["id_orientacao_sexual"] as! Int
        let idLocal = data["id_local"] as! Int
        let nomeSuspeito = data["nome_suspeito"] as! String
        let enderecoSuspeito = data["endereco_suspeito"] as! String
        let ufSuspeito = data["uf_suspeito"] as! String
        let cidadeSuspeito = data["cidade_suspeito"] as! String
        let idTipoViolacao = data["id_tipo_violacao"] as! Int
        let idViolacao = (data["id_violacao"] == nil) ? "156" : data["id_violacao"] as! String
        let outraViolacao = (data["outra_violacao"] == nil) ? "" : data["outra_violacao"] as! String
        let orgaoAcionado = (data["orgao_acionado"] == nil) ? "" : data["orgao_acionado"] as! String
        let descricaoDenuncia = data["descricao_denuncia"] as! String
        
        content = String(format: content,
                         nomeVitima, ufVitima, cidadeVitima, enderecoVitima,
                         idFaixaEtaria, idCorRaca, idSexo, idOrientacaoSexual,
                         idLocal, nomeSuspeito, enderecoSuspeito, ufSuspeito,
                         cidadeSuspeito, idTipoViolacao, idViolacao, outraViolacao,
                         orgaoAcionado, descricaoDenuncia
        )

        let url: URL!
        switch PBNetworkConfig.type {
        case .test:
            url = URL(string: "https://sondhateste.sdh.gov.br/disque100/webservice-acessibilidade/webservice.php?wsdl")!
        case .production:
            url = URL(string: "https://sondha.sdh.gov.br/disque100/webservice-acessibilidade/webservice.php?wsdl")!
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = content.data(using: String.Encoding.utf8)
        urlRequest.setValue("text/xml", forHTTPHeaderField: "Content-Type")
        
        Alamofire.request(urlRequest).responseData { (response) -> Void in
            let error = response.result.error
            let value = response.result.value
            if let error = error {
                print("Error while doing a complaint violation: \(error)")
                completion(nil, error)
                return
            }
            if let value = value, let result = String(data: value, encoding: String.Encoding.utf8) {
                do {
                    let regex1 = try NSRegularExpression(pattern: "<return xsi:type=\"xsd:string\">(.*?)<\\/return>",
                                                         options: .caseInsensitive)
                    let match1 = regex1.firstMatch(in: result, options: [],
                        range: NSMakeRange(0, result.count))
                    if match1 == nil {
                        print("Error while matching the result.")
                        completion(nil, nil)
                        return
                    }
                    let range1 = match1!.range(at: 1)
                    if range1.location == NSNotFound {
                        print("Range 1 not found...")
                        completion(nil, nil)
                        return
                    }
                    let returnString = (result as NSString).substring(with: range1)
                    let regex2 = try NSRegularExpression(pattern: "[^\\d]*(\\d*)", options: .caseInsensitive)
                    let match2 = regex2.firstMatch(in: returnString, options: [],
                        range: NSMakeRange(0, returnString.count))
                    if match2 == nil {
                        print("Error while matching the protocol.")
                        completion(nil, nil)
                        return
                    }
                    let range2 = match2!.range(at: 1)
                    if range2.location == NSNotFound {
                        print("Range 2 not found...")
                        completion(nil, nil)
                        return
                    }
                    let complaintProtocol = (returnString as NSString).substring(with: range2)
                    
                    // -------------
                    print("Protocolo: \(complaintProtocol)")
                    print("")
                    print("Parâmetros:")
                    print("\tnome_vitima: \(nomeVitima)")
                    print("\tuf_vitima: \(ufVitima)")
                    print("\tcidade_vitima: \(cidadeVitima)")
                    print("\tendereco_vitima: \(enderecoVitima)")
                    print("\tid_faixa_etaria: \(idFaixaEtaria)")
                    print("\tid_cor_raca: \(idCorRaca)")
                    print("\tid_sexo: \(idSexo)")
                    print("\tid_orientacao_sexual: \(idOrientacaoSexual)")
                    print("\tid_local: \(idLocal)")
                    print("\tnome_suspeito: \(nomeSuspeito)")
                    print("\tendereco_suspeito: \(enderecoSuspeito)")
                    print("\tuf_suspeito: \(ufSuspeito)")
                    print("\tcidade_suspeito: \(cidadeSuspeito)")
                    print("\tid_tipo_violacao: \(idTipoViolacao)")
                    print("\tid_violacao: \(idViolacao)")
                    print("\toutra_violacao: \(outraViolacao)")
                    print("\torgao_acionado: \(orgaoAcionado)")
                    print("\tdescricao_denuncia: \(descricaoDenuncia)")
                    
                    print("")
                    print("XML enviado para o servidor:")
                    print(content)
                    print("")
                    // -------------
                    
                    completion(complaintProtocol, nil)
                    return
                } catch {
                    completion(nil, nil)
                    return
                }
            }
        }
    }
    
}
