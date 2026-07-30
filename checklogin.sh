cat /sys/class/net/apcli0/operstate | grep "up"
if [ $? -eq 0 ]; then
  curl -X GET 'https://wifi.gcc.edu.cn:802/eportal/portal/page/loadLogonRecord?callback=dr1006&lang=zh-cn&program_index=9PMwE51745479032&page_index=P0nh3N1745479149&user_account=202412100220&wlan_user_ip=169291231&wlan_user_mac=000000000000&start_time=2026-4-7%2000%3A00%3A00&end_time=2026-4-7%2023%3A59%3A59&start_rn=1&end_rn=5&jsVersion=4.1.3&v=2045&lang=zh' -H 'Host: wifi.gcc.edu.cn:802' -H 'referer: https://wifi.gcc.edu.cn/' --output - | grep "加载页面设置信息成功"
  if [ $? -eq 0 ]; then
    echo login
  else
    # do login
    MY_IP=$(curl -X GET 'https://wifi.gcc.edu.cn/drcom/chkstatus?callback=dr1002&program_index=9PMwE51745479032&page_index=P0nh3N1745479149&jsVersion=4.1.3&v=3904&lang=zh' -H 'Referer: https://wifi.gcc.edu.cn/' --output - | sed -n 's/.*v46ip":"\([^"]*\)".*/\1/p')
    curl -X GET 'https://wifi.gcc.edu.cn:802/eportal/portal/login?callback=dr1003&login_method=1&is_base64encode=1&user_account=LDAsMjAyNDEyMTAwMjIw&user_password=U3cxbXB3ZEBkZWZhdWx0&wlan_user_ip='"$MY_IP"'&wlan_user_ipv6&wlan_user_mac=000000000000&wlan_vlan_id=0&wlan_ac_ip&wlan_ac_name&authex_enable&jsVersion=4.1.3&terminal_type=1&lang=zh-cn&program_index=9PMwE51745479032&page_index=P0nh3N1745479149&v=5736&lang=zh' -H 'Host: wifi.gcc.edu.cn:802' -H 'referer: https://wifi.gcc.edu.cn/'
    #echo not login
  fi
else
  echo network disconnected
fi
