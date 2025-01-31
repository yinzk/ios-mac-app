//
//  NetworkServer.swift
//  vpncore - Created on 08.03.2021.
//
//  Copyright (c) 2019 Proton Technologies AG
//
//  This file is part of vpncore.
//
//  vpncore is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  vpncore is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with vpncore.  If not, see <https://www.gnu.org/licenses/>.
//

import Foundation
import Network

final class NetworkServer {
    let port: NWEndpoint.Port
    let listener: NWListener

    let responseCondition: ((Data) -> Bool)
    var ready: (() -> Void)?

    private var connectionsByID: [Int: ServerConnection] = [:]

    init(port: UInt16, parameters: NWParameters, responseCondition: @escaping ((Data) -> Bool)) {
        self.port = NWEndpoint.Port(rawValue: port)!
        self.responseCondition = responseCondition
        listener = try! NWListener(using: parameters, on: self.port)
    }

    func start() throws {
        listener.stateUpdateHandler = self.stateDidChange(to:)
        listener.newConnectionHandler = self.didAccept(nwConnection:)
        listener.start(queue: .global(qos: .utility))
    }

    func stateDidChange(to newState: NWListener.State) {
        switch newState {
        case .ready:
            print("Server ready on port \(port).")
            ready?()
        case .failed(let error):
            print("Server failure on port \(port), error: \(error.localizedDescription)")
        default:
            print(newState)
        }
    }

    private func didAccept(nwConnection: NWConnection) {
        let connection = ServerConnection(nwConnection: nwConnection, port: Int(port.rawValue))
        connection.responseCondition = responseCondition
        print("Accepted connection \(connection.id) on port \(port)")
        self.connectionsByID[connection.id] = connection
        connection.didStopCallback = { _ in
            self.connectionDidStop(connection)
        }
        connection.start()
    }

    private func connectionDidStop(_ connection: ServerConnection) {
        self.connectionsByID.removeValue(forKey: connection.id)
        print("Server on port \(port) did close connection \(connection.id)")
    }

    func stop() {
        self.listener.stateUpdateHandler = nil
        self.listener.newConnectionHandler = nil
        self.listener.cancel()
        for connection in self.connectionsByID.values {
            connection.didStopCallback = nil
            connection.stop()
        }
        self.connectionsByID.removeAll()
    }
}

final class ServerConnection {
    private let MTU = 65536
    private static var nextID: Int = 0
    private let connection: NWConnection
    let id: Int
    let port: Int

    init(nwConnection: NWConnection, port: Int) {
        self.port = port
        connection = nwConnection
        id = ServerConnection.nextID
        ServerConnection.nextID += 1
    }

    var didStopCallback: ((Error?) -> Void)? = nil
    var responseCondition: ((Data) -> Bool)? = nil

    func start() {
        print("Connection \(id) on port \(port) will start")
        connection.stateUpdateHandler = self.stateDidChange(to:)
        setupReceive()
        connection.start(queue: .main)
    }

    private func stateDidChange(to state: NWConnection.State) {
        switch state {
        case .waiting(let error):
            connectionDidFail(error: error)
        case .ready:
            print("Connection \(id) on port \(port) ready")
        case .failed(let error):
            connectionDidFail(error: error)
        default:
            break
        }
    }

    private func setupReceive() {
        connection.receive(minimumIncompleteLength: 1, maximumLength: MTU) { (data, _, isComplete, error) in
            if let data = data, !data.isEmpty {
                print("Connection \(self.id) on port \(self.port) did receive, data: \(data as NSData)")
                if let condition = self.responseCondition, condition(data) {
                    print("Replying to connection \(self.id) on port \(self.port)")
                    self.send(data: data)
                }
            }

            if let error = error {
                self.connectionDidFail(error: error)
            } else {
                self.setupReceive()
            }
        }
    }


    func send(data: Data) {
        self.connection.send(content: data, completion: .contentProcessed( { error in
            if let error = error {
                self.connectionDidFail(error: error)
                return
            }
            print("Connection \(self.id) did send, data: \(data as NSData)")
        }))
    }

    func stop() {
        print("Connection \(id) will stop")
    }

    private func connectionDidFail(error: Error) {
        print("Connection \(id) did fail, error: \(error)")
        stop(error: error)
    }

    private func connectionDidEnd() {
        print("Connection \(id) on port \(port) did end")
        stop(error: nil)
    }

    private func stop(error: Error?) {
        connection.stateUpdateHandler = nil
        connection.cancel()
        if let didStopCallback = didStopCallback {
            self.didStopCallback = nil
            didStopCallback(error)
        }
    }
}
