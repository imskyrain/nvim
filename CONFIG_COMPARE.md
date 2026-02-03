# Neovim 配置对比：本机配置 vs 仓库配置 (Cookvim)

---

## 一、整体架构对比

| 维度 | 本机配置 (~/.config/nvim) | 仓库配置 (Cookvim) |
|---|---|---|
| **插件管理器** | lazy.nvim（但残留 packer_compiled.lua 未清理） | lazy.nvim（干净，无残留） |
| **入口文件** | init.lua 直接写了部分重复基础配置，未 require core/ 模块 | init.lua 严格 require core/ 各模块，结构清晰 |
| **目录结构** | 扁平：lua/plugins.lua 单文件列出所有插件；lua/core/ 存在但未被加载；plugins_bak/ 为旧备份残留 | 模块化分层：lua/core/（基础）、lua/features/（主题切换）、lua/plugins/{editor,git,lsp,navigation,ui,utils}/（按功能分目录）、lua/neovide/（GUI专属） |
| **配置风格** | 混合状态，部分配置重复、存在冲突（如主题设置） | 单一数据源，配置集中、无冲突，每个插件独占一个文件 |
| **Neovide 支持** | 在 init.lua 硬编码 guifont 和 transparency，无条件判断 | 条件加载（检测 vim.g.neovide），独立模块管理 GUI 配置和快捷键 |
| **插件延迟加载** | 基本无 lazy 事件配置 | 广泛使用 `event`、`cmd`、`keys` 延迟加载，启动性能更优 |

---

## 二、插件对比

### 2.1 主题

| 类别 | 本机配置 | 仓库配置 | 说明 |
|---|---|---|---|
| 主题插件数 | 1（tokyonight） | 15 个插件 | 仓库新增 14 个主题插件 |
| 可用变体数 | 2（night / moon，且存在冲突） | 60+（含所有插件的子变体） | 仓库可用变体远多于本机 |
| 切换机制 | 无，硬编码 | Telescope 下拉菜单（支持 ivy/dropdown/cursor 布局），持久化保存到磁盘，重启后自动恢复 | 仓库新增 |
| 冲突情况 | options.lua 设 tokyonight-moon，plugins.lua 设 tokyonight-night，两者冲突 | 无冲突，theme-list.lua 统一维护所有主题元数据 | 仓库修正了本机的冲突问题 |

### 2.2 编辑器核心

| 功能 | 本机配置 | 仓库配置 | 变化 |
|---|---|---|---|
| 文件树 | nvim-tree.lua + nvim-web-devicons | neo-tree.nvim + nui.nvim + nvim-web-devicons | **替换**：neo-tree 配置更丰富（git 状态图标、跟踪当前文件、合并空目录、接管 netrw） |
| 缩进线 | indent-blankline.nvim（默认配置） | indent-blankline.nvim + mini.indentscope（缩进作用域高亮） | **新增** mini.indentscope |
| 语法解析 | nvim-treesitter（仅 TSUpdate，无配置） | nvim-treesitter（与 ufo、gitsigns 等深度集成） | 配置层面补齐 |
| 自动括号 | 无 | nvim-autopairs | **新增** |
| 彩色括号 | 无 | rainbow-delimiters.nvim | **新增** |
| 文件管理 | 无 | mini.files | **新增** |
| 符号面板 | 无 | aerial.nvim | **新增** |

### 2.3 补全与 LSP

| 功能 | 本机配置 | 仓库配置 | 变化 |
|---|---|---|---|
| LSP 管理 | 无（mason/lspconfig 仅存在于未使用的 packer 残留中） | mason.nvim + mason-lspconfig + nvim-lspconfig（完整配置，含 on_attach、inlay hints、诊断） | **新增**（核心级别补齐） |
| 支持的 LSP 服务器 | 无 | clangd, rust_analyzer, lua_ls, basedpyright, ruff, html, cssls, emmet_ls, tailwindcss, ts_ls, marksman, yamlls, tinymist（共 13 个） | **新增** |
| 代码补全 | nvim-cmp + cmp-nvim-lsp + cmp-buffer + cmp-path（基础） | blink.cmp + friendly-snippets（新一代补全，含 cmdline 补全、super-tab 预设） | **替换** |
| 格式化 | 无 | conform.nvim（mason 双轨管理，含 format_on_save，覆盖 C/Lua/Python/Rust/JS/TS/CSS/HTML/YAML/Markdown/Typst 等） | **新增**（核心级别补齐） |
| LSP 进度提示 | 无 | fidget.nvim | **新增** |
| LSP 诊断显示 | 无 | 自定义 diagnostic.config（虚拟文本、符号标记、浮窗、实时更新） | **新增** |

### 2.4 Git 集成

