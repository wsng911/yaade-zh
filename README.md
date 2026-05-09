# Yaade

## 功能特性

- 创建和管理 API 请求集合
- 支持 GET/POST/PUT/DELETE 等 HTTP 方法
- 环境变量管理
- 请求脚本（Pre/Post）
- WebSocket 支持
- 多用户协作
- OAuth2 认证

## 快速部署

```bash
docker run -d \
  -p 9339:9339 \
  -v $(pwd)/data:/app/data \
  --name yaade-zh \
  wsng911/yaade-zh:latest
```

访问 `http://localhost:9339`，默认账号 `admin` / `password`
