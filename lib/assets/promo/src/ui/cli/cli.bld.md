# [.bld] Building project
{{parent: cli}}

The system shall provide command `clerq build`. When the user requests the command the system shall combine all requirements in the project repository and build the output document according to input parameters.

## [.par] Input parameters

The command shall provide the following input parameters:

* `-o/--output`, string, optional, represent name for the output document;
* `-t/--template TEMPLATE`, string, optional, represent a template for building the document;
* `-q/--query QUERY`, string, optional, represent query string for requirements.

##

When `-o/--output` parameter is not provided, the system shall use the default file name from settings of the project.

##

When `-o/--output` parameter is provided, the system shall save the generated document under the provided name.

##

When `-t/--template` parameter is not provided, the system shall use the default template from settings of the project.

##

When `-t/--template` parameter is provided, the system shall check that the provided template exists and use it for document generation.

##

When `-q/--query` parameter is provided, the system shall check if the provided query is correct query string and select requirements for building the document according to the query.
