# ==========================================
# 全局路径重构：解决用户名特殊字符(单引号 ' )引发的 eval 崩溃
# ==========================================

# 1. 首先抹除那两个带括号的非法变量名（变量名带括号是 Bash 的死穴，保险起见）
unset "ProgramFiles(x86)"
unset "CommonProgramFiles(x86)"

# 2. 【核心】遍历所有环境变量，把含有单引号路径的 Value 全部置换成软链接路径
# 这个循环会扫描几十个变量（PATH, APPDATA, TEMP 等）
# 只要值里面包含 yi'xuan(举例)，就自动换成 yixuan_wsl(此处换成所需的无特殊字符名字)
while read -r line; do
    if [[ "$line" == *"yi'xuan"* ]]; then
        # 提取变量名
        var_name=$(echo "$line" | cut -d'=' -f1)
        # 提取旧值并替换
        old_value=$(eval echo \$$var_name)
        new_value="${old_value//yi\'xuan/yixuan_wsl}"
        # 重新导出干净的变量
        export "$var_name"="$new_value"
    fi
done < <(env)

# ==========================================


