# Cookvim 使用手册

## 目录

1. [快速上手](#1-快速上手)
2. [目录结构](#2-目录结构)
3. [插件管理 (Lazy.nvim)](#3-插件管理-lazynvim)
4. [快捷键全表](#4-快捷键全表)
5. [LSP 与格式化](#5-lsp-与格式化)
6. [主题切换](#6-主题切换)
7. [文件树与文件管理](#7-文件树与文件管理)
8. [代码补全与签名帮助](#8-代码补全与签名帮助)
9. [代码折叠](#9-代码折叠)
10. [Git 操作](#10-git-操作)
11. [终端](#11-终端)
12. [会话与项目管理](#12-会话与项目管理)
13. [导航与查找](#13-导航与查找)
14. [问题诊断面板](#14-问题诊断面板)
15. [Obsess 专注工具](#15-obsess-专注工具)
16. [文档预览](#16-文档预览)
17. [Neovide (GUI) 专属](#17-neovide-gui-专属)
18. [新增 LSP / 格式化工具的方法](#18-新增-lsp--格式化工具的方法)
19. [后续优化建议](#19-后续优化建议)

---

## 1. 快速上手

首次启动后 Lazy.nvim 会自动下载所有插件。安装窗口弹出后可以直接按 `q` 关闭继续编辑，插件后台安装。如果某功能还用不上，关掉重开一次即可。

Mason 会自动安装所有配置中声明的 LSP 服务器和格式化工具，第一次可能需要一两分钟。可以用 `:Mason` 打开管理界面查看进度。

想知道当前能用哪些快捷键，任何时候按 `<Space>` 都会弹出 which-key 提示菜单。

---

## 2. 目录结构

```
nvim/
├── init.lua                    # 入口，按顺序加载 core / features / neovide
├── lua/
│   ├── core/
│   │   ├── autocmd.lua         # 自动命令（自动保存、复制高亮等）
│   │   ├── basic.lua           # 基础选项（行号、缩进、搜索等）
│   │   ├── keymap.lua          # 全局快捷键
│   │   └── lazy.lua            # Lazy.nvim 加载与插件目录声明
│   ├── features/
│   │   ├── switch-theme.lua    # 主题切换核心逻辑 + 持久化
│   │   └── theme-list.lua      # 可用主题清单（新增主题在此维护）
│   ├── neovide/
│   │   ├── basic.lua           # Neovide GUI 基础设置
│   │   └── keymap.lua          # Neovide 专属快捷键 (Cmd 键等)
│   └── plugins/
│       ├── theme.lua           # 所有主题插件声明
│       ├── nui.lua             # UI 库依赖
│       ├── editor/             # 编辑器核心插件（文件树、缩进、括号等）
│       ├── git/                # Git 相关插件
│       ├── lsp/                # LSP + 补全 + 格式化
│       │   └── config/
│       │       ├── servers.lua     # LSP 服务器列表（新增 LSP 在此维护）
│       │       └── formatters.lua  # 格式化工具列表（新增格式化在此维护）
│       ├── navigation/         # 查找、跳转、快捷键提示
│       ├── ui/                 # 状态栏、标签栏、通知等
│       └── utils/              # 其他工具插件
```

**核心原则：新增或修改插件，找到对应分类目录，一个插件对应一个文件，互不影响。**

---

## 3. 插件管理 (Lazy.nvim)

打开 `:Lazy` 进入管理页面：

| 按键 | 功能 | 什么时候用 |
|------|------|------------|
| `H` | 首页 | 从子页面返回 |
| `I` | Install | 有新插件未安装时 |
| `U` | Update | 更新插件到最新 |
| `S` | **Sync** | **日常首选：安装+更新+清理一键完成** |
| `X` | Clean | 删除已移除插件的残留文件 |
| `C` | Check | 检查插件版本冲突或构建问题 |

日常只需记住 **`S`**。

---

## 4. 快捷键全表

`<leader>` 即 `Space` 键。

### 4.1 基础操作

| 快捷键 | 功能 |
|--------|------|
| `<C-s>` | 保存文件（插入/Normal/Visual 均可） |
| `<C-a>` | 全选 |
| `<leader>qq` | 保存并退出所有窗口 |

### 4.2 窗口管理

| 快捷键 | 功能 |
|--------|------|
| `<C-Up>` / `<C-Down>` | 增大/减小窗口高度 |
| `<C-Left>` / `<C-Right>` | 减小/增大窗口宽度 |
| `<leader>wH` / `wJ` / `wK` / `wL` | 将当前窗口移至左/下/上/右 |

### 4.3 行操作

| 快捷键 | 功能 |
|--------|------|
| `<A-j>` / `<A-k>` | Normal/Visual 模式下移动行（上/下） |
| `j` / `k` | 软换行感知移动（wrap 开启时按显示行移动） |

### 4.4 缓冲区

| 快捷键 | 功能 |
|--------|------|
| `]b` / `[b` | 切换到下一个/上一个缓冲区 |
| `<leader>bb` | 快速切回上一个缓冲区 |
| `<leader>bd` | 关闭当前缓冲区 |
| `<leader>bf` | 弹窗选择缓冲区跳转 |
| `<leader>bo` | 关闭其他所有缓冲区 |
| `<leader>bp` | 固定/取消固定当前缓冲区 |
| `<leader>bP` | 关闭所有未固定的缓冲区 |

### 4.5 标签页

| 快捷键 | 功能 |
|--------|------|
| `<leader><tab><tab>` | 新建标签页 |
| `<leader><tab>d` | 关闭当前标签页 |
| `<leader><tab>o` | 关闭其他标签页 |
| `<leader><tab>l` / `<tab>h` | 切换到下一个/上一个标签页 |

### 4.6 查找与导航

| 快捷键 | 功能 |
|--------|------|
| `<leader>ff` | 查找文件 |
| `<leader>fg` | 全局搜索（live grep） |
| `<leader>fs` | 搜索光标下单词 |
| `<leader>fr` | 高级搜索（可传 grep 参数） |
| `<leader>fb` | 查看所有缓冲区 |
| `<leader>fo` | 历史文件 |
| `<leader>fp` | 切换项目 |
| `<leader>fk` | 查询所有快捷键 |
| `<leader>ft` | 查询 TODO 注释 |
| `<leader>H` | 查询帮助文档 |
| `s` | Flash 快速跳转（键入目标字符后跳转） |
| `S` | Flash + Treesitter 跳转（按语法树节点） |
| `gl` | 按行号跳转 |

### 4.7 Telescope 内部快捷键

在 Telescope 弹窗内，选好文件后可以：

| 快捷键 | 效果 |
|--------|------|
| `<A-s>` | 水平分割打开 |
| `<A-v>` | 垂直分割打开 |
| `<A-t>` | 在新标签页打开 |

### 4.8 LSP 操作

| 快捷键 | 功能 |
|--------|------|
| `gd` | 跳转到定义 |
| `gD` | 跳转到声明 |
| `gi` | 跳转到实现 |
| `gr` | 查找所有引用 |
| `gt` | 跳转到类型定义 |
| `K` | 显示悬停信息（折叠时预览折叠内容） |
| `<C-k>` | 签名帮助 |
| `<leader>cR` | 重命名符号 |
| `<leader>ca` | 代码操作（Quick Fix 等） |
| `<leader>cs` | 切换符号面板 (Aerial) |
| `<leader>cr` | 查找引用（Telescope） |
| `<leader>ci` | 查找实现（Telescope） |
| `<leader>cf` | 当前文件符号大纲 |
| `<leader>cw` | 工作区符号查找 |
| `<leader>c[` / `c]` | 被调用列表 / 调用列表 |
| `<leader>ce` | 当前文件诊断 |
| `<leader>cW` | 全局诊断 |
| `<leader>cl` | 切换 LSP 定义/引用面板 |

### 4.9 诊断

| 快捷键 | 功能 |
|--------|------|
| `[d` / `]d` | 跳转到上一个/下一个诊断 |
| `<leader>D` / `<leader>cd` | 打开当前行诊断浮窗 |

### 4.10 Git

| 快捷键 | 功能 |
|--------|------|
| `]c` / `[c` | 跳转到下一个/上一个 Git Hunk |
| `<leader>hp` | 弹窗预览 Hunk |
| `<leader>hi` | 行内预览 Hunk |
| `<leader>hb` | 显示当前行 blame 弹窗 |
| `<leader>ht` | 切换行内 blame 显示 |
| `<leader>hw` | 切换单词级别差异高亮 |
| `<leader>hd` / `hD` | 查看文件 diff（索引 / HEAD） |
| `<leader>hq` / `hQ` | 当前文件/所有变更到 Quickfix |
| `<leader>gg` | 打开 LazyGit |
| `ih`（对象模式） | 选取当前 Hunk |

### 4.11 终端

| 快捷键 | 功能 |
|--------|------|
| `<leader>tt` | 切换默认终端（浮动） |
| `<leader>tf` | 浮动终端 |
| `<leader>tv` | 垂直终端 |
| `<leader>th` | 水平终端 |
| `<Esc>`（终端内） | 退回 Normal 模式 |

### 4.12 问题面板 (Trouble)

| 快捷键 | 功能 |
|--------|------|
| `<leader>xx` | 当前文件诊断 |
| `<leader>xX` | 工作区全局诊断 |
| `<leader>xt` | TODO 列表 |
| `<leader>xL` | 位置列表 |
| `<leader>xQ` | 快速修复列表 |
| `[q` / `]q` | 在 Trouble 列表中导航 |

### 4.13 Harpoon 文件标记

| 快捷键 | 功能 |
|--------|------|
| `<leader>ma` | 添加当前文件到标记 |
| `<leader>md` | 移除当前文件标记 |
| `<leader>mm` | 打开标记菜单 |
| `<leader>m1` / `m2` / `m3` | 快速跳转到第 1/2/3 个标记 |
| `<leader>m[` / `m]` | 跳转到上一个/下一个标记 |

### 4.14 主题与其他

| 快捷键 | 功能 |
|--------|------|
| `<leader>T` | 打开主题切换弹窗 |
| `<leader>e` | 切换文件树 (Neo-tree) |
| `-` | 打开 mini.files 文件管理器 |
| `<leader>pm` | 切换 Markdown 预览 |
| `<leader>pt` | 切换 Typst 预览 |
| `zR` / `zM` | 展开所有折叠 / 折叠所有 |

### 4.15 Obsess 专注工具

| 快捷键 | 功能 |
|--------|------|
| `<leader>os` | 切换 Obsess 浮动窗口 |
| `<leader>oo` | 设置倒计时定时器（分钟） |
| `<leader>ol` | 设置倒计时定时器（秒） |
| `<leader>oa` | 添加任务 |
| `<leader>ot` | 切换任务完成状态 |
| `<leader>od` | 删除任务 |
| `<leader>oe` | 清空所有任务 |

---

## 5. LSP 与格式化

### LSP 服务器（自动安装）

配置声明了以下服务器，启动后由 Mason 自动下载：

| 语言 | LSP 服务器 | 特殊配置 |
|------|-----------|----------|
| C/C++ | clangd | — |
| Rust | rust_analyzer | clippy 检查、inlay hints |
| Lua | lua_ls | LuaJIT 环境、vim 全局变量 |
| Python | basedpyright + ruff | standard 类型检查 |
| HTML | html | — |
| CSS | cssls | — |
| JS/TS | ts_ls | inlay hints 全开 |
| JSX/TSX | ts_ls + tailwindcss | — |
| Emmet | emmet_ls | — |
| Markdown | marksman | — |
| YAML | yamlls | SchemaStore 集成 |
| Typst | tinymist | — |

### 格式化工具

保存文件时自动触发格式化（`format_on_save`，超时 500ms）。

**Mason 管理的工具：**

| 语言 | 工具 |
|------|------|
| C/C++ | clang-format |
| Lua | stylua |
| JS/TS/JSX/TSX | eslint_d + prettierd |
| CSS/SCSS/HTML | prettierd |
| JSON/YAML/Markdown | prettierd |
| TOML | taplo |
| Typst | typstyle |

**自维护工具（非 Mason）：**

| 语言 | 工具 |
|------|------|
| Rust | rustfmt（随 Rust 工具链安装） |
| Python | ruff_fix + ruff_format + ruff_organize_imports |

> LSP 自身的格式化被禁用，全部交给 conform.nvim 统一管理，避免冲突。

---

## 6. 主题切换

按 `<leader>T` 打开 Telescope 下拉菜单，上下箭头预览，回车确认。选中的主题会自动持久化保存，下次重启直接恢复。

当前可用主题（60+ 种）：

| 系列 | 变体 |
|------|------|
| TokyoNight | night / storm / day / moon |
| Catppuccin | latte / frappe / macchiato / mocha |
| GitHub | dark / light 及各色觉变体 |
| Kanagawa | wave / dragon / lotus |
| Rose Pine | main / moon / dawn |
| Nightfox | nightfox / dayfox / dawnfox / duskfox / nordfox / terafox / carbonfox |
| Monokai Pro | default / ristretto / classic / light / machine / octagon / spectrum |
| 其他 | gruvbox / nord / ayu / onedark / nordic / dracula / vague / poimandres |

新增主题需要两步：在 `lua/plugins/theme.lua` 添加插件声明，在 `lua/features/theme-list.lua` 添加主题名称。

---

## 7. 文件树与文件管理

有两个互补的工具：

**Neo-tree（`<leader>e`）** —— 项目级别的文件树，左侧侧栏。会自动定位到当前文件，显示 Git 状态图标。适合浏览项目结构。

**mini.files（`-`）** —— 轻量文件浏览器，带预览窗口。适合快速在目录间翻浏览和打开文件。

---

## 8. 代码补全与签名帮助

补全引擎是 blink.cmp，使用 super-tab 预设：

- 输入时自动弹出补全菜单
- `Tab` 确认补全
- `<C-Space>` 手动触发补全
- 命令行（`:` 和 `/`）也支持补全

签名帮助：输入函数参数时自动显示函数签名，也可手动按 `<C-k>` 触发。

snippet 由 friendly-snippets 提供，常用语言的 snippet 开箱可用。

---

## 9. 代码折叠

由 nvim-ufo 提供 VSCode 风格的折叠体验。

| 操作 | 方式 |
|------|------|
| 展开所有 | `zR` |
| 折叠所有 | `zM` |
| 折叠/展开当前块 | `za` |
| 预览折叠内容 | 光标移到折叠行，按 `K` |

折叠行尾会显示被折叠的行数。

---

## 10. Git 操作

### 行级别标记 (gitsigns)

左侧 sign column 会自动标记新增/修改/删除的行。当前行行尾实时显示 blame 信息（作者 + 时间 + 提交摘要）。

常用流程：
- `]c` / `[c` 在修改块之间跳转
- `<leader>hp` 预览当前块的 diff
- `<leader>hb` 查看当前行的完整 blame
- `<leader>hd` 查看当前文件相对暂存区的 diff

### 图形化 Git (LazyGit)

`<leader>gg` 打开 LazyGit 浮动窗口，提供完整的 Git 图形操作界面（暂存、提交、分支管理等）。

---

## 11. 终端

默认方向是浮动窗口。三种模式随时切换：

- `<leader>tf` — 浮动
- `<leader>tv` — 垂直分割（占屏幕宽度 40%）
- `<leader>th` — 水平分割（高度 8 行）

终端内按 `Esc` 退回 Normal 模式，退回后可以正常编辑。

---

## 12. 会话与项目管理

### 会话 (persistence.nvim)

会话按 **Git 分支** 自动保存。启动页面上有"恢复会话"和"查看会话"按钮。也可手动：
- 恢复上次会话：启动页按 `s`
- 查看/选择会话：启动页按 `m`

### 项目 (project.nvim)

`<leader>fp` 打开项目列表，project.nvim 自动检测项目根目录（基于 `.git`、`package.json` 等）。切换项目会自动切换工作目录。

---

## 13. 导航与查找

### Flash 快速跳转

按 `s`，键入目标附近的字符，屏幕上会出现跳转标签，再按标签对应的键即可跳转。比如想跳到屏幕上某个单词：`s` → 键入单词开头几个字 → 按弹出的标签键。

`S` 是 Treesitter 模式，会按语法树节点亮出跳转标签，适合精确跳转到代码块。

`gl` 按行跳转，所有行号会亮出来直接选。

### Harpoon 文件标记

高频访问的文件可以用 Harpoon 标记：
1. 在目标文件里按 `<leader>ma` 添加
2. 后续用 `<leader>m1` / `m2` / `m3` 直接跳转
3. `<leader>mm` 打开标记菜单可以重新排序或删除

---

## 14. 问题诊断面板

Trouble 提供统一的问题查看面板，比浮动弹窗更适合一次查看多个问题：

- `<leader>xx` 查看当前文件所有诊断（错误/警告）
- `<leader>xX` 查看整个工作区的诊断
- `<leader>xt` 查看所有 TODO/FIXME/HACK 注释
- `[q` / `]q` 在列表中上下导航并跳转到对应位置

---

## 15. Obsess 专注工具

右上角浮动窗口，支持倒计时和任务管理：

- `<leader>oo` 设置倒计时（输入分钟数）
- `<leader>oa` 添加待做任务
- `<leader>ot` 点击切换任务的完成状态
- 倒计时结束会闪烁提醒

适合番茄工法或者临时记一下当前要做的事。

---

## 16. 文档预览

### Markdown

- **实内渲染**：打开 `.md` 文件时，render-markdown.nvim 会直接在编辑区美化标题、列表、代码块等，插入模式切回来会恢复为源码视。
- **浏览器预览**：`<leader>pm` 在本地浏览器打开预览页（需要 node/npm）。

### Typst

- `<leader>pt` 切换 Typst 预览窗口（需要本地安装 typst）。

---

## 17. Neovide (GUI) 专属

以下设置仅在用 Neovide 启动时生效（终端 nvim 不受影响）：

| 功能 | 配置 |
|------|------|
| 光标动画 | pixiedust（粒子散落效果） |
| 缩放 | `<C-=>` 放大 / `<C-->` 缩小 |
| 保存 | `<D-s>`（Cmd+S） |
| 复制/粘贴 | `<D-c>` / `<D-v>`（各模式均支持） |
| 框线渲染 | native 模式（修复边框断裂） |

> 如果要设置字体，在 `lua/neovide/basic.lua` 中添加：
> ```lua
> vim.opt.guifont = "你的字体名:h字号"
> ```

---

## 18. 新增 LSP / 格式化工具的方法

### 新增 LSP 服务器

编辑 `lua/plugins/lsp/config/servers.lua`，按现有格式添加入口：

```lua
-- 举例：添加 Go 的 LSP
gopls = {},
```

保存后重新打开 nvim，Mason 会自动安装，lspconfig 自动注册。

### 新增格式化工具

编辑 `lua/plugins/lsp/config/formatters.lua`：

- 如果工具在 Mason 中可用，加入 `M.mason` 表；
- 如果是语言工具链自带（如 gofmt），加入 `M.custom` 表。

```lua
-- Mason 管理的示例
M.mason = {
    go = { "goimports" },   -- 新增
    -- ...
}

-- 自维护的示例
M.custom = {
    go = { "gofmt" },       -- 新增
    -- ...
}
```

---

## 19. 后续优化建议

以下是基于当前配置提出的优化方向，按优先级从高到低排列。

### 高优先级

**1. 补充 Neovide 字体配置**
当前 `lua/neovide/basic.lua` 中没有 `guifont` 设置。如果用 Neovide，需要手动添加，否则会使用系统默认字体，可能出现图标乱码。

**2. 开启 alpha-nvim 的启动页页脚信息**
`lua/plugins/ui/alpha-nvim.lua` 中有一段注释掉的代码，用于在启动页底部显示插件数量和启动时间。把注释打开即可，对快速判断启动状态很有用。代码块在 `config` 函数内，以 `LazyVimStarted` 事件开头。

**3. 开启 fidget 接管 vim.notify**
`lua/plugins/lsp/fidget.lua` 中 `override_vim_notify` 是注释掉的。开启后所有 `vim.notify` 消息都会走 fidget 的通知系统，和 LSP 进度信息在同一个位置显示，体验更统一。

### 中优先级

**4. transparent.nvim 的 BufferLine 和 Lualine 透明化**
`lua/plugins/ui/transparent.lua` 中 BufferLine 和 Lualine 的 `clear_prefix` 是注释状态。如果使用透明背景，这两个如果不清除，状态栏和标签栏会有不透明的色块，视觉不协调。根据个人喜好开启。

**5. bufferline 的 NvimTree offset 可以移除**
`lua/plugins/ui/bufferline.lua` 的 `offsets` 里还残留了一个 `filetype = "NvimTree"` 的配置。当前文件树已经换成了 Neo-tree，NvimTree 的 offset 不会起作用，可以删掉避免混淆。

**6. lualine 的 fileformat 字段重复**
`lua/plugins/ui/lualine.lua` 的 `lualine_x` 区域里，已经有一个自定义函数把 fileformat 渲染成 LF/CRLF/CR 了，后面还紧跟了一个原生的 `"fileformat"` 字段，会重复显示。把原生的 `"fileformat"` 删掉即可。

### 低优先级（根据需要考虑）

**7. 考虑添加 nvim-autopairs 与 blink.cmp 的集成**
当前 autopairs 使用默认配置。blink.cmp 官方推荐配置 autopairs 的 `enable_moveout` 方式，避免在补全接受时和括号自动闭合互相干扰。如果编写时遇到多余括号的问题，可以看 blink.cmp 文档配置。

**8. 考虑添加对调试器 (DAP) 的支持**
当前配置没有 DAP（Debug Adapter Protocol）相关插件。如果需要在 nvim 内调试 Python/Rust/C++ 等，可以后续添加 `nvim-dap` + `nvim-dap-ui`，Mason 已经支持大多数调试适配器的安装。

**9. 考虑用 Snip 替换 friendly-snippets 中缺少的自定义 snippet**
friendly-snippets 提供的是社区通用 snippet。如果某语言的 snippet 不够用，可以在项目内创建 `.snip` 文件或者配置 snippet 路径，blink.cmp 的 snippets source 会自动识别。

**10. 当前 surround 仅在 InsertEnter 时加载**
`lua/plugins/utils/surround.lua` 的 event 是 `InsertEnter`，意味着在 Normal 模式下用 `ys` 等操作时插件可能还没有加载。改成 `event = "VeryLazy"` 或者加上 `keys` 触发会更合适。
