build:
	podman build -t snmp_exporter .	

run:
	podman run --rm -ti -v "${PWD}:/opt/" snmp_exporter
	
