#!/usr/bin/env bash

set +e

echo "=========================================================="
echo "🚀 启动半导体气体设备与专利 AI 24小时全自动研发工厂"
echo "=========================================================="

# 1. 确保当前目录已初始化 Git（完全隔离，不影响其他仓库）
if [ ! -d ".git" ]; then
    echo "⚙️ 正在初始化本地 Git 仓库..."
    git init
    git branch -M main
fi

COUNTER=1

while true; do
    echo ""
    echo "----------------------------------------------------------"
    echo "🕒 [$(date '+%Y-%m-%d %H:%M:%S')] 开始第 $COUNTER 轮自动化研发与专利构建..."
    echo "----------------------------------------------------------"

    PROMPT="请作为半导体气体设备专家与专利代理人，执行以下全流程自动化任务：

【GitHub 自动建库检查】
- 请先检查当前 Git 是否已绑定远程 origin 仓库。
- 如果未绑定远程仓库，请直接调用终端命令（如通过 'gh repo create semico-patent-factory --public --source=. --remote=origin' 或使用 GitHub API）自动在我的 GitHub 账号下创建一个名为 'semico-patent-factory' 的公开仓库并绑定 origin。

【研发与专利生成】
1. **读取历史**：查看根目录下的 'index.json'，确保本次构思的新课题绝对不重复。
2. **自主构思**：基于半导体气体行业工程痛点，构思一个全新的、具备高专利价值的研发课题。
3. **创建目录**：生成递增的项目编号（例如 PROJ-001），并在 'projects/' 下创建对应文件夹。
4. **生成全套交付件**：在新建的项目目录下，按 CLAUDE.md 要求生成 4 个 Markdown 文件（计划书、决议、结题报告、专利草案）。
5. **更新索引库**：追加更新 'index.json'。

请直接开始思考并自动完成所有工具调用与操作。"

    claude -p "$PROMPT" --dangerously-skip-permissions
    
    CLAUDE_EXIT_CODE=$?
    if [ $CLAUDE_EXIT_CODE -ne 0 ]; then
        echo "⚠️ [$(date '+%Y-%m-%d %H:%M:%S')] Claude 运行返回非 0 状态码，等待 30 秒后重试..."
        sleep 30
        continue
    fi

    echo "📦 [$(date '+%Y-%m-%d %H:%M:%S')] 文件生成完毕，正在封装并同步至 GitHub..."

    git add .

    if git diff-index --quiet HEAD --; then
        echo "ℹ️ 检测到没有产生新的文件变动，跳过本次 Git 提交。"
    else
        git commit -m "Auto-R&D: Complete project and patent draft - Round $COUNTER [$(date '+%Y-%m-%d %H:%M:%S')]"
        git push -u origin main
        
        if [ $? -eq 0 ]; then
            echo "✅ [$(date '+%Y-%m-%d %H:%M:%S')] 第 $COUNTER 轮成果已成功推送至 GitHub 仓库！"
        else
            echo "⚠️ [$(date '+%Y-%m-%d %H:%M:%S')] 推送 GitHub 失败，将在下一轮尝试重新推送..."
        fi
    fi

    COUNTER=$((COUNTER + 1))
    echo "⏳ 本轮结束，休息 10 秒后自动无缝进入下一轮研发..."
    sleep 10
done
