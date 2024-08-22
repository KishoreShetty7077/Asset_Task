//
//  ViewModel.swift
//  Task
//
//  Created by Kishore Shetty on 25/02/21.
//

import Foundation

class VehicleViewModel: NSObject{
    
    func getVehicleDetails(completion: @escaping(_ vehicle: VehicleModel?, _ error: String?)->Void){
        let user = SendParameters(clientid: 11, enterprise_code: 1007, mno: "9889897789", passcode: 3476)
        API_HANDLER.getParse(urlString: APP_URL.URL, parameters: user) { (result: Result<VehicleModel, APIError>) in
            switch result {
            case .success(let success):
                completion(success, nil)
            case .failure(let failure):
                completion(nil, failure.description)
            }
        }
    }
}



struct APP_URL{
    static let URL = "http://34.70.239.163/jhsmobileapi/mobile/configure/v1/task"
}
