# yaade-zh Prompts

> 项目：EsperoTech/yaade 汉化版（yaade-zh）
> 技术栈：React + Vite + Chakra UI 前端，Kotlin + Vert.x 后端，H2 数据库

---

## 功能迭代

**1. 添加请求历史记录功能**
在 yaade-zh 中为每个 API 请求添加历史记录功能。每次发送请求后自动保存请求和响应到历史记录，用户可在侧边栏查看最近 50 条历史，点击可快速重放。需要修改前端 RequestPanel 和后端存储逻辑。

**2. 支持请求分组和批量运行**
在 yaade-zh 中为集合（Collection）添加批量运行功能。用户可选择集合中的多个请求，按顺序依次发送，并在结果面板中展示每个请求的状态码和耗时汇总。

**3. 添加响应数据可视化**
在 yaade-zh 的响应面板中，当响应体为 JSON 数组时，提供图表可视化选项（折线图/柱状图），使用 recharts 库渲染，帮助用户直观分析 API 返回的数据趋势。

**4. 实现请求模板变量功能**
在 yaade-zh 中扩展环境变量功能，支持在请求 URL、Headers、Body 中使用 `{{变量名}}` 语法引用环境变量，并在发送前实时预览变量替换后的最终请求内容。

**5. 添加 API 文档自动生成**
在 yaade-zh 中为集合添加"导出文档"功能，将集合中所有请求的 URL、方法、参数、示例响应自动生成 Markdown 格式的 API 文档，支持下载。

---

## Bug 修复

**6. 修复 WebSocket 连接断开后无法重连的问题**
在 yaade-zh 的 WebsocketPanel 中，当 WebSocket 连接意外断开后，点击重新连接按钮有时不生效，需要刷新页面。检查 WebsocketHandler 中的连接状态管理，确保断开后能正确清理状态并重新建立连接。

**7. 修复大响应体导致页面卡顿的问题**
在 yaade-zh 中，当 API 响应体超过 1MB 时，CodeMirror 编辑器渲染会导致页面明显卡顿。在 ResponsePanel 中添加响应体大小检测，超过阈值时截断显示并提示用户，或使用虚拟滚动优化渲染。

**8. 修复环境变量切换后请求未更新的问题**
在 yaade-zh 中，切换环境变量后，已打开的请求标签页中的变量引用不会立即更新预览。修复 EnvironmentsTab 中的状态同步逻辑，确保切换环境后所有打开的请求都能实时反映新的变量值。

**9. 修复导入 Postman 集合时中文字段名乱码**
在 yaade-zh 中导入包含中文字段名的 Postman 集合文件时，部分中文字符显示为乱码。检查 Collections 组件中的文件读取编码处理，确保使用 UTF-8 编码解析导入文件。

**10. 修复多用户同时编辑同一请求时的数据覆盖问题**
在 yaade-zh 的协作模式下，两个用户同时编辑同一个请求并保存时，后保存的会覆盖先保存的修改。在后端添加乐观锁（版本号）机制，前端在保存时携带版本号，冲突时提示用户。

---

## 重构

**11. 将 Dashboard 组件拆分为更小的子组件**
yaade-zh 的 Dashboard.tsx 文件超过 1000 行，包含了请求面板、响应面板、侧边栏等所有逻辑。把其拆分为独立的 RequestPanel、ResponsePanel、SidebarPanel 组件，每个组件不超过 200 行。

**12. 统一 API 请求层**
在 yaade-zh 前端中，各组件直接使用 `fetch` 调用 API，缺乏统一的错误处理和请求拦截。请创建 `src/api/client.ts`，封装统一的请求方法，支持自动添加认证头、统一处理 401 跳转登录。

**13. 将硬编码的颜色值迁移到 Chakra UI 主题**
在 yaade-zh 的组件中存在大量硬编码的颜色值（如 `'gray.200'`、`'green.500'`）。把这些值统一提取到 `src/theme.tsx` 的主题配置中，通过语义化 token 引用，便于统一修改主题。

---

## 测试

**14. 为 RequestSender 组件编写单元测试**
使用 Vitest + React Testing Library 为 yaade-zh 的 RequestSender 组件编写测试，覆盖：GET/POST/PUT/DELETE 请求发送、请求头添加、请求体设置、发送按钮 loading 状态。

**15. 为后端 API 路由编写集成测试**
使用 Kotlin + JUnit5 为 yaade-zh 后端的 `/api/collections` 和 `/api/requests` 路由编写集成测试，覆盖 CRUD 操作，使用内存 H2 数据库隔离测试环境。

**16. 为环境变量插值函数编写单元测试**
为 yaade-zh 前端的环境变量插值工具函数编写完整单元测试，覆盖：正常替换、嵌套变量、未定义变量的处理、特殊字符转义等边界情况。

---

## 代码理解

**17. 解释 yaade 的认证流程**
请详细解释 yaade-zh 的用户认证机制：登录接口如何工作、Session 如何维护、OAuth2 提供商如何集成、前端 UserContext 如何管理认证状态，以及 isAdmin 权限检查的实现原理。

**18. 解释 CollectionScript 的执行机制**
在 yaade-zh 中，CollectionScript 允许在请求前后执行自定义脚本。解释脚本的执行环境、可用的 API（如何访问请求/响应数据）、脚本错误如何处理，以及与 Postman 的 Pre-request Script 有何异同。

---

## DevOps

**19. 编写 GitHub Actions 自动构建流水线**
为 yaade-zh 编写 `.github/workflows/docker-build.yml`，实现：推送 main 分支时触发、使用 setup-java 安装 JDK 17、先构建前端再构建后端、最后构建多架构 Docker 镜像（amd64/arm64）并推送到 Docker Hub。

**20. 编写 docker-compose.yml 一键部署配置**
为 yaade-zh 编写 `docker-compose.yml`，包含：yaade 服务（映射 9339 端口）、数据目录挂载（`./data:/app/data`）、环境变量配置（YAADE_DB_PATH、YAADE_HEAP_SIZE）、健康检查、自动重启策略。
