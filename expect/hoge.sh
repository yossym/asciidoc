#!/usr/bin/expect 
#!/usr/bin/expect -d
#!/bin/bash

set timeout 20
spawn ssh admin@192.168.2.254
expect { 
	"*(yes/no)?" {
		send "yes\n"
		expect "*User:" 
		send "admin\n"
		expect "*Password:"
		send "Admin123\n"
	 } 
	"*User:" {
		send "admin\n"
		expect "*Password:"
		send "Admin123\n"
	}
}

expect ") >"
send "show time\n"

expect ") >"
send "logout\n"



