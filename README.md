#功能：批量转换编码格式
#用法：1:编译:make
#      2:转码:./make_utf8_with_bom.sh  /source/path/


#文件说明：
./path_to_utf8.sh #递归查找指定目录下的所有C++源文件,包含(.cpp .h .inl .c .cc .C)，将所有源文件的路径写入src_file.path文件内，调用./cpp_any2u.sh进行转码

./cpp_any2u.sh #读取文件内每一行路径的源码文件，转码为UTF-8 with BOM，删除'\r',删除行尾空格，把'\t'替换为4个空格(Makefile,python等文件慎用)。

./to_utf.cpp #辅助程序，自动识别文本文件编码并转成UTF-8.供./form.sh调用.

./cpp_w2u #将ascii文件转为utf-8


#自定义：
	有需要的朋友可以修改两个.sh脚本中的内容:例如：
	不需要BOM可以删除app_any2u.sh中增加BOM标识那两行
	需要其他文件类型可以打开path_to_utf8.sh修改
	如果不想转成UTF8可以修改to_utf.cpp然后重新编译
