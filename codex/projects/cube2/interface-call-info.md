# Cube2 接口调用必要信息

本文档记录 Cube2 各环境接口调试和调用所需的最小请求信息。进行接口调用或调试前，先按调用环境或接口路径检索对应章节。

## 环境地址与通用请求头

环境地址规则：

```text
本地： http://localhost:<用户确认的端口>
测试： https://cube-test.guhecloud.com:3000/api/<应用网关前缀>/<接口路径>
```

本地端口必须在调用前向用户确认。测试环境的应用网关前缀必须通过接口路径或业务关键词定位应用，再从该应用的 `server/BUILD.bazel` 中读取 `server_info.gw_prefix` 确认。

请求方法和地址模板：

```text
# 本地环境（端口需调用前确认）
<METHOD> http://localhost:${CUBE2_LOCAL_PORT}/<接口路径>

# 测试环境（网关前缀需从目标应用 server/BUILD.bazel 确认）
<METHOD> https://cube-test.guhecloud.com:3000/api/<网关前缀>/<接口路径>
```

必要请求头：

```text
tenant: <当前确认的租户>
terminal: bimops-manage-web
Authorization: Bearer ${CUBE2_BEARER_TOKEN}
User-Agent: Apifox/1.0.0 (https://apifox.com)
Content-Type: application/json
Accept: */*
Host: <按调用环境生成的 Host>
Connection: keep-alive
```

调用前根据已确认的环境、租户和当前会话准备请求头；不得从本文件推断具体应用、网关前缀、租户或 Token。
