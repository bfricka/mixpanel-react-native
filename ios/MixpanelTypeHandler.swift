 import Foundation
 import Mixpanel
 
 class MixpanelTypeHandler {
    /**
     Converts given object to MixpanelType
     */
    static func ToMixpanelType(_ object: Any) -> MixpanelType? {
        switch object {
        case let value as String:
            return value as MixpanelType

        case let value as NSNumber:
            if isBoolNumber(value) {
                return value.boolValue as MixpanelType
            } else if isInvalidNumber(value) {
                return String(describing: value) as MixpanelType
            } else {
                return value as MixpanelType
            }

        case let value as Int:
            return value as MixpanelType
            
        case let value as UInt:
            return value as MixpanelType
            
        case let value as Double:
            return value as MixpanelType
            
        case let value as Float:
            return value as MixpanelType
            
        case let value as Bool:
            return value as MixpanelType
            
        case let value as Date:
            return value as MixpanelType
            
        case let value as MixpanelType:
            return value
            
        case let value as [MixpanelType]:
            return value
            
        case let value as [String: MixpanelType]:
            return value
            
        case let value as URL:
            return value
            
        case let value as NSNull:
            return value
            
        default:
            return nil
        }
    }
    
    private static func isBoolNumber(_ num: NSNumber) -> Bool
    {
        let boolID = CFBooleanGetTypeID()
        let numID = CFGetTypeID(num)
        return numID == boolID
    }

    private static func isInvalidNumber(_ num: NSNumber) -> Bool
    {
        return num.doubleValue.isInfinite || num.doubleValue.isNaN
    }

    /**
     Merge User added properties and Automatic properties
     */
    static func processProperties(properties: Dictionary<String, Any>? = nil, includeLibInfo: Bool = false) -> Dictionary<String, MixpanelType> {
        var mpProperties = Dictionary<String, MixpanelType>()
        for (key,value) in properties ?? [:] {
            mpProperties[key] = ToMixpanelType(value)
        }
        if (includeLibInfo) {
            mpProperties.merge(dict: AutomaticProperties.peopleProperties)
        }
        return mpProperties
    }
 }
 
 extension Dictionary {
    mutating func merge(dict: [Key: Value]){
        for (k, v) in dict {
            updateValue(v, forKey: k)
        }
    }
 }