| 功能 | 本机配置 | 仓库配置 | 变化 |
|---|---|---|---|
| 行级别 Git 标记 | 无（packer 残留有 gitsigns，但 lazy 里未配置） | gitsigns.nvim（完整配置：hunk 导航、行内/弹窗 blame、diff、quickfix 集成、文本对象） | **新增** |
| Git 图形界面 | 无 | lazygit.nvim（`<leader>gg` 打开） | **新增** |

### 2.5 导航与查找

| 功能 | 本机配置 | 仓库配置 | 变化 |
|---|---|---|---|
| 模糊查找 | telescope.nvim + plenary（仅绑定 C-p 查文件、C-f grep） | telescope.nvim + fzf-native + live-grep-args + file-browser + project.nvim（绑定 10+ 个查找入口，含项目切换、历史文件、快捷键查询、LSP 调用图等） | **扩展**：功能大幅增加 |
| 快速字符跳转 | 无 | flash.nvim（s/S 跳转，含 treesitter 模式和行跳转） | **新增** |
| 文件标记 | 无 | harpoon（添加/移除标记，1-3 快跳，菜单管理） | **新增** |
| 快捷键提示 | 无 | which-key.nvim（helix preset，按 leader 分组显示，带图标） | **新增** |

### 2.6 UI 与美观

| 功能 | 本机配置 | 仓库配置 | 变化 |
|---|---|---|---|
| 启动页 | 无 | alpha-nvim | **新增** |
| 标签栏 | bufferline.nvim（默认配置） | bufferline.nvim（丰富配置：LSP 诊断显示、neo-tree 偏移、固定标签、排序策略） | **增强** |
| 状态栏 | lualine.nvim（主题锁定 tokyonight） | lualine.nvim（自定义：显示缩进方式/spaces/tab、编码、换行格式 LF/CRLF，不锁定主题） | **增强** |
| 消息/通知 | 无 | noice.nvim + nvim-notify（美化命令行消息和弹窗通知） | **新增** |
| 透明背景 | 无 | transparent.nvim | **新增** |

### 2.7 工具插件

| 功能 | 本机配置 | 仓库配置 | 变化 |
|---|---|---|---|
| 自动保存 | pocco81/auto-save.nvim（插件级别） | autocmd 原生实现（BufLeave/FocusLost 触发，带错误处理） | **替换**：去掉插件依赖，用更轻量的 autocmd 实现 |
| 代码折叠 | 无 | nvim-ufo（VSCode 风格，treesitter 提供者，折叠预览，zR/zM 控制） | **新增** |
| 会话管理 | 无 | persistence.nvim（按 git branch 保存和恢复会话） | **新增** |
| 浮动终端 | 无 | toggleterm.nvim（float/vertical/horizontal 三种模式） | **新增** |
| 问题列表 | 无 | trouble.nvim（诊断/TODO/quickfix/loclist 统一面板） | **新增** |
| TODO 注释 | 无 | todo-comments.nvim | **新增** |
| 颜色预览 | 无 | nvim-colorizer.lua | **新增** |
| 代码环绕 | 无 | nvim-surround | **新增** |
| Markdown 渲染 | 无 | render-markdown.nvim + markdown-preview.nvim | **新增** |
| Typst 预览 | 无 | typst-preview.nvim | **新增** |
| Rust Cargo | 无 | crates.nvim（Cargo.toml 中的依赖版本信息） | **新增** |
| 任务/倒计时 | 无 | obsess（浮动计时器和任务管理） | **新增** |

---

## 三、快捷键对比

