import http.server as server
import time

HOST_NAME = '127.0.0.1'
PORT_NUMBER = 8081


class myHandler(server.BaseHTTPRequestHandler):
    # def do_HEAD(self):
    #     self.send_response(200)
    #     self.send_header("Content-type", "text/html")
    #     self.end_headers()

    def do_GET(self):
        self.send_response(200)
        self.send_header("Content-type", "text/html")
        self.end_headers()
        message = "hello world"
        self.wfile.write(bytes(message, "utf-8"))


if __name__ == "__main__":
    serverClass = server.HTTPServer
    httpd = serverClass((HOST_NAME, PORT_NUMBER), myHandler)
    print(time.asctime(), "server starts")
    try:
        httpd.serve_forever()
    except KeyboardInterrupt:
        pass
    httpd.server_close()
    print(time.asctime(), "server stops")
