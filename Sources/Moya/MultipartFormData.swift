import Foundation
import Alamofire

/// Represents "multipart/form-data" for an upload.
// 上传文件时。采用的的multipart/from-data的content-type
public struct MultipartFormData {

    /// Method to provide the form data.
    public enum FormDataProvider {
        case data(Foundation.Data)
        case file(URL)
        case stream(InputStream, UInt64)
    }

    //name 对应的是远程的文件名
    //filename对应的是本地的文件名
    //mimeType表示Content的细分的文件类型
    public init(provider: FormDataProvider, name: String, fileName: String? = nil, mimeType: String? = nil) {
        self.provider = provider
        self.name = name
        self.fileName = fileName
        self.mimeType = mimeType
    }

    /// The method being used for providing form data.
    public let provider: FormDataProvider

    /// The name.
    public let name: String

    /// The file name.
    public let fileName: String?

    /// The MIME type
    public let mimeType: String?

}

// MARK: RequestMultipartFormData appending
//表示可以一次上传多个文件
internal extension RequestMultipartFormData {
    func append(data: Data, bodyPart: MultipartFormData) {
        append(data, withName: bodyPart.name, fileName: bodyPart.fileName, mimeType: bodyPart.mimeType)
    }

    func append(fileURL url: URL, bodyPart: MultipartFormData) {
        if let fileName = bodyPart.fileName, let mimeType = bodyPart.mimeType {
            append(url, withName: bodyPart.name, fileName: fileName, mimeType: mimeType)
        } else {
            append(url, withName: bodyPart.name)
        }
    }

    func append(stream: InputStream, length: UInt64, bodyPart: MultipartFormData) {
        append(stream, withLength: length, name: bodyPart.name, fileName: bodyPart.fileName ?? "", mimeType: bodyPart.mimeType ?? "")
    }

    func applyMoyaMultipartFormData(_ multipartBody: [Moya.MultipartFormData]) {
        for bodyPart in multipartBody {
            switch bodyPart.provider {
            case .data(let data):
                append(data: data, bodyPart: bodyPart)
            case .file(let url):
                append(fileURL: url, bodyPart: bodyPart)
            case .stream(let stream, let length):
                append(stream: stream, length: length, bodyPart: bodyPart)
            }
        }
    }
}