| 功能类别 | 本机配置 | 仓库配置 | 备注 |
|---|---|---|---|
| 退出插入模式 | `jk` | 无此绑定（默认 Esc） | 本机独有，切换到仓库后需手动添加或适应 Esc |
| 保存文件 | 无统一绑定 | `<C-s>`（全模式） | 仓库新增 |
| 全选 | 无 | `<C-a>` | 仓库新增 |
| 文件树 | `<leader>e` 打开 NvimTree，`<C-b>` 切换 | `<leader>e` 切换 Neo-tree | 功能一致，快捷键部分变化（无 C-b） |
| 标签栏切换 | `<S-l>` / `<S-h>` | `]b` / `[b` | **快捷键变化**，需适应 |
| 查找文件 | `<C-p>` | `<leader>ff`（dropdown） | **快捷键变化** |
| 全局搜索 | `<C-f>` | `<leader>fg`（live grep） | **快捷键变化** |
| 分割窗口 | `<leader>sv` / `<leader>sh` | 无显式分割绑定（用默认 `<C-w>` 系列） | 本机独有的显式分割快捷键 |
| 取消搜索高亮 | `<leader>nh` | 配置 `hlsearch = false`，默认不高亮，无需手动取消 | 仓库用配置级别解决，无需快捷键 |
| 行移动 | `v` 模式 `J`/`K` | `<A-j>` / `<A-k>`（normal 和 visual 均支持） | **快捷键变化** |
| 窗口调整大小 | 无 | `<C-Up/Down/Left/Right>` | 仓库新增 |
| 窗口移动 | 无 | `<leader>wH/J/K/L` | 仓库新增 |
| LSP 跳转 | 无 | `gd`/`gD`/`gi`/`gr`/`gt`，`K` hover，`<C-k>` 签名帮助 | 仓库新增 |
| LSP 操作 | 无 | `<leader>cR` 重命名，`<leader>ca` 代码操作，`<leader>c[/]` 调用图 | 仓库新增 |
| Git 操作 | 无 | `]c`/`[c` hunk 导航，`<leader>h*` 系列（blame/diff/preview），`<leader>gg` lazygit | 仓库新增 |
| 文件标记 | 无 | `<leader>ma` 添加，`<leader>m1/2/3` 快跳，`<leader>mm` 菜单 | 仓库新增 |
| 快速跳转 | 无 | `s`/`S` flash 跳转，`gl` 行跳转 | 仓库新增 |
| 终端 | 无 | `<leader>tt/tv/th/tf` 切换终端模式，`<C-\>` 启用 | 仓库新增 |
| 代码折叠 | 无 | `zR` 全展开，`zM` 全折叠 | 仓库新增 |
| 主题切换 | 无 | `<leader>T` 打开主题选择器 | 仓库新增 |
| 问题面板 | 无 | `<leader>xx` 文件诊断，`<leader>xX` 工作区诊断，`<leader>xt` TODO | 仓库新增 |
| 标签页管理 | 无 | `<leader><tab><tab>` 新建，`<leader><tab>d` 关闭，`<leader><tab>l/h` 切换 | 仓库新增 |
| Neovide 缩放 | 无 | `<C-=>` / `<C-->` 放大/缩小 | 仓库新增 |
| Neovide 剪切板 | 无显式 Cmd 绑定 | `<D-s>` 保存，`<D-c>` 复制，`<D-v>` 粘贴（各模式） | 仓库新增，macOS 原生体验 |

---

## 四、基础配置对比

| 配置项 | 本机配置 | 仓库配置 | 说明 |
|---|---|---|---|
| 行号 | 相对行号 + 绝对行号 | 相对行号 + 绝对行号 | 一致 |
| 缩进 | 2 空格，expandtab | 2 空格，expandtab + autoindent + smartindent | 仓库多了自动缩进选项 |
| 光标行高亮 | cursorline = true | cursorline = true | 一致 |
| 剪切板 | clipboard = unnamedplus | clipboard = unnamedplus | 一致 |
| 搜索 | ignorecase + smartcase | ignorecase + smartcase + incsearch + hlsearch=false | 仓库增量搜索开启，默认不高亮匹配 |
| 换行 | wrap = false | wrap = false（全局），markdown/text 文件自动开启软换行 | 仓库对文档文件做了例外处理 |
| signcolumn | 无配置 | signcolumn = "yes"（永远显示） | 仓库新增，配合 gitsigns 和诊断符号 |
| 窗口边框 | 无配置 | winborder = "rounded" | 仓库新增 |
| 颜色列 | 无配置 | colorcolumn = {80, 120} | 仓库新增行宽参考线 |
| 滚动余量 | 无配置 | scrolloff = 5, sidescrolloff = 5 | 仓库新增，编辑体验更好 |
| 撤销 | 无配置 | undofile = true（持久撤销） | 仓库新增 |
| 状态栏 | 默认显示 | laststatus = 0（禁用底部状态栏，由 lualine globalstatus 接管） | 仓库用全局状态栏替代，更干净 |
| 会话选项 | 无配置 | sessionoptions 配置了 buffers/curdir/tabpages/winsize 等 | 仓库新增，配合 persistence.nvim |
| 换行格式 | 无配置 | fileformat = unix 优先，fileformats = {unix, dos, mac} | 仓库统一换行格式 |
| 真色彩 | 无显式配置 | termguicolors = true | 仓库显式开启 |
| autocmd | 无 | LazyFile 自定义事件、复制高亮闪烁、取消自动换行注释、文档软换行、自动保存 | 仓库新增多个实用 autocmd |
| Neovide 光标 | railgun 模式 | pixiedust 模式 | **样式变化**，pixiedust 更轻柔 |
| Neovide 透明度 | transparency 0.95 | 无 transparency 配置（改用 transparent.nvim 插件方案） | 实现方式变化 |
| Neovide 字体 | guifont JetBrainsMono Nerd Font:h15 | 无显式 guifont 配置 | 仓库未设置，需自行补充或依赖系统默认 |

