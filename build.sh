#!/bin/bash
# 画廊浏览器 - 打包脚本（符合 fnOS / fnpack 规范）
# 用法：./build.sh [output.fpk]

set -e

OUTPUT="${1:-gallery-viewer.fpk}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "==> 清理旧文件..."
rm -f app.tgz "$OUTPUT"
rm -rf app/backend/__pycache__

echo "==> 打包应用内容 (app.tgz，不含 app/ 顶层目录)..."
# 注意：必须用 -C app/ 让 tar 把 app/ 内的内容（backend/, ui/）直接打包到 app.tgz 根
# 这样安装后，app.tgz 解压到 target/ 下就是 target/backend/、target/ui/
tar -czf app.tgz -C app/ backend/ ui/

echo "==> 验证 app.tgz 内容..."
tar -tzf app.tgz

echo
echo "==> 打包 fpk..."
tar -czf "$OUTPUT" \
  manifest \
  ICON.PNG \
  ICON_256.PNG \
  cmd/ \
  config/ \
  wizard/ \
  app.tgz

echo
echo "==> 验证 fpk 内容..."
tar -tzf "$OUTPUT"

SIZE=$(du -h "$OUTPUT" | cut -f1)
echo
echo "==> 打包完成: $OUTPUT ($SIZE)"

# 清理临时文件
rm -f app.tgz
echo "==> 完成 ✅"