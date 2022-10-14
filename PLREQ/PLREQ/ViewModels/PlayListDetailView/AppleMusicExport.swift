//
//  AppleMusicExport.swift
//  PLREQ
//
//  Created by 이주화 on 2022/10/13.
//

import Foundation
import MusicKit
import StoreKit

@available(iOS 16.0, *)
final class AppleMusicExport: MusicPlaylistAddable, Sendable {
    var id: MusicItemID = ""
    var check: Bool = false
    
    // 사용자가 애플 뮤직을 구독 중인지 확인
    func appleMusicSubscription() -> Bool {
        SKCloudServiceController().requestCapabilities { (capability:SKCloudServiceCapability, err:Error?) in
            // 에러 발생시
            guard err == nil else { return }
            // 사용자가 애플 뮤직을 구독 중이라면
            if capability.contains(SKCloudServiceCapability.musicCatalogPlayback) { self.check = true }
            // 사용자가 애플 뮤직을 구독 중이지 않다면
            if capability.contains(SKCloudServiceCapability.musicCatalogSubscriptionEligible) { self.check = false }
        }
        return check
    }
    
    // 플레이리스트 추가 및 음악 목록 추가
    func addPlayList(name: String, musicList: [String]) {
        Task {
            let newPlayList = try await MusicLibrary.shared.createPlaylist(name: name, description: "PLREQ에서 생성된 플레이리스트 입니다.", authorDisplayName: "PLREQ")
            musicList.forEach() { musicTitle in
                Task {
                    var request = MusicCatalogSearchRequest.init(term: musicTitle, types: [Song.self])
                    request.includeTopResults = true
                    let reponse = try await request.response()
                    try await MusicLibrary.shared.add(reponse.songs.first!, to: newPlayList)
                }
            }
        }
    }
    
    // 이름을 지정해서 해당 플레이리스트에 노래 추가
    func addSongsToPlayList(name: String, musicList: [String]) {
        Task {
            let request = MusicLibrarySearchRequest(term: name, types: [Playlist.self])
            let response = try await request.response()
            Task {
                musicList.forEach() { musicTitle in
                    Task {
                        var request = MusicCatalogSearchRequest.init(term: musicTitle, types: [Song.self])
                        request.includeTopResults = true
                        let reponse = try await request.response()
                        try await MusicLibrary.shared.add(reponse.songs.first!, to: response.playlists[0])
                    }
                }
            }
        }
    }
    
    // 이름을 지정해서 해당 플레이리스트에서 노래 불러오기
    // 개발 예정
    
}