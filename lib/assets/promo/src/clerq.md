# 1 Introduction
{{skip_meta: true}}

## 1.1 Purpose
{{skip_meta: true}}

The purpose of this document is to provide a demo project "Clerq Promo SRS" for all perspective Clerq users to introduce the system by example and provide a sandbox for experiments for the existing users.

The other purpose (rather technical) is to have repository that provides all possible combinations of markup inside (links, ids, macros, etc.) to exercise in writing documents templates.   

## 1.2 Scope
{{skip_meta: true}}

This software system will be a command-line interface (CLI) that provides a set of tools related to requirements management tasks. The system will also provide the requirements repository structure and the format of the requirements sources.

The system does not provide any graphical user interface. Assumed that users create and write requirements through any available text editor application, and manage requirements repository structure through any available file manager application.

Any features related to restricting access to the requirements repository or to the functions of the system are out of scope. Assumed that each project repository is under control of an SCM tool (Git, Subversion, etc.) and the SCM is in charge of user's access to the SCM artifacts.

## 1.3 Definitions, acronyms, and abbreviations
{{skip_meta: true}}

CLI

:   Command-line interface

VCS

:   Version control system

SCM

:   Software configuration management

User story

:   User stories at [www.agilealliance.org](https://www.agilealliance.org/glossary/user-stories)

OS

:   Operations System

[//]: # (to use the extension `--from markdown+definition_lists`)

## 1.4 References
{{skip_meta: true}}

1. [Markdown Guide](https://www.markdownguide.org/)
2. [Pandoc User’s Guide](https://pandoc.org/MANUAL.html)
3. [Git Documentation](https://git-scm.com/doc)

## 1.5 Overview
{{skip_meta: true}}

The remaining sections of this document provide user requirements and functional requirements of the system.

The next chapter [[us]] introduces the system from User Stories' point of view and establishes the context for the functional requirements. The chapter is organized by user roles.

The following chapter [[fr]] describes detailed requirements for functions and user interfaces that are based on user stories from the previous chapter. The chapter is structured around system components and is written primarily for developers and quality assurance specialists.

# [us] 2 User stories
{{skip_meta: true; order_index: .reader .writer}}

# [fr] 3 Functional requirements
{{skip_meta: true}}

## [cmp] Components
{{order_index: .node .repo}}

The system shall provide the following components:

{{@@list}}

## [ent] Entities
{{order_index: .node .tt}}

## [ui] User Interface

# Appendix
{{skip_meta: true}}

![Clerq in Atom](assets/promo_light.png)
