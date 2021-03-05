#!/bin/bash
while systemctl status nginx && nginx -v ; 
do sleep 10; 
done


#end
