import socket
import os

machine_name = os.environ['DOCKER_CONTAINER_NAME']
listen_address = socket.gethostbyname(socket.gethostname())

connect('weblogic','welcome1','t3://wlsadmin:7001')

edit()
startEdit()

cd('/')
cmo.createMachine(machine_name)

cd('/Machines/' + machine_name +'/NodeManager/' + machine_name)
cmo.setListenAddress(listen_address)

save()
activate()
exit()
