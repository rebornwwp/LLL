# 学习笔记

## 项目目录结构

项目总体环境配置文件

* 根目录下的pom.xml文件,加载需要用到的springboot模块

代码层的结构

根目录：com.springboot

1. 工程启动类(ApplicationServer.java)置于com.springboot.build包下
2. 实体类(domain)置于com.springboot.domain
3. 数据访问层(Dao)置于com.springboot.repository
4. 数据服务层(Service)置于com,springboot.service,数据服务的实现接口(serviceImpl)至于com.springboot.service.impl
5. 前端控制器(Controller)置于com.springboot.controller
6. 工具类(utils)置于com.springboot.utils
7. 常量接口类(constant)置于com.springboot.constant
8. 配置信息类(config)置于com.springboot.config
9. 数据传输类(vo)置于com.springboot.vo

资源文件的结构

根目录:src/main/resources

1. 配置文件(.properties/.json等)置于config文件夹下
2. 国际化(i18n))置于i18n文件夹下
3. spring.xml置于META-INF/spring文件夹下
4. 页面以及js/css/image等置于static文件夹下的各自文件下

## 实际工作流程

1. 添加springboot需要用到的模块到配置文件
2. 定义domain中的类，实现数据库的基本构造
3. 数据访问层，指定相关的将一些查询函数和sql对应
4. 数据服务层，对查询出来的数据进行，更精密的包装
5. controller
6. config

