package main

import (
	"fmt"
	"net/http"
)

func handler(writer http.ResponseWriter, request *http.Request) {
	fmt.Println(request.URL.Path[1:])
	fmt.Fprintf(writer, "Hello World, %s!", request.URL.Path[1:])
}

func main() {
	// Handle和HandleFunc函数可以向DefaultServerMux添加处理器。
	// 把之前定义的handler函数设置为根URL被访问时的处理器。
	http.HandleFunc("/", handler)
	// ListenAndServer使用指定的监听地址和处理器启动一个HTTP服务端。处理器参数通常是nil，这表示采用包变量DefaultServerMux作为处理器。
	// 启动服务器并让它监听系统的8080端口。
	http.ListenAndServe(":8080", nil)
}
