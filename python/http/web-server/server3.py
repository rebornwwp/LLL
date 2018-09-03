# -*- coding=utf-8 -*-
import http.server as server
import os
import subprocess
import sys


class ServerException(Exception):
    '''
    服务器内部错误
    '''
    pass


class Case_no_file(object):
    '''该路径不存在'''

    def test(self, handler):
        return not os.path.exists(handler.full_path)

    def act(self, handler):
        raise ServerException("'{0}' not found".format(handler.path))


class Case_existing_file(object):
    '''该路径是文件'''

    def test(self, handler):
        return os.path.isfile(handler.full_path)

    def act(self, handler):
        handler.handle_file(handler.full_path)


class Case_always_fail(object):
    '''所有情况都不符合时的默认处理类'''

    def test(self, handler):
        return True

    def act(self, handler):
        raise ServerException("Unknown object '{0}'".format(handler.path))


class Case_directory_index_file(object):
    def index_path(self, handler):
        return os.path.join(handler.full_path, 'index.html')

    def test(self, handler):
        return os.path.isdir(handler.full_path) and \
            os.path.isfile(self.index_path(handler))

    def act(self, handler):
        handler.handle_file(self.index_path(handler))


class Case_cgi_file(object):
    '''脚本文件处理'''

    def test(self, handler):
        return os.path.isfile(handler.full_path) and \
            handler.full_path.endswith('.py')

    def act(self, handler):
        handler.run_cgi(handler.full_path)


class RequestHandler(server.BaseHTTPRequestHandler):
    # 页面模板
    Error_Page = """\
        <html>
        <body>
        <h1>Error accessing {path}</h1>
        <p>{msg}</p>
        </body>
        </html>
        """
    # 处理一个GET请求

    Cases = [Case_no_file(),
             Case_cgi_file(),
             Case_existing_file(),
             Case_directory_index_file(),
             Case_always_fail()]

    def do_GET(self):
        try:
            # 文件完整路径
            self.full_path = os.getcwd() + self.path
            # print(self.path)
            # # 如果路径不存在
            # if not os.path.exists(full_path):
            #     raise ServerException("'{0}' not found.".format(self.path))
            # # 文件存在
            # elif os.path.isfile(full_path):
            #     self.handle_file(full_path)
            # # 路径不是一个文件
            # else:
            #     raise ServerException("Unknown object '{0}'".format(self.path))

            # 遍历所有可能的情况
            for case in self.Cases:
                if case.test(self):
                    case.act(self)
                    break
        except Exception as msg:
            self.handle_error(msg)

    def handle_file(self, full_path):
        try:
            with open(full_path, 'rb') as reader:
                content = reader.read()
            self.send_content(content)
        except IOError as msg:
            msg = "'{0}' cannot be read: {1}".format(self.path, msg)
        self.handle_error(msg)

    def handle_error(self, msg):
        content = self.Error_Page.format(path=self.path, msg=msg)
        self.send_content(content.encode('utf-8'))

    def send_content(self, page, status=200):
        self.send_response(status)
        self.send_header("Content-type", "text/html")
        self.send_header("Content-Length", str(len(page)))
        self.end_headers()
        self.wfile.write(page)

    def run_cgi(self, full_path):
        data = subprocess.check_output(["python3", full_path], shell=False)
        self.send_content(data)


if __name__ == "__main__":
    serverAddress = ("", 8080)
    ser = server.HTTPServer(serverAddress, RequestHandler)
    try:
        ser.serve_forever()
    except KeyboardInterrupt:
        pass
    ser.server_close()
