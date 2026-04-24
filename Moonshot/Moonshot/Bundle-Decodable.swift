//
//  Bundle-Decodable.swift
//  Moonshot
//
//  Created by Merve Akçakaya on 21.04.2026.
//

import Foundation
extension Bundle{
    func decode<T: Codable>(_ file: String)->T{
        //burada try? kullanmadık cunku URL? döner yani hata fırlatmaz. Sonuç ya vardır ya nil'dir
        guard let url = self.url(forResource: file, withExtension: nil)else{
            fatalError( "File \(file) not found")
        }
        //burada try? kullandık cunku Data struct'ının initinde throws keywordu var. try? kullanmak zorundayız.
        guard let data = try? Data(contentsOf: url)else{
            fatalError( "File \(file) cannot be read")
        }
        let decoder = JSONDecoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "y-MM-dd"
        decoder.dateDecodingStrategy = .formatted(formatter)
        
        do{
            return try decoder.decode(T.self, from: data)
        }catch DecodingError.keyNotFound(let key, let context){
            fatalError("Failed to decode \(file) from bundle due to missing key: \(key.stringValue) - \(context.debugDescription)")
        }catch DecodingError.typeMismatch(_, let context){
            fatalError("Failed to decode \(file) from bundle due to type mismatch - \(context.debugDescription)")
        }catch DecodingError.dataCorrupted(let context){
            fatalError( "Failed to decode \(file) from bundle due to data corruption - \(context.debugDescription)")
        }catch DecodingError.valueNotFound(let type, let context){
            fatalError("Failed to decode \(file) from bundle due to value not found: \(type) - \(context.debugDescription)")
        }
        catch{
            fatalError("Failed to decode \(file) from bundle: \(error.localizedDescription)")
        }
        
        
    }
}
