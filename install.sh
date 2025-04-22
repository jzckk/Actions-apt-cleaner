name: APT Cache Cleaner

on:
  schedule:
    - cron: "0 0 * * *"  # 每天UTC 0点运行
  workflow_dispatch:     # 允许手动触发

jobs:
  cleanup:
    runs-on: ubuntu-latest
    timeout-minutes: 10  # 防止长时间卡死
    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Clean APT Cache
        uses: appleboy/ssh-action@v1
        with:
          host: ${{ secrets.SERVER_IP }}
          username: ${{ secrets.SERVER_USER }}
          key: ${{ secrets.SSH_PRIVATE_KEY }}
          port: ${{ secrets.SSH_PORT || 22 }}
          script_timeout: 5m  # SSH超时设置
          script: |
            echo "🔄 连接到服务器..."
            cd /tmp
            wget -q https://raw.githubusercontent.com/${{ github.repository }}/main/cleanup.sh
            chmod +x cleanup.sh
            ./cleanup.sh
