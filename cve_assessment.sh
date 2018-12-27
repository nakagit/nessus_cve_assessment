#!/bin/sh
cve=$1
host=$2

# 引数の数チェック
if [ $# -ne 2 ]; then
  echo "引数が、不足しています。"
  echo "コマンド実行例: ./cve_assessment.sh CVE-2014-0001 192.168.1.1"
  echo "また、引数(CVE)は、大文字で入力してください。"
  echo ""
  exit 1
fi

# CVE -> cve-list作成
echo /opt/nessus/lib/nessus/plugins/*.nasl|xargs grep -C7 $1|grep script_id|awk '{print $2}'|awk -F"script_id" '{print $2}'|awk -F"(" '{print $2}'|awk -F")" '{print $1}' >> cve_list.txt

# cve-list -> scriptID作成(-i オプション)
for line in `cat "cve_list.txt"`
do
  echo -en "-i "$line" " >> scriptID_list.txt
done

# Nessus実行
/opt/nessus/bin/nessuscmd -V `cat scriptID_list.txt` $2

# 一時作成ファイル削除
rm -f cve_list.txt
rm -f scriptID_list.txt

