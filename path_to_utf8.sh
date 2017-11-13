#!/bin/sh
for dir in $*
	do
		find $dir -name "*.cpp" >> src_file.path
		find $dir -name "*.h" >> src_file.path
		find $dir -name "*.hpp" >> src_file.path
		find $dir -name "*.inl" >> src_file.path
		find $dir -name "*.cc" >> src_file.path
		find $dir -name "*.c" >> src_file.path
		find $dir -name "*.C" >> src_file.path
		./cpp_any2u.sh src_file.path
		rm -f src_file.path
	done

