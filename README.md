hydra-worker-round-robin
===========================

Worker for Hydra v3.1.0.  
Sort the list instances by round-robin algorithm.  
No new map will be generated.

# Installation

## Ubuntu/Debian

Add PPAs for:  
https://launchpad.net/~chris-lea/+archive/libpgm  
https://launchpad.net/~chris-lea/+archive/zeromq  
  
and run:  
```
sudo dpkg -i hydra-worker-round-robin-1-1.x86_64.deb
sudo apt-get install -f
```
## CentOS/RedHat/Fedora
```
sudo yum install libzmq3-3.2.2-13.1.x86_64.rpm hydra-worker-round-robin-1-1.x86_64.rpm
```

# Configuration

Configuration options can be set in two places:

 1. Command line flags
 2. Configuration file

Options set on the command line take precedence over all other sources.

## Command Line Flags

* `-hydra-server-addr` - The connection address for local workers uses ipc transport protocol (i.e `"ipc://hydra-0-backend.ipc"`) and for remote workers uses tcp transport protocol (i.e `"tcp://hydra0:7777"`).
* `-priority-level` - This option sets the priority level of the worker in the hydra server. This means that if a worker has available a lower value than the other, the server will always use the first. It must be equal to 0 for local workers with ipc protocol. Defaults to `0`.
* `-service-name` - The name under which the service is registered in the hydra server. (i.e `RoundRobin`).
* `-v, -verbose` - Show logs in DEBUG mode. Defaults to `false`.

## Configuration File

The hydra-worker-round-robin configuration file is written in [TOML](https://github.com/mojombo/toml)
and read from `/etc/hydra/hydra-worker-round-robin.conf` by default.

```TOML
hydra_server_address = "ipc://hydra-0-backend.ipc"
priority_level = 0
service_name = "RoundRobin"
verbose = false
```

In Hydra Server configuration in the apps.json file (Default to /etc/hydra/apps.json):

- Name: "RoundRobin"

## Configuration example (add to application balancers chain)
```
{
	"worker": "RoundRobin",
	"simple": "OK"
}
```			
This will sort the list of instances by round-robin algorithm remembering previous calls.

## Service configuration

No additional configuration is needed if running in the same machine that Hydra.  
Tune start file at /etc/init.d/hydra-worker-round-robin if you run it in a separate machine.

# Run
```
sudo /etc/init.d/hydra-worker-round-robin start
```

# License

(The MIT License)

Authors:  
Germán Ramos &lt;german.ramos@gmail.com&gt;  
Pascual de Juan &lt;pascual.dejuan@gmail.com&gt;  
Jonas da Cruz &lt;unlogic@gmail.com&gt;  
Luis Mesas &lt;luismesas@gmail.com&gt;  
Alejandro Penedo &lt;icedfiend@gmail.com&gt;  
Jose María San José &lt;josem.sanjose@gmail.com&gt;  

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