---

## 五、切换到仓库配置 (Cookvim) 的优缺点

### 优点

1. **LSP 体系全面补齐**：本机完全缺少 LSP 功能，仓库配置提供了 mason 自动管理、13 个语言服务器、inlay hints、诊断、签名帮助、代码跳转等完整体系，这是最大的功能跳跃。

2. **格式化从零到全覆盖**：仓库配置引入 conform.nvim，支持 mason 管理和自维护双轨格式化，覆盖了 C/Lua/Python/Rust/JS/TS/CSS/HTML/YAML/Markdown/Typst 等语言，且配置了 format_on_save。

3. **补全质量升级**：从 nvim-cmp 基础配置切换到 blink.cmp，后者是更新一代的补全引擎，支持 cmdline 补全和 super-tab 预设，性能和体验均优。

4. **Git 集成从无到有**：gitsigns 提供了行级别变更标记和 blame，lazygit 提供了图形化 Git 操作界面，大幅提升开发效率。

5. **配置架构干净可维护**：所有插件按功能分目录，每个插件独占一个文件，无冲突无残留。新增或修改插件时路径和逻辑一目了然，维护成本大幅降低。

6. **主题自由度大幅提升**：从单一 tokyonight（还有冲突）切换到 15 个插件、60+ 变体可选，且支持持久化保存和 Telescope 下拉切换，心情好换主题这件事变得开箱可用。

7. **导航效率大幅提升**：flash.nvim 快速字符跳转、harpoon 文件标记、which-key 快捷键提示、telescope 扩展功能（项目切换、LSP 调用图、快捷键查询）等，都是高频使用的效率工具。

8. **代码折叠开箱可用**：nvim-ufo 提供了 VSCode 风格的折叠体验，带折叠行数预览和展开/折叠图标，本机完全没有此功能。

9. **终端、问题面板、会话管理齐全**：toggleterm 浮动终端、trouble 问题面板、persistence 会话管理等，补齐了日常开发中常需的辅助工具。

10. **UI 细节打磨**：bufferline 显示 LSP 诊断数量、lualine 显示缩进/编码/换行格式、noice 美化消息弹窗、transparent 透明背景、alpha 启动页等，整体视觉和信息密度都更好。

11. **Neovide 体验更完善**：Cmd 键绑定（保存/复制/粘贴）、缩放快捷键、pixiedust 光标动画、box_drawing_mode native（修复字符边框断裂），对 macOS Neovide 用户体验明显提升。

12. **自动保存更轻量**：去掉了 pocco81/auto-save 插件依赖，用 autocmd 原生实现 BufLeave/FocusLost 触发保存，功能一致但依赖更少。

---

### 缺点 / 注意事项

1. **快捷键习惯需要适应**：多个常用快捷键发生了变化。最需要注意的几个：
   - 退出插入模式的 `jk` 快捷键被移除，需回归 Esc 或自行添加；
   - 查找文件从 `<C-p>` 变为 `<leader>ff`；
   - 全局搜索从 `<C-f>` 变为 `<leader>fg`；
   - bufferline 切换从 `<Shift-l>`/`<Shift-h>` 变为 `]b`/`[b`；
   - 行移动从 visual 模式的 `J`/`K` 变为 `<A-j>`/`<A-k>`。

2. **Neovide 字体未配置**：本机设置了 `guifont = JetBrainsMono Nerd Font:h15`，仓库配置中未包含此项，切换后 Neovide 内的字体会回退到系统默认，需要自行在 `lua/neovide/basic.lua` 中添加。

3. **Neovide 光标动画样式变化**：本机使用 railgun 模式（快速闪射感），仓库使用 pixiedust 模式（粒子散落感），这是一个主观偏好差异，不影响功能。

4. **透明度实现方式变化**：本机直接用 `neovide_transparency = 0.95` 实现透明，仓库使用 transparent.nvim 插件方案。两者在 Neovide 下的效果可能有轻微差异，需要自行调试透明度数值。

5. **文件树从 nvim-tree 换成了 neo-tree**：操作逻辑和快捷键有差异（如本机的 `<C-b>` 切换文件树不再可用），需要短暂适应新的文件树交互方式。

6. **插件数量增加，首次启动时间**：仓库配置的插件总量远多于本机，尽管使用了 lazy 延迟加载，但首次使用时 lazy 需要下载和编译更多插件，启动可能略慢；后续因缓存和延迟加载机制不会有明显影响。

7. **`s` 键被 flash.nvim 占用**：仓库配置中 `s` 绑定了 flash 跳转，如果本机习惯使用 `s` 做其他操作（如 vim-surround 的默认 `s` 前缀），需要注意冲突。
