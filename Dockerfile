
# Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
# Click nbfs://nbhost/SystemFileSystem/Templates/Other/Dockerfile to edit this template

# Kita pake Tomcat (Server Java)
FROM tomcat:9.0-jdk17-openjdk-slim

# Hapus aplikasi default Tomcat biar bersih
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy hasil build NetBeans (WAR) ke folder server
# GANTI 'MusicProject.war' SESUAI NAMA FILE DI FOLDER DIST KAMU
COPY dist/MusicProject.war /usr/local/tomcat/webapps/ROOT.war

# Buka port 8080
EXPOSE 8080

# Jalankan server
CMD ["catalina.sh", "run"]