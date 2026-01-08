<%-- 
    Document   : index
    Created on : Jan 9, 2026, 1:05:27 AM
    Author     : andik
--%>

<%@ page import="java.util.List" %>
<%@ page import="com.indiemusic.model.Song" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0"> 
    <title>YT Music Clone</title>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">
    
    <style>
        /* --- TEMA YT MUSIC --- */
        * { box-sizing: border-box; }
        
        body {
            background-color: #030303; /* Hitam Pekat YT Music */
            color: #ffffff;
            font-family: 'Roboto', sans-serif; /* Font khas Android/Google */
            margin: 0; padding: 0;
        }

        /* Navbar Sederhana */
        .navbar {
            padding: 20px;
            display: flex; align-items: center; gap: 10px;
            background-color: #030303;
            position: sticky; top: 0; z-index: 100;
            border-bottom: 1px solid #222;
        }
        
        .logo-text {
            font-weight: 700; font-size: 1.5rem; letter-spacing: -0.5px;
            display: flex; align-items: center; gap: 8px;
        }
        .logo-circle {
            width: 30px; height: 30px; border-radius: 50%;
            background: red; display: flex; align-items: center; justify-content: center;
        }
        .play-icon {
            width: 0; height: 0; 
            border-top: 5px solid transparent; border-bottom: 5px solid transparent;
            border-left: 8px solid white; margin-left: 2px;
        }

        .container { max-width: 1400px; margin: 0 auto; padding: 20px; }

        /* --- SEARCH BAR ALA YT MUSIC --- */
        .search-container { margin-bottom: 40px; margin-top: 10px; }
        .search-form {
            display: flex; width: 100%; max-width: 700px; margin: 0 auto;
            background-color: #212121; border-radius: 8px; overflow: hidden;
            border: 1px solid #333;
        }
        input[type="text"] {
            flex: 1; padding: 12px 20px;
            background: transparent; border: none; font-size: 1rem;
            color: white; font-family: 'Roboto', sans-serif;
        }
        input[type="text"]::placeholder { color: #aaa; }
        input[type="text"]:focus { outline: none; }
        
        button {
            padding: 0 25px; background-color: #2b2b2b; border: none;
            color: #aaa; cursor: pointer; border-left: 1px solid #333;
            font-weight: 500; transition: 0.2s;
        }
        button:hover { background-color: #3f3f3f; color: white; }

        /* --- GRID CONTENT --- */
        .grid-container {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 24px;
        }

        .card {
            background-color: transparent; /* Kartu transparan */
            border-radius: 4px; 
            display: flex; flex-direction: column;
            transition: 0.3s;
        }
        
        /* Video Container dengan Border Radius Khas */
        .video-wrapper {
            position: relative;
            width: 100%;
            padding-top: 56.25%; /* 16:9 */
            background: #111;
            border-radius: 12px; /* Radius YT Music */
            overflow: hidden;
            margin-bottom: 12px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.3);
        }
        .video-wrapper iframe {
            position: absolute; top: 0; left: 0; width: 100%; height: 100%;
        }

        .info { padding: 0 5px; }
        .song-title {
            font-weight: 700; font-size: 1rem; margin-bottom: 4px;
            white-space: nowrap; overflow: hidden; text-overflow: ellipsis;
        }
        .artist {
            color: #aaa; font-size: 0.9rem; font-weight: 400;
        }
        
        /* Mobile */
        @media (max-width: 600px) {
            .navbar { justify-content: center; }
            .search-form { width: 100%; }
        }
    </style>
</head>
<body>

<div class="navbar">
    <div class="logo-text">
        <div class="logo-circle"><div class="play-icon"></div></div>
        Music
    </div>
</div>

<div class="container">
    <div class="search-container">
        <form action="search" method="GET" class="search-form">
            <input type="text" name="q" placeholder="Search songs, albums, artists..." 
                   value="<%= request.getAttribute("searchKeyword") != null ? request.getAttribute("searchKeyword") : "" %>" required autocomplete="off">
            <button type="submit">SEARCH</button>
        </form>
    </div>

    <div class="grid-container">
        <%
            List<Song> songs = (List<Song>) request.getAttribute("songList");
            if (songs != null && !songs.isEmpty()) {
                for (Song s : songs) {
        %>
            <div class="card">
                <div class="video-wrapper">
                    <iframe 
                        src="https://www.youtube.com/embed/<%= s.getVideoId() %>" 
                        title="<%= s.getTitle() %>"
                        frameborder="0" 
                        allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" 
                        allowfullscreen>
                    </iframe>
                </div>
                <div class="info">
                    <div class="song-title"><%= s.getTitle() %></div>
                    <div class="artist"><%= s.getChannelName() %> • Video</div>
                </div>
            </div>
        <%
                }
            } else if (request.getAttribute("searchKeyword") != null) {
        %>
            <p style="text-align: center; color: #aaa; width: 100%;">No music found.</p>
        <%
            }
        %>
    </div>
</div>

</body>
</html>
