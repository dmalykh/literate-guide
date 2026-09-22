server {
  listen {{listen_port}};
  server_name {{server_name}};

  location / {
    root /usr/share/nginx/html;
  }
}
