//
//  FirebaseDeleteService.swift
//  DeleteUserDataFirebase
//
//  Created by Adem Tarhan on 2.08.2022.
//

import Alamofire
import FirebaseAuth
import FirebaseDatabase
import Foundation

protocol FirebaseDeleteService: AnyObject {
    func delete(_ completionHandler: @escaping (Result<Any, FirebaseError>) -> Void)
}

class FirbaseDeleteServiceImpl: FirebaseDeleteService {
    var ref: DatabaseReference!
    fileprivate var timer: Timer?

    private var myCompletionHandler: ((Result<Any, FirebaseError>) -> Void)?

    private func setUpTimer(for interval: TimeInterval) {
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(didTimerFire), userInfo: nil, repeats: false)
            RunLoop.main.add(timer!, forMode: .common)
        }
    }

    @objc func didTimerFire() {
        myCompletionHandler?(.failure(.timeOut))
    }

    private func invalidateTimer() {
        if let _ = timer {
            timer?.invalidate()
            timer = nil
        }
    }

    init() {
        ref = Database.database().reference()
    }

    /*
     var arr = [String]()

     private func deleteTEST(arr: [String]) {
         if !arr.isEmpty {
             ref.child(arr.first!).removeValue { error, _ in
                 if let err = error {
                     // ERROR
                 } else {
                     self.deleteTEST(arr: arr)
                 }
             }
         } else {
             // DONE
         }
     }
      */

    // MARK: main delete function

    func delete(_ completionHandler: @escaping (Result<Any, FirebaseError>) -> Void) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        let group = DispatchGroup()
        var index = 0
        group.enter()
        if NetworkReachabilityManager()!.isReachable {
            myCompletionHandler = completionHandler
            setUpTimer(for: 20)
            fetchAquariums { aquariums in
                guard let aquariums = try? aquariums.get() else { return }
                aquariums.forEach { aquarium in
                    self.startTransactionOfAquariumDeletion(aquariumID: aquarium) { result in
                        print("startTransactionOfAquariumDeletion finished")
                        switch result {
                        case .success:
                            index += 1
                            if index == aquariums.count {
                                group.leave()
                            }
                        case .failure:
                            completionHandler(.failure(.deleteAccountError))
                        }
                    }
                }
                group.enter()
                self.deleteUserFromUsers(userID: userID) { result in
                    print("deleteUserFromUsers finished")
                    switch result {
                    case .success:
                        group.leave()
                    case .failure:
                        completionHandler(.failure(.deleteUserError))
                    }
                }
                group.enter()
                self.deleteUserFromAuthentication(userID: userID) { result in
                    print("deleteAccount from auth")
                    switch result {
                    case .success:
                        group.leave()
                    case .failure:
                        completionHandler(.failure(.deleteUserError))
                    }
                }

                group.notify(queue: .global(qos: .background)) {
                    print("deleteAccount finished")
                    completionHandler(.success(true))
                }
            }
        }
    }

    // MARK: fetch aquariums

    private func fetchAquariums(_ completionHandler: @escaping (Result<[String], FirebaseError>) -> Void) {
        print("willFetchAquariums")
        guard let userID = Auth.auth().currentUser?.uid else { return }
        ref.child("Users").child(userID).getData { error, snapshot in
            if let _ = error {
                completionHandler(.failure(.timeOut))
            } else {
                guard let value = snapshot.value as? [String: Any] else { return }
                guard let aquariums = value["aquariums"] as? [String: Any] else { return }
                let aquariumIDs = Array(aquariums.keys) // .sorted() // for testing
                print("didFetchAquariums -> \(aquariumIDs)")

                completionHandler(.success(aquariumIDs))
            }
        }
    }

    // MARK: deletion aquarium with aquariumID

    private func startTransactionOfAquariumDeletion(aquariumID: String, _ completionHandler: @escaping (Result<Any, FirebaseError>) -> Void) {
        print("willStartTransactionOfAquariumDeletion -> \(aquariumID)")
        guard let userID = Auth.auth().currentUser?.uid else { return }
        fetchDevices(forAquariumID: aquariumID) { devices in
            guard let devices = try? devices.get() else { return }
            let group = DispatchGroup()

            devices.forEach { device in
                group.enter()
                self.startTransactionOfDeviceDeletion(aquariumID: aquariumID, deviceID: device) { _ in
                    do {
                        self.deleteAquariumIDFromUser(userID: userID, aquariumID: aquariumID) { _ in
                            do {
                                print("didFinishTransactionOfAquariumDeletion -> \(aquariumID)")
                                group.leave()

                            } catch {
                                completionHandler(.failure(.deleteAquariumError))
                            }
                        }

                    } catch {
                        completionHandler(.failure(.deleteDeviceError))
                    }
                }
            }

            group.notify(queue: .global(qos: .background)) {
                completionHandler(.success(true))
            }
        }
    }

    // MARK: fetch devices

    private func fetchDevices(forAquariumID aquarium: String, _ completionHandler: @escaping (Result<[String], FirebaseError>) -> Void) {
        print("willFetchDevicesForAquarium -> \(aquarium)")

        ref.child("aquariums").child(aquarium).getData { error, snapshot in
            if let _ = error {
                completionHandler(.failure(.timeOut))
            } else {
                guard let value = snapshot.value as? [String: Any] else { return }
                guard let devices = value["devices"] as? [String: Any] else { return }
                let deviceIDs = Array(devices.keys)
                print("didFetchDevicesForAquarium -> \(aquarium) v-> \(devices)")
                completionHandler(.success(deviceIDs))
            }
        }
    }

    // MARK: deletion device with deviceID

    private func startTransactionOfDeviceDeletion(aquariumID: String, deviceID: String, _ completionHandler: @escaping (Result<Any, FirebaseError>) -> Void) {
        print("willStartTransactionOfDeviceDeletion -> \(aquariumID) -> \(deviceID)")
        ref.child("devices").child(deviceID).removeValue { error, _ in
            if let _ = error {
                // Stop transaction
                completionHandler(.failure(.timeOut))

            } else {
                // Delete device id from aquarium
                self.deleteDeviceIDFromAquarium(aquariumID: aquariumID, deviceID: deviceID) { _ in
                    do {
                        completionHandler(.success(true))

                    } catch {
                        completionHandler(.failure(.deleteDeviceError))
                    }
                }
            }
        }
    }

    // MARK: deletion deviceID from aquarium

    private func deleteDeviceIDFromAquarium(aquariumID: String, deviceID: String, _ completionHandler: @escaping (Result<Any, FirebaseError>) -> Void) {
        print("willDeleteDeviceIDFromAquarium -> \(aquariumID) -> \(deviceID)")
        ref.child("aquariums").child(aquariumID).child("devices").child(deviceID).removeValue { error, _ in
            if let _ = error {
                // Stop transaction
                completionHandler(.failure(.timeOut))

            } else {
                print("didDeleteDeviceIDFromAquarium -> \(aquariumID) -> \(deviceID)")
                completionHandler(.success(true))
            }
        }
    }

    // MARK: deletion aquariumID from user

    private func deleteAquariumIDFromUser(userID: String, aquariumID: String, _ completionHandler: @escaping (Result<Any, FirebaseError>) -> Void) {
        print("willDeleteAquariumIDFromUser -> \(aquariumID) -> \(userID)")
        ref.child("Users").child(userID).child("aquariums").child(aquariumID).removeValue { error, _ in
            if let error = error {
                // Stop transaction
                completionHandler(.failure(.timeOut))

            } else {
                print("didDeleteAquariumIDFromUser -> \(aquariumID) -> \(userID)")
                completionHandler(.success(true))
            }
        }
    }

    // MARK: deletion user from users with userID

    private func deleteUserFromUsers(userID: String, completionHandler: @escaping (Result<Any, FirebaseError>) -> Void) {
        let ref = ref.child("Users").child(userID).ref
        removeData(ref: ref) { result in
            switch result {
            case .success:
                completionHandler(.success(true))
            case .failure:
                completionHandler(.failure(.deleteUserError))
            }
        }
    }

    // MARK: remove data function for repetitive code

    func removeData(ref: DatabaseReference, completion: @escaping (Result<Any, Error>) -> Void) {
        ref.removeValue { error, _ in
            if let err = error {
                print(err.localizedDescription)
                completion(.failure(err))
            } else {
                completion(.success(true))
            }
        }
    }

    // MARK: deletion user from authentication

    func deleteUserFromAuthentication(userID: String, completionHandler: @escaping (Result<Any, FirebaseError>) -> Void) {
        Auth.auth().currentUser?.delete(completion: { error in
            if let _ = error {
                completionHandler(.failure(.deleteAccountError))

            } else {
                completionHandler(.success(true))
            }
        })
    }
}
