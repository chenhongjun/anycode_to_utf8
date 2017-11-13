#!/bin/sh

function convert_file() {

# 检查文件是否存在
filename=$1
if [ ! -f $filename ]; then
    echo "$filename isn't exists"
    exit 0
fi

# 转换文件编码为UTF-8
#file -i $filename | grep -q "iso-8859-1"
#if [ $? -eq 0 ]; then
#    echo "iconv -f GBK -t UTF-8 -o $filename".tmp" $filename"
#    iconv -f GBK -t UTF-8 -o $filename".tmp" $filename
#    mv $filename".tmp" $filename
#fi
./to_utf8 $filename

# 验证是否为UTF-8
file -i $filename | grep -q "utf-8\|us-ascii"
if [ $? -eq 1 ]; then
    echo "$filename is not utf-8 file"
    return
fi

# 添加BOM标记
#file -i $filename | grep -q "BOM"
#if [ $? -eq 1 ]; then
#    echo "add BOM to $filename"
#    sed -i '1s/^/\xef\xbb\xbf/g' $filename
#fi
sed -i '1s/^\xef\xbb\xbf//g' $filename
sed -i '1s/^/\xef\xbb\xbf/g' $filename

# 删除回车
tr -d '\r' < $filename > $filename".tmp"
mv $filename".tmp" $filename

# 替换tab为空格
sed -i 's/	/    /g' $filename

# 去除结尾多余的空格
sed -i 's/    $//g' $filename
sed -i 's/   $//g' $filename
sed -i 's/  $//g' $filename
sed -i 's/ $//g' $filename
}

for x in $*
do
    cat $x | while read myline
    do
        convert_file $myline
    done
done
