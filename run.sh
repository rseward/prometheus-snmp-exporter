#!/bin/bash

ls -l /app/generator/snmp.yml
set -x
./snmp_exporter --config.file /app/generator/snmp.yml
