#!/usr/bin/env bash
# wget -q --show-progress 'https://downloader.disk.yandex.ru/disk/21cc79c9e29592f19321e8866961cd998308aab91e1a7a7c467abdad7defc566/5a302d86/lxaiTboSYrnu-A9Dw49a7fAuGyESkbGIWm84iXzXMbQIiL0Flo7l5mGJC0Ioe0ijnwpFeJOz1sN8aVUN6amV6w%3D%3D?uid=0&filename=test_data.tar&disposition=attachment&hash=jEdOu0p4Bc5MGMBZlc5/KknthJaIhkkDypR1C61UWVg%3D%3A&limit=0&content_type=application%2Fx-tar&fsize=12922880&hid=a2cf32b3030a9fe663d9b031b7a5a703&media_type=compressed&tknv=v2' -O 'test_data.tar'
wget 'https://downloader.disk.yandex.ru/disk/21cc79c9e29592f19321e8866961cd998308aab91e1a7a7c467abdad7defc566/5a302d86/lxaiTboSYrnu-A9Dw49a7fAuGyESkbGIWm84iXzXMbQIiL0Flo7l5mGJC0Ioe0ijnwpFeJOz1sN8aVUN6amV6w%3D%3D?uid=0&filename=test_data.tar&disposition=attachment&hash=jEdOu0p4Bc5MGMBZlc5/KknthJaIhkkDypR1C61UWVg%3D%3A&limit=0&content_type=application%2Fx-tar&fsize=12922880&hid=a2cf32b3030a9fe663d9b031b7a5a703&media_type=compressed&tknv=v2' -O 'test_data.tar'

echo "Unpacking test_data.tar ..."
tar -xvf test_data.tar >> /dev/null
rm -r test_data.tar

