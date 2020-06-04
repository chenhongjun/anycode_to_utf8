# any code text to utf8

```shell
# 记录src_path下所有源文件名,并添加到src_file_list.txt中,以便后面对每一个文件转换编码
find $src_path -name "*.h" >> src_file_list.txt
find $src_path -name "*.cpp" >> src_file_list.txt
#......
#其他非文本文件 别进行识别和转码，容易损坏文件
```

```shell
# 猜测文件的编码类型
# 因为识别文件编码可能会出错，这一步是最容易影响到编码转换正确率的,这里使用file命令
file -i $src_file_name
# 输出示例 to_utf8.cpp: text/x-c; charset=utf-8
# 输出示例 TextEncoding.exe: application/x-dosexec; charset=binary
```

```shell
# 文件编码格式转换
# 使用iconv命令，将GBK编码的src_file_name文件转为UTF8编码，并将转换后的结果写入$src_file_name".tmp"中
iconv -f GBK -t UTF-8 -o $src_file_name".tmp" $src_file_name
# 编码知识科普：数据在计算机存储为大量顺序的0和1，称为二进制，文件也一样。编码指的软件对这个文件的打开方式/解释方式。通常所说的乱码就是打开方式不对导致的[希望你用utf8打开，你却用utf16的解析方式打开，解析出来就是一堆乱码]
# 举例：我在纸上写了"小人"，原意为"卑鄙的人";一个古代人拿到这张纸，他以为我写的意思是"小孩子"。两个人的理解就对不上了。文件-纸；小人-二进制数据；卑鄙的人-uft8解码结果；小孩子-uft16解码结果。当然有一些字词古文和现代文解释出来意思一样。这样的字词不管用哪种方式解释都不会出现歧义/乱码。
# 编码历史
# 1：ascii编码：只支持英文字母/数字/少量符号。几乎所有编码方式 来打开 本该以ascii打开的文件 都不会乱码。
# 2：中国常用编码：GBK,gb2312,能够正确解释中文和英文，其他国文字不行。windows上容易出现。
# 4：windows常用编码：utf16，utf或者unicode开头的都是国际化编码，及所有人类文字符号都能解释。windows常用。
# 5：网页常用编码：utf8，国际化，省流量。最好用它。
# 6：程序内部字符串编码：utf32，国际化，占内存，但是每个字符定长，写代码方便。
#以上编码是会经常碰到的，当然还有其他更多编码方式。它们互不兼容，各干各的。就算你把 应该用gb2312解码的文本 给 utf8去解码，utf8也能把它解出来显示，但是只要有中文就会被解释错，看上去就是乱码。这也是乱码发生的根因。在已经看到乱码的情况下，又被编辑器以错误(与原码不一致及为错误)的编码方式保存一下，文件就彻底损坏了。经过多次错误，再也没人知道它原来的样子。
#如果你不想为乱码而烦恼，请把文本全转为utf8吧，它越来越流行了。如果你文本中只有英文，那无所谓用什么编码，因为几乎所有编码方式都能正确解析英文。
```

```shell
# UTF8 with BOM
# 如何识别一个文本文件是什么编码格式？最简单的，以每一种编码方式去打开同一个文件，肉眼去看有没有乱码，如果哪种编码方式打开后没有乱码，就算该文本属于该编码。一个文本字符较少时，可能被识别为既是GBK，又是utf8。或者更多。
# 所以上述的 file 命令去识别文格式，也会有出错的时候。
# windows怕自己识别不出UTF8编码的文本，于是自作聪明的在utf8编码的文件开头插入了3个字节长的固定的不可见字符，用来方便识别是不是uft8编码。这3个字节是 "\xef\xbb\xbf" 。开头插入了这3个字节的utf8文本文件，叫做UTF8 with BOM，及UTF8-BOM
sed -i '1s/^\xef\xbb\xbf//g' $src_file_name #将文件开头的BOM标记替换为空(及删去)
sed -i '1s/^/\xef\xbb\xbf/g' $src_file_name #将文件开头加上BOM标记
# 以上是删去和添加BOM标记的方法，建议不使用BOM，很少有编辑器需要它。
```

```shell
# 换行
# 有的字符被解析出来是不可见(如BOM)，有的字符被解析出来会感觉很特别，比如'\t'，编辑器默认会显示4个空格那么宽的空白(当然编辑器可以设置显示2个空白格/8个空白格)。那 换一行再显示 这个特效 用什么字符表示呢？
# 分歧
# unix/linux:使用'\n'表示换行
# mac os:使用'\r'表示换行
# windows:使用'\r\n'表示换行。windows真是个和事佬，很中立嘛。
# 我们当然希望我的项目源文件统一使用同一个换行符了
tr -d '\r' < $src_file_name > $src_file_name".tmp" #将文件中所有\r删了
```

```shell
# table '\t'
# python程序员可以略过
# 源文件中出现'\t'也是件很繁琐的事情，大段大段的空白，通用做法是将'\t'替换为几个空格。
sed -i 's/	/    /g' $src_file_name #将文件中的	换为    。哈哈哈，是不是看不到我写的字符，因为编辑器已经给你处理过了。
```

```shell
# 行末空格
# 如果行末多了几个不可见字符，看也看不到，放在那又导致文件变大了。把它删了吧！
sed -i 's/    $//g' $src_file_name
sed -i 's/   $//g' $src_file_name
sed -i 's/  $//g' $src_file_name
sed -i 's/ $//g' $src_file_name
```




