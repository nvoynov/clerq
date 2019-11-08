# [.new] Creating new project
{{parent: cli}}

The system shall provide command `clerq new`. When the user requests the command the system shall create a new clerq project according to input parameters.

{{@@skip TODO what is the project?}}

## [.par] Input parameters

The command shall provide the following input parameters:

* `PROJECT`, string, required, represent the name of the new project.

##

When parameter `PROJECT` not provided, the system shall stop the command execution and print the error message `Parameter "PROJECT" required!`.

##

When parameter `PROJECT` provided and a directory called according to the parameter value exists, the system shall stop the command execution and print the error message `Directory "PROJECT" exists!`.
