package com.indiemusic.model;

public class Song {
    private String title;
    private String channelName;   // Nama Channel (pengganti Artist)
    private String thumbnailUrl;  // Gambar Cover Video
    private String videoId;       // ID Unik Video (buat IFrame)

    public Song() {}

    public Song(String title, String channelName, String thumbnailUrl, String videoId) {
        this.title = title;
        this.channelName = channelName;
        this.thumbnailUrl = thumbnailUrl;
        this.videoId = videoId;
    }

    public String getTitle() { return title; }
    public String getChannelName() { return channelName; }
    public String getThumbnailUrl() { return thumbnailUrl; }
    public String getVideoId() { return videoId; }
}