package com.indiemusic.controller;

import com.indiemusic.model.Song;
import com.indiemusic.service.YouTubeService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/search")
public class SearchController extends HttpServlet {

    private YouTubeService youtubeService = new YouTubeService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String query = request.getParameter("q");
        
        if (query != null && !query.trim().isEmpty()) {
            List<Song> songs = youtubeService.searchVideos(query);
            request.setAttribute("songList", songs);
            request.setAttribute("searchKeyword", query);
        }

        request.getRequestDispatcher("index.jsp").forward(request, response);
    }
}