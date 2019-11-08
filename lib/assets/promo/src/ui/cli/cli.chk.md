# [.chk] Checking project
{{parent: cli}}

The system shall provide command `clerq check`. When the user requests the command the system shall check the clerq repository for errors.

##

When any errors have found during checking, the system shall print the errors grouped by error type. The following errors type shall be checked:

* Non-unique identifiers;
* Unknown/wrong parents;
* Unknown/Wrong links;
* Wrong order_index attribute.

##

When errors have not found, the system shall print the message `No errors found. Everything is fine.`
