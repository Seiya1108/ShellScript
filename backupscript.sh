#!/bin/bash
## ==バックアップスクリプト==

# バックアップの保存先ディレクトリ
BACKUP_DIR="/tmp"

# バックアップリストファイルのパス
BACKUP_LIST="backup_list"

# 日付フォーマット
DATE=$(date +%Y%m%d)

# バックアップリストファイルの存在確認
if [[ ! -f ${BACKUP_LIST} ]]; then
    echo "バックアップリストファイルが見つかりません: ${BACKUP_LIST}"
    exit 1
fi

# バックアップリストファイルを読み込み、各ディレクトリをバックアップ
while IFS= read -r DIR; do
    # 空行やコメント行をスキップ
    [[ -z "${DIR}" || ${DIR} == \#* ]] && continue

    # ディレクトリの存在確認
    if [[ -d ${DIR} ]]; then
        DIR_NAME=$(basename "${DIR}")
        BACKUP_FILE="${BACKUP_DIR}/${DIR_NAME}_${DATE}.tgz"

        # tarコマンドでディレクトリを圧縮
        if tar -czf "${BACKUP_FILE}" "${DIR}" 2>/dev/null; then
            echo "バックアップ成功: ${DIR} -> ${BACKUP_FILE}"
        else
            echo "バックアップ失敗: ${DIR}"
        fi
    else
        echo "ディレクトリが存在しません: ${DIR}"
    fi
done < "${BACKUP_LIST}"
