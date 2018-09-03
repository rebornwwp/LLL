import http.server as server


class RequestHandler(server.BaseHTTPRequestHandler):
    # 页面模板
    page = '''\
        <html>
        <body>
        <p>Hello, web!</p>
        </body>
        </html>
        '''

    # 处理一个GET请求
    def do_GET(self):
        self.send_response(200)
        self.send_header("Content-Type", "text/html")
        self.send_header("Content-Length", str(len(self.page)))
        self.end_headers()
        self.wfile.write(self.page.encode("utf-8"))


if __name__ == "__main__":
    serverAddress = ("", 8080)
    ser = server.HTTPServer(serverAddress, RequestHandler)
    try:
        ser.serve_forever()
    except KeyboardInterrupt:
        pass
    ser.server_close()
