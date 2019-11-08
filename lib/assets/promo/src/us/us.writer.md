# [.writer] Writer
{{parent: us}}

A requirements writer / author / developer / analyst

## README, HOW-TO

As a requirements analyst who visits the project promo page, I want to get some introduction to the project and its features, so that I understand how close it meets my needs.

{{@@skip it just requires that the project should have README.md}}

## Write in plain text files

As a requirements writer, I want to develop and store requirements in plain text, so that my readers and I would not need to install any specialized software to work with requirements.

## Using of lightweight markup language

As a requirements writer, when I work on the requirements text, I want to use a lightweight markup language (LML), so that it still plain text and, at the same time, I have basic formatting capabilities of style and structure of a text, lists, and tables.

## Set of separate files

As a requirements writer, when I develop requirements, I want to structure the entire set of requirements as a set of separate files and folders, so that I have a high degree of agility but some drawbacks also ...

* I can write different complex topics in different files and folders;
* I can share the same repository with other authors without  problems like the necessity to work with the same file simultaneously more that one person:

{{@@skip just curious if the user stories format really suited there for ... these rather features and benefits or quality properties than stories}}

## Requirements subordination and order

As a drawback for the previous story when I have requirements in separated files, I need an ability to specify requirements subordination and output order through separated files, so that I can combine all requirements into the consistent repository.

## Supporting Metadata

As a requirements writer, when I develop requirements, I want to mark requirements text by some metadata (source, author, dependencies, etc.), so that I can use the metadata for tagging, searching, selection, referring, etc.

## Supporting Links

As a requirements writer, when I develop requirements, I want to link those with each other through simple references, so that I refer from one requirement to others.

## Requirements templates

As a requirements writer, when I develop requirements, I want to create and use requirements templates, so that I simplify my work, improve productivity and provide basic writing style.

## Checking repository
{{topic: true}}

As a requirements writer, I want to check requirements repository for different possible errors, so that I fix the errors and have consistent repository.

Manual files writing and writing in separate files especially can cause the following errors:

* Errors in structure of a requirements file;
* Errors in linking or ordering requirements;
* References that not exist in the repository;
* Duplicates of requirements identifiers.

## Querying requirements

As a requirements writer, at any time, I want to query requirements (based on its attributes such "id", "title", "body", and metadata), so that I can have different subsets of requirements based on my needs.

## Combining into documents

As a requirements writer, at any time, I want to combine requirements to a single consistent requirements specification, so that I can have requirements draft and releases.

## Providing unique identifiers

As a requirements writer, I want to have automatically created unique identifiers for the requirements where it omitted, so that I will always have unique identifiers for all requirements.

## Document templates

As a requirement writer, I want the system support ability to chose different templates for documents, so that I can have templates for different purposes (drafts and releases) and even software products (GitHub Markdown, Gitlab Markdown, Pandoc Markdown to convert to docx, odt, or pdf.)

## Create own document template

As a requirements writer, I want to have ability to create my own templates or modify existing templates, so than I can do template tuning for my needs.

## Script automation

As a requirements analyst, I want have ability to automate my working tasks related to requirements, so that I can write scripts related to publishing, reviewing or deriving other artifacts based on the requirements (backlog, estimation sheet, traceability matrix, etc.).
