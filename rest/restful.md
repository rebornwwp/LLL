# RESTful 
REST : Representational State Transfer


一种软件架构风格，设计风格而不是标准，只是提供了一组设计原则和约束条件。它主要用于客户端和服务器交互类的软件。基于这个风格设计的软件可以更简洁，更有层次，更易于实现缓存等机制。


Web 应用程序最重要的 REST 原则是，客户端和服务器之间的交互在请求之间是无状态的。从客户端到服务器的每个请求都必须包含理解请求所必需的信息。如果服务器在请求之间的任何时间点重启，客户端不会得到通知。此外，无状态请求可以由任何可用服务器回答，这十分适合云计算之类的环境。客户端可以缓存数据以改进性能。

在服务器端，应用程序状态和功能可以分为各种资源。资源是一个有趣的概念实体，它向客户端公开。资源的例子有：应用程序对象、数据库记录、算法等等。每个资源都使用 URI (Universal Resource Identifier) 得到一个唯一的地址。所有资源都共享统一的接口，以便在客户端和服务器之间传输状态。使用的是标准的 HTTP 方法，比如 GET、PUT、POST 和 DELETE。Hypermedia 是应用程序状态的引擎，资源表示通过超链接互联。

另一个重要的 REST 原则是分层系统，这表示组件无法了解它与之交互的中间层以外的组件。通过将系统知识限制在单个层，可以限制整个系统的复杂性，促进了底层的独立性。
当 REST 架构的约束条件作为一个整体应用时，将生成一个可以扩展到大量客户端的应用程序。它还降低了客户端和服务器之间的交互延迟。统一界面简化了整个系统架构，改进了子系统之间交互的可见性。REST 简化了客户端和服务器的实现。

# post put patch方法的区别

 The fundamental difference between the POST and PUT requests is reflected in the different meaning of the Request-URI.
The URI in a POST request identifies the resource that will handle the enclosed entity.
That resource might be a data-accepting process, a gateway to some other protocol, or a separate entity that accepts annotations.
In contrast, the URI in a PUT request identifies the entity enclosed with the request --
the user agent knows what URI is intended and the server MUST NOT attempt to apply the request to some other resource.

* POST = 新增
* GET = 读取
* PUT = 更新(Replace (Create or Update)))(数据存在的话，就直接整体替换)
* DELETE = 删除
* patch = 局部跟新(partial update) 数据已经存在，不是重新覆盖，而是将数据中的某些属性替换
