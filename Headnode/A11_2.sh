#!/bin/bash

#PREGUNTA 6: AVAILABLE RESOURCE CLASSES
echo PREGUNTA6
openstack --os-placement-api-version 1.2 resource class list --sort-column name

#PREGUNTA 7: AVAILABLE TRAITS
echo PREGUNTA7
openstack --os-placement-api-version 1.6 trait list --sort-column name