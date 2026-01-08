package com.indiemusic.service;

import com.indiemusic.model.Song;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.Response;

import javax.net.ssl.*;
import java.security.cert.CertificateException;
import java.util.ArrayList;
import java.util.List;

public class YouTubeService {
    
    // 👇 PASTIKAN API KEY KAMU MASIH ADA DI SINI 👇
    private static final String API_KEY = "AIzaSyDoFEojixOMl4yTl1YvvoI5zDjkB_LrK6o"; 
    
    private OkHttpClient client;

    public YouTubeService() {
        this.client = getUnsafeOkHttpClient();
    }

    public List<Song> searchVideos(String query) {
        List<Song> songList = new ArrayList<>();
        
        if (query == null || query.trim().isEmpty()) return songList;

        try {
            String cleanQuery = query.replaceAll(" ", "+");
            
            // --- UPGRADE: Filter "videoCategoryId=10" (Khusus Musik) ---
            String url = "https://www.googleapis.com/youtube/v3/search"
                    + "?part=snippet"
                    + "&maxResults=12"
                    + "&q=" + cleanQuery
                    + "&type=video"
                    + "&videoCategoryId=10" // <--- INI MAGICNYA BIAR JADI YT MUSIC
                    + "&key=" + API_KEY;

            Request request = new Request.Builder().url(url).build();

            try (Response response = client.newCall(request).execute()) {
                if (response.isSuccessful() && response.body() != null) {
                    String jsonString = response.body().string();
                    JsonObject rootNode = JsonParser.parseString(jsonString).getAsJsonObject();
                    
                    if (rootNode.has("items")) {
                        JsonArray items = rootNode.getAsJsonArray("items");

                        for (int i = 0; i < items.size(); i++) {
                            JsonObject item = items.get(i).getAsJsonObject();
                            JsonObject snippet = item.get("snippet").getAsJsonObject();
                            
                            String videoId = item.get("id").getAsJsonObject().get("videoId").getAsString();
                            
                            // Decode HTML entities di judul biar rapi
                            String title = snippet.get("title").getAsString()
                                    .replace("&quot;", "\"").replace("&#39;", "'").replace("&amp;", "&");
                                    
                            String channel = snippet.get("channelTitle").getAsString();
                            
                            String thumbnail = "";
                            if (snippet.get("thumbnails").getAsJsonObject().has("high")) {
                                thumbnail = snippet.get("thumbnails").getAsJsonObject().get("high").getAsJsonObject().get("url").getAsString();
                            } else {
                                thumbnail = snippet.get("thumbnails").getAsJsonObject().get("medium").getAsJsonObject().get("url").getAsString();
                            }

                            songList.add(new Song(title, channel, thumbnail, videoId));
                        }
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return songList;
    }

    // --- TETEP PAKE BYPASS SSL ---
    private static OkHttpClient getUnsafeOkHttpClient() {
        try {
            final TrustManager[] trustAllCerts = new TrustManager[] {
                new X509TrustManager() {
                    @Override
                    public void checkClientTrusted(java.security.cert.X509Certificate[] chain, String authType) throws CertificateException {}
                    @Override
                    public void checkServerTrusted(java.security.cert.X509Certificate[] chain, String authType) throws CertificateException {}
                    @Override
                    public java.security.cert.X509Certificate[] getAcceptedIssuers() { return new java.security.cert.X509Certificate[]{}; }
                }
            };
            final SSLContext sslContext = SSLContext.getInstance("SSL");
            sslContext.init(null, trustAllCerts, new java.security.SecureRandom());
            final SSLSocketFactory sslSocketFactory = sslContext.getSocketFactory();
            OkHttpClient.Builder builder = new OkHttpClient.Builder();
            builder.sslSocketFactory(sslSocketFactory, (X509TrustManager)trustAllCerts[0]);
            builder.hostnameVerifier((hostname, session) -> true);
            return builder.build();
        } catch (Exception e) { throw new RuntimeException(e); }
    }
}