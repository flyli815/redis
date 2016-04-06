###  test

# redis 安装前准备
yum -y install gcc+

yum -y install vim

#安装
#1、下载，解压，编译:

$ wget http://download.redis.io/releases/redis-3.0.6.tar.gz

$ tar xzf redis-3.0.6.tar.gz

$ cd redis-3.0.6

$ make

$ make MALLOC=libc

$ make install


# 2、编译完成后，在Src目录下，有四个可执行文件redis-server、redis-benchmark、redis-cli和redis.conf。然后拷贝到一个目录下。

$ mkdir -p /usr/local/redis/conf

$ mkdir -p /usr/local/redis/logs

$ mkdir -p /usr/local/redis/bin

$ cp mkreleasehdr.sh /usr/local/redis/bin

$ cp redis-benchmark /usr/local/redis/bin

$ cp redis-check-dump /usr/local/redis/bin

$ cp redis-check-aof /usr/local/redis/bin

$ cp redis-cli /usr/local/redis/bin

$ cp redis-sentinel /usr/local/redis/bin

$ cp redis-server /usr/local/redis/bin

$ cp redis-trib.rb /usr/local/redis/bin

$ cp redis.conf  /usr/local/redis/conf


# 3、启动Redis服务。
$ redis-server /usr/local/redis/conf/redis.conf


# 4、然后用客户端测试一下是否启动成功。

$ redis-cli

$ redis> set foo bar

$ OK

$ redis> get foo

$ "bar"

$ redis> ping

$ PONG

# 上面的提示127.0.0.1是本机的IP地址，6379为Redis服务器运行的端口。
